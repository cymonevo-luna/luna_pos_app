// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoreSettings {

@JsonKey(name: 'brand_name') String get brandName;@JsonKey(name: 'branch_name') String get branchName;@JsonKey(name: 'branch_address') String get branchAddress;@JsonKey(name: 'branch_phone') String get branchPhone;@JsonKey(name: 'thank_you_note') String get thankYouNote;
/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreSettingsCopyWith<StoreSettings> get copyWith => _$StoreSettingsCopyWithImpl<StoreSettings>(this as StoreSettings, _$identity);

  /// Serializes this StoreSettings to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreSettings&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.branchAddress, branchAddress) || other.branchAddress == branchAddress)&&(identical(other.branchPhone, branchPhone) || other.branchPhone == branchPhone)&&(identical(other.thankYouNote, thankYouNote) || other.thankYouNote == thankYouNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,brandName,branchName,branchAddress,branchPhone,thankYouNote);

@override
String toString() {
  return 'StoreSettings(brandName: $brandName, branchName: $branchName, branchAddress: $branchAddress, branchPhone: $branchPhone, thankYouNote: $thankYouNote)';
}


}

/// @nodoc
abstract mixin class $StoreSettingsCopyWith<$Res>  {
  factory $StoreSettingsCopyWith(StoreSettings value, $Res Function(StoreSettings) _then) = _$StoreSettingsCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'brand_name') String brandName,@JsonKey(name: 'branch_name') String branchName,@JsonKey(name: 'branch_address') String branchAddress,@JsonKey(name: 'branch_phone') String branchPhone,@JsonKey(name: 'thank_you_note') String thankYouNote
});




}
/// @nodoc
class _$StoreSettingsCopyWithImpl<$Res>
    implements $StoreSettingsCopyWith<$Res> {
  _$StoreSettingsCopyWithImpl(this._self, this._then);

  final StoreSettings _self;
  final $Res Function(StoreSettings) _then;

/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brandName = null,Object? branchName = null,Object? branchAddress = null,Object? branchPhone = null,Object? thankYouNote = null,}) {
  return _then(_self.copyWith(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,branchAddress: null == branchAddress ? _self.branchAddress : branchAddress // ignore: cast_nullable_to_non_nullable
as String,branchPhone: null == branchPhone ? _self.branchPhone : branchPhone // ignore: cast_nullable_to_non_nullable
as String,thankYouNote: null == thankYouNote ? _self.thankYouNote : thankYouNote // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreSettings].
extension StoreSettingsPatterns on StoreSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreSettings value)  $default,){
final _that = this;
switch (_that) {
case _StoreSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreSettings value)?  $default,){
final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'brand_name')  String brandName, @JsonKey(name: 'branch_name')  String branchName, @JsonKey(name: 'branch_address')  String branchAddress, @JsonKey(name: 'branch_phone')  String branchPhone, @JsonKey(name: 'thank_you_note')  String thankYouNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
return $default(_that.brandName,_that.branchName,_that.branchAddress,_that.branchPhone,_that.thankYouNote);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'brand_name')  String brandName, @JsonKey(name: 'branch_name')  String branchName, @JsonKey(name: 'branch_address')  String branchAddress, @JsonKey(name: 'branch_phone')  String branchPhone, @JsonKey(name: 'thank_you_note')  String thankYouNote)  $default,) {final _that = this;
switch (_that) {
case _StoreSettings():
return $default(_that.brandName,_that.branchName,_that.branchAddress,_that.branchPhone,_that.thankYouNote);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'brand_name')  String brandName, @JsonKey(name: 'branch_name')  String branchName, @JsonKey(name: 'branch_address')  String branchAddress, @JsonKey(name: 'branch_phone')  String branchPhone, @JsonKey(name: 'thank_you_note')  String thankYouNote)?  $default,) {final _that = this;
switch (_that) {
case _StoreSettings() when $default != null:
return $default(_that.brandName,_that.branchName,_that.branchAddress,_that.branchPhone,_that.thankYouNote);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreSettings implements StoreSettings {
  const _StoreSettings({@JsonKey(name: 'brand_name') required this.brandName, @JsonKey(name: 'branch_name') required this.branchName, @JsonKey(name: 'branch_address') required this.branchAddress, @JsonKey(name: 'branch_phone') required this.branchPhone, @JsonKey(name: 'thank_you_note') this.thankYouNote = 'Terima kasih telah berbelanja!'});
  factory _StoreSettings.fromJson(Map<String, dynamic> json) => _$StoreSettingsFromJson(json);

@override@JsonKey(name: 'brand_name') final  String brandName;
@override@JsonKey(name: 'branch_name') final  String branchName;
@override@JsonKey(name: 'branch_address') final  String branchAddress;
@override@JsonKey(name: 'branch_phone') final  String branchPhone;
@override@JsonKey(name: 'thank_you_note') final  String thankYouNote;

/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreSettingsCopyWith<_StoreSettings> get copyWith => __$StoreSettingsCopyWithImpl<_StoreSettings>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreSettingsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreSettings&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.branchAddress, branchAddress) || other.branchAddress == branchAddress)&&(identical(other.branchPhone, branchPhone) || other.branchPhone == branchPhone)&&(identical(other.thankYouNote, thankYouNote) || other.thankYouNote == thankYouNote));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,brandName,branchName,branchAddress,branchPhone,thankYouNote);

@override
String toString() {
  return 'StoreSettings(brandName: $brandName, branchName: $branchName, branchAddress: $branchAddress, branchPhone: $branchPhone, thankYouNote: $thankYouNote)';
}


}

/// @nodoc
abstract mixin class _$StoreSettingsCopyWith<$Res> implements $StoreSettingsCopyWith<$Res> {
  factory _$StoreSettingsCopyWith(_StoreSettings value, $Res Function(_StoreSettings) _then) = __$StoreSettingsCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'brand_name') String brandName,@JsonKey(name: 'branch_name') String branchName,@JsonKey(name: 'branch_address') String branchAddress,@JsonKey(name: 'branch_phone') String branchPhone,@JsonKey(name: 'thank_you_note') String thankYouNote
});




}
/// @nodoc
class __$StoreSettingsCopyWithImpl<$Res>
    implements _$StoreSettingsCopyWith<$Res> {
  __$StoreSettingsCopyWithImpl(this._self, this._then);

  final _StoreSettings _self;
  final $Res Function(_StoreSettings) _then;

/// Create a copy of StoreSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brandName = null,Object? branchName = null,Object? branchAddress = null,Object? branchPhone = null,Object? thankYouNote = null,}) {
  return _then(_StoreSettings(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,branchAddress: null == branchAddress ? _self.branchAddress : branchAddress // ignore: cast_nullable_to_non_nullable
as String,branchPhone: null == branchPhone ? _self.branchPhone : branchPhone // ignore: cast_nullable_to_non_nullable
as String,thankYouNote: null == thankYouNote ? _self.thankYouNote : thankYouNote // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
