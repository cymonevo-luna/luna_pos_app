import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/di/locator.dart';
import '../../core/network/api_exception.dart';
import 'data/purchase_image_picker.dart';
import 'data/purchase_proof_upload.dart';
import 'data/purchase_request_repository.dart';
import 'models/purchase_request.dart';

class PurchaseDetailState {
  const PurchaseDetailState({
    this.loading = false,
    this.updatingStatus = false,
    this.error,
    this.forbidden = false,
    this.detail,
  });

  final bool loading;
  final bool updatingStatus;
  final String? error;
  final bool forbidden;
  final PurchaseRequestDetail? detail;

  PurchaseDetailState copyWith({
    bool? loading,
    bool? updatingStatus,
    String? error,
    bool? forbidden,
    PurchaseRequestDetail? detail,
    bool clearError = false,
    bool clearForbidden = false,
  }) {
    return PurchaseDetailState(
      loading: loading ?? this.loading,
      updatingStatus: updatingStatus ?? this.updatingStatus,
      error: clearError ? null : (error ?? this.error),
      forbidden: clearForbidden ? false : (forbidden ?? this.forbidden),
      detail: detail ?? this.detail,
    );
  }
}

enum PurchasePhotoSource { camera, gallery }

class PurchaseDetailController extends Notifier<PurchaseDetailState> {
  PurchaseDetailController(this._purchaseId);

  final String _purchaseId;

  PurchaseRequestRepository get _repository =>
      locator<PurchaseRequestRepository>();

  PurchaseProofUpload get _proofUpload => locator<PurchaseProofUpload>();

  PurchaseImagePicker get _imagePicker => locator<PurchaseImagePicker>();

  @override
  PurchaseDetailState build() {
    Future.microtask(load);
    return const PurchaseDetailState(loading: true);
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true, clearForbidden: true);

    try {
      final detail = await _repository.get(_purchaseId);
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
        error: 'Failed to load purchase request',
      );
    }
  }

  Future<void> retry() => load();

  bool statusRequiresProof(PurchaseRequestStatus status) =>
      status == PurchaseRequestStatus.paid ||
      status == PurchaseRequestStatus.delivered;

  Future<bool> updateStatus(PurchaseRequestStatus status) async {
    final current = state.detail;
    if (current == null || current.status == status) return false;

    if (statusRequiresProof(status)) {
      return false;
    }

    return _patchStatus(status);
  }

  Future<bool> updateStatusWithProof(
    PurchaseRequestStatus status,
    PurchasePhotoSource source,
  ) async {
    final current = state.detail;
    if (current == null || current.status == status) return false;

    final file = switch (source) {
      PurchasePhotoSource.camera => await _imagePicker.pickFromCamera(),
      PurchasePhotoSource.gallery => await _imagePicker.pickFromGallery(),
    };
    if (file == null) return false;

    state = state.copyWith(updatingStatus: true, clearError: true);
    try {
      final proofUrl = await _proofUpload.upload(file);
      return await _patchStatus(status, proofUrl: proofUrl);
    } on PurchaseProofValidationException catch (e) {
      state = state.copyWith(updatingStatus: false, error: e.message);
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(updatingStatus: false, error: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        updatingStatus: false,
        error: 'Failed to upload proof photo',
      );
      return false;
    }
  }

  /// Test hook: upload a pre-selected file without invoking the image picker.
  Future<bool> updateStatusWithFile(
    PurchaseRequestStatus status,
    XFile file,
  ) async {
    final current = state.detail;
    if (current == null || current.status == status) return false;

    state = state.copyWith(updatingStatus: true, clearError: true);
    try {
      final proofUrl = await _proofUpload.upload(file);
      return await _patchStatus(status, proofUrl: proofUrl);
    } on PurchaseProofValidationException catch (e) {
      state = state.copyWith(updatingStatus: false, error: e.message);
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(updatingStatus: false, error: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        updatingStatus: false,
        error: 'Failed to upload proof photo',
      );
      return false;
    }
  }

  Future<bool> updatePaidDate(DateTime paidAt) async {
    state = state.copyWith(updatingStatus: true, clearError: true);
    try {
      await _repository.patchPurchasePaidDate(_purchaseId, paidAt);
      final detail = await _repository.get(_purchaseId);
      state = state.copyWith(
        updatingStatus: false,
        detail: detail,
        clearError: true,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(updatingStatus: false, error: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        updatingStatus: false,
        error: 'Failed to update paid date',
      );
      return false;
    }
  }

  Future<bool> _patchStatus(
    PurchaseRequestStatus status, {
    String? proofUrl,
  }) async {
    state = state.copyWith(updatingStatus: true, clearError: true);
    try {
      final updated = await _repository.updateStatus(
        _purchaseId,
        status,
        proofUrl: proofUrl,
      );
      state = state.copyWith(
        updatingStatus: false,
        detail: updated,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(updatingStatus: false, error: e.message);
      return false;
    } catch (_) {
      state = state.copyWith(
        updatingStatus: false,
        error: 'Failed to update status',
      );
      return false;
    }
  }
}

final purchaseDetailProvider = NotifierProvider.family<
    PurchaseDetailController, PurchaseDetailState, String>(
  PurchaseDetailController.new,
);
