import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/router/app_router.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/purchase/data/purchase_request_repository.dart';
import 'package:luna_pos/features/purchase/purchase_list_page.dart';
import 'package:luna_pos/features/purchase/smart_purchase_request_page.dart';
import 'package:luna_pos/features/stock/data/food_supply_repository.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late FakeSecureStorage secure;

  const foodSupplyId = 'fs-1';
  const supplierCheap = 'sup-cheap';
  const supplierPremium = 'sup-premium';

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppConfig.load();
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    secure = FakeSecureStorage();
    registerAuthTestServices(secure: secure, client: mocked.client);
    locator
      ..registerSingleton<PreferencesService>(await PreferencesService.create())
      ..registerLazySingleton<PurchaseRequestRepository>(
        () => PurchaseRequestRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<FoodSupplyRepository>(
        () => FoodSupplyRepository(locator<ApiClient>()),
      );

    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.operational,
    );
  });

  Map<String, dynamic> suggestFixture({
    required String selectedSupplierId,
    required String selectedSupplierName,
    required int cheapAmount,
    required int premiumAmount,
    bool hasSupplierPrice = true,
  }) =>
      {
        'success': true,
        'data': {
          'all_items_matched': hasSupplierPrice,
          'items': [
            {
              'food_supply_id': foodSupplyId,
              'food_supply_title': 'Flour',
              'unit': 'gr',
              'quantity': '1000',
              'has_supplier_price': hasSupplierPrice,
              'selected_supplier_id':
                  hasSupplierPrice ? selectedSupplierId : null,
              'selected_supplier_name':
                  hasSupplierPrice ? selectedSupplierName : null,
              'supplier_price_id': hasSupplierPrice ? 'price-cheap' : null,
              'all_supplier_quotes': hasSupplierPrice
                  ? [
                      {
                        'supplier_id': supplierCheap,
                        'supplier_name': 'Cheap Supplier',
                        'supplier_price_id': 'price-cheap',
                        'price_amount': cheapAmount,
                        'price_quantity': 1000,
                        'unit_price': cheapAmount ~/ 1000,
                      },
                      {
                        'supplier_id': supplierPremium,
                        'supplier_name': 'Premium Supplier',
                        'supplier_price_id': 'price-premium',
                        'price_amount': premiumAmount,
                        'price_quantity': 1000,
                        'unit_price': premiumAmount ~/ 1000,
                      },
                    ]
                  : [],
            },
          ],
          'grouped_by_supplier': hasSupplierPrice
              ? [
                  {
                    'supplier_id': selectedSupplierId,
                    'supplier_name': selectedSupplierName,
                    'total_estimated_amount': selectedSupplierId == supplierCheap
                        ? cheapAmount
                        : premiumAmount,
                    'items': [
                      {
                        'food_supply_id': foodSupplyId,
                        'food_supply_title': 'Flour',
                        'unit': 'gr',
                        'quantity': '1000',
                        'unit_price': selectedSupplierId == supplierCheap
                            ? cheapAmount ~/ 1000
                            : premiumAmount ~/ 1000,
                        'line_total': selectedSupplierId == supplierCheap
                            ? cheapAmount
                            : premiumAmount,
                        'supplier_price_id': selectedSupplierId == supplierCheap
                            ? 'price-cheap'
                            : 'price-premium',
                      },
                    ],
                  },
                ]
              : [],
        },
      };

  void stubFoodSupplyList() {
    adapter.onGet(
      FoodSupplyRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'id': foodSupplyId,
            'title': 'Flour',
            'description': '',
            'stock_quantity': '1000',
            'unit': 'gr',
          },
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 1},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );
  }

  Widget buildSmartPurchaseApp() {
    final router = GoRouter(
      initialLocation: AppRoute.purchasesSmartRequest.path,
      routes: [
        GoRoute(
          path: AppRoute.purchases.path,
          name: AppRoute.purchases.name,
          builder: (context, state) => const Scaffold(body: Text('purchases-list')),
        ),
        GoRoute(
          path: AppRoute.purchasesSmartRequest.path,
          name: AppRoute.purchasesSmartRequest.name,
          builder: (context, state) => const SmartPurchaseRequestPage(),
        ),
      ],
    );

    return ProviderScope(
      child: MaterialApp.router(
        theme: AppTheme.light(AppAccent.blue),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routerConfig: router,
      ),
    );
  }

  Future<void> addIngredient(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('smart_purchase_add_ingredient_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('smart_purchase_food_supply_$foodSupplyId')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('smart_purchase_ingredient_${foodSupplyId}_quantity')),
      '1000',
    );
    await tester.pump();
  }

  testWidgets('smart request entry is visible on purchases list', (tester) async {
    adapter.onGet(
      '/api/admin/purchase-requests',
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {
          'page': 1,
          'per_page': PurchaseRequestRepository.defaultPerPage,
          'total': 0,
        },
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    final router = GoRouter(
      initialLocation: AppRoute.purchases.path,
      routes: [
        GoRoute(
          path: AppRoute.purchases.path,
          name: AppRoute.purchases.name,
          builder: (context, state) => const PurchaseListPage(),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    final l10n = AppLocalizationsEn();
    expect(find.byKey(const Key('smart_purchase_entry_button')), findsOneWidget);
    expect(find.text(l10n.smartPurchaseTitle), findsOneWidget);
    expect(find.text(l10n.purchasesNew), findsOneWidget);
  });

  testWidgets('ingredient step calls suggest API and opens review', (tester) async {
    stubFoodSupplyList();

    adapter.onPost(
      PurchaseRequestRepository.suggestPath,
      (server) => server.reply(
        200,
        suggestFixture(
          selectedSupplierId: supplierCheap,
          selectedSupplierName: 'Cheap Supplier',
          cheapAmount: 100000,
          premiumAmount: 150000,
        ),
      ),
      data: {
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '1000'},
        ],
      },
    );

    await tester.pumpWidget(buildSmartPurchaseApp());
    await tester.pumpAndSettle();

    await addIngredient(tester);
    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();

    expect(find.text('Cheap Supplier'), findsWidgets);
    expect(find.text(AppLocalizationsEn().smartPurchaseGroupedBySupplier),
        findsOneWidget);
  });

  testWidgets('review pre-selects cheapest supplier total', (tester) async {
    stubFoodSupplyList();

    adapter.onPost(
      PurchaseRequestRepository.suggestPath,
      (server) => server.reply(
        200,
        suggestFixture(
          selectedSupplierId: supplierCheap,
          selectedSupplierName: 'Cheap Supplier',
          cheapAmount: 100000,
          premiumAmount: 150000,
        ),
      ),
      data: {
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '1000'},
        ],
      },
    );

    await tester.pumpWidget(buildSmartPurchaseApp());
    await tester.pumpAndSettle();
    await addIngredient(tester);
    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();

    expect(find.text('Rp 100.000'), findsWidgets);
    expect(
      find.byKey(const Key('smart_purchase_actual_price_$foodSupplyId')),
      findsOneWidget,
    );
    expect(
      find.byKey(const Key('smart_purchase_catalog_update_$foodSupplyId')),
      findsOneWidget,
    );
  });

  testWidgets('actual amount updates totals and batch payload', (tester) async {
    stubFoodSupplyList();

    adapter.onPost(
      PurchaseRequestRepository.suggestPath,
      (server) => server.reply(
        200,
        suggestFixture(
          selectedSupplierId: supplierCheap,
          selectedSupplierName: 'Cheap Supplier',
          cheapAmount: 100000,
          premiumAmount: 150000,
        ),
      ),
      data: {
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '1000'},
        ],
      },
    );

    adapter.onPost(
      PurchaseRequestRepository.batchPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'purchase_requests': [
            {'id': 'pr-1', 'supplier_name': 'Cheap Supplier'},
          ],
        },
      }),
      data: {
        'groups': [
          {
            'supplier_id': supplierCheap,
            'items': [
              {
                'food_supply_id': foodSupplyId,
                'quantity': '1000',
                'line_actual_amount': 88000,
              },
            ],
          },
        ],
      },
    );

    await tester.pumpWidget(buildSmartPurchaseApp());
    await tester.pumpAndSettle();
    await addIngredient(tester);
    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('smart_purchase_actual_price_$foodSupplyId')),
      '88000',
    );
    await tester.pump();

    expect(find.text('Rp 88.000'), findsWidgets);

    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('smart_purchase_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('purchases-list'), findsOneWidget);
  });

  testWidgets('supplier override updates grouping and total', (tester) async {
    stubFoodSupplyList();

    adapter.onPost(
      PurchaseRequestRepository.suggestPath,
      (server) => server.reply(
        200,
        suggestFixture(
          selectedSupplierId: supplierCheap,
          selectedSupplierName: 'Cheap Supplier',
          cheapAmount: 100000,
          premiumAmount: 150000,
        ),
      ),
      data: {
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '1000'},
        ],
      },
    );

    await tester.pumpWidget(buildSmartPurchaseApp());
    await tester.pumpAndSettle();
    await addIngredient(tester);
    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(
        const Key('smart_purchase_supplier_${foodSupplyId}_$supplierCheap'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Premium Supplier · Rp 150'));
    await tester.pumpAndSettle();

    expect(find.text('Rp 150.000'), findsWidgets);
    final switchFinder =
        find.byKey(const Key('smart_purchase_catalog_update_$foodSupplyId'));
    expect(tester.widget<SwitchListTile>(switchFinder).value, isFalse);
  });

  testWidgets('confirm submits batch and returns to purchases list', (tester) async {
    stubFoodSupplyList();

    adapter.onPost(
      PurchaseRequestRepository.suggestPath,
      (server) => server.reply(
        200,
        suggestFixture(
          selectedSupplierId: supplierCheap,
          selectedSupplierName: 'Cheap Supplier',
          cheapAmount: 100000,
          premiumAmount: 150000,
        ),
      ),
      data: {
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '1000'},
        ],
      },
    );

    adapter.onPost(
      PurchaseRequestRepository.batchPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'purchase_requests': [
            {'id': 'pr-1', 'supplier_name': 'Cheap Supplier'},
          ],
        },
      }),
      data: {
        'groups': [
          {
            'supplier_id': supplierCheap,
            'items': [
              {'food_supply_id': foodSupplyId, 'quantity': '1000'},
            ],
          },
        ],
      },
    );

    await tester.pumpWidget(buildSmartPurchaseApp());
    await tester.pumpAndSettle();
    await addIngredient(tester);
    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('smart_purchase_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('purchases-list'), findsOneWidget);
  });

  testWidgets('unmatched item blocks confirm until manual supplier selected',
      (tester) async {
    stubFoodSupplyList();

    adapter.onPost(
      PurchaseRequestRepository.suggestPath,
      (server) => server.reply(
        200,
        suggestFixture(
          selectedSupplierId: supplierCheap,
          selectedSupplierName: 'Cheap Supplier',
          cheapAmount: 100000,
          premiumAmount: 150000,
          hasSupplierPrice: false,
        ),
      ),
      data: {
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '1000'},
        ],
      },
    );

    adapter.onGet(
      '/api/admin/food-supplies/$foodSupplyId/supplier-prices',
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {
            'supplier_id': supplierCheap,
            'supplier_name': 'Cheap Supplier',
            'supplier_price_id': 'price-cheap',
            'price_amount': 100000,
            'price_quantity': 1000,
            'unit_price': 100,
            'unit': 'gr',
          },
        ],
      }),
    );

    await tester.pumpWidget(buildSmartPurchaseApp());
    await tester.pumpAndSettle();
    await addIngredient(tester);
    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('smart_purchase_submit_button')), findsNothing);

    await tester.tap(
      find.byKey(const Key('smart_purchase_manual_supplier_$foodSupplyId')),
    );
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('smart_purchase_manual_price_$supplierCheap')),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('smart_purchase_next_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('smart_purchase_submit_button')), findsOneWidget);
  });
}
