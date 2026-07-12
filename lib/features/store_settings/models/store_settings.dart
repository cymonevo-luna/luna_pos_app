import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_settings.freezed.dart';
part 'store_settings.g.dart';

@freezed
abstract class StoreSettings with _$StoreSettings {
  const factory StoreSettings({
    @JsonKey(name: 'brand_name') required String brandName,
    @JsonKey(name: 'branch_name') required String branchName,
    @JsonKey(name: 'address') required String branchAddress,
    @JsonKey(name: 'phone') required String branchPhone,
    @JsonKey(name: 'thank_you_note')
    @Default('Terima kasih telah berbelanja!')
    String thankYouNote,
  }) = _StoreSettings;

  factory StoreSettings.fromJson(Map<String, dynamic> json) =>
      _$StoreSettingsFromJson(json);
}
