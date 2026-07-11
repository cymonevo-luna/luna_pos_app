// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_line_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptLineItem {

 String get title; int get quantity; String? get note; int get lineTotal;
/// Create a copy of ReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptLineItemCopyWith<ReceiptLineItem> get copyWith => _$ReceiptLineItemCopyWithImpl<ReceiptLineItem>(this as ReceiptLineItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptLineItem&&(identical(other.title, title) || other.title == title)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.note, note) || other.note == note)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal));
}


@override
int get hashCode => Object.hash(runtimeType,title,quantity,note,lineTotal);

@override
String toString() {
  return 'ReceiptLineItem(title: $title, quantity: $quantity, note: $note, lineTotal: $lineTotal)';
}


}

/// @nodoc
abstract mixin class $ReceiptLineItemCopyWith<$Res>  {
  factory $ReceiptLineItemCopyWith(ReceiptLineItem value, $Res Function(ReceiptLineItem) _then) = _$ReceiptLineItemCopyWithImpl;
@useResult
$Res call({
 String title, int quantity, String? note, int lineTotal
});




}
/// @nodoc
class _$ReceiptLineItemCopyWithImpl<$Res>
    implements $ReceiptLineItemCopyWith<$Res> {
  _$ReceiptLineItemCopyWithImpl(this._self, this._then);

  final ReceiptLineItem _self;
  final $Res Function(ReceiptLineItem) _then;

/// Create a copy of ReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? quantity = null,Object? note = freezed,Object? lineTotal = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptLineItem].
extension ReceiptLineItemPatterns on ReceiptLineItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptLineItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptLineItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptLineItem value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptLineItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptLineItem value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptLineItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  int quantity,  String? note,  int lineTotal)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptLineItem() when $default != null:
return $default(_that.title,_that.quantity,_that.note,_that.lineTotal);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  int quantity,  String? note,  int lineTotal)  $default,) {final _that = this;
switch (_that) {
case _ReceiptLineItem():
return $default(_that.title,_that.quantity,_that.note,_that.lineTotal);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  int quantity,  String? note,  int lineTotal)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptLineItem() when $default != null:
return $default(_that.title,_that.quantity,_that.note,_that.lineTotal);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptLineItem implements ReceiptLineItem {
  const _ReceiptLineItem({required this.title, required this.quantity, this.note, required this.lineTotal});
  

@override final  String title;
@override final  int quantity;
@override final  String? note;
@override final  int lineTotal;

/// Create a copy of ReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptLineItemCopyWith<_ReceiptLineItem> get copyWith => __$ReceiptLineItemCopyWithImpl<_ReceiptLineItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptLineItem&&(identical(other.title, title) || other.title == title)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.note, note) || other.note == note)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal));
}


@override
int get hashCode => Object.hash(runtimeType,title,quantity,note,lineTotal);

@override
String toString() {
  return 'ReceiptLineItem(title: $title, quantity: $quantity, note: $note, lineTotal: $lineTotal)';
}


}

/// @nodoc
abstract mixin class _$ReceiptLineItemCopyWith<$Res> implements $ReceiptLineItemCopyWith<$Res> {
  factory _$ReceiptLineItemCopyWith(_ReceiptLineItem value, $Res Function(_ReceiptLineItem) _then) = __$ReceiptLineItemCopyWithImpl;
@override @useResult
$Res call({
 String title, int quantity, String? note, int lineTotal
});




}
/// @nodoc
class __$ReceiptLineItemCopyWithImpl<$Res>
    implements _$ReceiptLineItemCopyWith<$Res> {
  __$ReceiptLineItemCopyWithImpl(this._self, this._then);

  final _ReceiptLineItem _self;
  final $Res Function(_ReceiptLineItem) _then;

/// Create a copy of ReceiptLineItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? quantity = null,Object? note = freezed,Object? lineTotal = null,}) {
  return _then(_ReceiptLineItem(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
