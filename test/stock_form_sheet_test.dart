import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/stock/data/food_supply_repository.dart';
import 'package:luna_pos/features/stock/models/food_supply.dart';
import 'package:luna_pos/features/stock/stock_controller.dart';
import 'package:luna_pos/features/stock/stock_form_sheet.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'helpers/auth_harness.dart';

void main() {
  late DioAdapter adapter;
  late ProviderContainer container;

  Widget buildFormApp({FoodSupply? existing}) {
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
        home: Scaffold(
          body: StockFormSheet(existing: existing),
        ),
      ),
    );
  }

  setUp(() async {
    await locator.reset();
    final mocked = buildMockedApiClient();
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<FoodSupplyRepository>(
        () => FoodSupplyRepository(locator<ApiClient>()),
      );
    container = ProviderContainer();
    container.read(stockProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  testWidgets('create supply submits POST', (tester) async {
    adapter.onPost(
      FoodSupplyRepository.listPath,
      (server) => server.reply(201, {
        'success': true,
        'data': {
          'id': 'fs-new',
          'title': 'Sugar',
          'description': 'White sugar',
          'stock_quantity': '1000',
          'unit': 'gr',
        },
      }),
      data: {
        'title': 'Sugar',
        'description': 'White sugar',
        'stock_quantity': 1000,
        'unit': 'gr',
      },
    );
    adapter.onGet(
      FoodSupplyRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [],
        'meta': {'page': 1, 'per_page': 20, 'total': 0},
      }),
      queryParameters: {'page': '1', 'per_page': '20'},
    );

    await tester.pumpWidget(buildFormApp());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('stock_title_field')), 'Sugar');
    await tester.enterText(
      find.byKey(const Key('stock_description_field')),
      'White sugar',
    );
    await tester.enterText(find.byKey(const Key('stock_quantity_field')), '1000');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Sugar'), findsNothing);
  });

  testWidgets('edit supply updates quantity', (tester) async {
    const existing = FoodSupply(
      id: 'fs-1',
      title: 'Flour',
      description: '',
      stockQuantity: 1000,
      unit: 'gr',
    );

    adapter.onPut(
      '${FoodSupplyRepository.listPath}/fs-1',
      (server) => server.reply(200, {
        'success': true,
        'data': {
          'id': 'fs-1',
          'title': 'Flour',
          'description': '',
          'stock_quantity': '1500',
          'unit': 'gr',
        },
      }),
      data: {
        'title': 'Flour',
        'description': '',
        'stock_quantity': 1500,
        'unit': 'gr',
      },
    );

    await tester.pumpWidget(buildFormApp(existing: existing));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('stock_quantity_field')), '1500');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  });
}
