import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/router/navigation_config.dart';
import 'package:luna_pos/core/router/pos_features.dart';
import 'package:luna_pos/core/router/shell_branch_provider.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/auth/auth_controller.dart';
import 'package:luna_pos/features/menu/menu_controller.dart' as menu_ctrl;
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/features/menu_disposal/disposal_history_controller.dart';
import 'package:luna_pos/features/menu_disposal/disposal_history_page.dart';
import 'package:luna_pos/features/menu_disposal/dispose_food_controller.dart';
import 'package:luna_pos/features/menu_disposal/dispose_food_page.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';

class _CashierAuthController extends AuthController {
  @override
  AuthState build() => AuthState(
        status: AuthStatus.authenticated,
        user: User(
          id: TestAccounts.cashierUserId,
          name: 'Cashier Test',
          email: TestAccounts.cashierEmail,
          merchantId: TestAccounts.testMerchantId,
          roles: const ['cashier'],
          features: TestAccounts.apiFeaturesFor(TestAccountRole.cashier),
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

class _DisposeFoodShellNotifier extends ShellBranchNotifier {
  @override
  int build() => ShellBranch.disposeFood.branchIndex;
}

class _MockDisposeFoodController extends DisposeFoodController {
  @override
  DisposeFoodState build() => const DisposeFoodState();
}

class _MockMenuPageController extends menu_ctrl.MenuController {
  @override
  menu_ctrl.MenuState build() => const menu_ctrl.MenuState(
        data: POSMenusResponse(categories: []),
      );

  @override
  Future<void> loadIfNeeded() async {}
}

class _MockDisposalHistoryController extends DisposalHistoryController {
  @override
  DisposalHistoryState build() => const DisposalHistoryState(
        items: [],
        page: 1,
      );

  @override
  Future<void> loadIfNeeded() async {}
}

ProviderContainer _buildContainer({
  AuthController Function()? authFactory,
}) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith(authFactory ?? _CashierAuthController.new),
      shellCurrentBranchProvider.overrideWith(_DisposeFoodShellNotifier.new),
      menu_ctrl.menuProvider.overrideWith(_MockMenuPageController.new),
      disposeFoodProvider.overrideWith(_MockDisposeFoodController.new),
      disposalHistoryProvider.overrideWith(_MockDisposalHistoryController.new),
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

  testWidgets('history button opens DisposalHistoryPage via router', (tester) async {
    final container = _buildContainer();
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);

    router.go(AppRoute.disposeFood.path);
    await tester.pumpAndSettle();

    expect(find.byType(DisposeFoodPage), findsOneWidget);

    await tester.tap(find.byKey(const Key('dispose_food_history_button')));
    await tester.pumpAndSettle();

    expect(find.byType(DisposalHistoryPage), findsOneWidget);
    expect(router.state.matchedLocation, AppRoute.disposeFoodHistory.path);
    expect(find.text('Disposal History'), findsOneWidget);
  });

  testWidgets('feature gate redirects unauthorized user from history', (tester) async {
    final container = _buildContainer(authFactory: _MenuOnlyAuthController.new);
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);

    router.go(AppRoute.disposeFoodHistory.path);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byType(DisposalHistoryPage), findsNothing);
    expect(router.state.matchedLocation, AppRoute.home.path);
  });
}
