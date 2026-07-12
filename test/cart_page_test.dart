import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:luna_pos/core/localization/locale_provider.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/order/cart_page.dart';
import 'package:luna_pos/features/order/order_controller.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
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

  void seedOneLineCart() {
    container.read(orderProvider.notifier).addLine(
          const POSMenuItem(
            id: 'm1',
            title: 'Es Teh',
            sellPrice: 8000,
            availableStock: 10,
          ),
          quantity: 2,
          note: 'less ice',
        );
  }

  testWidgets('cart page lists line with note and total',
      (WidgetTester tester) async {
    seedOneLineCart();

    await tester.pumpWidget(buildLocalizedApp(child: const CartPage()));
    await tester.pumpAndSettle();

    expect(find.text('Es Teh'), findsOneWidget);
    expect(find.textContaining('less ice'), findsOneWidget);
    expect(find.text('Rp 16.000'), findsWidgets);
    expect(find.text('2 items'), findsOneWidget);
  });

  testWidgets('remove line clears cart and shows empty state',
      (WidgetTester tester) async {
    seedOneLineCart();

    await tester.pumpWidget(buildLocalizedApp(child: const CartPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.delete_outline));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);
    expect(container.read(orderProvider).itemCount, 0);
    expect(container.read(orderProvider).lines, isEmpty);
  });

  testWidgets('checkout button is disabled when cart is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(buildLocalizedApp(child: const CartPage()));
    await tester.pumpAndSettle();

    expect(find.text('Your cart is empty'), findsOneWidget);

    final checkoutButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'Checkout'),
    );
    expect(checkoutButton.onPressed, isNull);
  });

  testWidgets('checkout navigates to checkout route when cart has items',
      (WidgetTester tester) async {
    seedOneLineCart();

    final router = GoRouter(
      initialLocation: AppRoute.cart.path,
      routes: [
        GoRoute(
          path: AppRoute.cart.path,
          name: AppRoute.cart.name,
          builder: (context, state) => const CartPage(),
        ),
        GoRoute(
          path: AppRoute.checkout.path,
          name: AppRoute.checkout.name,
          builder: (context, state) =>
              const Scaffold(body: Text('Checkout stub')),
        ),
      ],
    );

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
    await tester.pumpAndSettle();

    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();

    expect(find.text('Checkout stub'), findsOneWidget);
  });
}
