import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_settings.freezed.dart';

@freezed
abstract class StoreSettings with _$StoreSettings {
  const factory StoreSettings({
    required String brandName,
    required String branchName,
    required String branchAddress,
    required String branchPhone,
    @Default('Terima kasih telah berbelanja!') String thankYouNote,
  }) = _StoreSettings;
}
