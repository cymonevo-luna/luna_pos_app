// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoreSettings _$StoreSettingsFromJson(Map<String, dynamic> json) =>
    _StoreSettings(
      brandName: json['brand_name'] as String,
      branchName: json['branch_name'] as String,
      branchAddress: json['address'] as String,
      branchPhone: json['phone'] as String,
      thankYouNote:
          json['thank_you_note'] as String? ?? 'Terima kasih telah berbelanja!',
    );

Map<String, dynamic> _$StoreSettingsToJson(_StoreSettings instance) =>
    <String, dynamic>{
      'brand_name': instance.brandName,
      'branch_name': instance.branchName,
      'address': instance.branchAddress,
      'phone': instance.branchPhone,
      'thank_you_note': instance.thankYouNote,
    };
