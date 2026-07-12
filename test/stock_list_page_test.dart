import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/stock/models/food_supply.dart';
import 'package:luna_pos/features/stock/stock_controller.dart';
import 'package:luna_pos/features/stock/stock_list_page.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class _LoadedStockController extends StockController {
  @override
  StockState build() {
    return StockState(
      items: const [
        FoodSupply(
          id: 'fs-1',
          title: 'Flour',
          description: 'All-purpose flour',
          stockQuantity: 2500,
          unit: 'gr',
        ),
        FoodSupply(
          id: 'fs-2',
          title: 'Milk',
          stockQuantity: 500,
          unit: 'ml',
        ),
      ],
    );
  }
}

void main() {
  testWidgets('stock list page renders items', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          stockProvider.overrideWith(_LoadedStockController.new),
        ],
        child: MaterialApp(
          theme: AppTheme.light(AppAccent.blue),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const StockListPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Flour'), findsOneWidget);
    expect(find.text('Milk'), findsOneWidget);
    expect(find.textContaining('2.5 kg'), findsOneWidget);
    expect(find.textContaining('500 ml'), findsOneWidget);
  });
}
