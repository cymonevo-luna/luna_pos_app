import 'package:flutter/material.dart' show Icons, Size;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/storage/secure_storage_service.dart';
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
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerSingleton<SecureStorageService>(secure)
      ..registerSingleton<ApiClient>(mocked.client)
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

  Future<void> pumpApp(WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  testWidgets('authenticated user sees menus grouped by category', (
    WidgetTester tester,
  ) async {
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

  testWidgets('menu page renders categories in API order', (
    WidgetTester tester,
  ) async {
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
