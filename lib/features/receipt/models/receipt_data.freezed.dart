// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ReceiptData {

 String get brandName; String get branchName; String get branchAddress; String get branchPhone; String get cashierName; String get transactionId; DateTime get transactionDate; List<ReceiptLineItem> get items; int get subtotalAmount; int get discountAmount; int get totalAmount; int get cashTendered; int get changeAmount; String get thankYouNote;
/// Create a copy of ReceiptData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptDataCopyWith<ReceiptData> get copyWith => _$ReceiptDataCopyWithImpl<ReceiptData>(this as ReceiptData, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptData&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.branchAddress, branchAddress) || other.branchAddress == branchAddress)&&(identical(other.branchPhone, branchPhone) || other.branchPhone == branchPhone)&&(identical(other.cashierName, cashierName) || other.cashierName == cashierName)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount)&&(identical(other.thankYouNote, thankYouNote) || other.thankYouNote == thankYouNote));
}


@override
int get hashCode => Object.hash(runtimeType,brandName,branchName,branchAddress,branchPhone,cashierName,transactionId,transactionDate,const DeepCollectionEquality().hash(items),subtotalAmount,discountAmount,totalAmount,cashTendered,changeAmount,thankYouNote);

@override
String toString() {
  return 'ReceiptData(brandName: $brandName, branchName: $branchName, branchAddress: $branchAddress, branchPhone: $branchPhone, cashierName: $cashierName, transactionId: $transactionId, transactionDate: $transactionDate, items: $items, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, cashTendered: $cashTendered, changeAmount: $changeAmount, thankYouNote: $thankYouNote)';
}


}

/// @nodoc
abstract mixin class $ReceiptDataCopyWith<$Res>  {
  factory $ReceiptDataCopyWith(ReceiptData value, $Res Function(ReceiptData) _then) = _$ReceiptDataCopyWithImpl;
@useResult
$Res call({
 String brandName, String branchName, String branchAddress, String branchPhone, String cashierName, String transactionId, DateTime transactionDate, List<ReceiptLineItem> items, int subtotalAmount, int discountAmount, int totalAmount, int cashTendered, int changeAmount, String thankYouNote
});




}
/// @nodoc
class _$ReceiptDataCopyWithImpl<$Res>
    implements $ReceiptDataCopyWith<$Res> {
  _$ReceiptDataCopyWithImpl(this._self, this._then);

  final ReceiptData _self;
  final $Res Function(ReceiptData) _then;

/// Create a copy of ReceiptData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? brandName = null,Object? branchName = null,Object? branchAddress = null,Object? branchPhone = null,Object? cashierName = null,Object? transactionId = null,Object? transactionDate = null,Object? items = null,Object? subtotalAmount = null,Object? discountAmount = null,Object? totalAmount = null,Object? cashTendered = null,Object? changeAmount = null,Object? thankYouNote = null,}) {
  return _then(_self.copyWith(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,branchAddress: null == branchAddress ? _self.branchAddress : branchAddress // ignore: cast_nullable_to_non_nullable
as String,branchPhone: null == branchPhone ? _self.branchPhone : branchPhone // ignore: cast_nullable_to_non_nullable
as String,cashierName: null == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptLineItem>,subtotalAmount: null == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,cashTendered: null == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int,thankYouNote: null == thankYouNote ? _self.thankYouNote : thankYouNote // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptData].
extension ReceiptDataPatterns on ReceiptData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptData value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptData value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String brandName,  String branchName,  String branchAddress,  String branchPhone,  String cashierName,  String transactionId,  DateTime transactionDate,  List<ReceiptLineItem> items,  int subtotalAmount,  int discountAmount,  int totalAmount,  int cashTendered,  int changeAmount,  String thankYouNote)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptData() when $default != null:
return $default(_that.brandName,_that.branchName,_that.branchAddress,_that.branchPhone,_that.cashierName,_that.transactionId,_that.transactionDate,_that.items,_that.subtotalAmount,_that.discountAmount,_that.totalAmount,_that.cashTendered,_that.changeAmount,_that.thankYouNote);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String brandName,  String branchName,  String branchAddress,  String branchPhone,  String cashierName,  String transactionId,  DateTime transactionDate,  List<ReceiptLineItem> items,  int subtotalAmount,  int discountAmount,  int totalAmount,  int cashTendered,  int changeAmount,  String thankYouNote)  $default,) {final _that = this;
switch (_that) {
case _ReceiptData():
return $default(_that.brandName,_that.branchName,_that.branchAddress,_that.branchPhone,_that.cashierName,_that.transactionId,_that.transactionDate,_that.items,_that.subtotalAmount,_that.discountAmount,_that.totalAmount,_that.cashTendered,_that.changeAmount,_that.thankYouNote);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String brandName,  String branchName,  String branchAddress,  String branchPhone,  String cashierName,  String transactionId,  DateTime transactionDate,  List<ReceiptLineItem> items,  int subtotalAmount,  int discountAmount,  int totalAmount,  int cashTendered,  int changeAmount,  String thankYouNote)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptData() when $default != null:
return $default(_that.brandName,_that.branchName,_that.branchAddress,_that.branchPhone,_that.cashierName,_that.transactionId,_that.transactionDate,_that.items,_that.subtotalAmount,_that.discountAmount,_that.totalAmount,_that.cashTendered,_that.changeAmount,_that.thankYouNote);case _:
  return null;

}
}

}

/// @nodoc


class _ReceiptData extends ReceiptData {
  const _ReceiptData({required this.brandName, required this.branchName, required this.branchAddress, required this.branchPhone, required this.cashierName, required this.transactionId, required this.transactionDate, required final  List<ReceiptLineItem> items, required this.subtotalAmount, this.discountAmount = 0, required this.totalAmount, required this.cashTendered, this.changeAmount = 0, required this.thankYouNote}): _items = items,super._();
  

@override final  String brandName;
@override final  String branchName;
@override final  String branchAddress;
@override final  String branchPhone;
@override final  String cashierName;
@override final  String transactionId;
@override final  DateTime transactionDate;
 final  List<ReceiptLineItem> _items;
@override List<ReceiptLineItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  int subtotalAmount;
@override@JsonKey() final  int discountAmount;
@override final  int totalAmount;
@override final  int cashTendered;
@override@JsonKey() final  int changeAmount;
@override final  String thankYouNote;

/// Create a copy of ReceiptData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptDataCopyWith<_ReceiptData> get copyWith => __$ReceiptDataCopyWithImpl<_ReceiptData>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptData&&(identical(other.brandName, brandName) || other.brandName == brandName)&&(identical(other.branchName, branchName) || other.branchName == branchName)&&(identical(other.branchAddress, branchAddress) || other.branchAddress == branchAddress)&&(identical(other.branchPhone, branchPhone) || other.branchPhone == branchPhone)&&(identical(other.cashierName, cashierName) || other.cashierName == cashierName)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.transactionDate, transactionDate) || other.transactionDate == transactionDate)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.subtotalAmount, subtotalAmount) || other.subtotalAmount == subtotalAmount)&&(identical(other.discountAmount, discountAmount) || other.discountAmount == discountAmount)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.cashTendered, cashTendered) || other.cashTendered == cashTendered)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount)&&(identical(other.thankYouNote, thankYouNote) || other.thankYouNote == thankYouNote));
}


@override
int get hashCode => Object.hash(runtimeType,brandName,branchName,branchAddress,branchPhone,cashierName,transactionId,transactionDate,const DeepCollectionEquality().hash(_items),subtotalAmount,discountAmount,totalAmount,cashTendered,changeAmount,thankYouNote);

@override
String toString() {
  return 'ReceiptData(brandName: $brandName, branchName: $branchName, branchAddress: $branchAddress, branchPhone: $branchPhone, cashierName: $cashierName, transactionId: $transactionId, transactionDate: $transactionDate, items: $items, subtotalAmount: $subtotalAmount, discountAmount: $discountAmount, totalAmount: $totalAmount, cashTendered: $cashTendered, changeAmount: $changeAmount, thankYouNote: $thankYouNote)';
}


}

/// @nodoc
abstract mixin class _$ReceiptDataCopyWith<$Res> implements $ReceiptDataCopyWith<$Res> {
  factory _$ReceiptDataCopyWith(_ReceiptData value, $Res Function(_ReceiptData) _then) = __$ReceiptDataCopyWithImpl;
@override @useResult
$Res call({
 String brandName, String branchName, String branchAddress, String branchPhone, String cashierName, String transactionId, DateTime transactionDate, List<ReceiptLineItem> items, int subtotalAmount, int discountAmount, int totalAmount, int cashTendered, int changeAmount, String thankYouNote
});




}
/// @nodoc
class __$ReceiptDataCopyWithImpl<$Res>
    implements _$ReceiptDataCopyWith<$Res> {
  __$ReceiptDataCopyWithImpl(this._self, this._then);

  final _ReceiptData _self;
  final $Res Function(_ReceiptData) _then;

/// Create a copy of ReceiptData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? brandName = null,Object? branchName = null,Object? branchAddress = null,Object? branchPhone = null,Object? cashierName = null,Object? transactionId = null,Object? transactionDate = null,Object? items = null,Object? subtotalAmount = null,Object? discountAmount = null,Object? totalAmount = null,Object? cashTendered = null,Object? changeAmount = null,Object? thankYouNote = null,}) {
  return _then(_ReceiptData(
brandName: null == brandName ? _self.brandName : brandName // ignore: cast_nullable_to_non_nullable
as String,branchName: null == branchName ? _self.branchName : branchName // ignore: cast_nullable_to_non_nullable
as String,branchAddress: null == branchAddress ? _self.branchAddress : branchAddress // ignore: cast_nullable_to_non_nullable
as String,branchPhone: null == branchPhone ? _self.branchPhone : branchPhone // ignore: cast_nullable_to_non_nullable
as String,cashierName: null == cashierName ? _self.cashierName : cashierName // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,transactionDate: null == transactionDate ? _self.transactionDate : transactionDate // ignore: cast_nullable_to_non_nullable
as DateTime,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptLineItem>,subtotalAmount: null == subtotalAmount ? _self.subtotalAmount : subtotalAmount // ignore: cast_nullable_to_non_nullable
as int,discountAmount: null == discountAmount ? _self.discountAmount : discountAmount // ignore: cast_nullable_to_non_nullable
as int,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as int,cashTendered: null == cashTendered ? _self.cashTendered : cashTendered // ignore: cast_nullable_to_non_nullable
as int,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as int,thankYouNote: null == thankYouNote ? _self.thankYouNote : thankYouNote // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
