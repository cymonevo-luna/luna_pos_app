// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'purchase_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PurchaseRequestSummary {

 String get id;@JsonKey(name: 'supplier_name') String get supplierName; PurchaseRequestStatus get status;@JsonKey(name: 'total_estimated_amount') int get totalEstimatedAmount;@JsonKey(name: 'item_count') int get itemCount;@JsonKey(name: 'created_by_username') String? get createdByUsername;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;
/// Create a copy of PurchaseRequestSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseRequestSummaryCopyWith<PurchaseRequestSummary> get copyWith => _$PurchaseRequestSummaryCopyWithImpl<PurchaseRequestSummary>(this as PurchaseRequestSummary, _$identity);

  /// Serializes this PurchaseRequestSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseRequestSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalEstimatedAmount, totalEstimatedAmount) || other.totalEstimatedAmount == totalEstimatedAmount)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.createdByUsername, createdByUsername) || other.createdByUsername == createdByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierName,status,totalEstimatedAmount,itemCount,createdByUsername,createdAt);

@override
String toString() {
  return 'PurchaseRequestSummary(id: $id, supplierName: $supplierName, status: $status, totalEstimatedAmount: $totalEstimatedAmount, itemCount: $itemCount, createdByUsername: $createdByUsername, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PurchaseRequestSummaryCopyWith<$Res>  {
  factory $PurchaseRequestSummaryCopyWith(PurchaseRequestSummary value, $Res Function(PurchaseRequestSummary) _then) = _$PurchaseRequestSummaryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'supplier_name') String supplierName, PurchaseRequestStatus status,@JsonKey(name: 'total_estimated_amount') int totalEstimatedAmount,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'created_by_username') String? createdByUsername,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$PurchaseRequestSummaryCopyWithImpl<$Res>
    implements $PurchaseRequestSummaryCopyWith<$Res> {
  _$PurchaseRequestSummaryCopyWithImpl(this._self, this._then);

  final PurchaseRequestSummary _self;
  final $Res Function(PurchaseRequestSummary) _then;

/// Create a copy of PurchaseRequestSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? supplierName = null,Object? status = null,Object? totalEstimatedAmount = null,Object? itemCount = null,Object? createdByUsername = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PurchaseRequestStatus,totalEstimatedAmount: null == totalEstimatedAmount ? _self.totalEstimatedAmount : totalEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,createdByUsername: freezed == createdByUsername ? _self.createdByUsername : createdByUsername // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseRequestSummary].
extension PurchaseRequestSummaryPatterns on PurchaseRequestSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseRequestSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseRequestSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseRequestSummary value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseRequestSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseRequestSummary value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseRequestSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'supplier_name')  String supplierName,  PurchaseRequestStatus status, @JsonKey(name: 'total_estimated_amount')  int totalEstimatedAmount, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseRequestSummary() when $default != null:
return $default(_that.id,_that.supplierName,_that.status,_that.totalEstimatedAmount,_that.itemCount,_that.createdByUsername,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'supplier_name')  String supplierName,  PurchaseRequestStatus status, @JsonKey(name: 'total_estimated_amount')  int totalEstimatedAmount, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestSummary():
return $default(_that.id,_that.supplierName,_that.status,_that.totalEstimatedAmount,_that.itemCount,_that.createdByUsername,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'supplier_name')  String supplierName,  PurchaseRequestStatus status, @JsonKey(name: 'total_estimated_amount')  int totalEstimatedAmount, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestSummary() when $default != null:
return $default(_that.id,_that.supplierName,_that.status,_that.totalEstimatedAmount,_that.itemCount,_that.createdByUsername,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseRequestSummary implements PurchaseRequestSummary {
  const _PurchaseRequestSummary({required this.id, @JsonKey(name: 'supplier_name') required this.supplierName, required this.status, @JsonKey(name: 'total_estimated_amount') required this.totalEstimatedAmount, @JsonKey(name: 'item_count') required this.itemCount, @JsonKey(name: 'created_by_username') this.createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt});
  factory _PurchaseRequestSummary.fromJson(Map<String, dynamic> json) => _$PurchaseRequestSummaryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'supplier_name') final  String supplierName;
@override final  PurchaseRequestStatus status;
@override@JsonKey(name: 'total_estimated_amount') final  int totalEstimatedAmount;
@override@JsonKey(name: 'item_count') final  int itemCount;
@override@JsonKey(name: 'created_by_username') final  String? createdByUsername;
@override@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of PurchaseRequestSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseRequestSummaryCopyWith<_PurchaseRequestSummary> get copyWith => __$PurchaseRequestSummaryCopyWithImpl<_PurchaseRequestSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseRequestSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseRequestSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalEstimatedAmount, totalEstimatedAmount) || other.totalEstimatedAmount == totalEstimatedAmount)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.createdByUsername, createdByUsername) || other.createdByUsername == createdByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierName,status,totalEstimatedAmount,itemCount,createdByUsername,createdAt);

@override
String toString() {
  return 'PurchaseRequestSummary(id: $id, supplierName: $supplierName, status: $status, totalEstimatedAmount: $totalEstimatedAmount, itemCount: $itemCount, createdByUsername: $createdByUsername, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PurchaseRequestSummaryCopyWith<$Res> implements $PurchaseRequestSummaryCopyWith<$Res> {
  factory _$PurchaseRequestSummaryCopyWith(_PurchaseRequestSummary value, $Res Function(_PurchaseRequestSummary) _then) = __$PurchaseRequestSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'supplier_name') String supplierName, PurchaseRequestStatus status,@JsonKey(name: 'total_estimated_amount') int totalEstimatedAmount,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'created_by_username') String? createdByUsername,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$PurchaseRequestSummaryCopyWithImpl<$Res>
    implements _$PurchaseRequestSummaryCopyWith<$Res> {
  __$PurchaseRequestSummaryCopyWithImpl(this._self, this._then);

  final _PurchaseRequestSummary _self;
  final $Res Function(_PurchaseRequestSummary) _then;

/// Create a copy of PurchaseRequestSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? supplierName = null,Object? status = null,Object? totalEstimatedAmount = null,Object? itemCount = null,Object? createdByUsername = freezed,Object? createdAt = freezed,}) {
  return _then(_PurchaseRequestSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PurchaseRequestStatus,totalEstimatedAmount: null == totalEstimatedAmount ? _self.totalEstimatedAmount : totalEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,createdByUsername: freezed == createdByUsername ? _self.createdByUsername : createdByUsername // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
