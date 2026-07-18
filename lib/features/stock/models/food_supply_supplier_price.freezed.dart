// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_supply_supplier_price.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodSupplySupplierPrice {

@JsonKey(name: 'supplier_id') String get supplierId;@JsonKey(name: 'supplier_name') String get supplierName;@JsonKey(name: 'supplier_price_id') String get supplierPriceId;@JsonKey(name: 'price_amount') int get priceAmount;@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) num get priceQuantity;@JsonKey(name: 'unit_price', fromJson: _decimalFromJson) num get unitPrice; String get unit;
/// Create a copy of FoodSupplySupplierPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodSupplySupplierPriceCopyWith<FoodSupplySupplierPrice> get copyWith => _$FoodSupplySupplierPriceCopyWithImpl<FoodSupplySupplierPrice>(this as FoodSupplySupplierPrice, _$identity);

  /// Serializes this FoodSupplySupplierPrice to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodSupplySupplierPrice&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierPriceId, supplierPriceId) || other.supplierPriceId == supplierPriceId)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceQuantity, priceQuantity) || other.priceQuantity == priceQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supplierId,supplierName,supplierPriceId,priceAmount,priceQuantity,unitPrice,unit);

@override
String toString() {
  return 'FoodSupplySupplierPrice(supplierId: $supplierId, supplierName: $supplierName, supplierPriceId: $supplierPriceId, priceAmount: $priceAmount, priceQuantity: $priceQuantity, unitPrice: $unitPrice, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $FoodSupplySupplierPriceCopyWith<$Res>  {
  factory $FoodSupplySupplierPriceCopyWith(FoodSupplySupplierPrice value, $Res Function(FoodSupplySupplierPrice) _then) = _$FoodSupplySupplierPriceCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'supplier_name') String supplierName,@JsonKey(name: 'supplier_price_id') String supplierPriceId,@JsonKey(name: 'price_amount') int priceAmount,@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) num priceQuantity,@JsonKey(name: 'unit_price', fromJson: _decimalFromJson) num unitPrice, String unit
});




}
/// @nodoc
class _$FoodSupplySupplierPriceCopyWithImpl<$Res>
    implements $FoodSupplySupplierPriceCopyWith<$Res> {
  _$FoodSupplySupplierPriceCopyWithImpl(this._self, this._then);

  final FoodSupplySupplierPrice _self;
  final $Res Function(FoodSupplySupplierPrice) _then;

/// Create a copy of FoodSupplySupplierPrice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supplierId = null,Object? supplierName = null,Object? supplierPriceId = null,Object? priceAmount = null,Object? priceQuantity = null,Object? unitPrice = null,Object? unit = null,}) {
  return _then(_self.copyWith(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,supplierPriceId: null == supplierPriceId ? _self.supplierPriceId : supplierPriceId // ignore: cast_nullable_to_non_nullable
as String,priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as int,priceQuantity: null == priceQuantity ? _self.priceQuantity : priceQuantity // ignore: cast_nullable_to_non_nullable
as num,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodSupplySupplierPrice].
extension FoodSupplySupplierPricePatterns on FoodSupplySupplierPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodSupplySupplierPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodSupplySupplierPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodSupplySupplierPrice value)  $default,){
final _that = this;
switch (_that) {
case _FoodSupplySupplierPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodSupplySupplierPrice value)?  $default,){
final _that = this;
switch (_that) {
case _FoodSupplySupplierPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'supplier_price_id')  String supplierPriceId, @JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson)  num priceQuantity, @JsonKey(name: 'unit_price', fromJson: _decimalFromJson)  num unitPrice,  String unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodSupplySupplierPrice() when $default != null:
return $default(_that.supplierId,_that.supplierName,_that.supplierPriceId,_that.priceAmount,_that.priceQuantity,_that.unitPrice,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'supplier_price_id')  String supplierPriceId, @JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson)  num priceQuantity, @JsonKey(name: 'unit_price', fromJson: _decimalFromJson)  num unitPrice,  String unit)  $default,) {final _that = this;
switch (_that) {
case _FoodSupplySupplierPrice():
return $default(_that.supplierId,_that.supplierName,_that.supplierPriceId,_that.priceAmount,_that.priceQuantity,_that.unitPrice,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'supplier_price_id')  String supplierPriceId, @JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson)  num priceQuantity, @JsonKey(name: 'unit_price', fromJson: _decimalFromJson)  num unitPrice,  String unit)?  $default,) {final _that = this;
switch (_that) {
case _FoodSupplySupplierPrice() when $default != null:
return $default(_that.supplierId,_that.supplierName,_that.supplierPriceId,_that.priceAmount,_that.priceQuantity,_that.unitPrice,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodSupplySupplierPrice implements FoodSupplySupplierPrice {
  const _FoodSupplySupplierPrice({@JsonKey(name: 'supplier_id') required this.supplierId, @JsonKey(name: 'supplier_name') required this.supplierName, @JsonKey(name: 'supplier_price_id') required this.supplierPriceId, @JsonKey(name: 'price_amount') required this.priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) required this.priceQuantity, @JsonKey(name: 'unit_price', fromJson: _decimalFromJson) required this.unitPrice, required this.unit});
  factory _FoodSupplySupplierPrice.fromJson(Map<String, dynamic> json) => _$FoodSupplySupplierPriceFromJson(json);

@override@JsonKey(name: 'supplier_id') final  String supplierId;
@override@JsonKey(name: 'supplier_name') final  String supplierName;
@override@JsonKey(name: 'supplier_price_id') final  String supplierPriceId;
@override@JsonKey(name: 'price_amount') final  int priceAmount;
@override@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) final  num priceQuantity;
@override@JsonKey(name: 'unit_price', fromJson: _decimalFromJson) final  num unitPrice;
@override final  String unit;

/// Create a copy of FoodSupplySupplierPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodSupplySupplierPriceCopyWith<_FoodSupplySupplierPrice> get copyWith => __$FoodSupplySupplierPriceCopyWithImpl<_FoodSupplySupplierPrice>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodSupplySupplierPriceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodSupplySupplierPrice&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierPriceId, supplierPriceId) || other.supplierPriceId == supplierPriceId)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceQuantity, priceQuantity) || other.priceQuantity == priceQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supplierId,supplierName,supplierPriceId,priceAmount,priceQuantity,unitPrice,unit);

@override
String toString() {
  return 'FoodSupplySupplierPrice(supplierId: $supplierId, supplierName: $supplierName, supplierPriceId: $supplierPriceId, priceAmount: $priceAmount, priceQuantity: $priceQuantity, unitPrice: $unitPrice, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$FoodSupplySupplierPriceCopyWith<$Res> implements $FoodSupplySupplierPriceCopyWith<$Res> {
  factory _$FoodSupplySupplierPriceCopyWith(_FoodSupplySupplierPrice value, $Res Function(_FoodSupplySupplierPrice) _then) = __$FoodSupplySupplierPriceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'supplier_name') String supplierName,@JsonKey(name: 'supplier_price_id') String supplierPriceId,@JsonKey(name: 'price_amount') int priceAmount,@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) num priceQuantity,@JsonKey(name: 'unit_price', fromJson: _decimalFromJson) num unitPrice, String unit
});




}
/// @nodoc
class __$FoodSupplySupplierPriceCopyWithImpl<$Res>
    implements _$FoodSupplySupplierPriceCopyWith<$Res> {
  __$FoodSupplySupplierPriceCopyWithImpl(this._self, this._then);

  final _FoodSupplySupplierPrice _self;
  final $Res Function(_FoodSupplySupplierPrice) _then;

/// Create a copy of FoodSupplySupplierPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supplierId = null,Object? supplierName = null,Object? supplierPriceId = null,Object? priceAmount = null,Object? priceQuantity = null,Object? unitPrice = null,Object? unit = null,}) {
  return _then(_FoodSupplySupplierPrice(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,supplierPriceId: null == supplierPriceId ? _self.supplierPriceId : supplierPriceId // ignore: cast_nullable_to_non_nullable
as String,priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as int,priceQuantity: null == priceQuantity ? _self.priceQuantity : priceQuantity // ignore: cast_nullable_to_non_nullable
as num,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
