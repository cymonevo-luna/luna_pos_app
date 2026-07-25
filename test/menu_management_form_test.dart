import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';

import 'package:luna_pos/core/network/paginated_response.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/menu_management/data/admin_category_repository.dart';
import 'package:luna_pos/features/menu_management/data/admin_menu_repository.dart';
import 'package:luna_pos/features/menu_management/menu_management_form_sheet.dart';
import 'package:luna_pos/features/menu_management/menu_management_list_controller.dart';
import 'package:luna_pos/features/menu_management/models/admin_category.dart';
import 'package:luna_pos/features/menu_management/models/admin_menu.dart';
import 'package:luna_pos/features/purchase/data/purchase_image_picker.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

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

class _NoopMenuManagementController extends MenuManagementListController {
  @override
  MenuManagementState build() => const MenuManagementState();
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

class _PopCounterNavigatorObserver extends NavigatorObserver {
  int popCount = 0;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    popCount++;
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

void main() {
  late ProviderContainer container;

  Widget buildFormApp() {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(AppAccent.blue),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: MenuManagementFormSheet(),
        ),
      ),
    );
  }

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<AdminMenuRepository>(
        () => AdminMenuRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<AdminCategoryRepository>(
        () => _FakeAdminCategoryRepository(mocked.client),
      )
      ..registerLazySingleton<PurchaseImagePicker>(
        () => _FakePurchaseImagePicker(),
      );
    container = ProviderContainer(
      overrides: [
        menuManagementProvider.overrideWith(_NoopMenuManagementController.new),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('validation prevents submit with empty title', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildFormApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('menu_management_price_field')), '15000');
    await tester.enterText(find.byKey(const Key('menu_management_stock_field')), '5');
    await tester.ensureVisible(find.byKey(const Key('menu_management_submit_button')));
    await tester.tap(find.byKey(const Key('menu_management_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('This field is required'), findsOneWidget);
  });

  testWidgets('validation prevents submit with invalid sell price', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(buildFormApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('menu_management_title_field')), 'Tea');
    await tester.enterText(find.byKey(const Key('menu_management_stock_field')), '5');
    await tester.enterText(find.byKey(const Key('menu_management_price_field')), '0');
    await tester.ensureVisible(find.byKey(const Key('menu_management_submit_button')));
    await tester.tap(find.byKey(const Key('menu_management_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a price greater than 0'), findsOneWidget);
  });

  testWidgets('successful save pops exactly once via onSaved callback',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final navContainer = ProviderContainer(
      parent: container,
      overrides: [
        menuManagementProvider.overrideWith(
          _SuccessMenuManagementController.new,
        ),
      ],
    );
    addTearDown(navContainer.dispose);

    final navigatorKey = GlobalKey<NavigatorState>();
    final popObserver = _PopCounterNavigatorObserver();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: navContainer,
        child: MaterialApp(
          theme: AppTheme.light(AppAccent.blue),
          navigatorKey: navigatorKey,
          navigatorObservers: [popObserver],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            key: const Key('parent_list_scaffold'),
            body: TextButton(
              key: const Key('open_form_button'),
              onPressed: () => navigatorKey.currentState!.push(
                MaterialPageRoute<void>(
                  builder: (_) => UncontrolledProviderScope(
                    container: navContainer,
                    child: const MenuManagementFormPage(),
                  ),
                ),
              ),
              child: const Text('Open form'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('open_form_button')));
    await tester.pumpAndSettle();

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

    expect(find.text('Select a category'), findsNothing);
    expect(find.text('Menu saved'), findsOneWidget);
    expect(popObserver.popCount, 1);
    expect(find.byKey(const Key('parent_list_scaffold')), findsOneWidget);
    expect(find.byType(MenuManagementFormPage), findsNothing);
  });

  testWidgets('successful save without onSaved pops exactly once',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final navContainer = ProviderContainer(
      parent: container,
      overrides: [
        menuManagementProvider.overrideWith(
          _SuccessMenuManagementController.new,
        ),
      ],
    );
    addTearDown(navContainer.dispose);

    final navigatorKey = GlobalKey<NavigatorState>();
    final popObserver = _PopCounterNavigatorObserver();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: navContainer,
        child: MaterialApp(
          theme: AppTheme.light(AppAccent.blue),
          navigatorKey: navigatorKey,
          navigatorObservers: [popObserver],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            key: const Key('parent_list_scaffold'),
            body: TextButton(
              key: const Key('open_form_button'),
              onPressed: () => showDialog<void>(
                context: navigatorKey.currentContext!,
                builder: (dialogContext) => UncontrolledProviderScope(
                  container: navContainer,
                  child: Dialog(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: const MenuManagementFormSheet(),
                    ),
                  ),
                ),
              ),
              child: const Text('Open form'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('open_form_button')));
    await tester.pumpAndSettle();

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

    expect(popObserver.popCount, 1);
    expect(find.byKey(const Key('parent_list_scaffold')), findsOneWidget);
    expect(find.byType(MenuManagementFormSheet), findsNothing);
  });
}

class _FakePurchaseImagePicker implements PurchaseImagePicker {
  @override
  Future<XFile?> pickFromCamera() async => null;

  @override
  Future<XFile?> pickFromGallery() async => null;
}
