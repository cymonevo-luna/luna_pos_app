// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CreateTransactionRequest {

 String get method; List<TransactionItemRequest> get items;@JsonKey(name: 'subtotal_amount') int get subtotalAmount;@JsonKey(name: 'discount_amount') int get discountAmount; int get amount;@JsonKey(name: 'cash_tendered') int? get cashTendered;@JsonKey(name: 'change_amount') int? get changeAmount;
/// Create a copy of CreateTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTransactionRequestCopyWith<CreateTransactionRequest> get copyWith => _$CreateTransactionRequestCopyWithImpl<CreateTransactionRequest>(this as CreateTransactionRequest, _$identity);

  /// Serializes this CreateTransactionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTransactionRequest&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,const DeepCollectionEquality().hash(items),subtotalAmount,discountAmount,amount,cashTendered,changeAmount);

@override
String toString() {
  return 'CreateTransactionRequest(method: $method, items: $items, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, amount: $amount, cashTendered: $cashTendered, changeAmount: $changeAmount)';
}


}

/// @nodoc
abstract mixin class $CreateTransactionRequestCopyWith<$Res>  {
  factory $CreateTransactionRequestCopyWith(CreateTransactionRequest value, $Res Function(CreateTransactionRequest) _then) = _$CreateTransactionRequestCopyWithImpl;
@useResult
$Res call({
 String method, List<TransactionItemRequest> items,@JsonKey(name: 'subtotal_amount') int subtotalAmount,@JsonKey(name: 'discount_amount') int discountAmount, int amount,@JsonKey(name: 'cash_tendered') int? cashTendered,@JsonKey(name: 'change_amount') int? changeAmount
});




}
/// @nodoc
class _$CreateTransactionRequestCopyWithImpl<$Res>
    implements $CreateTransactionRequestCopyWith<$Res> {
  _$CreateTransactionRequestCopyWithImpl(this._self, this._then);

  final CreateTransactionRequest _self;
  final $Res Function(CreateTransactionRequest) _then;

/// Create a copy of CreateTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? method = null,Object? items = null,Object? subtotalAmount = null,Object? discountAmount = null,Object? amount = null,Object? cashTendered = freezed,Object? changeAmount = freezed,}) {
  return _then(_self.copyWith(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItemRequest>,subtotalAmount: null == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,cashTendered: freezed == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int?,changeAmount: freezed == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [CreateTransactionRequest].
extension CreateTransactionRequestPatterns on CreateTransactionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CreateTransactionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CreateTransactionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CreateTransactionRequest value)  $default,){
final _that = this;
switch (_that) {
case _CreateTransactionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CreateTransactionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CreateTransactionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String method,  List<TransactionItemRequest> items, @JsonKey(name: 'subtotal_amount')  int subtotalAmount, @JsonKey(name: 'discount_amount')  int discountAmount,  int amount, @JsonKey(name: 'cash_tendered')  int? cashTendered, @JsonKey(name: 'change_amount')  int? changeAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CreateTransactionRequest() when $default != null:
return $default(_that.method,_that.items,_that.subtotalAmount,_that.discountAmount,_that.amount,_that.cashTendered,_that.changeAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String method,  List<TransactionItemRequest> items, @JsonKey(name: 'subtotal_amount')  int subtotalAmount, @JsonKey(name: 'discount_amount')  int discountAmount,  int amount, @JsonKey(name: 'cash_tendered')  int? cashTendered, @JsonKey(name: 'change_amount')  int? changeAmount)  $default,) {final _that = this;
switch (_that) {
case _CreateTransactionRequest():
return $default(_that.method,_that.items,_that.subtotalAmount,_that.discountAmount,_that.amount,_that.cashTendered,_that.changeAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String method,  List<TransactionItemRequest> items, @JsonKey(name: 'subtotal_amount')  int subtotalAmount, @JsonKey(name: 'discount_amount')  int discountAmount,  int amount, @JsonKey(name: 'cash_tendered')  int? cashTendered, @JsonKey(name: 'change_amount')  int? changeAmount)?  $default,) {final _that = this;
switch (_that) {
case _CreateTransactionRequest() when $default != null:
return $default(_that.method,_that.items,_that.subtotalAmount,_that.discountAmount,_that.amount,_that.cashTendered,_that.changeAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CreateTransactionRequest implements CreateTransactionRequest {
  const _CreateTransactionRequest({required this.method, required final  List<TransactionItemRequest> items, @JsonKey(name: 'subtotal_amount') required this.subtotalAmount, @JsonKey(name: 'discount_amount') this.discountAmount = 0, required this.amount, @JsonKey(name: 'cash_tendered') this.cashTendered, @JsonKey(name: 'change_amount') this.changeAmount}): _items = items;
  factory _CreateTransactionRequest.fromJson(Map<String, dynamic> json) => _$CreateTransactionRequestFromJson(json);

@override final  String method;
 final  List<TransactionItemRequest> _items;
@override List<TransactionItemRequest> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'subtotal_amount') final  int subtotalAmount;
@override@JsonKey(name: 'discount_amount') final  int discountAmount;
@override final  int amount;
@override@JsonKey(name: 'cash_tendered') final  int? cashTendered;
@override@JsonKey(name: 'change_amount') final  int? changeAmount;

/// Create a copy of CreateTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CreateTransactionRequestCopyWith<_CreateTransactionRequest> get copyWith => __$CreateTransactionRequestCopyWithImpl<_CreateTransactionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CreateTransactionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CreateTransactionRequest&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,method,const DeepCollectionEquality().hash(_items),subtotalAmount,discountAmount,amount,cashTendered,changeAmount);

@override
String toString() {
  return 'CreateTransactionRequest(method: $method, items: $items, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, amount: $amount, cashTendered: $cashTendered, changeAmount: $changeAmount)';
}


}

/// @nodoc
abstract mixin class _$CreateTransactionRequestCopyWith<$Res> implements $CreateTransactionRequestCopyWith<$Res> {
  factory _$CreateTransactionRequestCopyWith(_CreateTransactionRequest value, $Res Function(_CreateTransactionRequest) _then) = __$CreateTransactionRequestCopyWithImpl;
@override @useResult
$Res call({
 String method, List<TransactionItemRequest> items,@JsonKey(name: 'subtotal_amount') int subtotalAmount,@JsonKey(name: 'discount_amount') int discountAmount, int amount,@JsonKey(name: 'cash_tendered') int? cashTendered,@JsonKey(name: 'change_amount') int? changeAmount
});




}
/// @nodoc
class __$CreateTransactionRequestCopyWithImpl<$Res>
    implements _$CreateTransactionRequestCopyWith<$Res> {
  __$CreateTransactionRequestCopyWithImpl(this._self, this._then);

  final _CreateTransactionRequest _self;
  final $Res Function(_CreateTransactionRequest) _then;

/// Create a copy of CreateTransactionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? method = null,Object? items = null,Object? subtotalAmount = null,Object? discountAmount = null,Object? amount = null,Object? cashTendered = freezed,Object? changeAmount = freezed,}) {
  return _then(_CreateTransactionRequest(
method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItemRequest>,subtotalAmount: null == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,cashTendered: freezed == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int?,changeAmount: freezed == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$TransactionItemRequest {

@JsonKey(name: 'menu_id') String get menuId; String get title; int get quantity;@JsonKey(name: 'unit_price') int get unitPrice;@JsonKey(name: 'line_total') int get lineTotal; String? get note;
/// Create a copy of TransactionItemRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionItemRequestCopyWith<TransactionItemRequest> get copyWith => _$TransactionItemRequestCopyWithImpl<TransactionItemRequest>(this as TransactionItemRequest, _$identity);

  /// Serializes this TransactionItemRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionItemRequest&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.title, title) || other.title == title)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuId,title,quantity,unitPrice,lineTotal,note);

@override
String toString() {
  return 'TransactionItemRequest(menuId: $menuId, title: $title, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal, note: $note)';
}


}

/// @nodoc
abstract mixin class $TransactionItemRequestCopyWith<$Res>  {
  factory $TransactionItemRequestCopyWith(TransactionItemRequest value, $Res Function(TransactionItemRequest) _then) = _$TransactionItemRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'menu_id') String menuId, String title, int quantity,@JsonKey(name: 'unit_price') int unitPrice,@JsonKey(name: 'line_total') int lineTotal, String? note
});




}
/// @nodoc
class _$TransactionItemRequestCopyWithImpl<$Res>
    implements $TransactionItemRequestCopyWith<$Res> {
  _$TransactionItemRequestCopyWithImpl(this._self, this._then);

  final TransactionItemRequest _self;
  final $Res Function(TransactionItemRequest) _then;

/// Create a copy of TransactionItemRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? menuId = null,Object? title = null,Object? quantity = null,Object? unitPrice = null,Object? lineTotal = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionItemRequest].
extension TransactionItemRequestPatterns on TransactionItemRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionItemRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionItemRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionItemRequest value)  $default,){
final _that = this;
switch (_that) {
case _TransactionItemRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionItemRequest value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionItemRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'menu_id')  String menuId,  String title,  int quantity, @JsonKey(name: 'unit_price')  int unitPrice, @JsonKey(name: 'line_total')  int lineTotal,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionItemRequest() when $default != null:
return $default(_that.menuId,_that.title,_that.quantity,_that.unitPrice,_that.lineTotal,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'menu_id')  String menuId,  String title,  int quantity, @JsonKey(name: 'unit_price')  int unitPrice, @JsonKey(name: 'line_total')  int lineTotal,  String? note)  $default,) {final _that = this;
switch (_that) {
case _TransactionItemRequest():
return $default(_that.menuId,_that.title,_that.quantity,_that.unitPrice,_that.lineTotal,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'menu_id')  String menuId,  String title,  int quantity, @JsonKey(name: 'unit_price')  int unitPrice, @JsonKey(name: 'line_total')  int lineTotal,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _TransactionItemRequest() when $default != null:
return $default(_that.menuId,_that.title,_that.quantity,_that.unitPrice,_that.lineTotal,_that.note);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionItemRequest implements TransactionItemRequest {
  const _TransactionItemRequest({@JsonKey(name: 'menu_id') required this.menuId, required this.title, required this.quantity, @JsonKey(name: 'unit_price') required this.unitPrice, @JsonKey(name: 'line_total') required this.lineTotal, this.note});
  factory _TransactionItemRequest.fromJson(Map<String, dynamic> json) => _$TransactionItemRequestFromJson(json);

@override@JsonKey(name: 'menu_id') final  String menuId;
@override final  String title;
@override final  int quantity;
@override@JsonKey(name: 'unit_price') final  int unitPrice;
@override@JsonKey(name: 'line_total') final  int lineTotal;
@override final  String? note;

/// Create a copy of TransactionItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionItemRequestCopyWith<_TransactionItemRequest> get copyWith => __$TransactionItemRequestCopyWithImpl<_TransactionItemRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionItemRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionItemRequest&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.title, title) || other.title == title)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unitPrice, unitPrice) || other.unitPrice == unitPrice)&&(identical(other.lineTotal, lineTotal) || other.lineTotal == lineTotal)&&(identical(other.note, note) || other.note == note));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuId,title,quantity,unitPrice,lineTotal,note);

@override
String toString() {
  return 'TransactionItemRequest(menuId: $menuId, title: $title, quantity: $quantity, unitPrice: $unitPrice, lineTotal: $lineTotal, note: $note)';
}


}

/// @nodoc
abstract mixin class _$TransactionItemRequestCopyWith<$Res> implements $TransactionItemRequestCopyWith<$Res> {
  factory _$TransactionItemRequestCopyWith(_TransactionItemRequest value, $Res Function(_TransactionItemRequest) _then) = __$TransactionItemRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'menu_id') String menuId, String title, int quantity,@JsonKey(name: 'unit_price') int unitPrice,@JsonKey(name: 'line_total') int lineTotal, String? note
});




}
/// @nodoc
class __$TransactionItemRequestCopyWithImpl<$Res>
    implements _$TransactionItemRequestCopyWith<$Res> {
  __$TransactionItemRequestCopyWithImpl(this._self, this._then);

  final _TransactionItemRequest _self;
  final $Res Function(_TransactionItemRequest) _then;

/// Create a copy of TransactionItemRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? menuId = null,Object? title = null,Object? quantity = null,Object? unitPrice = null,Object? lineTotal = null,Object? note = freezed,}) {
  return _then(_TransactionItemRequest(
menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as int,unitPrice: null == unitPrice ? _self.unitPrice : unitPrice // ignore: cast_nullable_to_non_nullable
as int,lineTotal: null == lineTotal ? _self.lineTotal : lineTotal // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$TransactionResponse {

 String get id; String get method; int get amount;@JsonKey(name: 'subtotal_amount') int? get subtotalAmount;@JsonKey(name: 'discount_amount') int? get discountAmount;@JsonKey(name: 'cash_tendered') int? get cashTendered;@JsonKey(name: 'change_amount') int? get changeAmount;
/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionResponseCopyWith<TransactionResponse> get copyWith => _$TransactionResponseCopyWithImpl<TransactionResponse>(this as TransactionResponse, _$identity);

  /// Serializes this TransactionResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,method,amount,subtotalAmount,discountAmount,cashTendered,changeAmount);

@override
String toString() {
  return 'TransactionResponse(id: $id, method: $method, amount: $amount, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, cashTendered: $cashTendered, changeAmount: $changeAmount)';
}


}

/// @nodoc
abstract mixin class $TransactionResponseCopyWith<$Res>  {
  factory $TransactionResponseCopyWith(TransactionResponse value, $Res Function(TransactionResponse) _then) = _$TransactionResponseCopyWithImpl;
@useResult
$Res call({
 String id, String method, int amount,@JsonKey(name: 'subtotal_amount') int? subtotalAmount,@JsonKey(name: 'discount_amount') int? discountAmount,@JsonKey(name: 'cash_tendered') int? cashTendered,@JsonKey(name: 'change_amount') int? changeAmount
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? method = null,Object? amount = null,Object? subtotalAmount = freezed,Object? discountAmount = freezed,Object? cashTendered = freezed,Object? changeAmount = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,subtotalAmount: freezed == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int?,cashTendered: freezed == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int?,changeAmount: freezed == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String method,  int amount, @JsonKey(name: 'subtotal_amount')  int? subtotalAmount, @JsonKey(name: 'discount_amount')  int? discountAmount, @JsonKey(name: 'cash_tendered')  int? cashTendered, @JsonKey(name: 'change_amount')  int? changeAmount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
return $default(_that.id,_that.method,_that.amount,_that.subtotalAmount,_that.discountAmount,_that.cashTendered,_that.changeAmount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String method,  int amount, @JsonKey(name: 'subtotal_amount')  int? subtotalAmount, @JsonKey(name: 'discount_amount')  int? discountAmount, @JsonKey(name: 'cash_tendered')  int? cashTendered, @JsonKey(name: 'change_amount')  int? changeAmount)  $default,) {final _that = this;
switch (_that) {
case _TransactionResponse():
return $default(_that.id,_that.method,_that.amount,_that.subtotalAmount,_that.discountAmount,_that.cashTendered,_that.changeAmount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String method,  int amount, @JsonKey(name: 'subtotal_amount')  int? subtotalAmount, @JsonKey(name: 'discount_amount')  int? discountAmount, @JsonKey(name: 'cash_tendered')  int? cashTendered, @JsonKey(name: 'change_amount')  int? changeAmount)?  $default,) {final _that = this;
switch (_that) {
case _TransactionResponse() when $default != null:
return $default(_that.id,_that.method,_that.amount,_that.subtotalAmount,_that.discountAmount,_that.cashTendered,_that.changeAmount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionResponse implements TransactionResponse {
  const _TransactionResponse({required this.id, required this.method, required this.amount, @JsonKey(name: 'subtotal_amount') this.subtotalAmount, @JsonKey(name: 'discount_amount') this.discountAmount, @JsonKey(name: 'cash_tendered') this.cashTendered, @JsonKey(name: 'change_amount') this.changeAmount});
  factory _TransactionResponse.fromJson(Map<String, dynamic> json) => _$TransactionResponseFromJson(json);

@override final  String id;
@override final  String method;
@override final  int amount;
@override@JsonKey(name: 'subtotal_amount') final  int? subtotalAmount;
@override@JsonKey(name: 'discount_amount') final  int? discountAmount;
@override@JsonKey(name: 'cash_tendered') final  int? cashTendered;
@override@JsonKey(name: 'change_amount') final  int? changeAmount;

/// Create a copy of TransactionResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionResponseCopyWith<_TransactionResponse> get copyWith => __$TransactionResponseCopyWithImpl<_TransactionResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,method,amount,subtotalAmount,discountAmount,cashTendered,changeAmount);

@override
String toString() {
  return 'TransactionResponse(id: $id, method: $method, amount: $amount, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, cashTendered: $cashTendered, changeAmount: $changeAmount)';
}


}

/// @nodoc
abstract mixin class _$TransactionResponseCopyWith<$Res> implements $TransactionResponseCopyWith<$Res> {
  factory _$TransactionResponseCopyWith(_TransactionResponse value, $Res Function(_TransactionResponse) _then) = __$TransactionResponseCopyWithImpl;
@override @useResult
$Res call({
 String id, String method, int amount,@JsonKey(name: 'subtotal_amount') int? subtotalAmount,@JsonKey(name: 'discount_amount') int? discountAmount,@JsonKey(name: 'cash_tendered') int? cashTendered,@JsonKey(name: 'change_amount') int? changeAmount
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? method = null,Object? amount = null,Object? subtotalAmount = freezed,Object? discountAmount = freezed,Object? cashTendered = freezed,Object? changeAmount = freezed,}) {
  return _then(_TransactionResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,subtotalAmount: freezed == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int?,discountAmount: freezed == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int?,cashTendered: freezed == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int?,changeAmount: freezed == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$TransactionListItem {

 String get id; String get method; int get amount;@JsonKey(name: 'cashier_username') String? get cashierUsername;@JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) DateTime? get transactionDate;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;
/// Create a copy of TransactionListItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionListItemCopyWith<TransactionListItem> get copyWith => _$TransactionListItemCopyWithImpl<TransactionListItem>(this as TransactionListItem, _$identity);

  /// Serializes this TransactionListItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.cashierUsername, cashierUsername) || other.cashierUsername == cashierUsername)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,method,amount,cashierUsername,transactionDate,createdAt);

@override
String toString() {
  return 'TransactionListItem(id: $id, method: $method, amount: $amount, cashierUsername: $cashierUsername, transactionDate: $transactionDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TransactionListItemCopyWith<$Res>  {
  factory $TransactionListItemCopyWith(TransactionListItem value, $Res Function(TransactionListItem) _then) = _$TransactionListItemCopyWithImpl;
@useResult
$Res call({
 String id, String method, int amount,@JsonKey(name: 'cashier_username') String? cashierUsername,@JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) DateTime? transactionDate,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$TransactionListItemCopyWithImpl<$Res>
    implements $TransactionListItemCopyWith<$Res> {
  _$TransactionListItemCopyWithImpl(this._self, this._then);

  final TransactionListItem _self;
  final $Res Function(TransactionListItem) _then;

/// Create a copy of TransactionListItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? method = null,Object? amount = null,Object? cashierUsername = freezed,Object? transactionDate = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,cashierUsername: freezed == cashierUsername ? _self.cashierUsername : cashierUsername // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionListItem].
extension TransactionListItemPatterns on TransactionListItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionListItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionListItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionListItem value)  $default,){
final _that = this;
switch (_that) {
case _TransactionListItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionListItem value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionListItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String method,  int amount, @JsonKey(name: 'cashier_username')  String? cashierUsername, @JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson)  DateTime? transactionDate, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionListItem() when $default != null:
return $default(_that.id,_that.method,_that.amount,_that.cashierUsername,_that.transactionDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String method,  int amount, @JsonKey(name: 'cashier_username')  String? cashierUsername, @JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson)  DateTime? transactionDate, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TransactionListItem():
return $default(_that.id,_that.method,_that.amount,_that.cashierUsername,_that.transactionDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String method,  int amount, @JsonKey(name: 'cashier_username')  String? cashierUsername, @JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson)  DateTime? transactionDate, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TransactionListItem() when $default != null:
return $default(_that.id,_that.method,_that.amount,_that.cashierUsername,_that.transactionDate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionListItem implements TransactionListItem {
  const _TransactionListItem({required this.id, required this.method, required this.amount, @JsonKey(name: 'cashier_username') this.cashierUsername, @JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) this.transactionDate, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt});
  factory _TransactionListItem.fromJson(Map<String, dynamic> json) => _$TransactionListItemFromJson(json);

@override final  String id;
@override final  String method;
@override final  int amount;
@override@JsonKey(name: 'cashier_username') final  String? cashierUsername;
@override@JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) final  DateTime? transactionDate;
@override@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of TransactionListItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionListItemCopyWith<_TransactionListItem> get copyWith => __$TransactionListItemCopyWithImpl<_TransactionListItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionListItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionListItem&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.cashierUsername, cashierUsername) || other.cashierUsername == cashierUsername)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,method,amount,cashierUsername,transactionDate,createdAt);

@override
String toString() {
  return 'TransactionListItem(id: $id, method: $method, amount: $amount, cashierUsername: $cashierUsername, transactionDate: $transactionDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionListItemCopyWith<$Res> implements $TransactionListItemCopyWith<$Res> {
  factory _$TransactionListItemCopyWith(_TransactionListItem value, $Res Function(_TransactionListItem) _then) = __$TransactionListItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String method, int amount,@JsonKey(name: 'cashier_username') String? cashierUsername,@JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) DateTime? transactionDate,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$TransactionListItemCopyWithImpl<$Res>
    implements _$TransactionListItemCopyWith<$Res> {
  __$TransactionListItemCopyWithImpl(this._self, this._then);

  final _TransactionListItem _self;
  final $Res Function(_TransactionListItem) _then;

/// Create a copy of TransactionListItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? method = null,Object? amount = null,Object? cashierUsername = freezed,Object? transactionDate = freezed,Object? createdAt = freezed,}) {
  return _then(_TransactionListItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,cashierUsername: freezed == cashierUsername ? _self.cashierUsername : cashierUsername // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$TransactionDetail {

 String get id; String get method; List<TransactionItemRequest> get items;@JsonKey(name: 'subtotal_amount') int get subtotalAmount;@JsonKey(name: 'discount_amount') int get discountAmount; int get amount;@JsonKey(name: 'cash_tendered') int? get cashTendered;@JsonKey(name: 'change_amount') int get changeAmount;@JsonKey(name: 'cashier_username') String? get cashierUsername;@JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) DateTime? get transactionDate;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;
/// Create a copy of TransactionDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionDetailCopyWith<TransactionDetail> get copyWith => _$TransactionDetailCopyWithImpl<TransactionDetail>(this as TransactionDetail, _$identity);

  /// Serializes this TransactionDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount)&&(identical(other.cashierUsername, cashierUsername) || other.cashierUsername == cashierUsername)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,method,const DeepCollectionEquality().hash(items),subtotalAmount,discountAmount,amount,cashTendered,changeAmount,cashierUsername,transactionDate,createdAt);

@override
String toString() {
  return 'TransactionDetail(id: $id, method: $method, items: $items, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, amount: $amount, cashTendered: $cashTendered, changeAmount: $changeAmount, cashierUsername: $cashierUsername, transactionDate: $transactionDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $TransactionDetailCopyWith<$Res>  {
  factory $TransactionDetailCopyWith(TransactionDetail value, $Res Function(TransactionDetail) _then) = _$TransactionDetailCopyWithImpl;
@useResult
$Res call({
 String id, String method, List<TransactionItemRequest> items,@JsonKey(name: 'subtotal_amount') int subtotalAmount,@JsonKey(name: 'discount_amount') int discountAmount, int amount,@JsonKey(name: 'cash_tendered') int? cashTendered,@JsonKey(name: 'change_amount') int changeAmount,@JsonKey(name: 'cashier_username') String? cashierUsername,@JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) DateTime? transactionDate,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class _$TransactionDetailCopyWithImpl<$Res>
    implements $TransactionDetailCopyWith<$Res> {
  _$TransactionDetailCopyWithImpl(this._self, this._then);

  final TransactionDetail _self;
  final $Res Function(TransactionDetail) _then;

/// Create a copy of TransactionDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? method = null,Object? items = null,Object? subtotalAmount = null,Object? discountAmount = null,Object? amount = null,Object? cashTendered = freezed,Object? changeAmount = null,Object? cashierUsername = freezed,Object? transactionDate = freezed,Object? createdAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItemRequest>,subtotalAmount: null == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,cashTendered: freezed == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int?,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int,cashierUsername: freezed == cashierUsername ? _self.cashierUsername : cashierUsername // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransactionDetail].
extension TransactionDetailPatterns on TransactionDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransactionDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransactionDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransactionDetail value)  $default,){
final _that = this;
switch (_that) {
case _TransactionDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransactionDetail value)?  $default,){
final _that = this;
switch (_that) {
case _TransactionDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String method,  List<TransactionItemRequest> items, @JsonKey(name: 'subtotal_amount')  int subtotalAmount, @JsonKey(name: 'discount_amount')  int discountAmount,  int amount, @JsonKey(name: 'cash_tendered')  int? cashTendered, @JsonKey(name: 'change_amount')  int changeAmount, @JsonKey(name: 'cashier_username')  String? cashierUsername, @JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson)  DateTime? transactionDate, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransactionDetail() when $default != null:
return $default(_that.id,_that.method,_that.items,_that.subtotalAmount,_that.discountAmount,_that.amount,_that.cashTendered,_that.changeAmount,_that.cashierUsername,_that.transactionDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String method,  List<TransactionItemRequest> items, @JsonKey(name: 'subtotal_amount')  int subtotalAmount, @JsonKey(name: 'discount_amount')  int discountAmount,  int amount, @JsonKey(name: 'cash_tendered')  int? cashTendered, @JsonKey(name: 'change_amount')  int changeAmount, @JsonKey(name: 'cashier_username')  String? cashierUsername, @JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson)  DateTime? transactionDate, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)  $default,) {final _that = this;
switch (_that) {
case _TransactionDetail():
return $default(_that.id,_that.method,_that.items,_that.subtotalAmount,_that.discountAmount,_that.amount,_that.cashTendered,_that.changeAmount,_that.cashierUsername,_that.transactionDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String method,  List<TransactionItemRequest> items, @JsonKey(name: 'subtotal_amount')  int subtotalAmount, @JsonKey(name: 'discount_amount')  int discountAmount,  int amount, @JsonKey(name: 'cash_tendered')  int? cashTendered, @JsonKey(name: 'change_amount')  int changeAmount, @JsonKey(name: 'cashier_username')  String? cashierUsername, @JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson)  DateTime? transactionDate, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt)?  $default,) {final _that = this;
switch (_that) {
case _TransactionDetail() when $default != null:
return $default(_that.id,_that.method,_that.items,_that.subtotalAmount,_that.discountAmount,_that.amount,_that.cashTendered,_that.changeAmount,_that.cashierUsername,_that.transactionDate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TransactionDetail implements TransactionDetail {
  const _TransactionDetail({required this.id, required this.method, required final  List<TransactionItemRequest> items, @JsonKey(name: 'subtotal_amount') required this.subtotalAmount, @JsonKey(name: 'discount_amount') this.discountAmount = 0, required this.amount, @JsonKey(name: 'cash_tendered') this.cashTendered, @JsonKey(name: 'change_amount') this.changeAmount = 0, @JsonKey(name: 'cashier_username') this.cashierUsername, @JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) this.transactionDate, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt}): _items = items;
  factory _TransactionDetail.fromJson(Map<String, dynamic> json) => _$TransactionDetailFromJson(json);

@override final  String id;
@override final  String method;
 final  List<TransactionItemRequest> _items;
@override List<TransactionItemRequest> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'subtotal_amount') final  int subtotalAmount;
@override@JsonKey(name: 'discount_amount') final  int discountAmount;
@override final  int amount;
@override@JsonKey(name: 'cash_tendered') final  int? cashTendered;
@override@JsonKey(name: 'change_amount') final  int changeAmount;
@override@JsonKey(name: 'cashier_username') final  String? cashierUsername;
@override@JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) final  DateTime? transactionDate;
@override@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) final  DateTime? createdAt;

/// Create a copy of TransactionDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransactionDetailCopyWith<_TransactionDetail> get copyWith => __$TransactionDetailCopyWithImpl<_TransactionDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TransactionDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransactionDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.method, method) || other.method == method)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount)&&(identical(other.cashierUsername, cashierUsername) || other.cashierUsername == cashierUsername)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,method,const DeepCollectionEquality().hash(_items),subtotalAmount,discountAmount,amount,cashTendered,changeAmount,cashierUsername,transactionDate,createdAt);

@override
String toString() {
  return 'TransactionDetail(id: $id, method: $method, items: $items, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, amount: $amount, cashTendered: $cashTendered, changeAmount: $changeAmount, cashierUsername: $cashierUsername, transactionDate: $transactionDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$TransactionDetailCopyWith<$Res> implements $TransactionDetailCopyWith<$Res> {
  factory _$TransactionDetailCopyWith(_TransactionDetail value, $Res Function(_TransactionDetail) _then) = __$TransactionDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String method, List<TransactionItemRequest> items,@JsonKey(name: 'subtotal_amount') int subtotalAmount,@JsonKey(name: 'discount_amount') int discountAmount, int amount,@JsonKey(name: 'cash_tendered') int? cashTendered,@JsonKey(name: 'change_amount') int changeAmount,@JsonKey(name: 'cashier_username') String? cashierUsername,@JsonKey(name: 'transaction_date', fromJson: _nullableDateTimeFromJson) DateTime? transactionDate,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt
});




}
/// @nodoc
class __$TransactionDetailCopyWithImpl<$Res>
    implements _$TransactionDetailCopyWith<$Res> {
  __$TransactionDetailCopyWithImpl(this._self, this._then);

  final _TransactionDetail _self;
  final $Res Function(_TransactionDetail) _then;

/// Create a copy of TransactionDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? method = null,Object? items = null,Object? subtotalAmount = null,Object? discountAmount = null,Object? amount = null,Object? cashTendered = freezed,Object? changeAmount = null,Object? cashierUsername = freezed,Object? transactionDate = freezed,Object? createdAt = freezed,}) {
  return _then(_TransactionDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,method: null == method ? _self.method : method // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<TransactionItemRequest>,subtotalAmount: null == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,cashTendered: freezed == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int?,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int,cashierUsername: freezed == cashierUsername ? _self.cashierUsername : cashierUsername // ignore: cast_nullable_to_non_nullable
as String?,transactionDate: freezed == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
