import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import 'data/menu_repository.dart';
import 'models/cart_line.dart';
import 'models/pos_menu.dart';

class MenuState {
  const MenuState({
    this.loading = false,
    this.refreshing = false,
    this.error,
    this.data,
    this.cart = const {},
  });

  final bool loading;
  final bool refreshing;
  final String? error;
  final POSMenusResponse? data;
  final Map<String, CartLine> cart;

  bool get isEmpty =>
      data != null &&
      (data!.categories.isEmpty ||
          data!.categories.every((category) => category.menus.isEmpty));

  bool get hasCartItems => cart.isNotEmpty;

  int get cartItemCount =>
      cart.values.fold(0, (sum, line) => sum + line.quantity);

  int get cartSubtotal =>
      cart.values.fold(0, (sum, line) => sum + line.lineTotal);

  MenuState copyWith({
    bool? loading,
    bool? refreshing,
    String? error,
    POSMenusResponse? data,
    Map<String, CartLine>? cart,
    bool clearError = false,
    bool clearCart = false,
  }) {
    return MenuState(
      loading: loading ?? this.loading,
      refreshing: refreshing ?? this.refreshing,
      error: clearError ? null : (error ?? this.error),
      data: data ?? this.data,
      cart: clearCart ? const {} : (cart ?? this.cart),
    );
  }
}

class MenuController extends Notifier<MenuState> {
  MenuRepository get _repository => locator<MenuRepository>();

  @override
  MenuState build() {
    Future.microtask(load);
    return const MenuState(loading: true);
  }

  Future<void> load() => _fetch(refreshing: false);

  Future<void> refresh() => _fetch(refreshing: true);

  Future<void> retry() => _fetch(refreshing: false, forceLoading: true);

  Future<void> _fetch({
    required bool refreshing,
    bool forceLoading = false,
  }) async {
    state = state.copyWith(
      loading: forceLoading || (!refreshing && state.data == null),
      refreshing: refreshing,
      clearError: true,
    );

    try {
      final data = await _repository.fetchPOSMenus();
      final prunedCart = _pruneCart(state.cart, data);

      state = state.copyWith(
        loading: false,
        refreshing: false,
        data: data,
        cart: prunedCart,
      );
    } on ApiException catch (e) {
      state = state.copyWith(
        loading: false,
        refreshing: false,
        error: e.message,
      );
    } catch (_) {
      state = state.copyWith(
        loading: false,
        refreshing: false,
        error: 'Failed to load menu items',
      );
    }
  }

  Map<String, CartLine> _pruneCart(
    Map<String, CartLine> cart,
    POSMenusResponse data,
  ) {
    if (cart.isEmpty) return cart;

    final menuById = <String, POSMenuItem>{
      for (final category in data.categories)
        for (final menu in category.menus) menu.id: menu,
    };

    final pruned = <String, CartLine>{};
    for (final entry in cart.entries) {
      final menu = menuById[entry.key];
      if (menu == null || !menu.isInStock) continue;

      final quantity = entry.value.quantity.clamp(1, menu.availableStock);
      pruned[entry.key] = entry.value.copyWith(
        title: menu.title,
        sellPrice: menu.sellPrice,
        quantity: quantity,
      );
    }
    return pruned;
  }

  void addToCart(POSMenuItem item, {int quantity = 1}) {
    if (!item.isInStock || quantity < 1) return;

    final existing = state.cart[item.id];
    final newQuantity = (existing?.quantity ?? 0) + quantity;
    if (newQuantity > item.availableStock) return;

    final updatedCart = Map<String, CartLine>.from(state.cart);
    updatedCart[item.id] = CartLine(
      menuId: item.id,
      title: item.title,
      sellPrice: item.sellPrice,
      quantity: newQuantity,
    );
    state = state.copyWith(cart: updatedCart);
  }

  void updateCartQuantity(String menuId, int quantity) {
    if (quantity < 1) {
      removeFromCart(menuId);
      return;
    }

    final existing = state.cart[menuId];
    if (existing == null) return;

    final menu = _findMenuItem(menuId);
    if (menu != null && quantity > menu.availableStock) return;

    final updatedCart = Map<String, CartLine>.from(state.cart);
    updatedCart[menuId] = existing.copyWith(quantity: quantity);
    state = state.copyWith(cart: updatedCart);
  }

  void removeFromCart(String menuId) {
    if (!state.cart.containsKey(menuId)) return;

    final updatedCart = Map<String, CartLine>.from(state.cart)..remove(menuId);
    state = state.copyWith(cart: updatedCart);
  }

  void clearCart() {
    if (state.cart.isEmpty) return;
    state = state.copyWith(clearCart: true);
  }

  POSMenuItem? _findMenuItem(String menuId) {
    final data = state.data;
    if (data == null) return null;

    for (final category in data.categories) {
      for (final menu in category.menus) {
        if (menu.id == menuId) return menu;
      }
    }
    return null;
  }
}

final menuProvider = NotifierProvider<MenuController, MenuState>(
  MenuController.new,
);
