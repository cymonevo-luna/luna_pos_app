// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_line_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OrderLineItem {

 String get id; String get menuId; String get title; int get sellPrice; int get quantity; String get note;
/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderLineItemCopyWith<OrderLineItem> get copyWith => _$OrderLineItemCopyWithImpl<OrderLineItem>(this as OrderLineItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderLineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.title, title) || other.title == title)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,menuId,title,sellPrice,quantity,note);

@override
String toString() {
  return 'OrderLineItem(id: $id, menuId: $menuId, title: $title, sellPrice: $sellPrice, quantity: $quantity, note: $note)';
}


}

/// @nodoc
abstract mixin class $OrderLineItemCopyWith<$Res>  {
  factory $OrderLineItemCopyWith(OrderLineItem value, $Res Function(OrderLineItem) _then) = _$OrderLineItemCopyWithImpl;
@useResult
$Res call({
 String id, String menuId, String title, int sellPrice, int quantity, String note
});




}
/// @nodoc
class _$OrderLineItemCopyWithImpl<$Res>
    implements $OrderLineItemCopyWith<$Res> {
  _$OrderLineItemCopyWithImpl(this._self, this._then);

  final OrderLineItem _self;
  final $Res Function(OrderLineItem) _then;

/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? menuId = null,Object? title = null,Object? sellPrice = null,Object? quantity = null,Object? note = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderLineItem].
extension OrderLineItemPatterns on OrderLineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderLineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderLineItem value)  $default,){
final _that = this;
switch (_that) {
case _OrderLineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderLineItem value)?  $default,){
final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String menuId,  String title,  int sellPrice,  int quantity,  String note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
return $default(_that.id,_that.menuId,_that.title,_that.sellPrice,_that.quantity,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String menuId,  String title,  int sellPrice,  int quantity,  String note)  $default,) {final _that = this;
switch (_that) {
case _OrderLineItem():
return $default(_that.id,_that.menuId,_that.title,_that.sellPrice,_that.quantity,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String menuId,  String title,  int sellPrice,  int quantity,  String note)?  $default,) {final _that = this;
switch (_that) {
case _OrderLineItem() when $default != null:
return $default(_that.id,_that.menuId,_that.title,_that.sellPrice,_that.quantity,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _OrderLineItem extends OrderLineItem {
  const _OrderLineItem({required this.id, required this.menuId, required this.title, required this.sellPrice, required this.quantity, this.note = ''}): super._();
  

@override final  String id;
@override final  String menuId;
@override final  String title;
@override final  int sellPrice;
@override final  int quantity;
@override@JsonKey() final  String note;

/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderLineItemCopyWith<_OrderLineItem> get copyWith => __$OrderLineItemCopyWithImpl<_OrderLineItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderLineItem&&(identical(other.id, id) || other.id == id)&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.title, title) || other.title == title)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,menuId,title,sellPrice,quantity,note);

@override
String toString() {
  return 'OrderLineItem(id: $id, menuId: $menuId, title: $title, sellPrice: $sellPrice, quantity: $quantity, note: $note)';
}


}

/// @nodoc
abstract mixin class _$OrderLineItemCopyWith<$Res> implements $OrderLineItemCopyWith<$Res> {
  factory _$OrderLineItemCopyWith(_OrderLineItem value, $Res Function(_OrderLineItem) _then) = __$OrderLineItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String menuId, String title, int sellPrice, int quantity, String note
});




}
/// @nodoc
class __$OrderLineItemCopyWithImpl<$Res>
    implements _$OrderLineItemCopyWith<$Res> {
  __$OrderLineItemCopyWithImpl(this._self, this._then);

  final _OrderLineItem _self;
  final $Res Function(_OrderLineItem) _then;

/// Create a copy of OrderLineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? menuId = null,Object? title = null,Object? sellPrice = null,Object? quantity = null,Object? note = null,}) {
  return _then(_OrderLineItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
