import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
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
import 'package:luna_pos/features/menu_management/data/admin_category_repository.dart';
import 'package:luna_pos/core/network/paginated_response.dart';
import 'package:luna_pos/features/menu_management/models/admin_category.dart';
import 'package:luna_pos/features/menu_management/data/admin_menu_repository.dart';
import 'package:luna_pos/features/menu_management/menu_management_list_controller.dart';
import 'package:luna_pos/features/menu_management/models/admin_menu.dart';
import 'package:luna_pos/features/menu_management/menu_management_form_sheet.dart';
import 'package:luna_pos/features/menu_management/menu_management_list_page.dart';
import 'package:luna_pos/features/purchase/data/purchase_image_picker.dart';
import 'package:luna_pos/features/user/models/user.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/shared/widgets/main_scaffold.dart';
import 'package:luna_pos/testing/test_accounts.dart';

import 'helpers/auth_harness.dart';

class _FakeAdminCategoryRepository extends AdminCategoryRepository {
  _FakeAdminCategoryRepository(super.api);

  @override
  Future<PaginatedResponse<AdminCategory>> fetchCategories({
    int page = 1,
    int perPage = AdminCategoryRepository.pickerPerPage,
  }) {
    return Future.value(
      PaginatedResponse(
        items: const [AdminCategory(id: 'cat-1', name: 'Rice')],
        page: 1,
        perPage: perPage,
        total: 1,
      ),
    );
  }
}

Future<void> _waitForCategoriesInForm(WidgetTester tester) async {
  for (var i = 0; i < 50; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    if (!tester.any(find.byType(LinearProgressIndicator))) {
      break;
    }
  }
  await tester.pumpAndSettle();

  if (!tester.any(find.text('Rice'))) {
    await tester.ensureVisible(
      find.byKey(const Key('menu_management_category_field')),
    );
    await tester.tap(find.byKey(const Key('menu_management_category_field')));
    await tester.pumpAndSettle();
    if (tester.any(find.text('Rice'))) {
      await tester.tap(find.text('Rice').last);
      await tester.pumpAndSettle();
    }
  }
}

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

class _MockMenuManagementListController extends MenuManagementListController {
  @override
  MenuManagementState build() => const MenuManagementState();

  @override
  Future<void> loadInitial() async {}

  @override
  Future<void> refresh() async {}
}

class _SuccessMenuManagementController extends MenuManagementListController {
  @override
  MenuManagementState build() => const MenuManagementState();

  @override
  Future<AdminMenu?> createMenu(AdminMenuRequest request) async {
    return AdminMenu(
      id: 'menu-new',
      title: request.title,
      categoryId: request.categoryId,
      categoryName: 'Rice',
      availableStock: request.availableStock,
      sellPrice: request.sellPrice,
      recipeYield: 1,
      marginPercent: 35,
      vatPercent: 11,
    );
  }
}

ProviderContainer _buildContainer({
  AuthController Function()? authFactory,
  MenuManagementListController Function()? menuManagementFactory,
}) {
  return ProviderContainer(
    overrides: [
      authProvider.overrideWith(authFactory ?? _ManageMenusAuthController.new),
      shellCurrentBranchProvider.overrideWith(_HomeShellNotifier.new),
      menu_ctrl.menuProvider.overrideWith(_MockMenuPageController.new),
      menuManagementProvider.overrideWith(
        menuManagementFactory ?? _MockMenuManagementListController.new,
      ),
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
      )
      ..registerLazySingleton<AdminMenuRepository>(
        () => AdminMenuRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<AdminCategoryRepository>(
        () => _FakeAdminCategoryRepository(mocked.client),
      )
      ..registerLazySingleton<PurchaseImagePicker>(
        () => _FakePurchaseImagePicker(),
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

  testWidgets('phone create save returns to manage menus list', (tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final container = _buildContainer(
      menuManagementFactory: _SuccessMenuManagementController.new,
    );
    addTearDown(container.dispose);

    final router = await pumpRouterApp(tester, container: container);

    router.go(AppRoute.manageMenusNew.path);
    await tester.pumpAndSettle();

    expect(find.byType(MenuManagementFormPage), findsOneWidget);

    await _waitForCategoriesInForm(tester);

    await tester.enterText(
      find.byKey(const Key('menu_management_title_field')),
      'Tea',
    );
    await tester.enterText(
      find.byKey(const Key('menu_management_stock_field')),
      '5',
    );
    await tester.enterText(
      find.byKey(const Key('menu_management_price_field')),
      '15000',
    );
    await tester.ensureVisible(
      find.byKey(const Key('menu_management_submit_button')),
    );
    await tester.tap(find.byKey(const Key('menu_management_submit_button')));
    await tester.pumpAndSettle();

    expect(router.state.matchedLocation, AppRoute.manageMenus.path);
    expect(find.byType(MainScaffold), findsOneWidget);
    expect(find.byType(MenuManagementListPage), findsOneWidget);
    expect(find.byType(MenuManagementFormPage), findsNothing);
  });
}

class _FakePurchaseImagePicker implements PurchaseImagePicker {
  @override
  Future<XFile?> pickFromCamera() async => null;

  @override
  Future<XFile?> pickFromGallery() async => null;
}
