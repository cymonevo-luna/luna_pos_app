import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/menu_management/data/admin_category_repository.dart';
import 'package:luna_pos/features/menu_management/data/admin_menu_repository.dart';
import 'package:luna_pos/features/menu_management/menu_management_form_sheet.dart';
import 'package:luna_pos/features/menu_management/menu_management_list_controller.dart';
import 'package:luna_pos/features/purchase/data/purchase_image_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:luna_pos/l10n/app_localizations.dart';

import 'helpers/auth_harness.dart';

class _NoopMenuManagementController extends MenuManagementListController {
  @override
  MenuManagementState build() => const MenuManagementState();
}

void main() {
  late DioAdapter adapter;
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
    adapter = mocked.adapter;
    locator
      ..registerSingleton<ApiClient>(mocked.client)
      ..registerLazySingleton<AdminMenuRepository>(
        () => AdminMenuRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<AdminCategoryRepository>(
        () => AdminCategoryRepository(locator<ApiClient>()),
      )
      ..registerLazySingleton<PurchaseImagePicker>(
        () => _FakePurchaseImagePicker(),
      );
    adapter.onGet(
      AdminCategoryRepository.listPath,
      (server) => server.reply(200, {
        'success': true,
        'data': [
          {'id': 'cat-1', 'name': 'Rice'},
        ],
        'meta': {'page': 1, 'per_page': '100', 'total': 1},
      }),
      queryParameters: {'page': '1', 'per_page': '100'},
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
}

class _FakePurchaseImagePicker implements PurchaseImagePicker {
  @override
  Future<XFile?> pickFromCamera() async => null;

  @override
  Future<XFile?> pickFromGallery() async => null;
}
