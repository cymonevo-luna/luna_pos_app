import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:luna_pos/core/formatting/currency_formatter.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/menu_management/menu_management_list_controller.dart';
import 'package:luna_pos/features/menu_management/menu_management_list_page.dart';
import 'package:luna_pos/features/menu_management/models/admin_menu.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

class _LoadedMenuManagementController extends MenuManagementListController {
  @override
  MenuManagementState build() {
    return const MenuManagementState(
      items: [
        AdminMenu(
          id: 'menu-1',
          title: 'Nasi Goreng',
          categoryId: 'cat-1',
          categoryName: 'Rice',
          availableStock: 12,
          sellPrice: 25000,
          recipeYield: 1,
          marginPercent: 35,
          vatPercent: 11,
        ),
        AdminMenu(
          id: 'menu-2',
          title: 'Es Teh',
          categoryId: 'cat-2',
          categoryName: 'Drinks',
          availableStock: 0,
          sellPrice: 8000,
          recipeYield: 1,
          marginPercent: 40,
          vatPercent: 11,
        ),
      ],
    );
  }
}

void main() {
  testWidgets('manage menu list page renders items with stock and price',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          menuManagementProvider.overrideWith(
            _LoadedMenuManagementController.new,
          ),
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
          home: const MenuManagementListPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Es Teh'), findsOneWidget);
    expect(find.text('Rice'), findsOneWidget);
    expect(find.text('Drinks'), findsOneWidget);
    expect(find.textContaining('Stock: 12'), findsOneWidget);
    expect(find.textContaining('Stock: 0'), findsOneWidget);
    expect(find.text(formatRupiah(25000)), findsOneWidget);
    expect(find.text(formatRupiah(8000)), findsOneWidget);
  });
}
