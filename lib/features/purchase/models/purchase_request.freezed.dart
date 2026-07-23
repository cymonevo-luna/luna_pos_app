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

 String get id;@JsonKey(name: 'supplier_name') String get supplierName; PurchaseRequestStatus get status;@JsonKey(name: 'total_estimated_amount') int get totalEstimatedAmount;@JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) int? get totalActualAmount;@JsonKey(name: 'item_count') int get itemCount;@JsonKey(name: 'created_by_username') String? get createdByUsername;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;
/// Create a copy of PurchaseRequestSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseRequestSummaryCopyWith<PurchaseRequestSummary> get copyWith => _$PurchaseRequestSummaryCopyWithImpl<PurchaseRequestSummary>(this as PurchaseRequestSummary, _$identity);

  /// Serializes this PurchaseRequestSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseRequestSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalEstimatedAmount, totalEstimatedAmount) || other.totalEstimatedAmount == totalEstimatedAmount)&&(identical(other.totalActualAmount, totalActualAmount) || other.totalActualAmount == totalActualAmount)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.createdByUsername, createdByUsername) || other.createdByUsername == createdByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierName,status,totalEstimatedAmount,totalActualAmount,itemCount,createdByUsername,createdAt);

@override
String toString() {
  return 'PurchaseRequestSummary(id: $id, supplierName: $supplierName, status: $status, totalEstimatedAmount: $totalEstimatedAmount, totalActualAmount: $totalActualAmount, itemCount: $itemCount, createdByUsername: $createdByUsername, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PurchaseRequestSummaryCopyWith<$Res>  {
  factory $PurchaseRequestSummaryCopyWith(PurchaseRequestSummary value, $Res Function(PurchaseRequestSummary) _then) = _$PurchaseRequestSummaryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'supplier_name') String supplierName, PurchaseRequestStatus status,@JsonKey(name: 'total_estimated_amount') int totalEstimatedAmount,@JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) int? totalActualAmount,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'created_by_username') String? createdByUsername,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? supplierName = null,Object? status = null,Object? totalEstimatedAmount = null,Object? totalActualAmount = freezed,Object? itemCount = null,Object? createdByUsername = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PurchaseRequestStatus,totalEstimatedAmount: null == totalEstimatedAmount ? _self.totalEstimatedAmount : totalEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int,totalActualAmount: freezed == totalActualAmount ? _self.totalActualAmount : totalActualAmount // ignore: cast_nullable_to_non_nullable
as int?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'supplier_name')  String supplierName,  PurchaseRequestStatus status, @JsonKey(name: 'total_estimated_amount')  int totalEstimatedAmount, @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson)  int? totalActualAmount, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseRequestSummary() when $default != null:
return $default(_that.id,_that.supplierName,_that.status,_that.totalEstimatedAmount,_that.totalActualAmount,_that.itemCount,_that.createdByUsername,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'supplier_name')  String supplierName,  PurchaseRequestStatus status, @JsonKey(name: 'total_estimated_amount')  int totalEstimatedAmount, @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson)  int? totalActualAmount, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestSummary():
return $default(_that.id,_that.supplierName,_that.status,_that.totalEstimatedAmount,_that.totalActualAmount,_that.itemCount,_that.createdByUsername,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'supplier_name')  String supplierName,  PurchaseRequestStatus status, @JsonKey(name: 'total_estimated_amount')  int totalEstimatedAmount, @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson)  int? totalActualAmount, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestSummary() when $default != null:
return $default(_that.id,_that.supplierName,_that.status,_that.totalEstimatedAmount,_that.totalActualAmount,_that.itemCount,_that.createdByUsername,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseRequestSummary implements PurchaseRequestSummary {
  const _PurchaseRequestSummary({required this.id, @JsonKey(name: 'supplier_name') required this.supplierName, required this.status, @JsonKey(name: 'total_estimated_amount') required this.totalEstimatedAmount, @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) this.totalActualAmount, @JsonKey(name: 'item_count') required this.itemCount, @JsonKey(name: 'created_by_username') this.createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt});
  factory _PurchaseRequestSummary.fromJson(Map<String, dynamic> json) => _$PurchaseRequestSummaryFromJson(json);

@override final  String id;
@override@JsonKey(name: 'supplier_name') final  String supplierName;
@override final  PurchaseRequestStatus status;
@override@JsonKey(name: 'total_estimated_amount') final  int totalEstimatedAmount;
@override@JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) final  int? totalActualAmount;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseRequestSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalEstimatedAmount, totalEstimatedAmount) || other.totalEstimatedAmount == totalEstimatedAmount)&&(identical(other.totalActualAmount, totalActualAmount) || other.totalActualAmount == totalActualAmount)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.createdByUsername, createdByUsername) || other.createdByUsername == createdByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierName,status,totalEstimatedAmount,totalActualAmount,itemCount,createdByUsername,createdAt);

@override
String toString() {
  return 'PurchaseRequestSummary(id: $id, supplierName: $supplierName, status: $status, totalEstimatedAmount: $totalEstimatedAmount, totalActualAmount: $totalActualAmount, itemCount: $itemCount, createdByUsername: $createdByUsername, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PurchaseRequestSummaryCopyWith<$Res> implements $PurchaseRequestSummaryCopyWith<$Res> {
  factory _$PurchaseRequestSummaryCopyWith(_PurchaseRequestSummary value, $Res Function(_PurchaseRequestSummary) _then) = __$PurchaseRequestSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'supplier_name') String supplierName, PurchaseRequestStatus status,@JsonKey(name: 'total_estimated_amount') int totalEstimatedAmount,@JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) int? totalActualAmount,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'created_by_username') String? createdByUsername,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? supplierName = null,Object? status = null,Object? totalEstimatedAmount = null,Object? totalActualAmount = freezed,Object? itemCount = null,Object? createdByUsername = freezed,Object? createdAt = freezed,}) {
  return _then(_PurchaseRequestSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PurchaseRequestStatus,totalEstimatedAmount: null == totalEstimatedAmount ? _self.totalEstimatedAmount : totalEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int,totalActualAmount: freezed == totalActualAmount ? _self.totalActualAmount : totalActualAmount // ignore: cast_nullable_to_non_nullable
as int?,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,createdByUsername: freezed == createdByUsername ? _self.createdByUsername : createdByUsername // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$PurchaseRequestItem {

@JsonKey(name: 'food_supply_id') String get foodSupplyId;@JsonKey(name: 'food_supply_title') String? get foodSupplyTitle;@JsonKey(fromJson: _quantityFromJson) num get quantity; String? get unit;@JsonKey(name: 'unit_price', fromJson: _nullableNumFromJson) num? get unitPrice;@JsonKey(name: 'line_estimated_amount', fromJson: _nullableIntFromJson) int? get lineEstimatedAmount;@JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) int? get lineActualAmount;
/// Create a copy of PurchaseRequestItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseRequestItemCopyWith<PurchaseRequestItem> get copyWith => _$PurchaseRequestItemCopyWithImpl<PurchaseRequestItem>(this as PurchaseRequestItem, _$identity);

  /// Serializes this PurchaseRequestItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseRequestItem&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.foodSupplyTitle, foodSupplyTitle) || other.foodSupplyTitle == foodSupplyTitle)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineEstimatedAmount, lineEstimatedAmount) || other.lineEstimatedAmount == lineEstimatedAmount)&&(identical(other.lineActualAmount, lineActualAmount) || other.lineActualAmount == lineActualAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,foodSupplyTitle,quantity,unit,unitPrice,lineEstimatedAmount,lineActualAmount);

@override
String toString() {
  return 'PurchaseRequestItem(foodSupplyId: $foodSupplyId, foodSupplyTitle: $foodSupplyTitle, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, lineEstimatedAmount: $lineEstimatedAmount, lineActualAmount: $lineActualAmount)';
}


}

/// @nodoc
abstract mixin class $PurchaseRequestItemCopyWith<$Res>  {
  factory $PurchaseRequestItemCopyWith(PurchaseRequestItem value, $Res Function(PurchaseRequestItem) _then) = _$PurchaseRequestItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(name: 'food_supply_title') String? foodSupplyTitle,@JsonKey(fromJson: _quantityFromJson) num quantity, String? unit,@JsonKey(name: 'unit_price', fromJson: _nullableNumFromJson) num? unitPrice,@JsonKey(name: 'line_estimated_amount', fromJson: _nullableIntFromJson) int? lineEstimatedAmount,@JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) int? lineActualAmount
});




}
/// @nodoc
class _$PurchaseRequestItemCopyWithImpl<$Res>
    implements $PurchaseRequestItemCopyWith<$Res> {
  _$PurchaseRequestItemCopyWithImpl(this._self, this._then);

  final PurchaseRequestItem _self;
  final $Res Function(PurchaseRequestItem) _then;

/// Create a copy of PurchaseRequestItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? foodSupplyId = null,Object? foodSupplyTitle = freezed,Object? quantity = null,Object? unit = freezed,Object? unitPrice = freezed,Object? lineEstimatedAmount = freezed,Object? lineActualAmount = freezed,}) {
  return _then(_self.copyWith(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,foodSupplyTitle: freezed == foodSupplyTitle ? _self.foodSupplyTitle : foodSupplyTitle // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num?,lineEstimatedAmount: freezed == lineEstimatedAmount ? _self.lineEstimatedAmount : lineEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int?,lineActualAmount: freezed == lineActualAmount ? _self.lineActualAmount : lineActualAmount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseRequestItem].
extension PurchaseRequestItemPatterns on PurchaseRequestItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseRequestItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseRequestItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseRequestItem value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseRequestItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseRequestItem value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseRequestItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String? foodSupplyTitle, @JsonKey(fromJson: _quantityFromJson)  num quantity,  String? unit, @JsonKey(name: 'unit_price', fromJson: _nullableNumFromJson)  num? unitPrice, @JsonKey(name: 'line_estimated_amount', fromJson: _nullableIntFromJson)  int? lineEstimatedAmount, @JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson)  int? lineActualAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseRequestItem() when $default != null:
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.quantity,_that.unit,_that.unitPrice,_that.lineEstimatedAmount,_that.lineActualAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String? foodSupplyTitle, @JsonKey(fromJson: _quantityFromJson)  num quantity,  String? unit, @JsonKey(name: 'unit_price', fromJson: _nullableNumFromJson)  num? unitPrice, @JsonKey(name: 'line_estimated_amount', fromJson: _nullableIntFromJson)  int? lineEstimatedAmount, @JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson)  int? lineActualAmount)  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestItem():
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.quantity,_that.unit,_that.unitPrice,_that.lineEstimatedAmount,_that.lineActualAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String? foodSupplyTitle, @JsonKey(fromJson: _quantityFromJson)  num quantity,  String? unit, @JsonKey(name: 'unit_price', fromJson: _nullableNumFromJson)  num? unitPrice, @JsonKey(name: 'line_estimated_amount', fromJson: _nullableIntFromJson)  int? lineEstimatedAmount, @JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson)  int? lineActualAmount)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestItem() when $default != null:
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.quantity,_that.unit,_that.unitPrice,_that.lineEstimatedAmount,_that.lineActualAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseRequestItem implements PurchaseRequestItem {
  const _PurchaseRequestItem({@JsonKey(name: 'food_supply_id') required this.foodSupplyId, @JsonKey(name: 'food_supply_title') this.foodSupplyTitle, @JsonKey(fromJson: _quantityFromJson) required this.quantity, this.unit, @JsonKey(name: 'unit_price', fromJson: _nullableNumFromJson) this.unitPrice, @JsonKey(name: 'line_estimated_amount', fromJson: _nullableIntFromJson) this.lineEstimatedAmount, @JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) this.lineActualAmount});
  factory _PurchaseRequestItem.fromJson(Map<String, dynamic> json) => _$PurchaseRequestItemFromJson(json);

@override@JsonKey(name: 'food_supply_id') final  String foodSupplyId;
@override@JsonKey(name: 'food_supply_title') final  String? foodSupplyTitle;
@override@JsonKey(fromJson: _quantityFromJson) final  num quantity;
@override final  String? unit;
@override@JsonKey(name: 'unit_price', fromJson: _nullableNumFromJson) final  num? unitPrice;
@override@JsonKey(name: 'line_estimated_amount', fromJson: _nullableIntFromJson) final  int? lineEstimatedAmount;
@override@JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) final  int? lineActualAmount;

/// Create a copy of PurchaseRequestItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseRequestItemCopyWith<_PurchaseRequestItem> get copyWith => __$PurchaseRequestItemCopyWithImpl<_PurchaseRequestItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseRequestItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseRequestItem&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.foodSupplyTitle, foodSupplyTitle) || other.foodSupplyTitle == foodSupplyTitle)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineEstimatedAmount, lineEstimatedAmount) || other.lineEstimatedAmount == lineEstimatedAmount)&&(identical(other.lineActualAmount, lineActualAmount) || other.lineActualAmount == lineActualAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,foodSupplyTitle,quantity,unit,unitPrice,lineEstimatedAmount,lineActualAmount);

@override
String toString() {
  return 'PurchaseRequestItem(foodSupplyId: $foodSupplyId, foodSupplyTitle: $foodSupplyTitle, quantity: $quantity, unit: $unit, unitPrice: $unitPrice, lineEstimatedAmount: $lineEstimatedAmount, lineActualAmount: $lineActualAmount)';
}


}

/// @nodoc
abstract mixin class _$PurchaseRequestItemCopyWith<$Res> implements $PurchaseRequestItemCopyWith<$Res> {
  factory _$PurchaseRequestItemCopyWith(_PurchaseRequestItem value, $Res Function(_PurchaseRequestItem) _then) = __$PurchaseRequestItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(name: 'food_supply_title') String? foodSupplyTitle,@JsonKey(fromJson: _quantityFromJson) num quantity, String? unit,@JsonKey(name: 'unit_price', fromJson: _nullableNumFromJson) num? unitPrice,@JsonKey(name: 'line_estimated_amount', fromJson: _nullableIntFromJson) int? lineEstimatedAmount,@JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) int? lineActualAmount
});




}
/// @nodoc
class __$PurchaseRequestItemCopyWithImpl<$Res>
    implements _$PurchaseRequestItemCopyWith<$Res> {
  __$PurchaseRequestItemCopyWithImpl(this._self, this._then);

  final _PurchaseRequestItem _self;
  final $Res Function(_PurchaseRequestItem) _then;

/// Create a copy of PurchaseRequestItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? foodSupplyId = null,Object? foodSupplyTitle = freezed,Object? quantity = null,Object? unit = freezed,Object? unitPrice = freezed,Object? lineEstimatedAmount = freezed,Object? lineActualAmount = freezed,}) {
  return _then(_PurchaseRequestItem(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,foodSupplyTitle: freezed == foodSupplyTitle ? _self.foodSupplyTitle : foodSupplyTitle // ignore: cast_nullable_to_non_nullable
as String?,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num?,lineEstimatedAmount: freezed == lineEstimatedAmount ? _self.lineEstimatedAmount : lineEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int?,lineActualAmount: freezed == lineActualAmount ? _self.lineActualAmount : lineActualAmount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$PurchaseRequestDetail {

 String get id;@JsonKey(name: 'supplier_id') String get supplierId;@JsonKey(name: 'supplier_name') String get supplierName;@JsonKey(name: 'supplier_contact_info') String? get supplierContactInfo; PurchaseRequestStatus get status;@JsonKey(name: 'total_estimated_amount') int? get totalEstimatedAmount;@JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) int? get totalActualAmount; List<PurchaseRequestItem> get items; String? get notes;@JsonKey(name: 'paid_proof_url') String? get paidProofUrl;@JsonKey(name: 'delivered_proof_url') String? get deliveredProofUrl;@JsonKey(name: 'created_by_username') String? get createdByUsername;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;
/// Create a copy of PurchaseRequestDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PurchaseRequestDetailCopyWith<PurchaseRequestDetail> get copyWith => _$PurchaseRequestDetailCopyWithImpl<PurchaseRequestDetail>(this as PurchaseRequestDetail, _$identity);

  /// Serializes this PurchaseRequestDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PurchaseRequestDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierContactInfo, supplierContactInfo) || other.supplierContactInfo == supplierContactInfo)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalEstimatedAmount, totalEstimatedAmount) || other.totalEstimatedAmount == totalEstimatedAmount)&&(identical(other.totalActualAmount, totalActualAmount) || other.totalActualAmount == totalActualAmount)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidProofUrl, paidProofUrl) || other.paidProofUrl == paidProofUrl)&&(identical(other.deliveredProofUrl, deliveredProofUrl) || other.deliveredProofUrl == deliveredProofUrl)&&(identical(other.createdByUsername, createdByUsername) || other.createdByUsername == createdByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierId,supplierName,supplierContactInfo,status,totalEstimatedAmount,totalActualAmount,const DeepCollectionEquality().hash(items),notes,paidProofUrl,deliveredProofUrl,createdByUsername,createdAt);

@override
String toString() {
  return 'PurchaseRequestDetail(id: $id, supplierId: $supplierId, supplierName: $supplierName, supplierContactInfo: $supplierContactInfo, status: $status, totalEstimatedAmount: $totalEstimatedAmount, totalActualAmount: $totalActualAmount, items: $items, notes: $notes, paidProofUrl: $paidProofUrl, deliveredProofUrl: $deliveredProofUrl, createdByUsername: $createdByUsername, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $PurchaseRequestDetailCopyWith<$Res>  {
  factory $PurchaseRequestDetailCopyWith(PurchaseRequestDetail value, $Res Function(PurchaseRequestDetail) _then) = _$PurchaseRequestDetailCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'supplier_name') String supplierName,@JsonKey(name: 'supplier_contact_info') String? supplierContactInfo, PurchaseRequestStatus status,@JsonKey(name: 'total_estimated_amount') int? totalEstimatedAmount,@JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) int? totalActualAmount, List<PurchaseRequestItem> items, String? notes,@JsonKey(name: 'paid_proof_url') String? paidProofUrl,@JsonKey(name: 'delivered_proof_url') String? deliveredProofUrl,@JsonKey(name: 'created_by_username') String? createdByUsername,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$PurchaseRequestDetailCopyWithImpl<$Res>
    implements $PurchaseRequestDetailCopyWith<$Res> {
  _$PurchaseRequestDetailCopyWithImpl(this._self, this._then);

  final PurchaseRequestDetail _self;
  final $Res Function(PurchaseRequestDetail) _then;

/// Create a copy of PurchaseRequestDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? supplierId = null,Object? supplierName = null,Object? supplierContactInfo = freezed,Object? status = null,Object? totalEstimatedAmount = freezed,Object? totalActualAmount = freezed,Object? items = null,Object? notes = freezed,Object? paidProofUrl = freezed,Object? deliveredProofUrl = freezed,Object? createdByUsername = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,supplierContactInfo: freezed == supplierContactInfo ? _self.supplierContactInfo : supplierContactInfo // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PurchaseRequestStatus,totalEstimatedAmount: freezed == totalEstimatedAmount ? _self.totalEstimatedAmount : totalEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int?,totalActualAmount: freezed == totalActualAmount ? _self.totalActualAmount : totalActualAmount // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseRequestItem>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paidProofUrl: freezed == paidProofUrl ? _self.paidProofUrl : paidProofUrl // ignore: cast_nullable_to_non_nullable
as String?,deliveredProofUrl: freezed == deliveredProofUrl ? _self.deliveredProofUrl : deliveredProofUrl // ignore: cast_nullable_to_non_nullable
as String?,createdByUsername: freezed == createdByUsername ? _self.createdByUsername : createdByUsername // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PurchaseRequestDetail].
extension PurchaseRequestDetailPatterns on PurchaseRequestDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PurchaseRequestDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PurchaseRequestDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PurchaseRequestDetail value)  $default,){
final _that = this;
switch (_that) {
case _PurchaseRequestDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PurchaseRequestDetail value)?  $default,){
final _that = this;
switch (_that) {
case _PurchaseRequestDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'supplier_contact_info')  String? supplierContactInfo,  PurchaseRequestStatus status, @JsonKey(name: 'total_estimated_amount')  int? totalEstimatedAmount, @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson)  int? totalActualAmount,  List<PurchaseRequestItem> items,  String? notes, @JsonKey(name: 'paid_proof_url')  String? paidProofUrl, @JsonKey(name: 'delivered_proof_url')  String? deliveredProofUrl, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PurchaseRequestDetail() when $default != null:
return $default(_that.id,_that.supplierId,_that.supplierName,_that.supplierContactInfo,_that.status,_that.totalEstimatedAmount,_that.totalActualAmount,_that.items,_that.notes,_that.paidProofUrl,_that.deliveredProofUrl,_that.createdByUsername,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'supplier_contact_info')  String? supplierContactInfo,  PurchaseRequestStatus status, @JsonKey(name: 'total_estimated_amount')  int? totalEstimatedAmount, @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson)  int? totalActualAmount,  List<PurchaseRequestItem> items,  String? notes, @JsonKey(name: 'paid_proof_url')  String? paidProofUrl, @JsonKey(name: 'delivered_proof_url')  String? deliveredProofUrl, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestDetail():
return $default(_that.id,_that.supplierId,_that.supplierName,_that.supplierContactInfo,_that.status,_that.totalEstimatedAmount,_that.totalActualAmount,_that.items,_that.notes,_that.paidProofUrl,_that.deliveredProofUrl,_that.createdByUsername,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'supplier_contact_info')  String? supplierContactInfo,  PurchaseRequestStatus status, @JsonKey(name: 'total_estimated_amount')  int? totalEstimatedAmount, @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson)  int? totalActualAmount,  List<PurchaseRequestItem> items,  String? notes, @JsonKey(name: 'paid_proof_url')  String? paidProofUrl, @JsonKey(name: 'delivered_proof_url')  String? deliveredProofUrl, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _PurchaseRequestDetail() when $default != null:
return $default(_that.id,_that.supplierId,_that.supplierName,_that.supplierContactInfo,_that.status,_that.totalEstimatedAmount,_that.totalActualAmount,_that.items,_that.notes,_that.paidProofUrl,_that.deliveredProofUrl,_that.createdByUsername,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PurchaseRequestDetail implements PurchaseRequestDetail {
  const _PurchaseRequestDetail({required this.id, @JsonKey(name: 'supplier_id') required this.supplierId, @JsonKey(name: 'supplier_name') required this.supplierName, @JsonKey(name: 'supplier_contact_info') this.supplierContactInfo, required this.status, @JsonKey(name: 'total_estimated_amount') this.totalEstimatedAmount, @JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) this.totalActualAmount, final  List<PurchaseRequestItem> items = const [], this.notes, @JsonKey(name: 'paid_proof_url') this.paidProofUrl, @JsonKey(name: 'delivered_proof_url') this.deliveredProofUrl, @JsonKey(name: 'created_by_username') this.createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt}): _items = items;
  factory _PurchaseRequestDetail.fromJson(Map<String, dynamic> json) => _$PurchaseRequestDetailFromJson(json);

@override final  String id;
@override@JsonKey(name: 'supplier_id') final  String supplierId;
@override@JsonKey(name: 'supplier_name') final  String supplierName;
@override@JsonKey(name: 'supplier_contact_info') final  String? supplierContactInfo;
@override final  PurchaseRequestStatus status;
@override@JsonKey(name: 'total_estimated_amount') final  int? totalEstimatedAmount;
@override@JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) final  int? totalActualAmount;
 final  List<PurchaseRequestItem> _items;
@override@JsonKey() List<PurchaseRequestItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  String? notes;
@override@JsonKey(name: 'paid_proof_url') final  String? paidProofUrl;
@override@JsonKey(name: 'delivered_proof_url') final  String? deliveredProofUrl;
@override@JsonKey(name: 'created_by_username') final  String? createdByUsername;
@override@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of PurchaseRequestDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PurchaseRequestDetailCopyWith<_PurchaseRequestDetail> get copyWith => __$PurchaseRequestDetailCopyWithImpl<_PurchaseRequestDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PurchaseRequestDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PurchaseRequestDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierContactInfo, supplierContactInfo) || other.supplierContactInfo == supplierContactInfo)&&(identical(other.status, status) || other.status == status)&&(identical(other.totalEstimatedAmount, totalEstimatedAmount) || other.totalEstimatedAmount == totalEstimatedAmount)&&(identical(other.totalActualAmount, totalActualAmount) || other.totalActualAmount == totalActualAmount)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.paidProofUrl, paidProofUrl) || other.paidProofUrl == paidProofUrl)&&(identical(other.deliveredProofUrl, deliveredProofUrl) || other.deliveredProofUrl == deliveredProofUrl)&&(identical(other.createdByUsername, createdByUsername) || other.createdByUsername == createdByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierId,supplierName,supplierContactInfo,status,totalEstimatedAmount,totalActualAmount,const DeepCollectionEquality().hash(_items),notes,paidProofUrl,deliveredProofUrl,createdByUsername,createdAt);

@override
String toString() {
  return 'PurchaseRequestDetail(id: $id, supplierId: $supplierId, supplierName: $supplierName, supplierContactInfo: $supplierContactInfo, status: $status, totalEstimatedAmount: $totalEstimatedAmount, totalActualAmount: $totalActualAmount, items: $items, notes: $notes, paidProofUrl: $paidProofUrl, deliveredProofUrl: $deliveredProofUrl, createdByUsername: $createdByUsername, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$PurchaseRequestDetailCopyWith<$Res> implements $PurchaseRequestDetailCopyWith<$Res> {
  factory _$PurchaseRequestDetailCopyWith(_PurchaseRequestDetail value, $Res Function(_PurchaseRequestDetail) _then) = __$PurchaseRequestDetailCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'supplier_name') String supplierName,@JsonKey(name: 'supplier_contact_info') String? supplierContactInfo, PurchaseRequestStatus status,@JsonKey(name: 'total_estimated_amount') int? totalEstimatedAmount,@JsonKey(name: 'total_actual_amount', fromJson: _nullableIntFromJson) int? totalActualAmount, List<PurchaseRequestItem> items, String? notes,@JsonKey(name: 'paid_proof_url') String? paidProofUrl,@JsonKey(name: 'delivered_proof_url') String? deliveredProofUrl,@JsonKey(name: 'created_by_username') String? createdByUsername,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$PurchaseRequestDetailCopyWithImpl<$Res>
    implements _$PurchaseRequestDetailCopyWith<$Res> {
  __$PurchaseRequestDetailCopyWithImpl(this._self, this._then);

  final _PurchaseRequestDetail _self;
  final $Res Function(_PurchaseRequestDetail) _then;

/// Create a copy of PurchaseRequestDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? supplierId = null,Object? supplierName = null,Object? supplierContactInfo = freezed,Object? status = null,Object? totalEstimatedAmount = freezed,Object? totalActualAmount = freezed,Object? items = null,Object? notes = freezed,Object? paidProofUrl = freezed,Object? deliveredProofUrl = freezed,Object? createdByUsername = freezed,Object? createdAt = freezed,}) {
  return _then(_PurchaseRequestDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,supplierContactInfo: freezed == supplierContactInfo ? _self.supplierContactInfo : supplierContactInfo // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PurchaseRequestStatus,totalEstimatedAmount: freezed == totalEstimatedAmount ? _self.totalEstimatedAmount : totalEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int?,totalActualAmount: freezed == totalActualAmount ? _self.totalActualAmount : totalActualAmount // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<PurchaseRequestItem>,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,paidProofUrl: freezed == paidProofUrl ? _self.paidProofUrl : paidProofUrl // ignore: cast_nullable_to_non_nullable
as String?,deliveredProofUrl: freezed == deliveredProofUrl ? _self.deliveredProofUrl : deliveredProofUrl // ignore: cast_nullable_to_non_nullable
as String?,createdByUsername: freezed == createdByUsername ? _self.createdByUsername : createdByUsername // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
