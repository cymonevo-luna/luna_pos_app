// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cashier_balance.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$CashierBalance {

@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int get balance;@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of CashierBalance
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashierBalanceCopyWith<CashierBalance> get copyWith => _$CashierBalanceCopyWithImpl<CashierBalance>(this as CashierBalance, _$identity);

  /// Serializes this CashierBalance to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashierBalance&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,updatedAt);

@override
String toString() {
  return 'CashierBalance(balance: $balance, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $CashierBalanceCopyWith<$Res>  {
  factory $CashierBalanceCopyWith(CashierBalance value, $Res Function(CashierBalance) _then) = _$CashierBalanceCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int balance,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$CashierBalanceCopyWithImpl<$Res>
    implements $CashierBalanceCopyWith<$Res> {
  _$CashierBalanceCopyWithImpl(this._self, this._then);

  final CashierBalance _self;
  final $Res Function(CashierBalance) _then;

/// Create a copy of CashierBalance
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [CashierBalance].
extension CashierBalancePatterns on CashierBalance {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashierBalance value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashierBalance() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashierBalance value)  $default,){
final _that = this;
switch (_that) {
case _CashierBalance():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashierBalance value)?  $default,){
final _that = this;
switch (_that) {
case _CashierBalance() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int balance, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashierBalance() when $default != null:
return $default(_that.balance,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int balance, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _CashierBalance():
return $default(_that.balance,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int balance, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _CashierBalance() when $default != null:
return $default(_that.balance,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashierBalance implements CashierBalance {
  const _CashierBalance({@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) required this.balance, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) this.updatedAt});
  factory _CashierBalance.fromJson(Map<String, dynamic> json) => _$CashierBalanceFromJson(json);

@override@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) final  int balance;
@override@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of CashierBalance
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashierBalanceCopyWith<_CashierBalance> get copyWith => __$CashierBalanceCopyWithImpl<_CashierBalance>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashierBalanceToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashierBalance&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,updatedAt);

@override
String toString() {
  return 'CashierBalance(balance: $balance, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$CashierBalanceCopyWith<$Res> implements $CashierBalanceCopyWith<$Res> {
  factory _$CashierBalanceCopyWith(_CashierBalance value, $Res Function(_CashierBalance) _then) = __$CashierBalanceCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int balance,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$CashierBalanceCopyWithImpl<$Res>
    implements _$CashierBalanceCopyWith<$Res> {
  __$CashierBalanceCopyWithImpl(this._self, this._then);

  final _CashierBalance _self;
  final $Res Function(_CashierBalance) _then;

/// Create a copy of CashierBalance
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? updatedAt = freezed,}) {
  return _then(_CashierBalance(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as int,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$CashierBalanceEntry {

 String get id;@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int get amount; String get purpose;@JsonKey(name: 'requested_by_user_id') String? get requestedByUserId;@JsonKey(name: 'requested_by_username') String? get requestedByUsername; String? get source;@JsonKey(name: 'transaction_id') String? get transactionId; CashierBalanceEntryType? get type;@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime get createdAt;
/// Create a copy of CashierBalanceEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashierBalanceEntryCopyWith<CashierBalanceEntry> get copyWith => _$CashierBalanceEntryCopyWithImpl<CashierBalanceEntry>(this as CashierBalanceEntry, _$identity);

  /// Serializes this CashierBalanceEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashierBalanceEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.requestedByUserId, requestedByUserId) || other.requestedByUserId == requestedByUserId)&&(identical(other.requestedByUsername, requestedByUsername) || other.requestedByUsername == requestedByUsername)&&(identical(other.source, source) || other.source == source)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,purpose,requestedByUserId,requestedByUsername,source,transactionId,type,createdAt);

@override
String toString() {
  return 'CashierBalanceEntry(id: $id, amount: $amount, purpose: $purpose, requestedByUserId: $requestedByUserId, requestedByUsername: $requestedByUsername, source: $source, transactionId: $transactionId, type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $CashierBalanceEntryCopyWith<$Res>  {
  factory $CashierBalanceEntryCopyWith(CashierBalanceEntry value, $Res Function(CashierBalanceEntry) _then) = _$CashierBalanceEntryCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount, String purpose,@JsonKey(name: 'requested_by_user_id') String? requestedByUserId,@JsonKey(name: 'requested_by_username') String? requestedByUsername, String? source,@JsonKey(name: 'transaction_id') String? transactionId, CashierBalanceEntryType? type,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime createdAt
});




}
/// @nodoc
class _$CashierBalanceEntryCopyWithImpl<$Res>
    implements $CashierBalanceEntryCopyWith<$Res> {
  _$CashierBalanceEntryCopyWithImpl(this._self, this._then);

  final CashierBalanceEntry _self;
  final $Res Function(CashierBalanceEntry) _then;

/// Create a copy of CashierBalanceEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? amount = null,Object? purpose = null,Object? requestedByUserId = freezed,Object? requestedByUsername = freezed,Object? source = freezed,Object? transactionId = freezed,Object? type = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,requestedByUserId: freezed == requestedByUserId ? _self.requestedByUserId : requestedByUserId // ignore: cast_nullable_to_non_nullable
as String?,requestedByUsername: freezed == requestedByUsername ? _self.requestedByUsername : requestedByUsername // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CashierBalanceEntryType?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [CashierBalanceEntry].
extension CashierBalanceEntryPatterns on CashierBalanceEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashierBalanceEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashierBalanceEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashierBalanceEntry value)  $default,){
final _that = this;
switch (_that) {
case _CashierBalanceEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashierBalanceEntry value)?  $default,){
final _that = this;
switch (_that) {
case _CashierBalanceEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  String purpose, @JsonKey(name: 'requested_by_user_id')  String? requestedByUserId, @JsonKey(name: 'requested_by_username')  String? requestedByUsername,  String? source, @JsonKey(name: 'transaction_id')  String? transactionId,  CashierBalanceEntryType? type, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashierBalanceEntry() when $default != null:
return $default(_that.id,_that.amount,_that.purpose,_that.requestedByUserId,_that.requestedByUsername,_that.source,_that.transactionId,_that.type,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  String purpose, @JsonKey(name: 'requested_by_user_id')  String? requestedByUserId, @JsonKey(name: 'requested_by_username')  String? requestedByUsername,  String? source, @JsonKey(name: 'transaction_id')  String? transactionId,  CashierBalanceEntryType? type, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _CashierBalanceEntry():
return $default(_that.id,_that.amount,_that.purpose,_that.requestedByUserId,_that.requestedByUsername,_that.source,_that.transactionId,_that.type,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  String purpose, @JsonKey(name: 'requested_by_user_id')  String? requestedByUserId, @JsonKey(name: 'requested_by_username')  String? requestedByUsername,  String? source, @JsonKey(name: 'transaction_id')  String? transactionId,  CashierBalanceEntryType? type, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson)  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _CashierBalanceEntry() when $default != null:
return $default(_that.id,_that.amount,_that.purpose,_that.requestedByUserId,_that.requestedByUsername,_that.source,_that.transactionId,_that.type,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashierBalanceEntry extends CashierBalanceEntry {
  const _CashierBalanceEntry({required this.id, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) required this.amount, required this.purpose, @JsonKey(name: 'requested_by_user_id') this.requestedByUserId, @JsonKey(name: 'requested_by_username') this.requestedByUsername, this.source, @JsonKey(name: 'transaction_id') this.transactionId, this.type, @JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) required this.createdAt}): super._();
  factory _CashierBalanceEntry.fromJson(Map<String, dynamic> json) => _$CashierBalanceEntryFromJson(json);

@override final  String id;
@override@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) final  int amount;
@override final  String purpose;
@override@JsonKey(name: 'requested_by_user_id') final  String? requestedByUserId;
@override@JsonKey(name: 'requested_by_username') final  String? requestedByUsername;
@override final  String? source;
@override@JsonKey(name: 'transaction_id') final  String? transactionId;
@override final  CashierBalanceEntryType? type;
@override@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) final  DateTime createdAt;

/// Create a copy of CashierBalanceEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashierBalanceEntryCopyWith<_CashierBalanceEntry> get copyWith => __$CashierBalanceEntryCopyWithImpl<_CashierBalanceEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashierBalanceEntryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashierBalanceEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.requestedByUserId, requestedByUserId) || other.requestedByUserId == requestedByUserId)&&(identical(other.requestedByUsername, requestedByUsername) || other.requestedByUsername == requestedByUsername)&&(identical(other.source, source) || other.source == source)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.type, type) || other.type == type)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,amount,purpose,requestedByUserId,requestedByUsername,source,transactionId,type,createdAt);

@override
String toString() {
  return 'CashierBalanceEntry(id: $id, amount: $amount, purpose: $purpose, requestedByUserId: $requestedByUserId, requestedByUsername: $requestedByUsername, source: $source, transactionId: $transactionId, type: $type, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$CashierBalanceEntryCopyWith<$Res> implements $CashierBalanceEntryCopyWith<$Res> {
  factory _$CashierBalanceEntryCopyWith(_CashierBalanceEntry value, $Res Function(_CashierBalanceEntry) _then) = __$CashierBalanceEntryCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount, String purpose,@JsonKey(name: 'requested_by_user_id') String? requestedByUserId,@JsonKey(name: 'requested_by_username') String? requestedByUsername, String? source,@JsonKey(name: 'transaction_id') String? transactionId, CashierBalanceEntryType? type,@JsonKey(name: 'created_at', fromJson: _dateTimeFromJson) DateTime createdAt
});




}
/// @nodoc
class __$CashierBalanceEntryCopyWithImpl<$Res>
    implements _$CashierBalanceEntryCopyWith<$Res> {
  __$CashierBalanceEntryCopyWithImpl(this._self, this._then);

  final _CashierBalanceEntry _self;
  final $Res Function(_CashierBalanceEntry) _then;

/// Create a copy of CashierBalanceEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? amount = null,Object? purpose = null,Object? requestedByUserId = freezed,Object? requestedByUsername = freezed,Object? source = freezed,Object? transactionId = freezed,Object? type = freezed,Object? createdAt = null,}) {
  return _then(_CashierBalanceEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,requestedByUserId: freezed == requestedByUserId ? _self.requestedByUserId : requestedByUserId // ignore: cast_nullable_to_non_nullable
as String?,requestedByUsername: freezed == requestedByUsername ? _self.requestedByUsername : requestedByUsername // ignore: cast_nullable_to_non_nullable
as String?,source: freezed == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String?,transactionId: freezed == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CashierBalanceEntryType?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$CashierBalanceAdjustmentRequest {

@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int get amount; String get purpose; CashierBalanceAdjustmentType get type;
/// Create a copy of CashierBalanceAdjustmentRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashierBalanceAdjustmentRequestCopyWith<CashierBalanceAdjustmentRequest> get copyWith => _$CashierBalanceAdjustmentRequestCopyWithImpl<CashierBalanceAdjustmentRequest>(this as CashierBalanceAdjustmentRequest, _$identity);

  /// Serializes this CashierBalanceAdjustmentRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashierBalanceAdjustmentRequest&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,purpose,type);

@override
String toString() {
  return 'CashierBalanceAdjustmentRequest(amount: $amount, purpose: $purpose, type: $type)';
}


}

/// @nodoc
abstract mixin class $CashierBalanceAdjustmentRequestCopyWith<$Res>  {
  factory $CashierBalanceAdjustmentRequestCopyWith(CashierBalanceAdjustmentRequest value, $Res Function(CashierBalanceAdjustmentRequest) _then) = _$CashierBalanceAdjustmentRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount, String purpose, CashierBalanceAdjustmentType type
});




}
/// @nodoc
class _$CashierBalanceAdjustmentRequestCopyWithImpl<$Res>
    implements $CashierBalanceAdjustmentRequestCopyWith<$Res> {
  _$CashierBalanceAdjustmentRequestCopyWithImpl(this._self, this._then);

  final CashierBalanceAdjustmentRequest _self;
  final $Res Function(CashierBalanceAdjustmentRequest) _then;

/// Create a copy of CashierBalanceAdjustmentRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? purpose = null,Object? type = null,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CashierBalanceAdjustmentType,
  ));
}

}


/// Adds pattern-matching-related methods to [CashierBalanceAdjustmentRequest].
extension CashierBalanceAdjustmentRequestPatterns on CashierBalanceAdjustmentRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashierBalanceAdjustmentRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashierBalanceAdjustmentRequest value)  $default,){
final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashierBalanceAdjustmentRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  String purpose,  CashierBalanceAdjustmentType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentRequest() when $default != null:
return $default(_that.amount,_that.purpose,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  String purpose,  CashierBalanceAdjustmentType type)  $default,) {final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentRequest():
return $default(_that.amount,_that.purpose,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  String purpose,  CashierBalanceAdjustmentType type)?  $default,) {final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentRequest() when $default != null:
return $default(_that.amount,_that.purpose,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashierBalanceAdjustmentRequest implements CashierBalanceAdjustmentRequest {
  const _CashierBalanceAdjustmentRequest({@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) required this.amount, required this.purpose, required this.type});
  factory _CashierBalanceAdjustmentRequest.fromJson(Map<String, dynamic> json) => _$CashierBalanceAdjustmentRequestFromJson(json);

@override@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) final  int amount;
@override final  String purpose;
@override final  CashierBalanceAdjustmentType type;

/// Create a copy of CashierBalanceAdjustmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashierBalanceAdjustmentRequestCopyWith<_CashierBalanceAdjustmentRequest> get copyWith => __$CashierBalanceAdjustmentRequestCopyWithImpl<_CashierBalanceAdjustmentRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashierBalanceAdjustmentRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashierBalanceAdjustmentRequest&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.purpose, purpose) || other.purpose == purpose)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,amount,purpose,type);

@override
String toString() {
  return 'CashierBalanceAdjustmentRequest(amount: $amount, purpose: $purpose, type: $type)';
}


}

/// @nodoc
abstract mixin class _$CashierBalanceAdjustmentRequestCopyWith<$Res> implements $CashierBalanceAdjustmentRequestCopyWith<$Res> {
  factory _$CashierBalanceAdjustmentRequestCopyWith(_CashierBalanceAdjustmentRequest value, $Res Function(_CashierBalanceAdjustmentRequest) _then) = __$CashierBalanceAdjustmentRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount, String purpose, CashierBalanceAdjustmentType type
});




}
/// @nodoc
class __$CashierBalanceAdjustmentRequestCopyWithImpl<$Res>
    implements _$CashierBalanceAdjustmentRequestCopyWith<$Res> {
  __$CashierBalanceAdjustmentRequestCopyWithImpl(this._self, this._then);

  final _CashierBalanceAdjustmentRequest _self;
  final $Res Function(_CashierBalanceAdjustmentRequest) _then;

/// Create a copy of CashierBalanceAdjustmentRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? purpose = null,Object? type = null,}) {
  return _then(_CashierBalanceAdjustmentRequest(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,purpose: null == purpose ? _self.purpose : purpose // ignore: cast_nullable_to_non_nullable
as String,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CashierBalanceAdjustmentType,
  ));
}


}


/// @nodoc
mixin _$CashierBalanceAdjustmentResponse {

 CashierBalance get balance; CashierBalanceEntry get entry;
/// Create a copy of CashierBalanceAdjustmentResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CashierBalanceAdjustmentResponseCopyWith<CashierBalanceAdjustmentResponse> get copyWith => _$CashierBalanceAdjustmentResponseCopyWithImpl<CashierBalanceAdjustmentResponse>(this as CashierBalanceAdjustmentResponse, _$identity);

  /// Serializes this CashierBalanceAdjustmentResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CashierBalanceAdjustmentResponse&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.entry, entry) || other.entry == entry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,entry);

@override
String toString() {
  return 'CashierBalanceAdjustmentResponse(balance: $balance, entry: $entry)';
}


}

/// @nodoc
abstract mixin class $CashierBalanceAdjustmentResponseCopyWith<$Res>  {
  factory $CashierBalanceAdjustmentResponseCopyWith(CashierBalanceAdjustmentResponse value, $Res Function(CashierBalanceAdjustmentResponse) _then) = _$CashierBalanceAdjustmentResponseCopyWithImpl;
@useResult
$Res call({
 CashierBalance balance, CashierBalanceEntry entry
});


$CashierBalanceCopyWith<$Res> get balance;$CashierBalanceEntryCopyWith<$Res> get entry;

}
/// @nodoc
class _$CashierBalanceAdjustmentResponseCopyWithImpl<$Res>
    implements $CashierBalanceAdjustmentResponseCopyWith<$Res> {
  _$CashierBalanceAdjustmentResponseCopyWithImpl(this._self, this._then);

  final CashierBalanceAdjustmentResponse _self;
  final $Res Function(CashierBalanceAdjustmentResponse) _then;

/// Create a copy of CashierBalanceAdjustmentResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? balance = null,Object? entry = null,}) {
  return _then(_self.copyWith(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as CashierBalance,entry: null == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as CashierBalanceEntry,
  ));
}
/// Create a copy of CashierBalanceAdjustmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashierBalanceCopyWith<$Res> get balance {
  
  return $CashierBalanceCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}/// Create a copy of CashierBalanceAdjustmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashierBalanceEntryCopyWith<$Res> get entry {
  
  return $CashierBalanceEntryCopyWith<$Res>(_self.entry, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}


/// Adds pattern-matching-related methods to [CashierBalanceAdjustmentResponse].
extension CashierBalanceAdjustmentResponsePatterns on CashierBalanceAdjustmentResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CashierBalanceAdjustmentResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CashierBalanceAdjustmentResponse value)  $default,){
final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CashierBalanceAdjustmentResponse value)?  $default,){
final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CashierBalance balance,  CashierBalanceEntry entry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentResponse() when $default != null:
return $default(_that.balance,_that.entry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CashierBalance balance,  CashierBalanceEntry entry)  $default,) {final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentResponse():
return $default(_that.balance,_that.entry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CashierBalance balance,  CashierBalanceEntry entry)?  $default,) {final _that = this;
switch (_that) {
case _CashierBalanceAdjustmentResponse() when $default != null:
return $default(_that.balance,_that.entry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CashierBalanceAdjustmentResponse implements CashierBalanceAdjustmentResponse {
  const _CashierBalanceAdjustmentResponse({required this.balance, required this.entry});
  factory _CashierBalanceAdjustmentResponse.fromJson(Map<String, dynamic> json) => _$CashierBalanceAdjustmentResponseFromJson(json);

@override final  CashierBalance balance;
@override final  CashierBalanceEntry entry;

/// Create a copy of CashierBalanceAdjustmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CashierBalanceAdjustmentResponseCopyWith<_CashierBalanceAdjustmentResponse> get copyWith => __$CashierBalanceAdjustmentResponseCopyWithImpl<_CashierBalanceAdjustmentResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CashierBalanceAdjustmentResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CashierBalanceAdjustmentResponse&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.entry, entry) || other.entry == entry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,balance,entry);

@override
String toString() {
  return 'CashierBalanceAdjustmentResponse(balance: $balance, entry: $entry)';
}


}

/// @nodoc
abstract mixin class _$CashierBalanceAdjustmentResponseCopyWith<$Res> implements $CashierBalanceAdjustmentResponseCopyWith<$Res> {
  factory _$CashierBalanceAdjustmentResponseCopyWith(_CashierBalanceAdjustmentResponse value, $Res Function(_CashierBalanceAdjustmentResponse) _then) = __$CashierBalanceAdjustmentResponseCopyWithImpl;
@override @useResult
$Res call({
 CashierBalance balance, CashierBalanceEntry entry
});


@override $CashierBalanceCopyWith<$Res> get balance;@override $CashierBalanceEntryCopyWith<$Res> get entry;

}
/// @nodoc
class __$CashierBalanceAdjustmentResponseCopyWithImpl<$Res>
    implements _$CashierBalanceAdjustmentResponseCopyWith<$Res> {
  __$CashierBalanceAdjustmentResponseCopyWithImpl(this._self, this._then);

  final _CashierBalanceAdjustmentResponse _self;
  final $Res Function(_CashierBalanceAdjustmentResponse) _then;

/// Create a copy of CashierBalanceAdjustmentResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? balance = null,Object? entry = null,}) {
  return _then(_CashierBalanceAdjustmentResponse(
balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as CashierBalance,entry: null == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as CashierBalanceEntry,
  ));
}

/// Create a copy of CashierBalanceAdjustmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashierBalanceCopyWith<$Res> get balance {
  
  return $CashierBalanceCopyWith<$Res>(_self.balance, (value) {
    return _then(_self.copyWith(balance: value));
  });
}/// Create a copy of CashierBalanceAdjustmentResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CashierBalanceEntryCopyWith<$Res> get entry {
  
  return $CashierBalanceEntryCopyWith<$Res>(_self.entry, (value) {
    return _then(_self.copyWith(entry: value));
  });
}
}

// dart format on
