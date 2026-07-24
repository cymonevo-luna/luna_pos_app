import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import 'data/menu_disposal_repository.dart';
import 'models/menu_disposal.dart';

class DisposalDetailState {
  const DisposalDetailState({
    this.loading = false,
    this.error,
    this.forbidden = false,
    this.detail,
  });

  final bool loading;
  final String? error;
  final bool forbidden;
  final MenuDisposalListItem? detail;

  DisposalDetailState copyWith({
    bool? loading,
    String? error,
    bool? forbidden,
    MenuDisposalListItem? detail,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return DisposalDetailState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      detail: detail ?? this.detail,
    );
  }
}

class DisposalDetailController extends Notifier<DisposalDetailState> {
  DisposalDetailController(this._disposalId);

  final String _disposalId;

  MenuDisposalRepository get _repository => locator<MenuDisposalRepository>();

  @override
  DisposalDetailState build() {
    Future.microtask(load);
    return const DisposalDetailState(loading: true);
  }

  Future<void> load({bool forceRefresh = false}) async {
    state = state.copyWith(loading: true, clearError: true, clearForbidden: true);

    try {
      final detail = await _repository.getMenuDisposal(
        _disposalId,
        forceRefresh: forceRefresh,
      );
      state = state.copyWith(loading: false, detail: detail);
    } on ApiException catch (e) {
      if (e.type == ApiErrorType.forbidden) {
        state = state.copyWith(
          loading: false,
          forbidden: true,
          error: e.message,
        );
        return;
      }
      state = state.copyWith(loading: false, error: e.message);
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: 'Failed to load disposal details',
      );
    }
  }

  Future<void> retry() => load(forceRefresh: true);
}

final disposalDetailProvider = NotifierProvider.family<
    DisposalDetailController, DisposalDetailState, String>(
  DisposalDetailController.new,
);
