import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import 'data/store_settings_repository.dart';
import 'models/store_settings.dart';

class StoreSettingsState {
  const StoreSettingsState({
    this.loading = false,
    this.error,
    this.settings,
  });

  final bool loading;
  final String? error;
  final StoreSettings? settings;

  StoreSettingsState copyWith({
    bool? loading,
    String? error,
    StoreSettings? settings,
    bool clearError = false,
  }) {
    return StoreSettingsState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      settings: settings ?? this.settings,
    );
  }
}

class StoreSettingsController extends Notifier<StoreSettingsState> {
  StoreSettingsRepository get _repository => locator<StoreSettingsRepository>();

  @override
  StoreSettingsState build() => const StoreSettingsState();

  /// Returns cached settings when available; otherwise fetches once per session.
  Future<StoreSettings> loadIfNeeded() async {
    final cached = state.settings;
    if (cached != null) return cached;

    state = state.copyWith(loading: true, clearError: true);

    try {
      final settings = await _repository.fetchStoreSettings();
      state = state.copyWith(loading: false, settings: settings);
      return settings;
    } on ApiException catch (error) {
      state = state.copyWith(loading: false, error: error.message);
      rethrow;
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Failed to load store settings',
      );
      rethrow;
    }
  }
}

final storeSettingsProvider =
    NotifierProvider<StoreSettingsController, StoreSettingsState>(
  StoreSettingsController.new,
);
