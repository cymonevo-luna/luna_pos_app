import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/localization/locale_provider.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/order/checkout_page.dart';
import 'package:luna_pos/features/order/order_controller.dart';
import 'package:luna_pos/features/store_settings/data/store_settings_repository.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/shared/widgets/app_button.dart';

import 'helpers/auth_harness.dart';
import 'helpers/mock_bluetooth_printer_service.dart';

class _FakeAuthController extends AuthController {
  @override
  AuthState build() => const AuthState(
        status: AuthStatus.authenticated,
        user: User(
          id: 'u1',
          name: 'Alex',
          email: 'a@b.com',
        ),
      );
}

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
      )
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<StoreSettingsRepository>(
        () => StoreSettingsRepository(locator<ApiClient>()),
      )
      ..registerSingleton<BluetoothPrinterService>(MockBluetoothPrinterService());
    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_FakeAuthController.new),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildLocalizedApp({required Widget child}) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        locale: const Locale('en'),
        supportedLocales: kSupportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: child,
      ),
    );
  }

  void seedTwoLineCart() {
    final notifier = container.read(orderProvider.notifier);
    notifier.addLine(
      const POSMenuItem(
        id: 'm1',
        title: 'Es Teh',
        sellPrice: 8000,
        availableStock: 10,
      ),
      quantity: 1,
      note: 'less ice',
    );
    notifier.addLine(
      const POSMenuItem(
        id: 'm2',
        title: 'Nasi Goreng',
        sellPrice: 35000,
        availableStock: 10,
      ),
      quantity: 2,
    );
  }

  testWidgets('checkout page lists lines and subtotal', (WidgetTester tester) async {
    seedTwoLineCart();

    await tester.pumpWidget(buildLocalizedApp(child: const CheckoutPage()));
    await tester.pumpAndSettle();

    expect(find.text('Es Teh'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('less ice'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);
    expect(find.text('Rp 8.000'), findsOneWidget);
    expect(find.text('Rp 70.000'), findsOneWidget);
    expect(find.text('Rp 78.000'), findsOneWidget);
  });

  testWidgets('confirm button disabled when cash tendered is insufficient',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await tester.pumpWidget(buildLocalizedApp(child: const CheckoutPage()));
    await tester.pumpAndSettle();

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('cash_tendered_field')), '50000');
    await tester.pumpAndSettle();

    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Confirm & Print'))
          .onPressed,
      isNull,
    );
  });

  testWidgets('empty cart cannot access checkout route',
      (WidgetTester tester) async {
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

    router.goNamed(AppRoute.checkout.name);
    await tester.pumpAndSettle();

    expect(find.byType(CheckoutPage), findsNothing);
    expect(find.byType(MenuPage), findsOneWidget);
  });
}
