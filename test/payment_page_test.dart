import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/localization/locale_provider.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/order/order_controller.dart';
import 'package:luna_pos/features/order/payment_page.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

import 'helpers/auth_harness.dart';

void main() {
  late ProviderContainer container;
  late FakeSecureStorage secure;
  late DioAdapter adapter;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    secure = FakeSecureStorage();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SecureStorageService>(secure)
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<MenuRepository>(
        () => MenuRepository(locator<ApiClient>()),
      );
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildPaymentApp() {
    secure.store[SecureKeys.authToken] = 'acc';
    secure.store[SecureKeys.userId] = 'u1';

    adapter
      ..onGet(
        '/api/v1/users/u1',
        (server) => server.reply(200, {
          'success': true,
          'data': {
            'id': 'u1',
            'email': 'a@b.com',
            'name': 'Alex',
            'role': 'user',
          },
        }),
      )
      ..onGet(
        '/api/v1/pos/menus',
        (server) => server.reply(200, {
          'success': true,
          'data': {'categories': []},
        }),
      );

    final router = GoRouter(
      initialLocation: AppRoute.payment.path,
      routes: [
        GoRoute(
          path: AppRoute.home.path,
          name: AppRoute.home.name,
          builder: (context, state) => const MenuPage(),
        ),
        GoRoute(
          path: AppRoute.payment.path,
          name: AppRoute.payment.name,
          builder: (context, state) => const PaymentPage(),
        ),
        GoRoute(
          path: AppRoute.login.path,
          name: AppRoute.login.name,
          builder: (context, state) => const Scaffold(body: Text('Login')),
        ),
      ],
    );

    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        locale: const Locale('en'),
        supportedLocales: kSupportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        routerConfig: router,
      ),
    );
  }

  Future<void> pumpPaymentApp(WidgetTester tester) async {
    container.read(authProvider);
    await tester.pumpWidget(buildPaymentApp());
    for (var i = 0;
        i < 100 && !container.read(authProvider).isAuthenticated;
        i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pumpAndSettle();
  }

  void seedCart({required int sellPrice, required int quantity}) {
    container.read(orderProvider.notifier).addLine(
          POSMenuItem(
            id: 'm1',
            title: 'Test Item',
            sellPrice: sellPrice,
            availableStock: 10,
          ),
          quantity: quantity,
        );
  }

  testWidgets('payment calculates change when overpaid',
      (WidgetTester tester) async {
    seedCart(sellPrice: 45000, quantity: 1);

    await pumpPaymentApp(tester);

    await tester.enterText(find.byType(TextFormField), '50000');
    await tester.pump();

    expect(find.text('Rp 5.000'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Complete'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('payment blocks complete when underpaid',
      (WidgetTester tester) async {
    seedCart(sellPrice: 45000, quantity: 1);

    await pumpPaymentApp(tester);

    await tester.enterText(find.byType(TextFormField), '40000');
    await tester.pump();

    expect(find.text('Insufficient payment'), findsOneWidget);
    expect(
      tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Complete'))
          .onPressed,
      isNull,
    );
  });

  testWidgets('complete clears cart and returns to menu',
      (WidgetTester tester) async {
    seedCart(sellPrice: 45000, quantity: 1);

    secure.store[SecureKeys.authToken] = 'acc';
    secure.store[SecureKeys.userId] = 'u1';
    adapter
      ..onGet(
        '/api/v1/users/u1',
        (server) => server.reply(200, {
          'success': true,
          'data': {
            'id': 'u1',
            'email': 'a@b.com',
            'name': 'Alex',
            'role': 'user',
          },
        }),
      )
      ..onGet(
        '/api/v1/pos/menus',
        (server) => server.reply(200, {
          'success': true,
          'data': {'categories': []},
        }),
      );

    final router = container.read(routerProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          locale: const Locale('en'),
          supportedLocales: kSupportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          routerConfig: router,
        ),
      ),
    );

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    router.goNamed(AppRoute.payment.name);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField), '50000');
    await tester.pump();

    await tester.tap(find.text('Complete'));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(find.byType(MenuPage), findsOneWidget);
    expect(container.read(orderProvider).lines, isEmpty);
    expect(find.text('Payment completed successfully'), findsOneWidget);
  });
}
