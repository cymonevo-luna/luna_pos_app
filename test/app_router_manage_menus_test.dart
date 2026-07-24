import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/core/router/shell_branch_provider.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/menu/menu_controller.dart' as menu_ctrl;
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/features/menu_management/menu_management_list_page.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/shared/widgets/main_scaffold.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';

final _l10n = AppLocalizationsEn();

class _ManageMenusAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: const User(
          id: TestAccounts.cashierUserId,
          name: 'Cashier Test',
          email: TestAccounts.cashierEmail,
          merchantId: TestAccounts.testMerchantId,
          roles: ['cashier'],
          features: [
            PosFeatures.menu,
            PosFeatures.transactions,
            PosFeatures.menusManage,
          ],
        ),
      );
}

class _MenuTransactionsOnlyAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: const User(
          id: TestAccounts.cashierUserId,
          name: 'Cashier Test',
          email: TestAccounts.cashierEmail,
          merchantId: TestAccounts.testMerchantId,
          roles: ['cashier'],
          features: [
            PosFeatures.menu,
            PosFeatures.transactions,
          ],
        ),
      );
}

class _MenuOnlyAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: const User(
          id: TestAccounts.cashierUserId,
          name: 'Menu Only',
          email: TestAccounts.cashierEmail,
          merchantId: TestAccounts.testMerchantId,
          roles: ['cashier'],
          features: [PosFeatures.menu],
        ),
      );
}

class _HomeShellNotifier extends ShellBranchNotifier {
  @override
  int build() => 0;
}

class _MockMenuPageController extends menu_ctrl.MenuController {
  @override
  menu_ctrl.MenuState build() => const menu_ctrl.MenuState();

  @override
  Future<void> loadIfNeeded() async {}
}

ProviderContainer _buildContainer({
  AuthController Function()? authFactory,
}) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith(authFactory ?? _ManageMenusAuthController.new),
      shellCurrentBranchProvider.overrideWith(_HomeShellNotifier.new),
      menu_ctrl.menuProvider.overrideWith(_MockMenuPageController.new),
    ],
  );
}

Future<GoRouter> pumpRouterApp(
  WidgetTester tester, {
  required ProviderContainer container,
}) async {
  final router = container.read(routerProvider);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    ),
  );
  await tester.pump();

  return router;
}

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await locator.reset();
    final mocked = buildMockedApiClient();
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerSingleton<PreferencesService>(
        await PreferencesService.create(),
      );
  });

  tearDown(() async {
    await locator.reset();
  });

  testWidgets('authorized cashier sees both selling and manage menu tabs',
      (tester) async {
    final container = _buildContainer();
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);
    router.go(AppRoute.home.path);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MainScaffold), findsOneWidget);
    expect(find.text(_l10n.menu), findsWidgets);
    expect(find.text(_l10n.manageMenus), findsWidgets);
  });

  testWidgets('cashier without menus manage feature hides manage menu tab',
      (tester) async {
    final container =
        _buildContainer(authFactory: _MenuTransactionsOnlyAuthController.new);
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);
    router.go(AppRoute.home.path);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(_l10n.menu), findsWidgets);
    expect(find.text(_l10n.manageMenus), findsNothing);
  });

  testWidgets('feature gate redirects unauthorized user from manage menus',
      (tester) async {
    final container =
        _buildContainer(authFactory: _MenuTransactionsOnlyAuthController.new);
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);

    router.go(AppRoute.manageMenus.path);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MenuManagementListPage), findsNothing);
    expect(find.byType(MenuPage), findsOneWidget);
    expect(router.state.matchedLocation, AppRoute.home.path);
  });

  testWidgets('selling menu tab still loads POS catalog at /home', (tester) async {
    final container = _buildContainer(authFactory: _MenuOnlyAuthController.new);
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);

    router.go(AppRoute.home.path);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MenuPage), findsOneWidget);
    expect(find.byType(MenuManagementListPage), findsNothing);
    expect(router.state.matchedLocation, AppRoute.home.path);
  });

  testWidgets('manage menu tab opens MenuManagementListPage', (tester) async {
    final container = _buildContainer();
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);

    router.go(AppRoute.manageMenus.path);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(MenuManagementListPage), findsOneWidget);
    expect(router.state.matchedLocation, AppRoute.manageMenus.path);
  });
}
