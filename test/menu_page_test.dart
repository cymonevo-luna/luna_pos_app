import 'package:flutter/material.dart' show Icons, Key, Offset, RenderBox, Size, TextField;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/auth/login_page.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu/menu_page.dart';
import 'package:luna_pos/features/menu/widgets/menu_item_card.dart';
import 'package:luna_pos/features/order/order_controller.dart';
import 'package:luna_pos/shared/widgets/app_button.dart';
import 'package:luna_pos/shared/widgets/app_section_header.dart';

import 'helpers/auth_harness.dart';

void main() {
  late FakeSecureStorage secure;
  late DioAdapter adapter;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    secure = FakeSecureStorage();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    registerAuthTestServices(secure: secure, client: mocked.client);
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerLazySingleton<MenuRepository>(
        () => MenuRepository(locator<ApiClient>(), testResourceCache()),
      );
  });

  Map<String, dynamic> orderedCategoriesResponse() => {
    'success': true,
    'data': {
      'categories': [
        {
          'id': 'c2',
          'name': 'Desserts',
          'menus': [
            {
              'id': 'm-dessert',
              'title': 'Pudding',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 5,
              'sell_price': 15000,
            },
          ],
        },
        {
          'id': 'c3',
          'name': 'Appetizers',
          'menus': [
            {
              'id': 'm-appetizer',
              'title': 'Spring Rolls',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 10,
              'sell_price': 20000,
            },
          ],
        },
        {
          'id': 'c1',
          'name': 'Mains',
          'menus': [
            {
              'id': 'm-main',
              'title': 'Nasi Goreng',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 3,
              'sell_price': 35000,
            },
          ],
        },
      ],
    },
  };

  Map<String, dynamic> denseMenusResponse() => {
    'success': true,
    'data': {
      'categories': [
        {
          'id': 'c1',
          'name': 'Mains',
          'menus': [
            {
              'id': 'm1',
              'title': 'Nasi Goreng',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 3,
              'sell_price': 35000,
            },
            {
              'id': 'm2',
              'title': 'Mie Goreng',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 5,
              'sell_price': 30000,
            },
            {
              'id': 'm3',
              'title': 'Ayam Bakar',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 8,
              'sell_price': 40000,
            },
            {
              'id': 'm4',
              'title': 'Sate Ayam',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 10,
              'sell_price': 25000,
            },
          ],
        },
        {
          'id': 'c2',
          'name': 'Drinks',
          'menus': [
            {
              'id': 'm5',
              'title': 'Es Teh',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 20,
              'sell_price': 5000,
            },
            {
              'id': 'm6',
              'title': 'Es Jeruk',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 15,
              'sell_price': 8000,
            },
          ],
        },
      ],
    },
  };

  Map<String, dynamic> cashierUserPayload() => {
        'id': 'u1',
        'email': 'a@b.com',
        'name': 'Alex',
        'merchant_id': 'merchant-1',
        'roles': ['cashier'],
      };

  void stubCashierSession() {
    seedRestorableSecureTokens(secure);
    stubSessionRestoreApis(
      adapter,
      userId: 'u1',
      userData: cashierUserPayload(),
    );
  }

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  Future<void> pumpAuthenticatedMenuPage(
    WidgetTester tester, {
    required Map<String, dynamic> menusResponse,
    Size surfaceSize = const Size(360, 640),
  }) async {
    seedRestorableSecureTokens(secure);
    stubSessionRestoreApis(
      adapter,
      userId: 'u1',
      userData: cashierUserPayload(),
    );

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, menusResponse),
    );

    await tester.binding.setSurfaceSize(surfaceSize);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpApp(tester);
  }

  Finder menuItemCardWithTitle(String title) {
    return find.descendant(
      of: find.byType(MenuItemCard),
      matching: find.text(title),
    );
  }

  Future<void> tapMenuItemCard(WidgetTester tester, String title) async {
    final target = menuItemCardWithTitle(title);
    await tester.ensureVisible(target);
    await tester.tap(target);
    await tester.pumpAndSettle();
  }

  Future<void> clearMenuSearch(WidgetTester tester) async {
    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('menu_search_field')),
        matching: find.byIcon(Icons.clear),
      ),
    );
    await tester.pumpAndSettle();
  }

  Map<String, dynamic> sampleMenusResponse() => {
    'success': true,
    'data': {
      'categories': [
        {
          'id': 'c1',
          'name': 'Mains',
          'menus': [
            {
              'id': 'm1',
              'title': 'Nasi Goreng',
              'description': '',
              'photo_url': '/static/default-food.png',
              'available_stock': 3,
              'sell_price': 35000,
            },
            {
              'id': 'm2',
              'title': 'Empty Stock',
              'description': '',
              'photo_url': '',
              'available_stock': 0,
              'sell_price': 20000,
            },
          ],
        },
      ],
    },
  };

  testWidgets('authenticated user sees menus grouped by category', (
    WidgetTester tester,
  ) async {
    stubCashierSession();

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, sampleMenusResponse()),
    );

    await pumpApp(tester);

    expect(find.byType(MenuPage), findsOneWidget);
    expect(find.text('Mains'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Rp 35.000'), findsOneWidget);
    expect(find.text('Out of stock'), findsWidgets);
  });

  testWidgets('menu page renders cart bottom bar with total', (
    WidgetTester tester,
  ) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: sampleMenusResponse(),
    );

    expect(find.text('Order total'), findsOneWidget);
    expect(find.text('Rp 0'), findsOneWidget);

    await tapMenuItemCard(tester, 'Nasi Goreng');

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.text('2 items'), findsOneWidget);
    expect(find.text('Rp 70.000'), findsOneWidget);
  });

  testWidgets('checkout button disabled on empty cart', (
    WidgetTester tester,
  ) async {
    stubCashierSession();

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, sampleMenusResponse()),
    );

    await pumpApp(tester);

    final checkoutButtons = tester.widgetList<AppButton>(
      find.widgetWithText(AppButton, 'Checkout'),
    );
    expect(checkoutButtons, hasLength(1));
    expect(checkoutButtons.first.onPressed, isNull);
  });

  testWidgets('add item from menu updates cart count', (
    WidgetTester tester,
  ) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: sampleMenusResponse(),
    );

    await tapMenuItemCard(tester, 'Nasi Goreng');

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final menuPage = tester.element(find.byType(MenuPage));
    final container = ProviderScope.containerOf(menuPage);
    expect(container.read(orderProvider).itemCount, 1);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('out-of-stock item cannot open add sheet', (
    WidgetTester tester,
  ) async {
    stubCashierSession();

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, sampleMenusResponse()),
    );

    await pumpApp(tester);

    final outOfStockCard = tester.widget<MenuItemCard>(
      find.ancestor(
        of: find.text('Empty Stock'),
        matching: find.byType(MenuItemCard),
      ),
    );
    expect(outOfStockCard.item.isInStock, isFalse);

    await tapMenuItemCard(tester, 'Empty Stock');

    expect(find.text('Qty'), findsNothing);
  });

  testWidgets('menu fetch error shows retry control', (
    WidgetTester tester,
  ) async {
    stubCashierSession();

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(500, {
        'success': false,
        'error': {'message': 'server error'},
      }),
    );

    await pumpApp(tester);

    expect(find.text('Retry'), findsOneWidget);

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, sampleMenusResponse()),
    );

    await tester.tap(find.text('Retry'));
    await tester.pumpAndSettle();

    expect(find.text('Nasi Goreng'), findsOneWidget);
  });

  testWidgets('unauthenticated access to menu redirects to login', (
    WidgetTester tester,
  ) async {
    await pumpApp(tester);

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.byType(MenuPage), findsNothing);
  });

  testWidgets('menu page renders without overflow on phone viewport', (
    WidgetTester tester,
  ) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: denseMenusResponse(),
    );

    expect(tester.takeException(), isNull);
    expect(find.byType(MenuPage), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Mains'), findsOneWidget);
  });

  testWidgets('menu page shows at least four cards above the fold on phone', (
    WidgetTester tester,
  ) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: denseMenusResponse(),
    );

    final visibleCards = find
        .byType(MenuItemCard)
        .evaluate()
        .where((element) {
          final box = element.renderObject! as RenderBox;
          final topLeft = box.localToGlobal(Offset.zero);
          final bottom = topLeft.dy + box.size.height;
          return topLeft.dy >= 0 && bottom <= 640;
        })
        .length;

    expect(visibleCards, greaterThanOrEqualTo(4));
  });

  testWidgets('menu page renders categories in API order', (
    WidgetTester tester,
  ) async {
    stubCashierSession();

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, orderedCategoriesResponse()),
    );

    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpApp(tester);

    expect(find.byType(MenuPage), findsOneWidget);

    final headers = tester
        .widgetList<AppSectionHeader>(find.byType(AppSectionHeader))
        .toList();
    expect(headers.map((header) => header.title).toList(), [
      'Desserts',
      'Appetizers',
      'Mains',
    ]);
  });

  testWidgets('search field visible on menu page', (WidgetTester tester) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: sampleMenusResponse(),
    );

    expect(find.byKey(const Key('menu_search_field')), findsOneWidget);
  });

  testWidgets('typing filters visible menu cards', (WidgetTester tester) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: denseMenusResponse(),
    );

    await tester.enterText(
      find.byKey(const Key('menu_search_field')),
      'Nasi',
    );
    await tester.pumpAndSettle();

    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Es Teh'), findsNothing);
  });

  testWidgets('clear button restores full menu', (WidgetTester tester) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: denseMenusResponse(),
    );

    await tester.enterText(
      find.byKey(const Key('menu_search_field')),
      'Nasi',
    );
    await tester.pumpAndSettle();

    expect(find.text('Es Teh'), findsNothing);

    await clearMenuSearch(tester);

    expect(find.text('Mie Goreng'), findsOneWidget);
    expect(find.text('Nasi Goreng'), findsOneWidget);
  });

  testWidgets('no results empty state', (WidgetTester tester) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: denseMenusResponse(),
    );

    await tester.enterText(
      find.byKey(const Key('menu_search_field')),
      'zzznomatch',
    );
    await tester.pumpAndSettle();

    expect(
      find.text('No menu items match your search'),
      findsOneWidget,
    );
    expect(find.byType(MenuItemCard), findsNothing);
  });

  testWidgets('category headers hidden when empty', (
    WidgetTester tester,
  ) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: denseMenusResponse(),
    );

    await tester.enterText(
      find.byKey(const Key('menu_search_field')),
      'Es Teh',
    );
    await tester.pumpAndSettle();

    final headers = tester
        .widgetList<AppSectionHeader>(find.byType(AppSectionHeader))
        .toList();
    expect(headers, hasLength(1));
    expect(headers.single.title, 'Drinks');
  });

  testWidgets('add to cart works on filtered item', (
    WidgetTester tester,
  ) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: denseMenusResponse(),
    );

    await tester.enterText(
      find.byKey(const Key('menu_search_field')),
      'Nasi Goreng',
    );
    await tester.pumpAndSettle();

    await tapMenuItemCard(tester, 'Nasi Goreng');

    await tester.tap(find.byIcon(Icons.add_circle_outline));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    final menuPage = tester.element(find.byType(MenuPage));
    final container = ProviderScope.containerOf(menuPage);
    expect(container.read(orderProvider).itemCount, 2);
  });

  testWidgets('out-of-stock behavior unchanged after filtering', (
    WidgetTester tester,
  ) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: sampleMenusResponse(),
    );

    await tester.enterText(
      find.byKey(const Key('menu_search_field')),
      'Empty Stock',
    );
    await tester.pumpAndSettle();

    await tapMenuItemCard(tester, 'Empty Stock');

    expect(find.text('Qty'), findsNothing);
  });

  testWidgets('refresh preserves active search', (WidgetTester tester) async {
    await pumpAuthenticatedMenuPage(
      tester,
      menusResponse: denseMenusResponse(),
    );

    await tester.enterText(
      find.byKey(const Key('menu_search_field')),
      'Nasi',
    );
    await tester.pumpAndSettle();

    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Es Teh'), findsNothing);

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, denseMenusResponse()),
    );

    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pumpAndSettle();

    expect(
      tester.widget<TextField>(find.byKey(const Key('menu_search_field')))
          .controller
          ?.text,
      'Nasi',
    );
    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Es Teh'), findsNothing);
  });
}
