// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Expense {

 String get id; String get title; String? get description;@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int get amount;@JsonKey(name: 'source_of_fund') ExpenseSourceOfFund get sourceOfFund;@JsonKey(name: 'receipt_url') String? get receiptUrl;@JsonKey(name: 'recurring_expense_id') String? get recurringExpenseId;@JsonKey(name: 'created_by_user_id') String? get createdByUserId;@JsonKey(name: 'created_by_username') String? get createdByUsername;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseCopyWith<Expense> get copyWith => _$ExpenseCopyWithImpl<Expense>(this as Expense, _$identity);

  /// Serializes this Expense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sourceOfFund, sourceOfFund) || other.sourceOfFund == sourceOfFund)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.recurringExpenseId, recurringExpenseId) || other.recurringExpenseId == recurringExpenseId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdByUsername, createdByUsername) || other.createdByUsername == createdByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,amount,sourceOfFund,receiptUrl,recurringExpenseId,createdByUserId,createdByUsername,createdAt,updatedAt);

@override
String toString() {
  return 'Expense(id: $id, title: $title, description: $description, amount: $amount, sourceOfFund: $sourceOfFund, receiptUrl: $receiptUrl, recurringExpenseId: $recurringExpenseId, createdByUserId: $createdByUserId, createdByUsername: $createdByUsername, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ExpenseCopyWith<$Res>  {
  factory $ExpenseCopyWith(Expense value, $Res Function(Expense) _then) = _$ExpenseCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount,@JsonKey(name: 'source_of_fund') ExpenseSourceOfFund sourceOfFund,@JsonKey(name: 'receipt_url') String? receiptUrl,@JsonKey(name: 'recurring_expense_id') String? recurringExpenseId,@JsonKey(name: 'created_by_user_id') String? createdByUserId,@JsonKey(name: 'created_by_username') String? createdByUsername,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$ExpenseCopyWithImpl<$Res>
    implements $ExpenseCopyWith<$Res> {
  _$ExpenseCopyWithImpl(this._self, this._then);

  final Expense _self;
  final $Res Function(Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? amount = null,Object? sourceOfFund = null,Object? receiptUrl = freezed,Object? recurringExpenseId = freezed,Object? createdByUserId = freezed,Object? createdByUsername = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,sourceOfFund: null == sourceOfFund ? _self.sourceOfFund : sourceOfFund // ignore: cast_nullable_to_non_nullable
as ExpenseSourceOfFund,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,recurringExpenseId: freezed == recurringExpenseId ? _self.recurringExpenseId : recurringExpenseId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdByUsername: freezed == createdByUsername ? _self.createdByUsername : createdByUsername // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Expense].
extension ExpensePatterns on Expense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Expense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Expense value)  $default,){
final _that = this;
switch (_that) {
case _Expense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Expense value)?  $default,){
final _that = this;
switch (_that) {
case _Expense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount, @JsonKey(name: 'source_of_fund')  ExpenseSourceOfFund sourceOfFund, @JsonKey(name: 'receipt_url')  String? receiptUrl, @JsonKey(name: 'recurring_expense_id')  String? recurringExpenseId, @JsonKey(name: 'created_by_user_id')  String? createdByUserId, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.amount,_that.sourceOfFund,_that.receiptUrl,_that.recurringExpenseId,_that.createdByUserId,_that.createdByUsername,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount, @JsonKey(name: 'source_of_fund')  ExpenseSourceOfFund sourceOfFund, @JsonKey(name: 'receipt_url')  String? receiptUrl, @JsonKey(name: 'recurring_expense_id')  String? recurringExpenseId, @JsonKey(name: 'created_by_user_id')  String? createdByUserId, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Expense():
return $default(_that.id,_that.title,_that.description,_that.amount,_that.sourceOfFund,_that.receiptUrl,_that.recurringExpenseId,_that.createdByUserId,_that.createdByUsername,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount, @JsonKey(name: 'source_of_fund')  ExpenseSourceOfFund sourceOfFund, @JsonKey(name: 'receipt_url')  String? receiptUrl, @JsonKey(name: 'recurring_expense_id')  String? recurringExpenseId, @JsonKey(name: 'created_by_user_id')  String? createdByUserId, @JsonKey(name: 'created_by_username')  String? createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Expense() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.amount,_that.sourceOfFund,_that.receiptUrl,_that.recurringExpenseId,_that.createdByUserId,_that.createdByUsername,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Expense implements Expense {
  const _Expense({required this.id, required this.title, this.description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) required this.amount, @JsonKey(name: 'source_of_fund') this.sourceOfFund = ExpenseSourceOfFund.personalMoney, @JsonKey(name: 'receipt_url') this.receiptUrl, @JsonKey(name: 'recurring_expense_id') this.recurringExpenseId, @JsonKey(name: 'created_by_user_id') this.createdByUserId, @JsonKey(name: 'created_by_username') this.createdByUsername, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) this.updatedAt});
  factory _Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) final  int amount;
@override@JsonKey(name: 'source_of_fund') final  ExpenseSourceOfFund sourceOfFund;
@override@JsonKey(name: 'receipt_url') final  String? receiptUrl;
@override@JsonKey(name: 'recurring_expense_id') final  String? recurringExpenseId;
@override@JsonKey(name: 'created_by_user_id') final  String? createdByUserId;
@override@JsonKey(name: 'created_by_username') final  String? createdByUsername;
@override@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseCopyWith<_Expense> get copyWith => __$ExpenseCopyWithImpl<_Expense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Expense&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sourceOfFund, sourceOfFund) || other.sourceOfFund == sourceOfFund)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl)&&(identical(other.recurringExpenseId, recurringExpenseId) || other.recurringExpenseId == recurringExpenseId)&&(identical(other.createdByUserId, createdByUserId) || other.createdByUserId == createdByUserId)&&(identical(other.createdByUsername, createdByUsername) || other.createdByUsername == createdByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,amount,sourceOfFund,receiptUrl,recurringExpenseId,createdByUserId,createdByUsername,createdAt,updatedAt);

@override
String toString() {
  return 'Expense(id: $id, title: $title, description: $description, amount: $amount, sourceOfFund: $sourceOfFund, receiptUrl: $receiptUrl, recurringExpenseId: $recurringExpenseId, createdByUserId: $createdByUserId, createdByUsername: $createdByUsername, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ExpenseCopyWith<$Res> implements $ExpenseCopyWith<$Res> {
  factory _$ExpenseCopyWith(_Expense value, $Res Function(_Expense) _then) = __$ExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount,@JsonKey(name: 'source_of_fund') ExpenseSourceOfFund sourceOfFund,@JsonKey(name: 'receipt_url') String? receiptUrl,@JsonKey(name: 'recurring_expense_id') String? recurringExpenseId,@JsonKey(name: 'created_by_user_id') String? createdByUserId,@JsonKey(name: 'created_by_username') String? createdByUsername,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$ExpenseCopyWithImpl<$Res>
    implements _$ExpenseCopyWith<$Res> {
  __$ExpenseCopyWithImpl(this._self, this._then);

  final _Expense _self;
  final $Res Function(_Expense) _then;

/// Create a copy of Expense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? amount = null,Object? sourceOfFund = null,Object? receiptUrl = freezed,Object? recurringExpenseId = freezed,Object? createdByUserId = freezed,Object? createdByUsername = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_Expense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,sourceOfFund: null == sourceOfFund ? _self.sourceOfFund : sourceOfFund // ignore: cast_nullable_to_non_nullable
as ExpenseSourceOfFund,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,recurringExpenseId: freezed == recurringExpenseId ? _self.recurringExpenseId : recurringExpenseId // ignore: cast_nullable_to_non_nullable
as String?,createdByUserId: freezed == createdByUserId ? _self.createdByUserId : createdByUserId // ignore: cast_nullable_to_non_nullable
as String?,createdByUsername: freezed == createdByUsername ? _self.createdByUsername : createdByUsername // ignore: cast_nullable_to_non_nullable
as String?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ExpenseRequest {

 String get title; String? get description;@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int get amount;@JsonKey(name: 'source_of_fund') ExpenseSourceOfFund get sourceOfFund;@JsonKey(name: 'receipt_url') String? get receiptUrl;
/// Create a copy of ExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseRequestCopyWith<ExpenseRequest> get copyWith => _$ExpenseRequestCopyWithImpl<ExpenseRequest>(this as ExpenseRequest, _$identity);

  /// Serializes this ExpenseRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sourceOfFund, sourceOfFund) || other.sourceOfFund == sourceOfFund)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,amount,sourceOfFund,receiptUrl);

@override
String toString() {
  return 'ExpenseRequest(title: $title, description: $description, amount: $amount, sourceOfFund: $sourceOfFund, receiptUrl: $receiptUrl)';
}


}

/// @nodoc
abstract mixin class $ExpenseRequestCopyWith<$Res>  {
  factory $ExpenseRequestCopyWith(ExpenseRequest value, $Res Function(ExpenseRequest) _then) = _$ExpenseRequestCopyWithImpl;
@useResult
$Res call({
 String title, String? description,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount,@JsonKey(name: 'source_of_fund') ExpenseSourceOfFund sourceOfFund,@JsonKey(name: 'receipt_url') String? receiptUrl
});




}
/// @nodoc
class _$ExpenseRequestCopyWithImpl<$Res>
    implements $ExpenseRequestCopyWith<$Res> {
  _$ExpenseRequestCopyWithImpl(this._self, this._then);

  final ExpenseRequest _self;
  final $Res Function(ExpenseRequest) _then;

/// Create a copy of ExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? amount = null,Object? sourceOfFund = null,Object? receiptUrl = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,sourceOfFund: null == sourceOfFund ? _self.sourceOfFund : sourceOfFund // ignore: cast_nullable_to_non_nullable
as ExpenseSourceOfFund,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseRequest].
extension ExpenseRequestPatterns on ExpenseRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseRequest value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseRequest value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount, @JsonKey(name: 'source_of_fund')  ExpenseSourceOfFund sourceOfFund, @JsonKey(name: 'receipt_url')  String? receiptUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseRequest() when $default != null:
return $default(_that.title,_that.description,_that.amount,_that.sourceOfFund,_that.receiptUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount, @JsonKey(name: 'source_of_fund')  ExpenseSourceOfFund sourceOfFund, @JsonKey(name: 'receipt_url')  String? receiptUrl)  $default,) {final _that = this;
switch (_that) {
case _ExpenseRequest():
return $default(_that.title,_that.description,_that.amount,_that.sourceOfFund,_that.receiptUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount, @JsonKey(name: 'source_of_fund')  ExpenseSourceOfFund sourceOfFund, @JsonKey(name: 'receipt_url')  String? receiptUrl)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseRequest() when $default != null:
return $default(_that.title,_that.description,_that.amount,_that.sourceOfFund,_that.receiptUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExpenseRequest implements ExpenseRequest {
  const _ExpenseRequest({required this.title, this.description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) required this.amount, @JsonKey(name: 'source_of_fund') required this.sourceOfFund, @JsonKey(name: 'receipt_url') this.receiptUrl});
  factory _ExpenseRequest.fromJson(Map<String, dynamic> json) => _$ExpenseRequestFromJson(json);

@override final  String title;
@override final  String? description;
@override@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) final  int amount;
@override@JsonKey(name: 'source_of_fund') final  ExpenseSourceOfFund sourceOfFund;
@override@JsonKey(name: 'receipt_url') final  String? receiptUrl;

/// Create a copy of ExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseRequestCopyWith<_ExpenseRequest> get copyWith => __$ExpenseRequestCopyWithImpl<_ExpenseRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExpenseRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.sourceOfFund, sourceOfFund) || other.sourceOfFund == sourceOfFund)&&(identical(other.receiptUrl, receiptUrl) || other.receiptUrl == receiptUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,amount,sourceOfFund,receiptUrl);

@override
String toString() {
  return 'ExpenseRequest(title: $title, description: $description, amount: $amount, sourceOfFund: $sourceOfFund, receiptUrl: $receiptUrl)';
}


}

/// @nodoc
abstract mixin class _$ExpenseRequestCopyWith<$Res> implements $ExpenseRequestCopyWith<$Res> {
  factory _$ExpenseRequestCopyWith(_ExpenseRequest value, $Res Function(_ExpenseRequest) _then) = __$ExpenseRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount,@JsonKey(name: 'source_of_fund') ExpenseSourceOfFund sourceOfFund,@JsonKey(name: 'receipt_url') String? receiptUrl
});




}
/// @nodoc
class __$ExpenseRequestCopyWithImpl<$Res>
    implements _$ExpenseRequestCopyWith<$Res> {
  __$ExpenseRequestCopyWithImpl(this._self, this._then);

  final _ExpenseRequest _self;
  final $Res Function(_ExpenseRequest) _then;

/// Create a copy of ExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? amount = null,Object? sourceOfFund = null,Object? receiptUrl = freezed,}) {
  return _then(_ExpenseRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,sourceOfFund: null == sourceOfFund ? _self.sourceOfFund : sourceOfFund // ignore: cast_nullable_to_non_nullable
as ExpenseSourceOfFund,receiptUrl: freezed == receiptUrl ? _self.receiptUrl : receiptUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
