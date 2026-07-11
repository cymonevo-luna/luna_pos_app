import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
import 'package:luna_pos/features/menu/menu_controller.dart' as menu;
import 'package:luna_pos/features/menu/models/cart_line.dart';
import 'package:luna_pos/features/transaction/checkout_page.dart';
import 'package:luna_pos/features/transaction/data/transaction_repository.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/shared/widgets/app_button.dart';

import 'helpers/auth_harness.dart';

class _TestMenuController extends menu.MenuController {
  @override
  menu.MenuState build() {
    return const menu.MenuState(
      cart: {
        'm1': CartLine(
          menuId: 'm1',
          title: 'Es Teh',
          sellPrice: 8000,
          quantity: 2,
        ),
        'm2': CartLine(
          menuId: 'm2',
          title: 'Nasi Goreng',
          sellPrice: 35000,
          quantity: 1,
        ),
      },
    );
  }
}

void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();

    final mocked = buildMockedApiClient();
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SecureStorageService>(FakeSecureStorage())
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<TransactionRepository>(
        () => TransactionRepository(locator<ApiClient>()),
      );

    container = ProviderContainer(
      overrides: [
        menu.menuProvider.overrideWith(_TestMenuController.new),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildCheckoutPage() {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const CheckoutPage(),
      ),
    );
  }

  testWidgets('complete sale button disabled when underpaid',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(buildCheckoutPage());
    await tester.pump();

  final listScrollable = find.byWidgetPredicate(
      (widget) =>
          widget is Scrollable && widget.axisDirection == AxisDirection.down,
    );

    await tester.scrollUntilVisible(
      find.text('Complete sale'),
      100,
      scrollable: listScrollable,
    );
    await tester.scrollUntilVisible(
      find.byKey(const Key('cash_tendered_field')),
      100,
      scrollable: listScrollable,
    );
    await tester.enterText(
      find.byKey(const Key('cash_tendered_field')),
      '50000',
    );
    await tester.pump();

    final completeButton = tester.widget<AppButton>(find.byType(AppButton));
    expect(completeButton.onPressed, isNull);
  });
}
