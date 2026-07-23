// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'smart_purchase_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SmartPurchaseSuggestInput {

@JsonKey(name: 'food_supply_id') String get foodSupplyId;@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) num get quantity;
/// Create a copy of SmartPurchaseSuggestInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseSuggestInputCopyWith<SmartPurchaseSuggestInput> get copyWith => _$SmartPurchaseSuggestInputCopyWithImpl<SmartPurchaseSuggestInput>(this as SmartPurchaseSuggestInput, _$identity);

  /// Serializes this SmartPurchaseSuggestInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseSuggestInput&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,quantity);

@override
String toString() {
  return 'SmartPurchaseSuggestInput(foodSupplyId: $foodSupplyId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseSuggestInputCopyWith<$Res>  {
  factory $SmartPurchaseSuggestInputCopyWith(SmartPurchaseSuggestInput value, $Res Function(SmartPurchaseSuggestInput) _then) = _$SmartPurchaseSuggestInputCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) num quantity
});




}
/// @nodoc
class _$SmartPurchaseSuggestInputCopyWithImpl<$Res>
    implements $SmartPurchaseSuggestInputCopyWith<$Res> {
  _$SmartPurchaseSuggestInputCopyWithImpl(this._self, this._then);

  final SmartPurchaseSuggestInput _self;
  final $Res Function(SmartPurchaseSuggestInput) _then;

/// Create a copy of SmartPurchaseSuggestInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? foodSupplyId = null,Object? quantity = null,}) {
  return _then(_self.copyWith(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseSuggestInput].
extension SmartPurchaseSuggestInputPatterns on SmartPurchaseSuggestInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseSuggestInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseSuggestInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseSuggestInput value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSuggestInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseSuggestInput value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSuggestInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)  num quantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseSuggestInput() when $default != null:
return $default(_that.foodSupplyId,_that.quantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)  num quantity)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSuggestInput():
return $default(_that.foodSupplyId,_that.quantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)  num quantity)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSuggestInput() when $default != null:
return $default(_that.foodSupplyId,_that.quantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseSuggestInput implements SmartPurchaseSuggestInput {
  const _SmartPurchaseSuggestInput({@JsonKey(name: 'food_supply_id') required this.foodSupplyId, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) required this.quantity});
  factory _SmartPurchaseSuggestInput.fromJson(Map<String, dynamic> json) => _$SmartPurchaseSuggestInputFromJson(json);

@override@JsonKey(name: 'food_supply_id') final  String foodSupplyId;
@override@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) final  num quantity;

/// Create a copy of SmartPurchaseSuggestInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseSuggestInputCopyWith<_SmartPurchaseSuggestInput> get copyWith => __$SmartPurchaseSuggestInputCopyWithImpl<_SmartPurchaseSuggestInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseSuggestInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseSuggestInput&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.quantity, quantity) || other.quantity == quantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,quantity);

@override
String toString() {
  return 'SmartPurchaseSuggestInput(foodSupplyId: $foodSupplyId, quantity: $quantity)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseSuggestInputCopyWith<$Res> implements $SmartPurchaseSuggestInputCopyWith<$Res> {
  factory _$SmartPurchaseSuggestInputCopyWith(_SmartPurchaseSuggestInput value, $Res Function(_SmartPurchaseSuggestInput) _then) = __$SmartPurchaseSuggestInputCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) num quantity
});




}
/// @nodoc
class __$SmartPurchaseSuggestInputCopyWithImpl<$Res>
    implements _$SmartPurchaseSuggestInputCopyWith<$Res> {
  __$SmartPurchaseSuggestInputCopyWithImpl(this._self, this._then);

  final _SmartPurchaseSuggestInput _self;
  final $Res Function(_SmartPurchaseSuggestInput) _then;

/// Create a copy of SmartPurchaseSuggestInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? foodSupplyId = null,Object? quantity = null,}) {
  return _then(_SmartPurchaseSuggestInput(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}


/// @nodoc
mixin _$SmartPurchaseSupplierQuote {

@JsonKey(name: 'supplier_id') String get supplierId;@JsonKey(name: 'supplier_name') String get supplierName;@JsonKey(name: 'supplier_price_id') String get supplierPriceId;@JsonKey(name: 'price_amount') int get priceAmount;@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) num get priceQuantity;@JsonKey(name: 'unit_price', fromJson: _decimalFromJson) num get unitPrice;
/// Create a copy of SmartPurchaseSupplierQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseSupplierQuoteCopyWith<SmartPurchaseSupplierQuote> get copyWith => _$SmartPurchaseSupplierQuoteCopyWithImpl<SmartPurchaseSupplierQuote>(this as SmartPurchaseSupplierQuote, _$identity);

  /// Serializes this SmartPurchaseSupplierQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseSupplierQuote&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierPriceId, supplierPriceId) || other.supplierPriceId == supplierPriceId)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceQuantity, priceQuantity) || other.priceQuantity == priceQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supplierId,supplierName,supplierPriceId,priceAmount,priceQuantity,unitPrice);

@override
String toString() {
  return 'SmartPurchaseSupplierQuote(supplierId: $supplierId, supplierName: $supplierName, supplierPriceId: $supplierPriceId, priceAmount: $priceAmount, priceQuantity: $priceQuantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseSupplierQuoteCopyWith<$Res>  {
  factory $SmartPurchaseSupplierQuoteCopyWith(SmartPurchaseSupplierQuote value, $Res Function(SmartPurchaseSupplierQuote) _then) = _$SmartPurchaseSupplierQuoteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'supplier_name') String supplierName,@JsonKey(name: 'supplier_price_id') String supplierPriceId,@JsonKey(name: 'price_amount') int priceAmount,@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) num priceQuantity,@JsonKey(name: 'unit_price', fromJson: _decimalFromJson) num unitPrice
});




}
/// @nodoc
class _$SmartPurchaseSupplierQuoteCopyWithImpl<$Res>
    implements $SmartPurchaseSupplierQuoteCopyWith<$Res> {
  _$SmartPurchaseSupplierQuoteCopyWithImpl(this._self, this._then);

  final SmartPurchaseSupplierQuote _self;
  final $Res Function(SmartPurchaseSupplierQuote) _then;

/// Create a copy of SmartPurchaseSupplierQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supplierId = null,Object? supplierName = null,Object? supplierPriceId = null,Object? priceAmount = null,Object? priceQuantity = null,Object? unitPrice = null,}) {
  return _then(_self.copyWith(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,supplierPriceId: null == supplierPriceId ? _self.supplierPriceId : supplierPriceId // ignore: cast_nullable_to_non_nullable
as String,priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as int,priceQuantity: null == priceQuantity ? _self.priceQuantity : priceQuantity // ignore: cast_nullable_to_non_nullable
as num,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseSupplierQuote].
extension SmartPurchaseSupplierQuotePatterns on SmartPurchaseSupplierQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseSupplierQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseSupplierQuote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseSupplierQuote value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSupplierQuote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseSupplierQuote value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSupplierQuote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'supplier_price_id')  String supplierPriceId, @JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson)  num priceQuantity, @JsonKey(name: 'unit_price', fromJson: _decimalFromJson)  num unitPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseSupplierQuote() when $default != null:
return $default(_that.supplierId,_that.supplierName,_that.supplierPriceId,_that.priceAmount,_that.priceQuantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'supplier_price_id')  String supplierPriceId, @JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson)  num priceQuantity, @JsonKey(name: 'unit_price', fromJson: _decimalFromJson)  num unitPrice)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSupplierQuote():
return $default(_that.supplierId,_that.supplierName,_that.supplierPriceId,_that.priceAmount,_that.priceQuantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'supplier_price_id')  String supplierPriceId, @JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson)  num priceQuantity, @JsonKey(name: 'unit_price', fromJson: _decimalFromJson)  num unitPrice)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSupplierQuote() when $default != null:
return $default(_that.supplierId,_that.supplierName,_that.supplierPriceId,_that.priceAmount,_that.priceQuantity,_that.unitPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseSupplierQuote implements SmartPurchaseSupplierQuote {
  const _SmartPurchaseSupplierQuote({@JsonKey(name: 'supplier_id') required this.supplierId, @JsonKey(name: 'supplier_name') required this.supplierName, @JsonKey(name: 'supplier_price_id') required this.supplierPriceId, @JsonKey(name: 'price_amount') required this.priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) required this.priceQuantity, @JsonKey(name: 'unit_price', fromJson: _decimalFromJson) required this.unitPrice});
  factory _SmartPurchaseSupplierQuote.fromJson(Map<String, dynamic> json) => _$SmartPurchaseSupplierQuoteFromJson(json);

@override@JsonKey(name: 'supplier_id') final  String supplierId;
@override@JsonKey(name: 'supplier_name') final  String supplierName;
@override@JsonKey(name: 'supplier_price_id') final  String supplierPriceId;
@override@JsonKey(name: 'price_amount') final  int priceAmount;
@override@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) final  num priceQuantity;
@override@JsonKey(name: 'unit_price', fromJson: _decimalFromJson) final  num unitPrice;

/// Create a copy of SmartPurchaseSupplierQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseSupplierQuoteCopyWith<_SmartPurchaseSupplierQuote> get copyWith => __$SmartPurchaseSupplierQuoteCopyWithImpl<_SmartPurchaseSupplierQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseSupplierQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseSupplierQuote&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.supplierPriceId, supplierPriceId) || other.supplierPriceId == supplierPriceId)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceQuantity, priceQuantity) || other.priceQuantity == priceQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supplierId,supplierName,supplierPriceId,priceAmount,priceQuantity,unitPrice);

@override
String toString() {
  return 'SmartPurchaseSupplierQuote(supplierId: $supplierId, supplierName: $supplierName, supplierPriceId: $supplierPriceId, priceAmount: $priceAmount, priceQuantity: $priceQuantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseSupplierQuoteCopyWith<$Res> implements $SmartPurchaseSupplierQuoteCopyWith<$Res> {
  factory _$SmartPurchaseSupplierQuoteCopyWith(_SmartPurchaseSupplierQuote value, $Res Function(_SmartPurchaseSupplierQuote) _then) = __$SmartPurchaseSupplierQuoteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'supplier_name') String supplierName,@JsonKey(name: 'supplier_price_id') String supplierPriceId,@JsonKey(name: 'price_amount') int priceAmount,@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) num priceQuantity,@JsonKey(name: 'unit_price', fromJson: _decimalFromJson) num unitPrice
});




}
/// @nodoc
class __$SmartPurchaseSupplierQuoteCopyWithImpl<$Res>
    implements _$SmartPurchaseSupplierQuoteCopyWith<$Res> {
  __$SmartPurchaseSupplierQuoteCopyWithImpl(this._self, this._then);

  final _SmartPurchaseSupplierQuote _self;
  final $Res Function(_SmartPurchaseSupplierQuote) _then;

/// Create a copy of SmartPurchaseSupplierQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supplierId = null,Object? supplierName = null,Object? supplierPriceId = null,Object? priceAmount = null,Object? priceQuantity = null,Object? unitPrice = null,}) {
  return _then(_SmartPurchaseSupplierQuote(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,supplierPriceId: null == supplierPriceId ? _self.supplierPriceId : supplierPriceId // ignore: cast_nullable_to_non_nullable
as String,priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as int,priceQuantity: null == priceQuantity ? _self.priceQuantity : priceQuantity // ignore: cast_nullable_to_non_nullable
as num,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}


/// @nodoc
mixin _$SmartPurchaseSuggestItem {

@JsonKey(name: 'food_supply_id') String get foodSupplyId;@JsonKey(name: 'food_supply_title') String get foodSupplyTitle; String get unit;@JsonKey(fromJson: _quantityFromJson) num get quantity;@JsonKey(name: 'has_supplier_price') bool get hasSupplierPrice;@JsonKey(name: 'selected_supplier_id') String? get selectedSupplierId;@JsonKey(name: 'selected_supplier_name') String? get selectedSupplierName;@JsonKey(name: 'supplier_price_id') String? get supplierPriceId;@JsonKey(name: 'all_supplier_quotes') List<SmartPurchaseSupplierQuote> get allSupplierQuotes;
/// Create a copy of SmartPurchaseSuggestItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseSuggestItemCopyWith<SmartPurchaseSuggestItem> get copyWith => _$SmartPurchaseSuggestItemCopyWithImpl<SmartPurchaseSuggestItem>(this as SmartPurchaseSuggestItem, _$identity);

  /// Serializes this SmartPurchaseSuggestItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseSuggestItem&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.foodSupplyTitle, foodSupplyTitle) || other.foodSupplyTitle == foodSupplyTitle)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.hasSupplierPrice, hasSupplierPrice) || other.hasSupplierPrice == hasSupplierPrice)&&(identical(other.selectedSupplierId, selectedSupplierId) || other.selectedSupplierId == selectedSupplierId)&&(identical(other.selectedSupplierName, selectedSupplierName) || other.selectedSupplierName == selectedSupplierName)&&(identical(other.supplierPriceId, supplierPriceId) || other.supplierPriceId == supplierPriceId)&&const DeepCollectionEquality().equals(other.allSupplierQuotes, allSupplierQuotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,foodSupplyTitle,unit,quantity,hasSupplierPrice,selectedSupplierId,selectedSupplierName,supplierPriceId,const DeepCollectionEquality().hash(allSupplierQuotes));

@override
String toString() {
  return 'SmartPurchaseSuggestItem(foodSupplyId: $foodSupplyId, foodSupplyTitle: $foodSupplyTitle, unit: $unit, quantity: $quantity, hasSupplierPrice: $hasSupplierPrice, selectedSupplierId: $selectedSupplierId, selectedSupplierName: $selectedSupplierName, supplierPriceId: $supplierPriceId, allSupplierQuotes: $allSupplierQuotes)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseSuggestItemCopyWith<$Res>  {
  factory $SmartPurchaseSuggestItemCopyWith(SmartPurchaseSuggestItem value, $Res Function(SmartPurchaseSuggestItem) _then) = _$SmartPurchaseSuggestItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(name: 'food_supply_title') String foodSupplyTitle, String unit,@JsonKey(fromJson: _quantityFromJson) num quantity,@JsonKey(name: 'has_supplier_price') bool hasSupplierPrice,@JsonKey(name: 'selected_supplier_id') String? selectedSupplierId,@JsonKey(name: 'selected_supplier_name') String? selectedSupplierName,@JsonKey(name: 'supplier_price_id') String? supplierPriceId,@JsonKey(name: 'all_supplier_quotes') List<SmartPurchaseSupplierQuote> allSupplierQuotes
});




}
/// @nodoc
class _$SmartPurchaseSuggestItemCopyWithImpl<$Res>
    implements $SmartPurchaseSuggestItemCopyWith<$Res> {
  _$SmartPurchaseSuggestItemCopyWithImpl(this._self, this._then);

  final SmartPurchaseSuggestItem _self;
  final $Res Function(SmartPurchaseSuggestItem) _then;

/// Create a copy of SmartPurchaseSuggestItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? foodSupplyId = null,Object? foodSupplyTitle = null,Object? unit = null,Object? quantity = null,Object? hasSupplierPrice = null,Object? selectedSupplierId = freezed,Object? selectedSupplierName = freezed,Object? supplierPriceId = freezed,Object? allSupplierQuotes = null,}) {
  return _then(_self.copyWith(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,foodSupplyTitle: null == foodSupplyTitle ? _self.foodSupplyTitle : foodSupplyTitle // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,hasSupplierPrice: null == hasSupplierPrice ? _self.hasSupplierPrice : hasSupplierPrice // ignore: cast_nullable_to_non_nullable
as bool,selectedSupplierId: freezed == selectedSupplierId ? _self.selectedSupplierId : selectedSupplierId // ignore: cast_nullable_to_non_nullable
as String?,selectedSupplierName: freezed == selectedSupplierName ? _self.selectedSupplierName : selectedSupplierName // ignore: cast_nullable_to_non_nullable
as String?,supplierPriceId: freezed == supplierPriceId ? _self.supplierPriceId : supplierPriceId // ignore: cast_nullable_to_non_nullable
as String?,allSupplierQuotes: null == allSupplierQuotes ? _self.allSupplierQuotes : allSupplierQuotes // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseSupplierQuote>,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseSuggestItem].
extension SmartPurchaseSuggestItemPatterns on SmartPurchaseSuggestItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseSuggestItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseSuggestItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseSuggestItem value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSuggestItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseSuggestItem value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSuggestItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String foodSupplyTitle,  String unit, @JsonKey(fromJson: _quantityFromJson)  num quantity, @JsonKey(name: 'has_supplier_price')  bool hasSupplierPrice, @JsonKey(name: 'selected_supplier_id')  String? selectedSupplierId, @JsonKey(name: 'selected_supplier_name')  String? selectedSupplierName, @JsonKey(name: 'supplier_price_id')  String? supplierPriceId, @JsonKey(name: 'all_supplier_quotes')  List<SmartPurchaseSupplierQuote> allSupplierQuotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseSuggestItem() when $default != null:
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.unit,_that.quantity,_that.hasSupplierPrice,_that.selectedSupplierId,_that.selectedSupplierName,_that.supplierPriceId,_that.allSupplierQuotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String foodSupplyTitle,  String unit, @JsonKey(fromJson: _quantityFromJson)  num quantity, @JsonKey(name: 'has_supplier_price')  bool hasSupplierPrice, @JsonKey(name: 'selected_supplier_id')  String? selectedSupplierId, @JsonKey(name: 'selected_supplier_name')  String? selectedSupplierName, @JsonKey(name: 'supplier_price_id')  String? supplierPriceId, @JsonKey(name: 'all_supplier_quotes')  List<SmartPurchaseSupplierQuote> allSupplierQuotes)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSuggestItem():
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.unit,_that.quantity,_that.hasSupplierPrice,_that.selectedSupplierId,_that.selectedSupplierName,_that.supplierPriceId,_that.allSupplierQuotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String foodSupplyTitle,  String unit, @JsonKey(fromJson: _quantityFromJson)  num quantity, @JsonKey(name: 'has_supplier_price')  bool hasSupplierPrice, @JsonKey(name: 'selected_supplier_id')  String? selectedSupplierId, @JsonKey(name: 'selected_supplier_name')  String? selectedSupplierName, @JsonKey(name: 'supplier_price_id')  String? supplierPriceId, @JsonKey(name: 'all_supplier_quotes')  List<SmartPurchaseSupplierQuote> allSupplierQuotes)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSuggestItem() when $default != null:
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.unit,_that.quantity,_that.hasSupplierPrice,_that.selectedSupplierId,_that.selectedSupplierName,_that.supplierPriceId,_that.allSupplierQuotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseSuggestItem implements SmartPurchaseSuggestItem {
  const _SmartPurchaseSuggestItem({@JsonKey(name: 'food_supply_id') required this.foodSupplyId, @JsonKey(name: 'food_supply_title') required this.foodSupplyTitle, required this.unit, @JsonKey(fromJson: _quantityFromJson) required this.quantity, @JsonKey(name: 'has_supplier_price') required this.hasSupplierPrice, @JsonKey(name: 'selected_supplier_id') this.selectedSupplierId, @JsonKey(name: 'selected_supplier_name') this.selectedSupplierName, @JsonKey(name: 'supplier_price_id') this.supplierPriceId, @JsonKey(name: 'all_supplier_quotes') final  List<SmartPurchaseSupplierQuote> allSupplierQuotes = const []}): _allSupplierQuotes = allSupplierQuotes;
  factory _SmartPurchaseSuggestItem.fromJson(Map<String, dynamic> json) => _$SmartPurchaseSuggestItemFromJson(json);

@override@JsonKey(name: 'food_supply_id') final  String foodSupplyId;
@override@JsonKey(name: 'food_supply_title') final  String foodSupplyTitle;
@override final  String unit;
@override@JsonKey(fromJson: _quantityFromJson) final  num quantity;
@override@JsonKey(name: 'has_supplier_price') final  bool hasSupplierPrice;
@override@JsonKey(name: 'selected_supplier_id') final  String? selectedSupplierId;
@override@JsonKey(name: 'selected_supplier_name') final  String? selectedSupplierName;
@override@JsonKey(name: 'supplier_price_id') final  String? supplierPriceId;
 final  List<SmartPurchaseSupplierQuote> _allSupplierQuotes;
@override@JsonKey(name: 'all_supplier_quotes') List<SmartPurchaseSupplierQuote> get allSupplierQuotes {
  if (_allSupplierQuotes is EqualUnmodifiableListView) return _allSupplierQuotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allSupplierQuotes);
}


/// Create a copy of SmartPurchaseSuggestItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseSuggestItemCopyWith<_SmartPurchaseSuggestItem> get copyWith => __$SmartPurchaseSuggestItemCopyWithImpl<_SmartPurchaseSuggestItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseSuggestItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseSuggestItem&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.foodSupplyTitle, foodSupplyTitle) || other.foodSupplyTitle == foodSupplyTitle)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.hasSupplierPrice, hasSupplierPrice) || other.hasSupplierPrice == hasSupplierPrice)&&(identical(other.selectedSupplierId, selectedSupplierId) || other.selectedSupplierId == selectedSupplierId)&&(identical(other.selectedSupplierName, selectedSupplierName) || other.selectedSupplierName == selectedSupplierName)&&(identical(other.supplierPriceId, supplierPriceId) || other.supplierPriceId == supplierPriceId)&&const DeepCollectionEquality().equals(other._allSupplierQuotes, _allSupplierQuotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,foodSupplyTitle,unit,quantity,hasSupplierPrice,selectedSupplierId,selectedSupplierName,supplierPriceId,const DeepCollectionEquality().hash(_allSupplierQuotes));

@override
String toString() {
  return 'SmartPurchaseSuggestItem(foodSupplyId: $foodSupplyId, foodSupplyTitle: $foodSupplyTitle, unit: $unit, quantity: $quantity, hasSupplierPrice: $hasSupplierPrice, selectedSupplierId: $selectedSupplierId, selectedSupplierName: $selectedSupplierName, supplierPriceId: $supplierPriceId, allSupplierQuotes: $allSupplierQuotes)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseSuggestItemCopyWith<$Res> implements $SmartPurchaseSuggestItemCopyWith<$Res> {
  factory _$SmartPurchaseSuggestItemCopyWith(_SmartPurchaseSuggestItem value, $Res Function(_SmartPurchaseSuggestItem) _then) = __$SmartPurchaseSuggestItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(name: 'food_supply_title') String foodSupplyTitle, String unit,@JsonKey(fromJson: _quantityFromJson) num quantity,@JsonKey(name: 'has_supplier_price') bool hasSupplierPrice,@JsonKey(name: 'selected_supplier_id') String? selectedSupplierId,@JsonKey(name: 'selected_supplier_name') String? selectedSupplierName,@JsonKey(name: 'supplier_price_id') String? supplierPriceId,@JsonKey(name: 'all_supplier_quotes') List<SmartPurchaseSupplierQuote> allSupplierQuotes
});




}
/// @nodoc
class __$SmartPurchaseSuggestItemCopyWithImpl<$Res>
    implements _$SmartPurchaseSuggestItemCopyWith<$Res> {
  __$SmartPurchaseSuggestItemCopyWithImpl(this._self, this._then);

  final _SmartPurchaseSuggestItem _self;
  final $Res Function(_SmartPurchaseSuggestItem) _then;

/// Create a copy of SmartPurchaseSuggestItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? foodSupplyId = null,Object? foodSupplyTitle = null,Object? unit = null,Object? quantity = null,Object? hasSupplierPrice = null,Object? selectedSupplierId = freezed,Object? selectedSupplierName = freezed,Object? supplierPriceId = freezed,Object? allSupplierQuotes = null,}) {
  return _then(_SmartPurchaseSuggestItem(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,foodSupplyTitle: null == foodSupplyTitle ? _self.foodSupplyTitle : foodSupplyTitle // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,hasSupplierPrice: null == hasSupplierPrice ? _self.hasSupplierPrice : hasSupplierPrice // ignore: cast_nullable_to_non_nullable
as bool,selectedSupplierId: freezed == selectedSupplierId ? _self.selectedSupplierId : selectedSupplierId // ignore: cast_nullable_to_non_nullable
as String?,selectedSupplierName: freezed == selectedSupplierName ? _self.selectedSupplierName : selectedSupplierName // ignore: cast_nullable_to_non_nullable
as String?,supplierPriceId: freezed == supplierPriceId ? _self.supplierPriceId : supplierPriceId // ignore: cast_nullable_to_non_nullable
as String?,allSupplierQuotes: null == allSupplierQuotes ? _self._allSupplierQuotes : allSupplierQuotes // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseSupplierQuote>,
  ));
}


}


/// @nodoc
mixin _$SmartPurchaseSupplierGroup {

@JsonKey(name: 'supplier_id') String get supplierId;@JsonKey(name: 'supplier_name') String get supplierName;@JsonKey(name: 'total_estimated_amount', fromJson: _nullableIntFromJson) int? get totalEstimatedAmount; List<SmartPurchaseGroupedItem> get items;
/// Create a copy of SmartPurchaseSupplierGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseSupplierGroupCopyWith<SmartPurchaseSupplierGroup> get copyWith => _$SmartPurchaseSupplierGroupCopyWithImpl<SmartPurchaseSupplierGroup>(this as SmartPurchaseSupplierGroup, _$identity);

  /// Serializes this SmartPurchaseSupplierGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseSupplierGroup&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.totalEstimatedAmount, totalEstimatedAmount) || other.totalEstimatedAmount == totalEstimatedAmount)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supplierId,supplierName,totalEstimatedAmount,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SmartPurchaseSupplierGroup(supplierId: $supplierId, supplierName: $supplierName, totalEstimatedAmount: $totalEstimatedAmount, items: $items)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseSupplierGroupCopyWith<$Res>  {
  factory $SmartPurchaseSupplierGroupCopyWith(SmartPurchaseSupplierGroup value, $Res Function(SmartPurchaseSupplierGroup) _then) = _$SmartPurchaseSupplierGroupCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'supplier_name') String supplierName,@JsonKey(name: 'total_estimated_amount', fromJson: _nullableIntFromJson) int? totalEstimatedAmount, List<SmartPurchaseGroupedItem> items
});




}
/// @nodoc
class _$SmartPurchaseSupplierGroupCopyWithImpl<$Res>
    implements $SmartPurchaseSupplierGroupCopyWith<$Res> {
  _$SmartPurchaseSupplierGroupCopyWithImpl(this._self, this._then);

  final SmartPurchaseSupplierGroup _self;
  final $Res Function(SmartPurchaseSupplierGroup) _then;

/// Create a copy of SmartPurchaseSupplierGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supplierId = null,Object? supplierName = null,Object? totalEstimatedAmount = freezed,Object? items = null,}) {
  return _then(_self.copyWith(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,totalEstimatedAmount: freezed == totalEstimatedAmount ? _self.totalEstimatedAmount : totalEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseGroupedItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseSupplierGroup].
extension SmartPurchaseSupplierGroupPatterns on SmartPurchaseSupplierGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseSupplierGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseSupplierGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseSupplierGroup value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSupplierGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseSupplierGroup value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSupplierGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'total_estimated_amount', fromJson: _nullableIntFromJson)  int? totalEstimatedAmount,  List<SmartPurchaseGroupedItem> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseSupplierGroup() when $default != null:
return $default(_that.supplierId,_that.supplierName,_that.totalEstimatedAmount,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'total_estimated_amount', fromJson: _nullableIntFromJson)  int? totalEstimatedAmount,  List<SmartPurchaseGroupedItem> items)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSupplierGroup():
return $default(_that.supplierId,_that.supplierName,_that.totalEstimatedAmount,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'supplier_id')  String supplierId, @JsonKey(name: 'supplier_name')  String supplierName, @JsonKey(name: 'total_estimated_amount', fromJson: _nullableIntFromJson)  int? totalEstimatedAmount,  List<SmartPurchaseGroupedItem> items)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSupplierGroup() when $default != null:
return $default(_that.supplierId,_that.supplierName,_that.totalEstimatedAmount,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseSupplierGroup implements SmartPurchaseSupplierGroup {
  const _SmartPurchaseSupplierGroup({@JsonKey(name: 'supplier_id') required this.supplierId, @JsonKey(name: 'supplier_name') required this.supplierName, @JsonKey(name: 'total_estimated_amount', fromJson: _nullableIntFromJson) this.totalEstimatedAmount, final  List<SmartPurchaseGroupedItem> items = const []}): _items = items;
  factory _SmartPurchaseSupplierGroup.fromJson(Map<String, dynamic> json) => _$SmartPurchaseSupplierGroupFromJson(json);

@override@JsonKey(name: 'supplier_id') final  String supplierId;
@override@JsonKey(name: 'supplier_name') final  String supplierName;
@override@JsonKey(name: 'total_estimated_amount', fromJson: _nullableIntFromJson) final  int? totalEstimatedAmount;
 final  List<SmartPurchaseGroupedItem> _items;
@override@JsonKey() List<SmartPurchaseGroupedItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SmartPurchaseSupplierGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseSupplierGroupCopyWith<_SmartPurchaseSupplierGroup> get copyWith => __$SmartPurchaseSupplierGroupCopyWithImpl<_SmartPurchaseSupplierGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseSupplierGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseSupplierGroup&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName)&&(identical(other.totalEstimatedAmount, totalEstimatedAmount) || other.totalEstimatedAmount == totalEstimatedAmount)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supplierId,supplierName,totalEstimatedAmount,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SmartPurchaseSupplierGroup(supplierId: $supplierId, supplierName: $supplierName, totalEstimatedAmount: $totalEstimatedAmount, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseSupplierGroupCopyWith<$Res> implements $SmartPurchaseSupplierGroupCopyWith<$Res> {
  factory _$SmartPurchaseSupplierGroupCopyWith(_SmartPurchaseSupplierGroup value, $Res Function(_SmartPurchaseSupplierGroup) _then) = __$SmartPurchaseSupplierGroupCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId,@JsonKey(name: 'supplier_name') String supplierName,@JsonKey(name: 'total_estimated_amount', fromJson: _nullableIntFromJson) int? totalEstimatedAmount, List<SmartPurchaseGroupedItem> items
});




}
/// @nodoc
class __$SmartPurchaseSupplierGroupCopyWithImpl<$Res>
    implements _$SmartPurchaseSupplierGroupCopyWith<$Res> {
  __$SmartPurchaseSupplierGroupCopyWithImpl(this._self, this._then);

  final _SmartPurchaseSupplierGroup _self;
  final $Res Function(_SmartPurchaseSupplierGroup) _then;

/// Create a copy of SmartPurchaseSupplierGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supplierId = null,Object? supplierName = null,Object? totalEstimatedAmount = freezed,Object? items = null,}) {
  return _then(_SmartPurchaseSupplierGroup(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,totalEstimatedAmount: freezed == totalEstimatedAmount ? _self.totalEstimatedAmount : totalEstimatedAmount // ignore: cast_nullable_to_non_nullable
as int?,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseGroupedItem>,
  ));
}


}


/// @nodoc
mixin _$SmartPurchaseGroupedItem {

@JsonKey(name: 'food_supply_id') String get foodSupplyId;@JsonKey(name: 'food_supply_title') String get foodSupplyTitle; String get unit;@JsonKey(fromJson: _quantityFromJson) num get quantity;@JsonKey(name: 'unit_price', fromJson: _nullableIntFromJson) int? get unitPrice;@JsonKey(name: 'line_total', fromJson: _nullableIntFromJson) int? get lineTotal;@JsonKey(name: 'supplier_price_id') String? get supplierPriceId;
/// Create a copy of SmartPurchaseGroupedItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseGroupedItemCopyWith<SmartPurchaseGroupedItem> get copyWith => _$SmartPurchaseGroupedItemCopyWithImpl<SmartPurchaseGroupedItem>(this as SmartPurchaseGroupedItem, _$identity);

  /// Serializes this SmartPurchaseGroupedItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseGroupedItem&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.foodSupplyTitle, foodSupplyTitle) || other.foodSupplyTitle == foodSupplyTitle)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.supplierPriceId, supplierPriceId) || other.supplierPriceId == supplierPriceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,foodSupplyTitle,unit,quantity,unitPrice,lineTotal,supplierPriceId);

@override
String toString() {
  return 'SmartPurchaseGroupedItem(foodSupplyId: $foodSupplyId, foodSupplyTitle: $foodSupplyTitle, unit: $unit, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal, supplierPriceId: $supplierPriceId)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseGroupedItemCopyWith<$Res>  {
  factory $SmartPurchaseGroupedItemCopyWith(SmartPurchaseGroupedItem value, $Res Function(SmartPurchaseGroupedItem) _then) = _$SmartPurchaseGroupedItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(name: 'food_supply_title') String foodSupplyTitle, String unit,@JsonKey(fromJson: _quantityFromJson) num quantity,@JsonKey(name: 'unit_price', fromJson: _nullableIntFromJson) int? unitPrice,@JsonKey(name: 'line_total', fromJson: _nullableIntFromJson) int? lineTotal,@JsonKey(name: 'supplier_price_id') String? supplierPriceId
});




}
/// @nodoc
class _$SmartPurchaseGroupedItemCopyWithImpl<$Res>
    implements $SmartPurchaseGroupedItemCopyWith<$Res> {
  _$SmartPurchaseGroupedItemCopyWithImpl(this._self, this._then);

  final SmartPurchaseGroupedItem _self;
  final $Res Function(SmartPurchaseGroupedItem) _then;

/// Create a copy of SmartPurchaseGroupedItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? foodSupplyId = null,Object? foodSupplyTitle = null,Object? unit = null,Object? quantity = null,Object? unitPrice = freezed,Object? lineTotal = freezed,Object? supplierPriceId = freezed,}) {
  return _then(_self.copyWith(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,foodSupplyTitle: null == foodSupplyTitle ? _self.foodSupplyTitle : foodSupplyTitle // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int?,lineTotal: freezed == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as int?,supplierPriceId: freezed == supplierPriceId ? _self.supplierPriceId : supplierPriceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseGroupedItem].
extension SmartPurchaseGroupedItemPatterns on SmartPurchaseGroupedItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseGroupedItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseGroupedItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseGroupedItem value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseGroupedItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseGroupedItem value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseGroupedItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String foodSupplyTitle,  String unit, @JsonKey(fromJson: _quantityFromJson)  num quantity, @JsonKey(name: 'unit_price', fromJson: _nullableIntFromJson)  int? unitPrice, @JsonKey(name: 'line_total', fromJson: _nullableIntFromJson)  int? lineTotal, @JsonKey(name: 'supplier_price_id')  String? supplierPriceId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseGroupedItem() when $default != null:
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.unit,_that.quantity,_that.unitPrice,_that.lineTotal,_that.supplierPriceId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String foodSupplyTitle,  String unit, @JsonKey(fromJson: _quantityFromJson)  num quantity, @JsonKey(name: 'unit_price', fromJson: _nullableIntFromJson)  int? unitPrice, @JsonKey(name: 'line_total', fromJson: _nullableIntFromJson)  int? lineTotal, @JsonKey(name: 'supplier_price_id')  String? supplierPriceId)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseGroupedItem():
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.unit,_that.quantity,_that.unitPrice,_that.lineTotal,_that.supplierPriceId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String foodSupplyTitle,  String unit, @JsonKey(fromJson: _quantityFromJson)  num quantity, @JsonKey(name: 'unit_price', fromJson: _nullableIntFromJson)  int? unitPrice, @JsonKey(name: 'line_total', fromJson: _nullableIntFromJson)  int? lineTotal, @JsonKey(name: 'supplier_price_id')  String? supplierPriceId)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseGroupedItem() when $default != null:
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.unit,_that.quantity,_that.unitPrice,_that.lineTotal,_that.supplierPriceId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseGroupedItem implements SmartPurchaseGroupedItem {
  const _SmartPurchaseGroupedItem({@JsonKey(name: 'food_supply_id') required this.foodSupplyId, @JsonKey(name: 'food_supply_title') required this.foodSupplyTitle, required this.unit, @JsonKey(fromJson: _quantityFromJson) required this.quantity, @JsonKey(name: 'unit_price', fromJson: _nullableIntFromJson) this.unitPrice, @JsonKey(name: 'line_total', fromJson: _nullableIntFromJson) this.lineTotal, @JsonKey(name: 'supplier_price_id') this.supplierPriceId});
  factory _SmartPurchaseGroupedItem.fromJson(Map<String, dynamic> json) => _$SmartPurchaseGroupedItemFromJson(json);

@override@JsonKey(name: 'food_supply_id') final  String foodSupplyId;
@override@JsonKey(name: 'food_supply_title') final  String foodSupplyTitle;
@override final  String unit;
@override@JsonKey(fromJson: _quantityFromJson) final  num quantity;
@override@JsonKey(name: 'unit_price', fromJson: _nullableIntFromJson) final  int? unitPrice;
@override@JsonKey(name: 'line_total', fromJson: _nullableIntFromJson) final  int? lineTotal;
@override@JsonKey(name: 'supplier_price_id') final  String? supplierPriceId;

/// Create a copy of SmartPurchaseGroupedItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseGroupedItemCopyWith<_SmartPurchaseGroupedItem> get copyWith => __$SmartPurchaseGroupedItemCopyWithImpl<_SmartPurchaseGroupedItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseGroupedItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseGroupedItem&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.foodSupplyTitle, foodSupplyTitle) || other.foodSupplyTitle == foodSupplyTitle)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.supplierPriceId, supplierPriceId) || other.supplierPriceId == supplierPriceId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,foodSupplyTitle,unit,quantity,unitPrice,lineTotal,supplierPriceId);

@override
String toString() {
  return 'SmartPurchaseGroupedItem(foodSupplyId: $foodSupplyId, foodSupplyTitle: $foodSupplyTitle, unit: $unit, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal, supplierPriceId: $supplierPriceId)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseGroupedItemCopyWith<$Res> implements $SmartPurchaseGroupedItemCopyWith<$Res> {
  factory _$SmartPurchaseGroupedItemCopyWith(_SmartPurchaseGroupedItem value, $Res Function(_SmartPurchaseGroupedItem) _then) = __$SmartPurchaseGroupedItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(name: 'food_supply_title') String foodSupplyTitle, String unit,@JsonKey(fromJson: _quantityFromJson) num quantity,@JsonKey(name: 'unit_price', fromJson: _nullableIntFromJson) int? unitPrice,@JsonKey(name: 'line_total', fromJson: _nullableIntFromJson) int? lineTotal,@JsonKey(name: 'supplier_price_id') String? supplierPriceId
});




}
/// @nodoc
class __$SmartPurchaseGroupedItemCopyWithImpl<$Res>
    implements _$SmartPurchaseGroupedItemCopyWith<$Res> {
  __$SmartPurchaseGroupedItemCopyWithImpl(this._self, this._then);

  final _SmartPurchaseGroupedItem _self;
  final $Res Function(_SmartPurchaseGroupedItem) _then;

/// Create a copy of SmartPurchaseGroupedItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? foodSupplyId = null,Object? foodSupplyTitle = null,Object? unit = null,Object? quantity = null,Object? unitPrice = freezed,Object? lineTotal = freezed,Object? supplierPriceId = freezed,}) {
  return _then(_SmartPurchaseGroupedItem(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,foodSupplyTitle: null == foodSupplyTitle ? _self.foodSupplyTitle : foodSupplyTitle // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int?,lineTotal: freezed == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as int?,supplierPriceId: freezed == supplierPriceId ? _self.supplierPriceId : supplierPriceId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$SmartPurchaseSuggestResponse {

@JsonKey(name: 'all_items_matched') bool get allItemsMatched; List<SmartPurchaseSuggestItem> get items;@JsonKey(name: 'grouped_by_supplier') List<SmartPurchaseSupplierGroup> get groupedBySupplier;
/// Create a copy of SmartPurchaseSuggestResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseSuggestResponseCopyWith<SmartPurchaseSuggestResponse> get copyWith => _$SmartPurchaseSuggestResponseCopyWithImpl<SmartPurchaseSuggestResponse>(this as SmartPurchaseSuggestResponse, _$identity);

  /// Serializes this SmartPurchaseSuggestResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseSuggestResponse&&(identical(other.allItemsMatched, allItemsMatched) || other.allItemsMatched == allItemsMatched)&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.groupedBySupplier, groupedBySupplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allItemsMatched,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(groupedBySupplier));

@override
String toString() {
  return 'SmartPurchaseSuggestResponse(allItemsMatched: $allItemsMatched, items: $items, groupedBySupplier: $groupedBySupplier)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseSuggestResponseCopyWith<$Res>  {
  factory $SmartPurchaseSuggestResponseCopyWith(SmartPurchaseSuggestResponse value, $Res Function(SmartPurchaseSuggestResponse) _then) = _$SmartPurchaseSuggestResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'all_items_matched') bool allItemsMatched, List<SmartPurchaseSuggestItem> items,@JsonKey(name: 'grouped_by_supplier') List<SmartPurchaseSupplierGroup> groupedBySupplier
});




}
/// @nodoc
class _$SmartPurchaseSuggestResponseCopyWithImpl<$Res>
    implements $SmartPurchaseSuggestResponseCopyWith<$Res> {
  _$SmartPurchaseSuggestResponseCopyWithImpl(this._self, this._then);

  final SmartPurchaseSuggestResponse _self;
  final $Res Function(SmartPurchaseSuggestResponse) _then;

/// Create a copy of SmartPurchaseSuggestResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? allItemsMatched = null,Object? items = null,Object? groupedBySupplier = null,}) {
  return _then(_self.copyWith(
allItemsMatched: null == allItemsMatched ? _self.allItemsMatched : allItemsMatched // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseSuggestItem>,groupedBySupplier: null == groupedBySupplier ? _self.groupedBySupplier : groupedBySupplier // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseSupplierGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseSuggestResponse].
extension SmartPurchaseSuggestResponsePatterns on SmartPurchaseSuggestResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseSuggestResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseSuggestResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseSuggestResponse value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSuggestResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseSuggestResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSuggestResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'all_items_matched')  bool allItemsMatched,  List<SmartPurchaseSuggestItem> items, @JsonKey(name: 'grouped_by_supplier')  List<SmartPurchaseSupplierGroup> groupedBySupplier)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseSuggestResponse() when $default != null:
return $default(_that.allItemsMatched,_that.items,_that.groupedBySupplier);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'all_items_matched')  bool allItemsMatched,  List<SmartPurchaseSuggestItem> items, @JsonKey(name: 'grouped_by_supplier')  List<SmartPurchaseSupplierGroup> groupedBySupplier)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSuggestResponse():
return $default(_that.allItemsMatched,_that.items,_that.groupedBySupplier);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'all_items_matched')  bool allItemsMatched,  List<SmartPurchaseSuggestItem> items, @JsonKey(name: 'grouped_by_supplier')  List<SmartPurchaseSupplierGroup> groupedBySupplier)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSuggestResponse() when $default != null:
return $default(_that.allItemsMatched,_that.items,_that.groupedBySupplier);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseSuggestResponse implements SmartPurchaseSuggestResponse {
  const _SmartPurchaseSuggestResponse({@JsonKey(name: 'all_items_matched') required this.allItemsMatched, final  List<SmartPurchaseSuggestItem> items = const [], @JsonKey(name: 'grouped_by_supplier') final  List<SmartPurchaseSupplierGroup> groupedBySupplier = const []}): _items = items,_groupedBySupplier = groupedBySupplier;
  factory _SmartPurchaseSuggestResponse.fromJson(Map<String, dynamic> json) => _$SmartPurchaseSuggestResponseFromJson(json);

@override@JsonKey(name: 'all_items_matched') final  bool allItemsMatched;
 final  List<SmartPurchaseSuggestItem> _items;
@override@JsonKey() List<SmartPurchaseSuggestItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

 final  List<SmartPurchaseSupplierGroup> _groupedBySupplier;
@override@JsonKey(name: 'grouped_by_supplier') List<SmartPurchaseSupplierGroup> get groupedBySupplier {
  if (_groupedBySupplier is EqualUnmodifiableListView) return _groupedBySupplier;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_groupedBySupplier);
}


/// Create a copy of SmartPurchaseSuggestResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseSuggestResponseCopyWith<_SmartPurchaseSuggestResponse> get copyWith => __$SmartPurchaseSuggestResponseCopyWithImpl<_SmartPurchaseSuggestResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseSuggestResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseSuggestResponse&&(identical(other.allItemsMatched, allItemsMatched) || other.allItemsMatched == allItemsMatched)&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._groupedBySupplier, _groupedBySupplier));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,allItemsMatched,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_groupedBySupplier));

@override
String toString() {
  return 'SmartPurchaseSuggestResponse(allItemsMatched: $allItemsMatched, items: $items, groupedBySupplier: $groupedBySupplier)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseSuggestResponseCopyWith<$Res> implements $SmartPurchaseSuggestResponseCopyWith<$Res> {
  factory _$SmartPurchaseSuggestResponseCopyWith(_SmartPurchaseSuggestResponse value, $Res Function(_SmartPurchaseSuggestResponse) _then) = __$SmartPurchaseSuggestResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'all_items_matched') bool allItemsMatched, List<SmartPurchaseSuggestItem> items,@JsonKey(name: 'grouped_by_supplier') List<SmartPurchaseSupplierGroup> groupedBySupplier
});




}
/// @nodoc
class __$SmartPurchaseSuggestResponseCopyWithImpl<$Res>
    implements _$SmartPurchaseSuggestResponseCopyWith<$Res> {
  __$SmartPurchaseSuggestResponseCopyWithImpl(this._self, this._then);

  final _SmartPurchaseSuggestResponse _self;
  final $Res Function(_SmartPurchaseSuggestResponse) _then;

/// Create a copy of SmartPurchaseSuggestResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? allItemsMatched = null,Object? items = null,Object? groupedBySupplier = null,}) {
  return _then(_SmartPurchaseSuggestResponse(
allItemsMatched: null == allItemsMatched ? _self.allItemsMatched : allItemsMatched // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseSuggestItem>,groupedBySupplier: null == groupedBySupplier ? _self._groupedBySupplier : groupedBySupplier // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseSupplierGroup>,
  ));
}


}


/// @nodoc
mixin _$SmartPurchaseSupplierPriceUpdate {

@JsonKey(name: 'price_amount') int get priceAmount;@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson, toJson: _quantityToJson) num get priceQuantity;
/// Create a copy of SmartPurchaseSupplierPriceUpdate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseSupplierPriceUpdateCopyWith<SmartPurchaseSupplierPriceUpdate> get copyWith => _$SmartPurchaseSupplierPriceUpdateCopyWithImpl<SmartPurchaseSupplierPriceUpdate>(this as SmartPurchaseSupplierPriceUpdate, _$identity);

  /// Serializes this SmartPurchaseSupplierPriceUpdate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseSupplierPriceUpdate&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceQuantity, priceQuantity) || other.priceQuantity == priceQuantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,priceAmount,priceQuantity);

@override
String toString() {
  return 'SmartPurchaseSupplierPriceUpdate(priceAmount: $priceAmount, priceQuantity: $priceQuantity)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseSupplierPriceUpdateCopyWith<$Res>  {
  factory $SmartPurchaseSupplierPriceUpdateCopyWith(SmartPurchaseSupplierPriceUpdate value, $Res Function(SmartPurchaseSupplierPriceUpdate) _then) = _$SmartPurchaseSupplierPriceUpdateCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'price_amount') int priceAmount,@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson, toJson: _quantityToJson) num priceQuantity
});




}
/// @nodoc
class _$SmartPurchaseSupplierPriceUpdateCopyWithImpl<$Res>
    implements $SmartPurchaseSupplierPriceUpdateCopyWith<$Res> {
  _$SmartPurchaseSupplierPriceUpdateCopyWithImpl(this._self, this._then);

  final SmartPurchaseSupplierPriceUpdate _self;
  final $Res Function(SmartPurchaseSupplierPriceUpdate) _then;

/// Create a copy of SmartPurchaseSupplierPriceUpdate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? priceAmount = null,Object? priceQuantity = null,}) {
  return _then(_self.copyWith(
priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as int,priceQuantity: null == priceQuantity ? _self.priceQuantity : priceQuantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseSupplierPriceUpdate].
extension SmartPurchaseSupplierPriceUpdatePatterns on SmartPurchaseSupplierPriceUpdate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseSupplierPriceUpdate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseSupplierPriceUpdate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseSupplierPriceUpdate value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSupplierPriceUpdate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseSupplierPriceUpdate value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseSupplierPriceUpdate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson, toJson: _quantityToJson)  num priceQuantity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseSupplierPriceUpdate() when $default != null:
return $default(_that.priceAmount,_that.priceQuantity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson, toJson: _quantityToJson)  num priceQuantity)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSupplierPriceUpdate():
return $default(_that.priceAmount,_that.priceQuantity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson, toJson: _quantityToJson)  num priceQuantity)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseSupplierPriceUpdate() when $default != null:
return $default(_that.priceAmount,_that.priceQuantity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseSupplierPriceUpdate implements SmartPurchaseSupplierPriceUpdate {
  const _SmartPurchaseSupplierPriceUpdate({@JsonKey(name: 'price_amount') required this.priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson, toJson: _quantityToJson) required this.priceQuantity});
  factory _SmartPurchaseSupplierPriceUpdate.fromJson(Map<String, dynamic> json) => _$SmartPurchaseSupplierPriceUpdateFromJson(json);

@override@JsonKey(name: 'price_amount') final  int priceAmount;
@override@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson, toJson: _quantityToJson) final  num priceQuantity;

/// Create a copy of SmartPurchaseSupplierPriceUpdate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseSupplierPriceUpdateCopyWith<_SmartPurchaseSupplierPriceUpdate> get copyWith => __$SmartPurchaseSupplierPriceUpdateCopyWithImpl<_SmartPurchaseSupplierPriceUpdate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseSupplierPriceUpdateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseSupplierPriceUpdate&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceQuantity, priceQuantity) || other.priceQuantity == priceQuantity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,priceAmount,priceQuantity);

@override
String toString() {
  return 'SmartPurchaseSupplierPriceUpdate(priceAmount: $priceAmount, priceQuantity: $priceQuantity)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseSupplierPriceUpdateCopyWith<$Res> implements $SmartPurchaseSupplierPriceUpdateCopyWith<$Res> {
  factory _$SmartPurchaseSupplierPriceUpdateCopyWith(_SmartPurchaseSupplierPriceUpdate value, $Res Function(_SmartPurchaseSupplierPriceUpdate) _then) = __$SmartPurchaseSupplierPriceUpdateCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'price_amount') int priceAmount,@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson, toJson: _quantityToJson) num priceQuantity
});




}
/// @nodoc
class __$SmartPurchaseSupplierPriceUpdateCopyWithImpl<$Res>
    implements _$SmartPurchaseSupplierPriceUpdateCopyWith<$Res> {
  __$SmartPurchaseSupplierPriceUpdateCopyWithImpl(this._self, this._then);

  final _SmartPurchaseSupplierPriceUpdate _self;
  final $Res Function(_SmartPurchaseSupplierPriceUpdate) _then;

/// Create a copy of SmartPurchaseSupplierPriceUpdate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? priceAmount = null,Object? priceQuantity = null,}) {
  return _then(_SmartPurchaseSupplierPriceUpdate(
priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as int,priceQuantity: null == priceQuantity ? _self.priceQuantity : priceQuantity // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}


/// @nodoc
mixin _$SmartPurchaseBatchItemInput {

@JsonKey(name: 'food_supply_id') String get foodSupplyId;@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) num get quantity;@JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) int? get lineActualAmount;@JsonKey(name: 'supplier_price_update') SmartPurchaseSupplierPriceUpdate? get supplierPriceUpdate;
/// Create a copy of SmartPurchaseBatchItemInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseBatchItemInputCopyWith<SmartPurchaseBatchItemInput> get copyWith => _$SmartPurchaseBatchItemInputCopyWithImpl<SmartPurchaseBatchItemInput>(this as SmartPurchaseBatchItemInput, _$identity);

  /// Serializes this SmartPurchaseBatchItemInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseBatchItemInput&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineActualAmount, lineActualAmount) || other.lineActualAmount == lineActualAmount)&&(identical(other.supplierPriceUpdate, supplierPriceUpdate) || other.supplierPriceUpdate == supplierPriceUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,quantity,lineActualAmount,supplierPriceUpdate);

@override
String toString() {
  return 'SmartPurchaseBatchItemInput(foodSupplyId: $foodSupplyId, quantity: $quantity, lineActualAmount: $lineActualAmount, supplierPriceUpdate: $supplierPriceUpdate)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseBatchItemInputCopyWith<$Res>  {
  factory $SmartPurchaseBatchItemInputCopyWith(SmartPurchaseBatchItemInput value, $Res Function(SmartPurchaseBatchItemInput) _then) = _$SmartPurchaseBatchItemInputCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) num quantity,@JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) int? lineActualAmount,@JsonKey(name: 'supplier_price_update') SmartPurchaseSupplierPriceUpdate? supplierPriceUpdate
});


$SmartPurchaseSupplierPriceUpdateCopyWith<$Res>? get supplierPriceUpdate;

}
/// @nodoc
class _$SmartPurchaseBatchItemInputCopyWithImpl<$Res>
    implements $SmartPurchaseBatchItemInputCopyWith<$Res> {
  _$SmartPurchaseBatchItemInputCopyWithImpl(this._self, this._then);

  final SmartPurchaseBatchItemInput _self;
  final $Res Function(SmartPurchaseBatchItemInput) _then;

/// Create a copy of SmartPurchaseBatchItemInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? foodSupplyId = null,Object? quantity = null,Object? lineActualAmount = freezed,Object? supplierPriceUpdate = freezed,}) {
  return _then(_self.copyWith(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,lineActualAmount: freezed == lineActualAmount ? _self.lineActualAmount : lineActualAmount // ignore: cast_nullable_to_non_nullable
as int?,supplierPriceUpdate: freezed == supplierPriceUpdate ? _self.supplierPriceUpdate : supplierPriceUpdate // ignore: cast_nullable_to_non_nullable
as SmartPurchaseSupplierPriceUpdate?,
  ));
}
/// Create a copy of SmartPurchaseBatchItemInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SmartPurchaseSupplierPriceUpdateCopyWith<$Res>? get supplierPriceUpdate {
    if (_self.supplierPriceUpdate == null) {
    return null;
  }

  return $SmartPurchaseSupplierPriceUpdateCopyWith<$Res>(_self.supplierPriceUpdate!, (value) {
    return _then(_self.copyWith(supplierPriceUpdate: value));
  });
}
}


/// Adds pattern-matching-related methods to [SmartPurchaseBatchItemInput].
extension SmartPurchaseBatchItemInputPatterns on SmartPurchaseBatchItemInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseBatchItemInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchItemInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseBatchItemInput value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchItemInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseBatchItemInput value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchItemInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)  num quantity, @JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson)  int? lineActualAmount, @JsonKey(name: 'supplier_price_update')  SmartPurchaseSupplierPriceUpdate? supplierPriceUpdate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchItemInput() when $default != null:
return $default(_that.foodSupplyId,_that.quantity,_that.lineActualAmount,_that.supplierPriceUpdate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)  num quantity, @JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson)  int? lineActualAmount, @JsonKey(name: 'supplier_price_update')  SmartPurchaseSupplierPriceUpdate? supplierPriceUpdate)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchItemInput():
return $default(_that.foodSupplyId,_that.quantity,_that.lineActualAmount,_that.supplierPriceUpdate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)  num quantity, @JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson)  int? lineActualAmount, @JsonKey(name: 'supplier_price_update')  SmartPurchaseSupplierPriceUpdate? supplierPriceUpdate)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchItemInput() when $default != null:
return $default(_that.foodSupplyId,_that.quantity,_that.lineActualAmount,_that.supplierPriceUpdate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseBatchItemInput implements SmartPurchaseBatchItemInput {
  const _SmartPurchaseBatchItemInput({@JsonKey(name: 'food_supply_id') required this.foodSupplyId, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) required this.quantity, @JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) this.lineActualAmount, @JsonKey(name: 'supplier_price_update') this.supplierPriceUpdate});
  factory _SmartPurchaseBatchItemInput.fromJson(Map<String, dynamic> json) => _$SmartPurchaseBatchItemInputFromJson(json);

@override@JsonKey(name: 'food_supply_id') final  String foodSupplyId;
@override@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) final  num quantity;
@override@JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) final  int? lineActualAmount;
@override@JsonKey(name: 'supplier_price_update') final  SmartPurchaseSupplierPriceUpdate? supplierPriceUpdate;

/// Create a copy of SmartPurchaseBatchItemInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseBatchItemInputCopyWith<_SmartPurchaseBatchItemInput> get copyWith => __$SmartPurchaseBatchItemInputCopyWithImpl<_SmartPurchaseBatchItemInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseBatchItemInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseBatchItemInput&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lineActualAmount, lineActualAmount) || other.lineActualAmount == lineActualAmount)&&(identical(other.supplierPriceUpdate, supplierPriceUpdate) || other.supplierPriceUpdate == supplierPriceUpdate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,quantity,lineActualAmount,supplierPriceUpdate);

@override
String toString() {
  return 'SmartPurchaseBatchItemInput(foodSupplyId: $foodSupplyId, quantity: $quantity, lineActualAmount: $lineActualAmount, supplierPriceUpdate: $supplierPriceUpdate)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseBatchItemInputCopyWith<$Res> implements $SmartPurchaseBatchItemInputCopyWith<$Res> {
  factory _$SmartPurchaseBatchItemInputCopyWith(_SmartPurchaseBatchItemInput value, $Res Function(_SmartPurchaseBatchItemInput) _then) = __$SmartPurchaseBatchItemInputCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) num quantity,@JsonKey(name: 'line_actual_amount', fromJson: _nullableIntFromJson) int? lineActualAmount,@JsonKey(name: 'supplier_price_update') SmartPurchaseSupplierPriceUpdate? supplierPriceUpdate
});


@override $SmartPurchaseSupplierPriceUpdateCopyWith<$Res>? get supplierPriceUpdate;

}
/// @nodoc
class __$SmartPurchaseBatchItemInputCopyWithImpl<$Res>
    implements _$SmartPurchaseBatchItemInputCopyWith<$Res> {
  __$SmartPurchaseBatchItemInputCopyWithImpl(this._self, this._then);

  final _SmartPurchaseBatchItemInput _self;
  final $Res Function(_SmartPurchaseBatchItemInput) _then;

/// Create a copy of SmartPurchaseBatchItemInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? foodSupplyId = null,Object? quantity = null,Object? lineActualAmount = freezed,Object? supplierPriceUpdate = freezed,}) {
  return _then(_SmartPurchaseBatchItemInput(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,lineActualAmount: freezed == lineActualAmount ? _self.lineActualAmount : lineActualAmount // ignore: cast_nullable_to_non_nullable
as int?,supplierPriceUpdate: freezed == supplierPriceUpdate ? _self.supplierPriceUpdate : supplierPriceUpdate // ignore: cast_nullable_to_non_nullable
as SmartPurchaseSupplierPriceUpdate?,
  ));
}

/// Create a copy of SmartPurchaseBatchItemInput
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SmartPurchaseSupplierPriceUpdateCopyWith<$Res>? get supplierPriceUpdate {
    if (_self.supplierPriceUpdate == null) {
    return null;
  }

  return $SmartPurchaseSupplierPriceUpdateCopyWith<$Res>(_self.supplierPriceUpdate!, (value) {
    return _then(_self.copyWith(supplierPriceUpdate: value));
  });
}
}


/// @nodoc
mixin _$SmartPurchaseBatchGroupInput {

@JsonKey(name: 'supplier_id') String get supplierId; List<SmartPurchaseBatchItemInput> get items;
/// Create a copy of SmartPurchaseBatchGroupInput
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseBatchGroupInputCopyWith<SmartPurchaseBatchGroupInput> get copyWith => _$SmartPurchaseBatchGroupInputCopyWithImpl<SmartPurchaseBatchGroupInput>(this as SmartPurchaseBatchGroupInput, _$identity);

  /// Serializes this SmartPurchaseBatchGroupInput to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseBatchGroupInput&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supplierId,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SmartPurchaseBatchGroupInput(supplierId: $supplierId, items: $items)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseBatchGroupInputCopyWith<$Res>  {
  factory $SmartPurchaseBatchGroupInputCopyWith(SmartPurchaseBatchGroupInput value, $Res Function(SmartPurchaseBatchGroupInput) _then) = _$SmartPurchaseBatchGroupInputCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId, List<SmartPurchaseBatchItemInput> items
});




}
/// @nodoc
class _$SmartPurchaseBatchGroupInputCopyWithImpl<$Res>
    implements $SmartPurchaseBatchGroupInputCopyWith<$Res> {
  _$SmartPurchaseBatchGroupInputCopyWithImpl(this._self, this._then);

  final SmartPurchaseBatchGroupInput _self;
  final $Res Function(SmartPurchaseBatchGroupInput) _then;

/// Create a copy of SmartPurchaseBatchGroupInput
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? supplierId = null,Object? items = null,}) {
  return _then(_self.copyWith(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseBatchItemInput>,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseBatchGroupInput].
extension SmartPurchaseBatchGroupInputPatterns on SmartPurchaseBatchGroupInput {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseBatchGroupInput value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchGroupInput() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseBatchGroupInput value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchGroupInput():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseBatchGroupInput value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchGroupInput() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId,  List<SmartPurchaseBatchItemInput> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchGroupInput() when $default != null:
return $default(_that.supplierId,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'supplier_id')  String supplierId,  List<SmartPurchaseBatchItemInput> items)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchGroupInput():
return $default(_that.supplierId,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'supplier_id')  String supplierId,  List<SmartPurchaseBatchItemInput> items)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchGroupInput() when $default != null:
return $default(_that.supplierId,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseBatchGroupInput implements SmartPurchaseBatchGroupInput {
  const _SmartPurchaseBatchGroupInput({@JsonKey(name: 'supplier_id') required this.supplierId, required final  List<SmartPurchaseBatchItemInput> items}): _items = items;
  factory _SmartPurchaseBatchGroupInput.fromJson(Map<String, dynamic> json) => _$SmartPurchaseBatchGroupInputFromJson(json);

@override@JsonKey(name: 'supplier_id') final  String supplierId;
 final  List<SmartPurchaseBatchItemInput> _items;
@override List<SmartPurchaseBatchItemInput> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SmartPurchaseBatchGroupInput
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseBatchGroupInputCopyWith<_SmartPurchaseBatchGroupInput> get copyWith => __$SmartPurchaseBatchGroupInputCopyWithImpl<_SmartPurchaseBatchGroupInput>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseBatchGroupInputToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseBatchGroupInput&&(identical(other.supplierId, supplierId) || other.supplierId == supplierId)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,supplierId,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SmartPurchaseBatchGroupInput(supplierId: $supplierId, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseBatchGroupInputCopyWith<$Res> implements $SmartPurchaseBatchGroupInputCopyWith<$Res> {
  factory _$SmartPurchaseBatchGroupInputCopyWith(_SmartPurchaseBatchGroupInput value, $Res Function(_SmartPurchaseBatchGroupInput) _then) = __$SmartPurchaseBatchGroupInputCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'supplier_id') String supplierId, List<SmartPurchaseBatchItemInput> items
});




}
/// @nodoc
class __$SmartPurchaseBatchGroupInputCopyWithImpl<$Res>
    implements _$SmartPurchaseBatchGroupInputCopyWith<$Res> {
  __$SmartPurchaseBatchGroupInputCopyWithImpl(this._self, this._then);

  final _SmartPurchaseBatchGroupInput _self;
  final $Res Function(_SmartPurchaseBatchGroupInput) _then;

/// Create a copy of SmartPurchaseBatchGroupInput
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? supplierId = null,Object? items = null,}) {
  return _then(_SmartPurchaseBatchGroupInput(
supplierId: null == supplierId ? _self.supplierId : supplierId // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseBatchItemInput>,
  ));
}


}


/// @nodoc
mixin _$SmartPurchaseBatchResponse {

@JsonKey(name: 'purchase_requests') List<SmartPurchaseBatchCreatedRequest> get purchaseRequests;
/// Create a copy of SmartPurchaseBatchResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseBatchResponseCopyWith<SmartPurchaseBatchResponse> get copyWith => _$SmartPurchaseBatchResponseCopyWithImpl<SmartPurchaseBatchResponse>(this as SmartPurchaseBatchResponse, _$identity);

  /// Serializes this SmartPurchaseBatchResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseBatchResponse&&const DeepCollectionEquality().equals(other.purchaseRequests, purchaseRequests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(purchaseRequests));

@override
String toString() {
  return 'SmartPurchaseBatchResponse(purchaseRequests: $purchaseRequests)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseBatchResponseCopyWith<$Res>  {
  factory $SmartPurchaseBatchResponseCopyWith(SmartPurchaseBatchResponse value, $Res Function(SmartPurchaseBatchResponse) _then) = _$SmartPurchaseBatchResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'purchase_requests') List<SmartPurchaseBatchCreatedRequest> purchaseRequests
});




}
/// @nodoc
class _$SmartPurchaseBatchResponseCopyWithImpl<$Res>
    implements $SmartPurchaseBatchResponseCopyWith<$Res> {
  _$SmartPurchaseBatchResponseCopyWithImpl(this._self, this._then);

  final SmartPurchaseBatchResponse _self;
  final $Res Function(SmartPurchaseBatchResponse) _then;

/// Create a copy of SmartPurchaseBatchResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? purchaseRequests = null,}) {
  return _then(_self.copyWith(
purchaseRequests: null == purchaseRequests ? _self.purchaseRequests : purchaseRequests // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseBatchCreatedRequest>,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseBatchResponse].
extension SmartPurchaseBatchResponsePatterns on SmartPurchaseBatchResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseBatchResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseBatchResponse value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseBatchResponse value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'purchase_requests')  List<SmartPurchaseBatchCreatedRequest> purchaseRequests)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchResponse() when $default != null:
return $default(_that.purchaseRequests);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'purchase_requests')  List<SmartPurchaseBatchCreatedRequest> purchaseRequests)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchResponse():
return $default(_that.purchaseRequests);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'purchase_requests')  List<SmartPurchaseBatchCreatedRequest> purchaseRequests)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchResponse() when $default != null:
return $default(_that.purchaseRequests);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseBatchResponse implements SmartPurchaseBatchResponse {
  const _SmartPurchaseBatchResponse({@JsonKey(name: 'purchase_requests') final  List<SmartPurchaseBatchCreatedRequest> purchaseRequests = const []}): _purchaseRequests = purchaseRequests;
  factory _SmartPurchaseBatchResponse.fromJson(Map<String, dynamic> json) => _$SmartPurchaseBatchResponseFromJson(json);

 final  List<SmartPurchaseBatchCreatedRequest> _purchaseRequests;
@override@JsonKey(name: 'purchase_requests') List<SmartPurchaseBatchCreatedRequest> get purchaseRequests {
  if (_purchaseRequests is EqualUnmodifiableListView) return _purchaseRequests;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_purchaseRequests);
}


/// Create a copy of SmartPurchaseBatchResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseBatchResponseCopyWith<_SmartPurchaseBatchResponse> get copyWith => __$SmartPurchaseBatchResponseCopyWithImpl<_SmartPurchaseBatchResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseBatchResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseBatchResponse&&const DeepCollectionEquality().equals(other._purchaseRequests, _purchaseRequests));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_purchaseRequests));

@override
String toString() {
  return 'SmartPurchaseBatchResponse(purchaseRequests: $purchaseRequests)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseBatchResponseCopyWith<$Res> implements $SmartPurchaseBatchResponseCopyWith<$Res> {
  factory _$SmartPurchaseBatchResponseCopyWith(_SmartPurchaseBatchResponse value, $Res Function(_SmartPurchaseBatchResponse) _then) = __$SmartPurchaseBatchResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'purchase_requests') List<SmartPurchaseBatchCreatedRequest> purchaseRequests
});




}
/// @nodoc
class __$SmartPurchaseBatchResponseCopyWithImpl<$Res>
    implements _$SmartPurchaseBatchResponseCopyWith<$Res> {
  __$SmartPurchaseBatchResponseCopyWithImpl(this._self, this._then);

  final _SmartPurchaseBatchResponse _self;
  final $Res Function(_SmartPurchaseBatchResponse) _then;

/// Create a copy of SmartPurchaseBatchResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? purchaseRequests = null,}) {
  return _then(_SmartPurchaseBatchResponse(
purchaseRequests: null == purchaseRequests ? _self._purchaseRequests : purchaseRequests // ignore: cast_nullable_to_non_nullable
as List<SmartPurchaseBatchCreatedRequest>,
  ));
}


}


/// @nodoc
mixin _$SmartPurchaseBatchCreatedRequest {

 String get id;@JsonKey(name: 'supplier_name') String get supplierName;
/// Create a copy of SmartPurchaseBatchCreatedRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmartPurchaseBatchCreatedRequestCopyWith<SmartPurchaseBatchCreatedRequest> get copyWith => _$SmartPurchaseBatchCreatedRequestCopyWithImpl<SmartPurchaseBatchCreatedRequest>(this as SmartPurchaseBatchCreatedRequest, _$identity);

  /// Serializes this SmartPurchaseBatchCreatedRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmartPurchaseBatchCreatedRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierName);

@override
String toString() {
  return 'SmartPurchaseBatchCreatedRequest(id: $id, supplierName: $supplierName)';
}


}

/// @nodoc
abstract mixin class $SmartPurchaseBatchCreatedRequestCopyWith<$Res>  {
  factory $SmartPurchaseBatchCreatedRequestCopyWith(SmartPurchaseBatchCreatedRequest value, $Res Function(SmartPurchaseBatchCreatedRequest) _then) = _$SmartPurchaseBatchCreatedRequestCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'supplier_name') String supplierName
});




}
/// @nodoc
class _$SmartPurchaseBatchCreatedRequestCopyWithImpl<$Res>
    implements $SmartPurchaseBatchCreatedRequestCopyWith<$Res> {
  _$SmartPurchaseBatchCreatedRequestCopyWithImpl(this._self, this._then);

  final SmartPurchaseBatchCreatedRequest _self;
  final $Res Function(SmartPurchaseBatchCreatedRequest) _then;

/// Create a copy of SmartPurchaseBatchCreatedRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? supplierName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SmartPurchaseBatchCreatedRequest].
extension SmartPurchaseBatchCreatedRequestPatterns on SmartPurchaseBatchCreatedRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmartPurchaseBatchCreatedRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchCreatedRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmartPurchaseBatchCreatedRequest value)  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchCreatedRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmartPurchaseBatchCreatedRequest value)?  $default,){
final _that = this;
switch (_that) {
case _SmartPurchaseBatchCreatedRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'supplier_name')  String supplierName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchCreatedRequest() when $default != null:
return $default(_that.id,_that.supplierName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'supplier_name')  String supplierName)  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchCreatedRequest():
return $default(_that.id,_that.supplierName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'supplier_name')  String supplierName)?  $default,) {final _that = this;
switch (_that) {
case _SmartPurchaseBatchCreatedRequest() when $default != null:
return $default(_that.id,_that.supplierName);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SmartPurchaseBatchCreatedRequest implements SmartPurchaseBatchCreatedRequest {
  const _SmartPurchaseBatchCreatedRequest({required this.id, @JsonKey(name: 'supplier_name') required this.supplierName});
  factory _SmartPurchaseBatchCreatedRequest.fromJson(Map<String, dynamic> json) => _$SmartPurchaseBatchCreatedRequestFromJson(json);

@override final  String id;
@override@JsonKey(name: 'supplier_name') final  String supplierName;

/// Create a copy of SmartPurchaseBatchCreatedRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmartPurchaseBatchCreatedRequestCopyWith<_SmartPurchaseBatchCreatedRequest> get copyWith => __$SmartPurchaseBatchCreatedRequestCopyWithImpl<_SmartPurchaseBatchCreatedRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SmartPurchaseBatchCreatedRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmartPurchaseBatchCreatedRequest&&(identical(other.id, id) || other.id == id)&&(identical(other.supplierName, supplierName) || other.supplierName == supplierName));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,supplierName);

@override
String toString() {
  return 'SmartPurchaseBatchCreatedRequest(id: $id, supplierName: $supplierName)';
}


}

/// @nodoc
abstract mixin class _$SmartPurchaseBatchCreatedRequestCopyWith<$Res> implements $SmartPurchaseBatchCreatedRequestCopyWith<$Res> {
  factory _$SmartPurchaseBatchCreatedRequestCopyWith(_SmartPurchaseBatchCreatedRequest value, $Res Function(_SmartPurchaseBatchCreatedRequest) _then) = __$SmartPurchaseBatchCreatedRequestCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'supplier_name') String supplierName
});




}
/// @nodoc
class __$SmartPurchaseBatchCreatedRequestCopyWithImpl<$Res>
    implements _$SmartPurchaseBatchCreatedRequestCopyWith<$Res> {
  __$SmartPurchaseBatchCreatedRequestCopyWithImpl(this._self, this._then);

  final _SmartPurchaseBatchCreatedRequest _self;
  final $Res Function(_SmartPurchaseBatchCreatedRequest) _then;

/// Create a copy of SmartPurchaseBatchCreatedRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? supplierName = null,}) {
  return _then(_SmartPurchaseBatchCreatedRequest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,supplierName: null == supplierName ? _self.supplierName : supplierName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
