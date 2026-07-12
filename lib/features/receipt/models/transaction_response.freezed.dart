// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionResponse {

 String get id; String get method; DateTime get createdAt; List<ReceiptLineItem> get items; int get subtotalAmount; int get discountAmount; int get totalAmount; int? get cashTendered; int get changeAmount;
/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionResponseCopyWith<TransactionResponse> get copyWith => _$TransactionResponseCopyWithImpl<TransactionResponse>(this as TransactionResponse, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount));
}


@override
int get hashCode => Object.hash(runtimeType,id,method,createdAt,const DeepCollectionEquality().hash(items),subtotalAmount,discountAmount,totalAmount,cashTendered,changeAmount);

@override
String toString() {
  return 'TransactionResponse(id: $id, method: $method, createdAt: $createdAt, items: $items, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, cashTendered: $cashTendered, changeAmount: $changeAmount)';
}


}

/// @nodoc
abstract mixin class $TransactionResponseCopyWith<$Res>  {
  factory $TransactionResponseCopyWith(TransactionResponse value, $Res Function(TransactionResponse) _then) = _$TransactionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String method, DateTime createdAt, List<ReceiptLineItem> items, int subtotalAmount, int discountAmount, int totalAmount, int? cashTendered, int changeAmount
});




}
/// @nodoc
class _$TransactionResponseCopyWithImpl<$Res>
    implements $TransactionResponseCopyWith<$Res> {
  _$TransactionResponseCopyWithImpl(this._self, this._then);

  final TransactionResponse _self;
  final $Res Function(TransactionResponse) _then;

/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? method = null,Object? createdAt = null,Object? items = null,Object? subtotalAmount = null,Object? discountAmount = null,Object? totalAmount = null,Object? cashTendered = freezed,Object? changeAmount = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptLineItem>,subtotalAmount: null == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,cashTendered: freezed == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int?,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionResponse].
extension TransactionResponsePatterns on TransactionResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionResponse value)  $default,){
final _that = this;
switch (_that) {
case _TransactionResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionResponse value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String method,  DateTime createdAt,  List<ReceiptLineItem> items,  int subtotalAmount,  int discountAmount,  int totalAmount,  int? cashTendered,  int changeAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
return $default(_that.id,_that.method,_that.createdAt,_that.items,_that.subtotalAmount,_that.discountAmount,_that.totalAmount,_that.cashTendered,_that.changeAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String method,  DateTime createdAt,  List<ReceiptLineItem> items,  int subtotalAmount,  int discountAmount,  int totalAmount,  int? cashTendered,  int changeAmount)  $default,) {final _that = this;
switch (_that) {
case _TransactionResponse():
return $default(_that.id,_that.method,_that.createdAt,_that.items,_that.subtotalAmount,_that.discountAmount,_that.totalAmount,_that.cashTendered,_that.changeAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String method,  DateTime createdAt,  List<ReceiptLineItem> items,  int subtotalAmount,  int discountAmount,  int totalAmount,  int? cashTendered,  int changeAmount)?  $default,) {final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
return $default(_that.id,_that.method,_that.createdAt,_that.items,_that.subtotalAmount,_that.discountAmount,_that.totalAmount,_that.cashTendered,_that.changeAmount);case _:
  return null;

}
}

}

/// @nodoc


class _TransactionResponse implements TransactionResponse {
  const _TransactionResponse({required this.id, required this.method, required this.createdAt, required final  List<ReceiptLineItem> items, required this.subtotalAmount, this.discountAmount = 0, required this.totalAmount, this.cashTendered, this.changeAmount = 0}): _items = items;
  

@override final  String id;
@override final  String method;
@override final  DateTime createdAt;
 final  List<ReceiptLineItem> _items;
@override List<ReceiptLineItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int subtotalAmount;
@override@JsonKey() final  int discountAmount;
@override final  int totalAmount;
@override final  int? cashTendered;
@override@JsonKey() final  int changeAmount;

/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionResponseCopyWith<_TransactionResponse> get copyWith => __$TransactionResponseCopyWithImpl<_TransactionResponse>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount));
}


@override
int get hashCode => Object.hash(runtimeType,id,method,createdAt,const DeepCollectionEquality().hash(_items),subtotalAmount,discountAmount,totalAmount,cashTendered,changeAmount);

@override
String toString() {
  return 'TransactionResponse(id: $id, method: $method, createdAt: $createdAt, items: $items, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, cashTendered: $cashTendered, changeAmount: $changeAmount)';
}


}

/// @nodoc
abstract mixin class _$TransactionResponseCopyWith<$Res> implements $TransactionResponseCopyWith<$Res> {
  factory _$TransactionResponseCopyWith(_TransactionResponse value, $Res Function(_TransactionResponse) _then) = __$TransactionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String method, DateTime createdAt, List<ReceiptLineItem> items, int subtotalAmount, int discountAmount, int totalAmount, int? cashTendered, int changeAmount
});




}
/// @nodoc
class __$TransactionResponseCopyWithImpl<$Res>
    implements _$TransactionResponseCopyWith<$Res> {
  __$TransactionResponseCopyWithImpl(this._self, this._then);

  final _TransactionResponse _self;
  final $Res Function(_TransactionResponse) _then;

/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? method = null,Object? createdAt = null,Object? items = null,Object? subtotalAmount = null,Object? discountAmount = null,Object? totalAmount = null,Object? cashTendered = freezed,Object? changeAmount = null,}) {
  return _then(_TransactionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptLineItem>,subtotalAmount: null == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,cashTendered: freezed == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int?,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
