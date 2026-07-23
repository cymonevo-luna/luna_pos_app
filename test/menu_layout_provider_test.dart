import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:luna_pos/core/di/locator.dart';
import 'package:luna_pos/core/storage/preferences_service.dart';
import 'package:luna_pos/features/menu/menu_layout_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await locator.reset();
    locator.registerSingleton<PreferencesService>(
      await PreferencesService.create(),
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('default layout is grid', () {
    container = ProviderContainer();
    expect(container.read(menuLayoutProvider), MenuLayout.grid);
  });

  test('layout preference persists', () {
    container = ProviderContainer();
    container.read(menuLayoutProvider.notifier).setLayout(MenuLayout.list);

    container.dispose();
    container = ProviderContainer();

    expect(container.read(menuLayoutProvider), MenuLayout.list);
    expect(
      locator<PreferencesService>().getString(PrefKeys.menuLayout),
      'list',
    );
  });
}
