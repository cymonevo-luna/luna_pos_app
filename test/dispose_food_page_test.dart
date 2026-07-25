import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:luna_pos/app.dart';
import 'package:luna_pos/core/config/app_config.dart';
import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/network/api_client.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/menu/data/menu_repository.dart';
import 'package:luna_pos/features/menu_disposal/data/menu_disposal_repository.dart';
import 'package:luna_pos/features/menu_disposal/dispose_food_controller.dart';
import 'package:luna_pos/features/menu/models/pos_menu.dart';
import 'package:luna_pos/l10n/app_localizations_en.dart';
import 'package:luna_pos/shared/widgets/app_button.dart';
import 'package:luna_pos/testing/test_accounts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/auth_harness.dart';

void main() {
  const sampleMenu = POSMenuItem(
    id: 'menu-1',
    title: 'Nasi Goreng',
    availableStock: 1,
    sellPrice: 35000,
  );

  final l10n = AppLocalizationsEn();

  test('setQuantity blocks quantity above available stock', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(disposeFoodProvider.notifier);
    notifier.selectMenu(sampleMenu);
    notifier.setQuantity(5);

    final state = container.read(disposeFoodProvider);
    expect(state.quantityError, isNotNull);
    expect(state.canSubmit, isFalse);
  });

  test('setQuantity blocks zero quantity', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(disposeFoodProvider.notifier);
    notifier.selectMenu(sampleMenu);
    notifier.setQuantity(0);

    final state = container.read(disposeFoodProvider);
    expect(state.quantityError, isNotNull);
    expect(state.canSubmit, isFalse);
  });

  group('DisposeFoodPage', () {
    late DioAdapter adapter;
    late FakeSecureStorage secure;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      await AppConfig.load();
      await locator.reset();
      final mocked = buildMockedApiClient();
      adapter = mocked.adapter;
      secure = FakeSecureStorage();
      registerAuthTestServices(secure: secure, client: mocked.client);
      locator
        ..registerSingleton<PreferencesService>(
          await PreferencesService.create(),
        )
        ..registerLazySingleton<MenuRepository>(
          () => MenuRepository(locator<ApiClient>(), testResourceCache()),
        )
        ..registerLazySingleton<MenuDisposalRepository>(
          () => MenuDisposalRepository(
            locator<ApiClient>(),
            testResourceCache(),
          ),
        );

      seedAuthenticatedTestAccount(
        secure,
        adapter,
        TestAccountRole.cashier,
      );
      stubTokenRefresh(adapter);
    });

    void stubMenus({required int availableStock}) {
      adapter.onGet(
        MenuRepository.menusPath,
        (server) => server.replyCallback(200, (_) => {
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
                        'available_stock': availableStock,
                        'sell_price': 35000,
                      },
                    ],
                  },
                ],
              },
            }),
      );
    }

    void stubCreateDisposal({
      required int quantity,
      int lossAmount = 70000,
    }) {
      adapter.onPost(
        MenuDisposalRepository.listPath,
        (server) => server.reply(201, {
          'success': true,
          'data': {
            'id': 'disposal-1',
            'menu_title': 'Nasi Goreng',
            'quantity': quantity,
            'loss_amount': lossAmount,
            'disposed_at': '2026-07-24T10:00:00Z',
          },
        }),
        data: {'menu_id': 'm1', 'quantity': quantity},
      );
    }

    Future<void> pumpApp(WidgetTester tester) async {
      await tester.pumpWidget(const ProviderScope(child: App()));
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle(
        const Duration(milliseconds: 100),
        EnginePhase.sendSemanticsUpdate,
        const Duration(seconds: 5),
      );
    }

    Future<void> openDisposeFood(WidgetTester tester) async {
      await tester.tap(find.text(l10n.disposeFoodTitle));
      await tester.pumpAndSettle();
    }

    testWidgets('submit returns to food list without spinner', (tester) async {
      stubMenus(availableStock: 5);
      stubCreateDisposal(quantity: 2);

      await pumpApp(tester);
      await openDisposeFood(tester);

      await tester.tap(find.byKey(const Key('dispose_menu_row_m1')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('dispose_food_quantity_field')),
        '2',
      );
      await tester.pumpAndSettle();

      final submitFinder = find.byKey(const Key('dispose_food_submit'));
      await tester.ensureVisible(submitFinder);
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(find.text(l10n.disposeFoodSelectMenu), findsOneWidget);
      expect(find.byKey(const Key('dispose_menu_row_m1')), findsOneWidget);
      expect(find.byKey(const Key('dispose_food_submit')), findsNothing);
      expect(
        find.descendant(
          of: find.byType(Scaffold).first,
          matching: find.byType(CircularProgressIndicator),
        ),
        findsNothing,
      );
    });

    testWidgets('submit button stops loading after success when re-selected',
        (tester) async {
      stubMenus(availableStock: 5);
      stubCreateDisposal(quantity: 1);

      await pumpApp(tester);
      await openDisposeFood(tester);

      await tester.tap(find.byKey(const Key('dispose_menu_row_m1')));
      await tester.pumpAndSettle();

      final submitFinder = find.byKey(const Key('dispose_food_submit'));
      await tester.ensureVisible(submitFinder);
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(find.text(l10n.disposeFoodSelectMenu), findsOneWidget);

      await tester.tap(find.byKey(const Key('dispose_menu_row_m1')));
      await tester.pumpAndSettle();

      final resubmitFinder = find.byKey(const Key('dispose_food_submit'));
      final submitButton = tester.widget<AppButton>(resubmitFinder);
      expect(submitButton.loading, isFalse);
      expect(submitButton.onPressed, isNotNull);
    });

    testWidgets('success snackbar still shown after submit', (tester) async {
      stubMenus(availableStock: 5);
      stubCreateDisposal(quantity: 2, lossAmount: 70000);

      await pumpApp(tester);
      await openDisposeFood(tester);

      await tester.tap(find.byKey(const Key('dispose_menu_row_m1')));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('dispose_food_quantity_field')),
        '2',
      );
      await tester.pumpAndSettle();

      final submitFinder = find.byKey(const Key('dispose_food_submit'));
      await tester.ensureVisible(submitFinder);
      await tester.tap(submitFinder);
      await tester.pumpAndSettle();

      expect(find.textContaining('Nasi Goreng'), findsWidgets);
      expect(find.textContaining('Loss:'), findsOneWidget);
    });
  });
}
