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
import 'package:luna_pos/features/purchase/data/supplier_repository.dart';
import 'package:luna_pos/features/purchase/purchase_create_page.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late FakeSecureStorage secure;
  late ProviderContainer container;

  const supplierId = 'sup-1';
  const foodSupplyId = 'fs-1';

  Map<String, dynamic> supplierDetailFixture() => {
        'success': true,
        'data': {
          'id': supplierId,
          'name': 'Toko Sembako Jaya',
          'price_quotes': [
            {
              'food_supply_id': foodSupplyId,
              'food_supply_title': 'Flour',
              'unit': 'gr',
              'price_amount': 140000,
              'price_quantity': 1000,
              'unit_price': 140,
            },
          ],
        },
      };

  Map<String, dynamic> supplierListFixture() => {
        'success': true,
        'data': [
          {'id': supplierId, 'name': 'Toko Sembako Jaya'},
        ],
        'meta': {'page': 1, 'per_page': 20, 'total': 1},
      };

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
      ..registerLazySingleton<SupplierRepository>(
        () => SupplierRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<PurchaseRequestRepository>(
        () => PurchaseRequestRepository(locator<ApiClient>()),
      );

    seedAuthenticatedTestAccount(
      secure,
      adapter,
      TestAccountRole.operational,
    );

    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  Widget buildApp({List<GoRoute>? extraRoutes}) {
    final router = GoRouter(
      initialLocation: AppRoute.purchasesNew.path,
      routes: [
        GoRoute(
          path: AppRoute.purchasesNew.path,
          name: AppRoute.purchasesNew.name,
          builder: (context, state) => const PurchaseCreatePage(),
        ),
        GoRoute(
          path: AppRoute.purchaseDetail.path,
          name: AppRoute.purchaseDetail.name,
          builder: (context, state) => Scaffold(
            body: Center(
              child: Text('detail:${state.pathParameters['id']}'),
            ),
          ),
        ),
        ...?extraRoutes,
      ],
    );

    return UncontrolledProviderScope(
      container: container,
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

  void stubSupplierApis() {
    adapter.onGet(
      SupplierRepository.listPath,
      (server) => server.reply(200, supplierListFixture()),
      queryParameters: {'page': '1', 'per_page': '20'},
    );
    adapter.onGet(
      '${SupplierRepository.listPath}/$supplierId',
      (server) => server.reply(200, supplierDetailFixture()),
    );
  }

  Future<void> selectSupplier(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('purchase_supplier_selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('purchase_supplier_option_$supplierId')));
    await tester.pumpAndSettle();
  }

  Future<void> addCatalogItem(WidgetTester tester) async {
    await tester.tap(find.byKey(const Key('purchase_add_item_button')));
    await tester.pumpAndSettle();
    await tester.tap(
      find.byKey(const Key('purchase_catalog_option_$foodSupplyId')),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('duplicate item blocked client-side', (tester) async {
    stubSupplierApis();

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await selectSupplier(tester);
    await addCatalogItem(tester);
    await addCatalogItem(tester);

    await tester.tap(find.byKey(const Key('purchase_submit_button')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('purchase_duplicate_error')), findsOneWidget);
    expect(
      find.textContaining('Each supply can only appear once'),
      findsOneWidget,
    );
  });

  testWidgets('submit sends correct POST body', (tester) async {
    stubSupplierApis();

    adapter.onPost(
      PurchaseRequestRepository.listPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'pr-created',
          'supplier_id': supplierId,
          'supplier_name': 'Toko Sembako Jaya',
          'status': 'PENDING',
          'total_estimated_amount': 140000,
          'items': [
            {
              'food_supply_id': foodSupplyId,
              'food_supply_title': 'Flour',
              'quantity': '1000',
              'unit': 'gr',
            },
          ],
        },
      }),
      data: {
        'supplier_id': supplierId,
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '1000'},
        ],
      },
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await selectSupplier(tester);
    await addCatalogItem(tester);

    await tester.enterText(
      find.byKey(const Key('purchase_line_item_${foodSupplyId}_quantity')),
      '1000',
    );
    await tester.pump();

    await tester.tap(find.byKey(const Key('purchase_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('detail:pr-created'), findsOneWidget);
  });

  testWidgets('success navigates to detail', (tester) async {
    stubSupplierApis();

    adapter.onPost(
      PurchaseRequestRepository.listPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'new-id',
          'supplier_id': supplierId,
          'supplier_name': 'Toko Sembako Jaya',
          'status': 'PENDING',
          'items': [],
        },
      }),
      data: {
        'supplier_id': supplierId,
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '1'},
        ],
      },
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await selectSupplier(tester);
    await addCatalogItem(tester);
    await tester.tap(find.byKey(const Key('purchase_submit_button')));
    await tester.pumpAndSettle();

    expect(find.text('detail:new-id'), findsOneWidget);
  });

  testWidgets('API catalog mismatch shows error', (tester) async {
    stubSupplierApis();

    adapter.onPost(
      PurchaseRequestRepository.listPath,
      (server) => server.reply(
        422,
        {
          'success': false,
          'error': {
            'message': 'Validation failed',
            'fields': {
              'items[0].food_supply_id': 'not in supplier catalog',
            },
          },
        },
      ),
      data: {
        'supplier_id': supplierId,
        'items': [
          {'food_supply_id': foodSupplyId, 'quantity': '1'},
        ],
      },
    );

    await tester.pumpWidget(buildApp());
    await tester.pumpAndSettle();

    await selectSupplier(tester);
    await addCatalogItem(tester);
    await tester.tap(find.byKey(const Key('purchase_submit_button')));
    await tester.pumpAndSettle();

    expect(find.textContaining('not in supplier catalog'), findsWidgets);
  });
}
