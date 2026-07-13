import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:luna_pos/core/theme/app_palette.dart';
import 'package:luna_pos/core/theme/app_theme.dart';
import 'package:luna_pos/features/production_request/models/production_request.dart';
import 'package:luna_pos/features/production_request/production_request_controller.dart';
import 'package:luna_pos/features/production_request/production_request_detail_page.dart';
import 'package:luna_pos/features/production_request/production_request_list_page.dart';
import 'package:luna_pos/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class _LoadedProductionRequestListController
    extends ProductionRequestListController {
  @override
  ProductionRequestListState build() {
    return ProductionRequestListState(
      items: const [
        ProductionRequestSummary(
          id: 'pr-1',
          status: ProductionRequestStatus.readyToPick,
          itemCount: 2,
          items: [
            ProductionRequestItem(menuTitle: 'Nasi Goreng', quantity: 2),
            ProductionRequestItem(menuTitle: 'Es Teh', quantity: 1),
          ],
          createdAt: null,
        ),
      ],
    );
  }
}

class _EmptyProductionRequestListController
    extends ProductionRequestListController {
  @override
  ProductionRequestListState build() {
    return const ProductionRequestListState();
  }
}

class _LoadedProductionRequestDetailController
    extends ProductionRequestDetailController {
  _LoadedProductionRequestDetailController(this.id) : super(id);

  final String id;
  var markDoneCalled = false;

  @override
  ProductionRequestDetailState build() {
    return ProductionRequestDetailState(
      detail: ProductionRequestDetail(
        id: id,
        status: ProductionRequestStatus.readyToPick,
        items: const [
          ProductionRequestItem(menuTitle: 'Nasi Goreng', quantity: 2),
        ],
      ),
    );
  }

  @override
  Future<bool> markDone() async {
    markDoneCalled = true;
    return true;
  }
}

void main() {
  testWidgets('production request list AppBar shows Production title',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productionRequestListProvider
              .overrideWith(_EmptyProductionRequestListController.new),
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
          locale: const Locale('en'),
          home: const ProductionRequestListPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Production'), findsOneWidget);
    expect(find.text('Production deliveries'), findsNothing);
  });

  testWidgets('production request list shows Produksi title in Indonesian',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productionRequestListProvider
              .overrideWith(_EmptyProductionRequestListController.new),
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
          locale: const Locale('id'),
          home: const ProductionRequestListPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Produksi'), findsOneWidget);
  });

  testWidgets('bottom nav Production label uses Produksi in Indonesian',
      (tester) async {
    final l10n = lookupAppLocalizations(const Locale('id'));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(AppAccent.blue),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('id'),
        home: Scaffold(
          bottomNavigationBar: NavigationBar(
            selectedIndex: 1,
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.restaurant_menu_outlined),
                label: 'Menu',
              ),
              NavigationDestination(
                icon: const Icon(Icons.lunch_dining_outlined),
                selectedIcon: const Icon(Icons.lunch_dining),
                label: l10n.deliveries,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Produksi'), findsOneWidget);
    expect(find.text('Pengiriman'), findsNothing);
    expect(find.byIcon(Icons.lunch_dining), findsOneWidget);
    expect(find.byIcon(Icons.local_shipping_outlined), findsNothing);
  });

  testWidgets('production request list renders pending deliveries',
      (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productionRequestListProvider
              .overrideWith(_LoadedProductionRequestListController.new),
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
          home: const ProductionRequestListPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.text('Es Teh'), findsOneWidget);
    expect(find.textContaining('Qty: 2'), findsOneWidget);
    expect(find.textContaining('Qty: 1'), findsOneWidget);
  });

  testWidgets('production request list shows empty state', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productionRequestListProvider
              .overrideWith(_EmptyProductionRequestListController.new),
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
          home: const ProductionRequestListPage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('No deliveries pending'), findsOneWidget);
  });

  testWidgets('confirm delivery button triggers markDone', (tester) async {
    final controller = _LoadedProductionRequestDetailController('pr-1');
    final router = GoRouter(
      initialLocation: '/calendar',
      routes: [
        GoRoute(
          path: '/calendar',
          builder: (_, _) => const ProductionRequestListPage(),
        ),
        GoRoute(
          path: '/production-requests/:id',
          builder: (_, state) => ProductionRequestDetailPage(
            requestId: state.pathParameters['id']!,
          ),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          productionRequestListProvider
              .overrideWith(_EmptyProductionRequestListController.new),
          productionRequestDetailProvider('pr-1')
              .overrideWith(() => controller),
        ],
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
      ),
    );
    await tester.pumpAndSettle();

    router.push('/production-requests/pr-1');
    await tester.pumpAndSettle();

    expect(find.text('Nasi Goreng'), findsOneWidget);
    expect(find.byKey(const Key('confirm_delivery_button')), findsOneWidget);

    await tester.tap(find.byKey(const Key('confirm_delivery_button')));
    await tester.pump();
    await tester.pumpAndSettle();

    expect(controller.markDoneCalled, isTrue);
    expect(find.text('Delivery confirmed'), findsOneWidget);
    expect(find.byType(ProductionRequestListPage), findsOneWidget);
  });
}
