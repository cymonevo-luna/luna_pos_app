import 'package:flutter/material.dart' show Icons, Offset, RenderBox, Size;
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
        () => MenuRepository(locator<ApiClient>()),
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
    stubCashierSession();

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, sampleMenusResponse()),
    );

    await pumpApp(tester);

    expect(find.text('Order total'), findsOneWidget);
    expect(find.text('Rp 0'), findsOneWidget);

    await tester.tap(find.text('Nasi Goreng'));
    await tester.pumpAndSettle();

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
    stubCashierSession();

    adapter.onGet(
      '/api/v1/pos/menus',
      (server) => server.reply(200, sampleMenusResponse()),
    );

    await pumpApp(tester);

    await tester.tap(find.text('Nasi Goreng'));
    await tester.pumpAndSettle();

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

    await tester.tap(find.text('Empty Stock'));
    await tester.pumpAndSettle();

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
}
