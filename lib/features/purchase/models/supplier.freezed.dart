// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'supplier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SupplierSummary {

 String get id; String get name;
/// Create a copy of SupplierSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierSummaryCopyWith<SupplierSummary> get copyWith => _$SupplierSummaryCopyWithImpl<SupplierSummary>(this as SupplierSummary, _$identity);

  /// Serializes this SupplierSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SupplierSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SupplierSummary(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $SupplierSummaryCopyWith<$Res>  {
  factory $SupplierSummaryCopyWith(SupplierSummary value, $Res Function(SupplierSummary) _then) = _$SupplierSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$SupplierSummaryCopyWithImpl<$Res>
    implements $SupplierSummaryCopyWith<$Res> {
  _$SupplierSummaryCopyWithImpl(this._self, this._then);

  final SupplierSummary _self;
  final $Res Function(SupplierSummary) _then;

/// Create a copy of SupplierSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SupplierSummary].
extension SupplierSummaryPatterns on SupplierSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SupplierSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SupplierSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SupplierSummary value)  $default,){
final _that = this;
switch (_that) {
case _SupplierSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SupplierSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SupplierSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SupplierSummary() when $default != null:
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _SupplierSummary():
return $default(_that.id,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _SupplierSummary() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SupplierSummary implements SupplierSummary {
  const _SupplierSummary({required this.id, required this.name});
  factory _SupplierSummary.fromJson(Map<String, dynamic> json) => _$SupplierSummaryFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of SupplierSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierSummaryCopyWith<_SupplierSummary> get copyWith => __$SupplierSummaryCopyWithImpl<_SupplierSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplierSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SupplierSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'SupplierSummary(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$SupplierSummaryCopyWith<$Res> implements $SupplierSummaryCopyWith<$Res> {
  factory _$SupplierSummaryCopyWith(_SupplierSummary value, $Res Function(_SupplierSummary) _then) = __$SupplierSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$SupplierSummaryCopyWithImpl<$Res>
    implements _$SupplierSummaryCopyWith<$Res> {
  __$SupplierSummaryCopyWithImpl(this._self, this._then);

  final _SupplierSummary _self;
  final $Res Function(_SupplierSummary) _then;

/// Create a copy of SupplierSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_SupplierSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$PriceQuote {

@JsonKey(name: 'food_supply_id') String get foodSupplyId;@JsonKey(name: 'food_supply_title') String get foodSupplyTitle; String get unit;@JsonKey(name: 'price_amount') int get priceAmount;@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) num get priceQuantity;@JsonKey(name: 'unit_price', fromJson: _nullableDecimalFromJson) num? get unitPrice;
/// Create a copy of PriceQuote
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceQuoteCopyWith<PriceQuote> get copyWith => _$PriceQuoteCopyWithImpl<PriceQuote>(this as PriceQuote, _$identity);

  /// Serializes this PriceQuote to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceQuote&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.foodSupplyTitle, foodSupplyTitle) || other.foodSupplyTitle == foodSupplyTitle)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceQuantity, priceQuantity) || other.priceQuantity == priceQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,foodSupplyTitle,unit,priceAmount,priceQuantity,unitPrice);

@override
String toString() {
  return 'PriceQuote(foodSupplyId: $foodSupplyId, foodSupplyTitle: $foodSupplyTitle, unit: $unit, priceAmount: $priceAmount, priceQuantity: $priceQuantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class $PriceQuoteCopyWith<$Res>  {
  factory $PriceQuoteCopyWith(PriceQuote value, $Res Function(PriceQuote) _then) = _$PriceQuoteCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(name: 'food_supply_title') String foodSupplyTitle, String unit,@JsonKey(name: 'price_amount') int priceAmount,@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) num priceQuantity,@JsonKey(name: 'unit_price', fromJson: _nullableDecimalFromJson) num? unitPrice
});




}
/// @nodoc
class _$PriceQuoteCopyWithImpl<$Res>
    implements $PriceQuoteCopyWith<$Res> {
  _$PriceQuoteCopyWithImpl(this._self, this._then);

  final PriceQuote _self;
  final $Res Function(PriceQuote) _then;

/// Create a copy of PriceQuote
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? foodSupplyId = null,Object? foodSupplyTitle = null,Object? unit = null,Object? priceAmount = null,Object? priceQuantity = null,Object? unitPrice = freezed,}) {
  return _then(_self.copyWith(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,foodSupplyTitle: null == foodSupplyTitle ? _self.foodSupplyTitle : foodSupplyTitle // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as int,priceQuantity: null == priceQuantity ? _self.priceQuantity : priceQuantity // ignore: cast_nullable_to_non_nullable
as num,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceQuote].
extension PriceQuotePatterns on PriceQuote {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceQuote value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceQuote() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceQuote value)  $default,){
final _that = this;
switch (_that) {
case _PriceQuote():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceQuote value)?  $default,){
final _that = this;
switch (_that) {
case _PriceQuote() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String foodSupplyTitle,  String unit, @JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson)  num priceQuantity, @JsonKey(name: 'unit_price', fromJson: _nullableDecimalFromJson)  num? unitPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceQuote() when $default != null:
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.unit,_that.priceAmount,_that.priceQuantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String foodSupplyTitle,  String unit, @JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson)  num priceQuantity, @JsonKey(name: 'unit_price', fromJson: _nullableDecimalFromJson)  num? unitPrice)  $default,) {final _that = this;
switch (_that) {
case _PriceQuote():
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.unit,_that.priceAmount,_that.priceQuantity,_that.unitPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'food_supply_id')  String foodSupplyId, @JsonKey(name: 'food_supply_title')  String foodSupplyTitle,  String unit, @JsonKey(name: 'price_amount')  int priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson)  num priceQuantity, @JsonKey(name: 'unit_price', fromJson: _nullableDecimalFromJson)  num? unitPrice)?  $default,) {final _that = this;
switch (_that) {
case _PriceQuote() when $default != null:
return $default(_that.foodSupplyId,_that.foodSupplyTitle,_that.unit,_that.priceAmount,_that.priceQuantity,_that.unitPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PriceQuote implements PriceQuote {
  const _PriceQuote({@JsonKey(name: 'food_supply_id') required this.foodSupplyId, @JsonKey(name: 'food_supply_title') required this.foodSupplyTitle, required this.unit, @JsonKey(name: 'price_amount') required this.priceAmount, @JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) required this.priceQuantity, @JsonKey(name: 'unit_price', fromJson: _nullableDecimalFromJson) this.unitPrice});
  factory _PriceQuote.fromJson(Map<String, dynamic> json) => _$PriceQuoteFromJson(json);

@override@JsonKey(name: 'food_supply_id') final  String foodSupplyId;
@override@JsonKey(name: 'food_supply_title') final  String foodSupplyTitle;
@override final  String unit;
@override@JsonKey(name: 'price_amount') final  int priceAmount;
@override@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) final  num priceQuantity;
@override@JsonKey(name: 'unit_price', fromJson: _nullableDecimalFromJson) final  num? unitPrice;

/// Create a copy of PriceQuote
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceQuoteCopyWith<_PriceQuote> get copyWith => __$PriceQuoteCopyWithImpl<_PriceQuote>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PriceQuoteToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceQuote&&(identical(other.foodSupplyId, foodSupplyId) || other.foodSupplyId == foodSupplyId)&&(identical(other.foodSupplyTitle, foodSupplyTitle) || other.foodSupplyTitle == foodSupplyTitle)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.priceAmount, priceAmount) || other.priceAmount == priceAmount)&&(identical(other.priceQuantity, priceQuantity) || other.priceQuantity == priceQuantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,foodSupplyId,foodSupplyTitle,unit,priceAmount,priceQuantity,unitPrice);

@override
String toString() {
  return 'PriceQuote(foodSupplyId: $foodSupplyId, foodSupplyTitle: $foodSupplyTitle, unit: $unit, priceAmount: $priceAmount, priceQuantity: $priceQuantity, unitPrice: $unitPrice)';
}


}

/// @nodoc
abstract mixin class _$PriceQuoteCopyWith<$Res> implements $PriceQuoteCopyWith<$Res> {
  factory _$PriceQuoteCopyWith(_PriceQuote value, $Res Function(_PriceQuote) _then) = __$PriceQuoteCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'food_supply_id') String foodSupplyId,@JsonKey(name: 'food_supply_title') String foodSupplyTitle, String unit,@JsonKey(name: 'price_amount') int priceAmount,@JsonKey(name: 'price_quantity', fromJson: _decimalFromJson) num priceQuantity,@JsonKey(name: 'unit_price', fromJson: _nullableDecimalFromJson) num? unitPrice
});




}
/// @nodoc
class __$PriceQuoteCopyWithImpl<$Res>
    implements _$PriceQuoteCopyWith<$Res> {
  __$PriceQuoteCopyWithImpl(this._self, this._then);

  final _PriceQuote _self;
  final $Res Function(_PriceQuote) _then;

/// Create a copy of PriceQuote
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? foodSupplyId = null,Object? foodSupplyTitle = null,Object? unit = null,Object? priceAmount = null,Object? priceQuantity = null,Object? unitPrice = freezed,}) {
  return _then(_PriceQuote(
foodSupplyId: null == foodSupplyId ? _self.foodSupplyId : foodSupplyId // ignore: cast_nullable_to_non_nullable
as String,foodSupplyTitle: null == foodSupplyTitle ? _self.foodSupplyTitle : foodSupplyTitle // ignore: cast_nullable_to_non_nullable
as String,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,priceAmount: null == priceAmount ? _self.priceAmount : priceAmount // ignore: cast_nullable_to_non_nullable
as int,priceQuantity: null == priceQuantity ? _self.priceQuantity : priceQuantity // ignore: cast_nullable_to_non_nullable
as num,unitPrice: freezed == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as num?,
  ));
}


}


/// @nodoc
mixin _$Supplier {

 String get id; String get name;@JsonKey(name: 'price_quotes') List<PriceQuote> get priceQuotes;
/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SupplierCopyWith<Supplier> get copyWith => _$SupplierCopyWithImpl<Supplier>(this as Supplier, _$identity);

  /// Serializes this Supplier to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Supplier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.priceQuotes, priceQuotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(priceQuotes));

@override
String toString() {
  return 'Supplier(id: $id, name: $name, priceQuotes: $priceQuotes)';
}


}

/// @nodoc
abstract mixin class $SupplierCopyWith<$Res>  {
  factory $SupplierCopyWith(Supplier value, $Res Function(Supplier) _then) = _$SupplierCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(name: 'price_quotes') List<PriceQuote> priceQuotes
});




}
/// @nodoc
class _$SupplierCopyWithImpl<$Res>
    implements $SupplierCopyWith<$Res> {
  _$SupplierCopyWithImpl(this._self, this._then);

  final Supplier _self;
  final $Res Function(Supplier) _then;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priceQuotes = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceQuotes: null == priceQuotes ? _self.priceQuotes : priceQuotes // ignore: cast_nullable_to_non_nullable
as List<PriceQuote>,
  ));
}

}


/// Adds pattern-matching-related methods to [Supplier].
extension SupplierPatterns on Supplier {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Supplier value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Supplier() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Supplier value)  $default,){
final _that = this;
switch (_that) {
case _Supplier():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Supplier value)?  $default,){
final _that = this;
switch (_that) {
case _Supplier() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'price_quotes')  List<PriceQuote> priceQuotes)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Supplier() when $default != null:
return $default(_that.id,_that.name,_that.priceQuotes);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(name: 'price_quotes')  List<PriceQuote> priceQuotes)  $default,) {final _that = this;
switch (_that) {
case _Supplier():
return $default(_that.id,_that.name,_that.priceQuotes);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(name: 'price_quotes')  List<PriceQuote> priceQuotes)?  $default,) {final _that = this;
switch (_that) {
case _Supplier() when $default != null:
return $default(_that.id,_that.name,_that.priceQuotes);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Supplier implements Supplier {
  const _Supplier({required this.id, required this.name, @JsonKey(name: 'price_quotes') final  List<PriceQuote> priceQuotes = const []}): _priceQuotes = priceQuotes;
  factory _Supplier.fromJson(Map<String, dynamic> json) => _$SupplierFromJson(json);

@override final  String id;
@override final  String name;
 final  List<PriceQuote> _priceQuotes;
@override@JsonKey(name: 'price_quotes') List<PriceQuote> get priceQuotes {
  if (_priceQuotes is EqualUnmodifiableListView) return _priceQuotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_priceQuotes);
}


/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SupplierCopyWith<_Supplier> get copyWith => __$SupplierCopyWithImpl<_Supplier>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SupplierToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Supplier&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._priceQuotes, _priceQuotes));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_priceQuotes));

@override
String toString() {
  return 'Supplier(id: $id, name: $name, priceQuotes: $priceQuotes)';
}


}

/// @nodoc
abstract mixin class _$SupplierCopyWith<$Res> implements $SupplierCopyWith<$Res> {
  factory _$SupplierCopyWith(_Supplier value, $Res Function(_Supplier) _then) = __$SupplierCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(name: 'price_quotes') List<PriceQuote> priceQuotes
});




}
/// @nodoc
class __$SupplierCopyWithImpl<$Res>
    implements _$SupplierCopyWith<$Res> {
  __$SupplierCopyWithImpl(this._self, this._then);

  final _Supplier _self;
  final $Res Function(_Supplier) _then;

/// Create a copy of Supplier
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priceQuotes = null,}) {
  return _then(_Supplier(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceQuotes: null == priceQuotes ? _self._priceQuotes : priceQuotes // ignore: cast_nullable_to_non_nullable
as List<PriceQuote>,
  ));
}


}

// dart format on
