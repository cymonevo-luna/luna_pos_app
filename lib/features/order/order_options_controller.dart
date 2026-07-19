import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import '../../core/network/resource_cache.dart';
import '../auth/auth_controller.dart';
import 'data/order_option_repository.dart';
import 'models/order_option.dart';

class OrderOptionsState {
  const OrderOptionsState({
    this.loading = false,
    this.error,
    this.options = const [],
    this.merchantId,
  });

  final bool loading;
  final String? error;
  final List<OrderOption> options;
  final String? merchantId;

  bool get isEmpty => !loading && error == null && options.isEmpty;

  OrderOptionsState copyWith({
    bool? loading,
    String? error,
    List<OrderOption>? options,
    String? merchantId,
    bool clearError = false,
    bool clearOptions = false,
  }) {
    return OrderOptionsState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      options: clearOptions ? const [] : (options ?? this.options),
      merchantId: merchantId ?? this.merchantId,
    );
  }
}

class OrderOptionsController extends Notifier<OrderOptionsState> {
  OrderOptionRepository get _repository => locator<OrderOptionRepository>();

  DateTime? _fetchedAt;

  @override
  OrderOptionsState build() {
    ref.listen(
      authProvider.select((auth) => auth.user?.merchantId),
      (previous, next) {
        if (previous != null && next != null && previous != next) {
          refresh();
        }
      },
    );

    return const OrderOptionsState();
  }

  /// Returns cached options when available for the current merchant.
  Future<void> loadIfNeeded() async {
    final merchantId = ref.read(authProvider).user?.merchantId;
    if (merchantId != null &&
        state.merchantId == merchantId &&
        state.options.isNotEmpty) {
      final fetchedAt = _fetchedAt;
      if (fetchedAt != null &&
          DateTime.now().difference(fetchedAt) < ResourceCache.cacheTtl) {
        return;
      }
    }
    await refresh();
  }

  Future<void> refresh({bool forceRefresh = false}) async {
    final merchantId = ref.read(authProvider).user?.merchantId;
    state = state.copyWith(loading: true, clearError: true);

    try {
      final response =
          await _repository.fetchOrderOptions(forceRefresh: forceRefresh);
      final sorted = List<OrderOption>.from(response.options)
        ..sort((a, b) => b.priority.compareTo(a.priority));

      _fetchedAt = DateTime.now();
      state = state.copyWith(
        loading: false,
        options: sorted,
        merchantId: merchantId,
      );
    } on ApiException catch (error) {
      state = state.copyWith(loading: false, error: error.message);
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Failed to load order options',
      );
    }
  }

  OrderOption? optionById(String? id) {
    if (id == null) return null;
    for (final option in state.options) {
      if (option.id == id) return option;
    }
    return null;
  }
}

final orderOptionsProvider =
    NotifierProvider<OrderOptionsController, OrderOptionsState>(
  OrderOptionsController.new,
);
