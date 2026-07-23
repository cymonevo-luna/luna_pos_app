import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/localization/locale_provider.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/printer/bluetooth_printer_service.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/order/checkout_page.dart';
import 'package:luna_pos/features/order/data/order_option_repository.dart';
import 'package:luna_pos/features/order/models/idr_banknote.dart';
import 'package:luna_pos/features/order/order_controller.dart';
import 'package:luna_pos/features/order/order_options_controller.dart';
import 'package:luna_pos/features/receipt/receipt_print_service.dart';
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
          merchantId: 'merchant-1',
          roles: ['cashier'],
        ),
      );
}

void main() {
  late ProviderContainer container;
  late FakeSecureStorage secure;
  late DioAdapter adapter;
  late MockBluetoothPrinterService printer;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    secure = FakeSecureStorage();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    printer = MockBluetoothPrinterService();
    registerAuthTestServices(secure: secure, client: mocked.client);
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerLazySingleton<OrderOptionRepository>(
        () => OrderOptionRepository(locator<ApiClient>(), testResourceCache()),
      )
      ..registerLazySingleton<MenuRepository>(
        () => MenuRepository(locator<ApiClient>(), testResourceCache()),
      )
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepository(locator<ApiClient>(), testResourceCache()),
      )
      ..registerLazySingleton<StoreSettingsRepository>(
        () => StoreSettingsRepository(locator<ApiClient>(), testResourceCache()),
      )
      ..registerSingleton<BluetoothPrinterService>(printer)
      ..registerLazySingleton<ReceiptPrintService>(ReceiptPrintService.new);
    container = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_FakeAuthController.new),
      ],
    );
    stubOrderOptions(adapter);
    await container.read(orderOptionsProvider.notifier).loadIfNeeded();
  });

  tearDown(() {
    container.dispose();
    printer.dispose();
  });

  Widget buildLocalizedApp({required Widget child}) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(AppAccent.blue),
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

  Future<void> scrollToFooter(WidgetTester tester) async {
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pump();
  }

  Future<void> scrollToBanknoteSection(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.byKey(const Key('banknote_row_1000')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
  }

  Future<void> scrollToCashSummary(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.byKey(const Key('cash_payment_summary')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
  }

  Future<void> scrollToCashFields(WidgetTester tester) async {
    await scrollToBanknoteSection(tester);
    await scrollToCashSummary(tester);
  }

  Future<void> tapBanknoteIncrement(
    WidgetTester tester,
    int denomination, {
    int times = 1,
  }) async {
    final incrementKey = Key('banknote_increment_$denomination');
    for (var i = 0; i < times; i++) {
      await tester.scrollUntilVisible(
        find.byKey(incrementKey),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump();
      await tester.tap(find.byKey(incrementKey), warnIfMissed: false);
      await tester.pump();
    }
    await tester.pumpAndSettle();
  }

  void expectBanknoteRowsVisible() {
    for (final denomination in idrBanknoteDenominations) {
      expect(
        find.byKey(Key('banknote_row_$denomination')),
        findsOneWidget,
      );
    }
  }

  void expectBanknoteRowsHidden() {
    for (final denomination in idrBanknoteDenominations) {
      expect(
        find.byKey(Key('banknote_row_$denomination')),
        findsNothing,
      );
    }
  }

  Future<void> pumpCheckoutPage(WidgetTester tester) async {
    await tester.pumpWidget(buildLocalizedApp(child: const CheckoutPage()));
    await tester.pump();
  }

  Future<void> scrollToOrderOptions(WidgetTester tester) async {
    await tester.scrollUntilVisible(
      find.byKey(const Key('order_option_selector')),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
  }

  Future<void> selectTakeAwayOption(WidgetTester tester) async {
    await scrollToOrderOptions(tester);
    await tester.tap(find.descendant(
      of: find.byKey(const Key('order_option_selector')),
      matching: find.text('Take Away'),
    ));
    await tester.pump();
  }

  testWidgets('checkout page lists lines and subtotal', (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);

    expect(find.text('Es Teh'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('less ice'), findsOneWidget);
    expect(find.text('—'), findsOneWidget);
    expect(find.text('Rp 8.000'), findsOneWidget);
    expect(find.text('Rp 70.000'), findsOneWidget);

    await scrollToCashFields(tester);
    expect(find.text('Rp 78.000'), findsWidgets);
  });

  testWidgets('payment method dropdown appears above proceed button',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await selectTakeAwayOption(tester);

    expect(find.byKey(const Key('payment_method_dropdown')), findsOneWidget);
    expect(find.text('Cash'), findsWidgets);
    expect(find.widgetWithText(AppButton, 'Proceed'), findsOneWidget);
    expect(find.text('Print receipt'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsOneWidget);

    final dropdownFinder = find.byKey(const Key('payment_method_dropdown'));
    final proceedFinder = find.widgetWithText(AppButton, 'Proceed');
    final dropdownY = tester.getTopLeft(dropdownFinder).dy;
    final proceedY = tester.getTopLeft(proceedFinder).dy;
    expect(dropdownY, lessThan(proceedY));

    await tester.tap(find.byKey(const Key('payment_method_dropdown')));
    await tester.pumpAndSettle();
    expect(find.text('QRIS'), findsOneWidget);
  });

  testWidgets('cash shows banknote keyboard and change summary',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await scrollToCashFields(tester);

    expect(find.byKey(const Key('cash_tendered_field')), findsNothing);
    expectBanknoteRowsVisible();
    expect(find.byKey(const Key('cash_payment_summary')), findsOneWidget);

    await tapBanknoteIncrement(tester, 50000, times: 2);
    await tapBanknoteIncrement(tester, 20000);

    expect(find.byKey(const Key('change_amount_display')), findsOneWidget);
    expect(find.text(formatRupiah(42000)), findsOneWidget);
    expect(find.byKey(const Key('insufficient_payment_message')), findsNothing);
  });

  testWidgets('qris hides banknote keyboard and cash summary',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await scrollToCashFields(tester);

    await tester.tap(find.byKey(const Key('payment_method_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('QRIS').last);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('cash_tendered_field')), findsNothing);
    expectBanknoteRowsHidden();
    expect(find.byKey(const Key('cash_payment_summary')), findsNothing);
    expect(find.byKey(const Key('change_amount_display')), findsNothing);
  });

  testWidgets('switching payment methods toggles banknote keyboard visibility',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await scrollToCashFields(tester);

    expectBanknoteRowsVisible();

    await tapBanknoteIncrement(tester, 50000);
    expect(
      find.descendant(
        of: find.byKey(const Key('banknote_qty_50000')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('payment_method_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('QRIS').last);
    await tester.pumpAndSettle();
    expectBanknoteRowsHidden();

    await tester.tap(find.byKey(const Key('payment_method_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cash').last);
    await tester.pumpAndSettle();
    await scrollToCashFields(tester);
    expectBanknoteRowsVisible();
    expect(
      find.descendant(
        of: find.byKey(const Key('banknote_qty_50000')),
        matching: find.text('0'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('default payment method is cash with banknote keyboard visible',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await scrollToCashFields(tester);

    expect(find.byKey(const Key('cash_tendered_field')), findsNothing);
    expect(find.byKey(const Key('banknote_row_1000')), findsOneWidget);
    expect(find.byKey(const Key('cash_payment_summary')), findsOneWidget);
  });

  testWidgets('qris enables proceed without cash input when option selected',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await selectTakeAwayOption(tester);
    await scrollToCashFields(tester);

    await tester.tap(find.byKey(const Key('payment_method_dropdown')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('QRIS').last);
    await tester.pumpAndSettle();

    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Proceed'))
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('proceed button disabled without order option selection',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await scrollToFooter(tester);

    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Proceed')).onPressed,
      isNull,
    );
  });

  testWidgets('order option selector shows options in priority order and enables proceed',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await scrollToOrderOptions(tester);

    expect(find.text('Order Type'), findsOneWidget);
    expect(find.text('Take Away'), findsOneWidget);
    expect(find.text('Dine In'), findsOneWidget);

    await selectTakeAwayOption(tester);

    await tester.tap(find.byKey(const Key('payment_method_dropdown')));
    await tester.pump();
    await tester.tap(find.text('QRIS').last);
    await tester.pump();
    await scrollToFooter(tester);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Proceed')).onPressed,
      isNotNull,
    );
  });

  testWidgets('empty order options shows blocking message and disables proceed',
      (WidgetTester tester) async {
    seedTwoLineCart();

    final emptyContainer = ProviderContainer(
      overrides: [
        authProvider.overrideWith(_FakeAuthController.new),
        orderOptionsProvider.overrideWith(_EmptyOrderOptionsController.new),
      ],
    );
    addTearDown(emptyContainer.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: emptyContainer,
        child: MaterialApp(
          theme: AppTheme.light(AppAccent.blue),
          locale: const Locale('en'),
          supportedLocales: kSupportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const CheckoutPage(),
        ),
      ),
    );
    await tester.pump();
    await tester.scrollUntilVisible(
      find.text('No order options configured. Contact manager.'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();

    expect(
      find.text('No order options configured. Contact manager.'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.widgetWithText(AppButton, 'Proceed'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Proceed')).onPressed,
      isNull,
    );
  });

  testWidgets('proceed button disabled when banknote total is insufficient',
      (WidgetTester tester) async {
    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await selectTakeAwayOption(tester);

    await scrollToFooter(tester);
    await scrollToCashFields(tester);

    await tapBanknoteIncrement(tester, 50000);

    expect(find.byKey(const Key('insufficient_payment_message')), findsOneWidget);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Proceed')).onPressed,
      isNull,
    );
  });

  testWidgets('banknote input enables proceed when payment is sufficient',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    seedTwoLineCart();

    await pumpCheckoutPage(tester);
    await selectTakeAwayOption(tester);

    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    await tapBanknoteIncrement(tester, 50000, times: 2);
    await tapBanknoteIncrement(tester, 20000);

    expect(find.byKey(const Key('change_amount_display')), findsOneWidget);
    expect(find.text(formatRupiah(42000)), findsOneWidget);

    await scrollToFooter(tester);
    expect(
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Proceed')).onPressed,
      isNotNull,
    );
  });

  testWidgets('empty cart cannot access checkout route',
      (WidgetTester tester) async {
    seedRestorableSecureTokens(secure);
    stubSessionRestoreApis(
      adapter,
      userId: 'u1',
      userData: {
        'id': 'u1',
        'email': 'a@b.com',
        'name': 'Alex',
        'merchant_id': 'merchant-1',
        'roles': ['cashier'],
      },
    );

    adapter.onGet(
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

  testWidgets('retry print snackbar includes printer error',
      (WidgetTester tester) async {
    seedTwoLineCart();

    const printerError = 'Could not connect to the printer.';
    final prefs = locator<PreferencesService>();
    await prefs.setString(PrefKeys.printerDeviceId, '00:11:22:33:44:55');
    await prefs.setString(PrefKeys.printerDeviceName, 'Test Printer');
    printer.dispose();
    printer = MockBluetoothPrinterService(connectSucceeds: false);
    locator.unregister<BluetoothPrinterService>();
    locator.registerSingleton<BluetoothPrinterService>(printer);

    adapter.onGet(
      '/api/v1/pos/store-settings',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'brand_name': 'Luna Cafe',
          'branch_name': 'Cabang Sudirman',
          'address': 'Jl. Sudirman No. 10',
          'phone': '021-1234567',
          'thank_you_note': 'Terima kasih!',
        },
      }),
    );
    adapter.onPost(
      '/api/v1/pos/transactions',
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'tx-print-1',
          'method': 'CASH',
          'subtotal_amount': 78000,
          'discount_amount': 0,
          'amount': 78000,
          'cash_tendered': 80000,
          'change_amount': 2000,
        },
      }),
      data: {
        'order_option_id': kTestOrderOptionTakeAwayId,
        'method': 'CASH',
        'items': [
          {
            'menu_id': 'm1',
            'title': 'Es Teh',
            'quantity': 1,
            'unit_price': 8000,
            'line_total': 8000,
            'note': 'less ice',
          },
          {
            'menu_id': 'm2',
            'title': 'Nasi Goreng',
            'quantity': 2,
            'unit_price': 35000,
            'line_total': 70000,
          },
        ],
        'subtotal_amount': 78000,
        'discount_amount': 0,
        'amount': 78000,
        'cash_tendered': 80000,
        'change_amount': 2000,
      },
    );

    await tester.pumpWidget(buildLocalizedApp(child: const CheckoutPage()));
    await tester.pumpAndSettle();

    await selectTakeAwayOption(tester);
    await tester.tap(find.byType(CheckboxListTile));
    await tester.pumpAndSettle();
    await scrollToCashFields(tester);
    await tapBanknoteIncrement(tester, 50000);
    await tapBanknoteIncrement(tester, 20000);
    await tapBanknoteIncrement(tester, 10000);
    await scrollToFooter(tester);

    await tester.tap(find.widgetWithText(AppButton, 'Proceed'));
    await tester.pumpAndSettle();

    expect(find.text('Sale complete'), findsOneWidget);
    expect(find.text(printerError), findsOneWidget);

    await tester.tap(find.text('Print again'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining(printerError),
      findsWidgets,
    );
  });
}

class _EmptyOrderOptionsController extends OrderOptionsController {
  @override
  OrderOptionsState build() =>
      const OrderOptionsState(merchantId: 'merchant-1');
}
