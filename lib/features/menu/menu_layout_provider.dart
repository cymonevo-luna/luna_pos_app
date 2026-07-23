import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/storage/preferences_service.dart';

/// How menu items are displayed on the menu screen.
enum MenuLayout {
  grid,
  list;

  static MenuLayout fromName(String? name) => MenuLayout.values.firstWhere(
        (layout) => layout.name == name,
        orElse: () => MenuLayout.grid,
      );
}

/// Owns the active menu layout. Restores from [PreferencesService] on creation
/// and persists every change, so selections survive restarts.
class MenuLayoutNotifier extends Notifier<MenuLayout> {
  PreferencesService get _prefs => locator<PreferencesService>();

  @override
  MenuLayout build() {
    if (!_prefs.containsKey(PrefKeys.menuLayout)) return MenuLayout.grid;
    return MenuLayout.fromName(_prefs.getString(PrefKeys.menuLayout));
  }

  void setLayout(MenuLayout layout) {
    if (state == layout) return;
    state = layout;
    _prefs.setString(PrefKeys.menuLayout, layout.name);
  }
}

/// Watch with `ref.watch(menuLayoutProvider)`; mutate with
/// `ref.read(menuLayoutProvider.notifier)`.
final menuLayoutProvider =
    NotifierProvider<MenuLayoutNotifier, MenuLayout>(MenuLayoutNotifier.new);
