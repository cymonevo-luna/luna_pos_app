// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'production_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductionRequestSummary {

 String get id; String get status;@JsonKey(name: 'item_count') int get itemCount;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of ProductionRequestSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionRequestSummaryCopyWith<ProductionRequestSummary> get copyWith => _$ProductionRequestSummaryCopyWithImpl<ProductionRequestSummary>(this as ProductionRequestSummary, _$identity);

  /// Serializes this ProductionRequestSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionRequestSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,itemCount,createdAt,updatedAt);

@override
String toString() {
  return 'ProductionRequestSummary(id: $id, status: $status, itemCount: $itemCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductionRequestSummaryCopyWith<$Res>  {
  factory $ProductionRequestSummaryCopyWith(ProductionRequestSummary value, $Res Function(ProductionRequestSummary) _then) = _$ProductionRequestSummaryCopyWithImpl;
@useResult
$Res call({
 String id, String status,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$ProductionRequestSummaryCopyWithImpl<$Res>
    implements $ProductionRequestSummaryCopyWith<$Res> {
  _$ProductionRequestSummaryCopyWithImpl(this._self, this._then);

  final ProductionRequestSummary _self;
  final $Res Function(ProductionRequestSummary) _then;

/// Create a copy of ProductionRequestSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? itemCount = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductionRequestSummary].
extension ProductionRequestSummaryPatterns on ProductionRequestSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionRequestSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionRequestSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionRequestSummary value)  $default,){
final _that = this;
switch (_that) {
case _ProductionRequestSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionRequestSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionRequestSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionRequestSummary() when $default != null:
return $default(_that.id,_that.status,_that.itemCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProductionRequestSummary():
return $default(_that.id,_that.status,_that.itemCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status, @JsonKey(name: 'item_count')  int itemCount, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductionRequestSummary() when $default != null:
return $default(_that.id,_that.status,_that.itemCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductionRequestSummary implements ProductionRequestSummary {
  const _ProductionRequestSummary({required this.id, required this.status, @JsonKey(name: 'item_count') required this.itemCount, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) this.updatedAt});
  factory _ProductionRequestSummary.fromJson(Map<String, dynamic> json) => _$ProductionRequestSummaryFromJson(json);

@override final  String id;
@override final  String status;
@override@JsonKey(name: 'item_count') final  int itemCount;
@override@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of ProductionRequestSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionRequestSummaryCopyWith<_ProductionRequestSummary> get copyWith => __$ProductionRequestSummaryCopyWithImpl<_ProductionRequestSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductionRequestSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionRequestSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,itemCount,createdAt,updatedAt);

@override
String toString() {
  return 'ProductionRequestSummary(id: $id, status: $status, itemCount: $itemCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductionRequestSummaryCopyWith<$Res> implements $ProductionRequestSummaryCopyWith<$Res> {
  factory _$ProductionRequestSummaryCopyWith(_ProductionRequestSummary value, $Res Function(_ProductionRequestSummary) _then) = __$ProductionRequestSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, String status,@JsonKey(name: 'item_count') int itemCount,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$ProductionRequestSummaryCopyWithImpl<$Res>
    implements _$ProductionRequestSummaryCopyWith<$Res> {
  __$ProductionRequestSummaryCopyWithImpl(this._self, this._then);

  final _ProductionRequestSummary _self;
  final $Res Function(_ProductionRequestSummary) _then;

/// Create a copy of ProductionRequestSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? itemCount = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ProductionRequestSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,itemCount: null == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ProductionRequestItem {

@JsonKey(name: 'menu_title') String get menuTitle;@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) num get quantity;@JsonKey(name: 'is_finished') bool get isFinished;
/// Create a copy of ProductionRequestItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionRequestItemCopyWith<ProductionRequestItem> get copyWith => _$ProductionRequestItemCopyWithImpl<ProductionRequestItem>(this as ProductionRequestItem, _$identity);

  /// Serializes this ProductionRequestItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionRequestItem&&(identical(other.menuTitle, menuTitle) || other.menuTitle == menuTitle)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuTitle,quantity,isFinished);

@override
String toString() {
  return 'ProductionRequestItem(menuTitle: $menuTitle, quantity: $quantity, isFinished: $isFinished)';
}


}

/// @nodoc
abstract mixin class $ProductionRequestItemCopyWith<$Res>  {
  factory $ProductionRequestItemCopyWith(ProductionRequestItem value, $Res Function(ProductionRequestItem) _then) = _$ProductionRequestItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'menu_title') String menuTitle,@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) num quantity,@JsonKey(name: 'is_finished') bool isFinished
});




}
/// @nodoc
class _$ProductionRequestItemCopyWithImpl<$Res>
    implements $ProductionRequestItemCopyWith<$Res> {
  _$ProductionRequestItemCopyWithImpl(this._self, this._then);

  final ProductionRequestItem _self;
  final $Res Function(ProductionRequestItem) _then;

/// Create a copy of ProductionRequestItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? menuTitle = null,Object? quantity = null,Object? isFinished = null,}) {
  return _then(_self.copyWith(
menuTitle: null == menuTitle ? _self.menuTitle : menuTitle // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductionRequestItem].
extension ProductionRequestItemPatterns on ProductionRequestItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionRequestItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionRequestItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionRequestItem value)  $default,){
final _that = this;
switch (_that) {
case _ProductionRequestItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionRequestItem value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionRequestItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'menu_title')  String menuTitle, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)  num quantity, @JsonKey(name: 'is_finished')  bool isFinished)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionRequestItem() when $default != null:
return $default(_that.menuTitle,_that.quantity,_that.isFinished);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'menu_title')  String menuTitle, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)  num quantity, @JsonKey(name: 'is_finished')  bool isFinished)  $default,) {final _that = this;
switch (_that) {
case _ProductionRequestItem():
return $default(_that.menuTitle,_that.quantity,_that.isFinished);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'menu_title')  String menuTitle, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson)  num quantity, @JsonKey(name: 'is_finished')  bool isFinished)?  $default,) {final _that = this;
switch (_that) {
case _ProductionRequestItem() when $default != null:
return $default(_that.menuTitle,_that.quantity,_that.isFinished);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductionRequestItem implements ProductionRequestItem {
  const _ProductionRequestItem({@JsonKey(name: 'menu_title') required this.menuTitle, @JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) required this.quantity, @JsonKey(name: 'is_finished') this.isFinished = false});
  factory _ProductionRequestItem.fromJson(Map<String, dynamic> json) => _$ProductionRequestItemFromJson(json);

@override@JsonKey(name: 'menu_title') final  String menuTitle;
@override@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) final  num quantity;
@override@JsonKey(name: 'is_finished') final  bool isFinished;

/// Create a copy of ProductionRequestItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionRequestItemCopyWith<_ProductionRequestItem> get copyWith => __$ProductionRequestItemCopyWithImpl<_ProductionRequestItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductionRequestItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionRequestItem&&(identical(other.menuTitle, menuTitle) || other.menuTitle == menuTitle)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.isFinished, isFinished) || other.isFinished == isFinished));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuTitle,quantity,isFinished);

@override
String toString() {
  return 'ProductionRequestItem(menuTitle: $menuTitle, quantity: $quantity, isFinished: $isFinished)';
}


}

/// @nodoc
abstract mixin class _$ProductionRequestItemCopyWith<$Res> implements $ProductionRequestItemCopyWith<$Res> {
  factory _$ProductionRequestItemCopyWith(_ProductionRequestItem value, $Res Function(_ProductionRequestItem) _then) = __$ProductionRequestItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'menu_title') String menuTitle,@JsonKey(fromJson: _quantityFromJson, toJson: _quantityToJson) num quantity,@JsonKey(name: 'is_finished') bool isFinished
});




}
/// @nodoc
class __$ProductionRequestItemCopyWithImpl<$Res>
    implements _$ProductionRequestItemCopyWith<$Res> {
  __$ProductionRequestItemCopyWithImpl(this._self, this._then);

  final _ProductionRequestItem _self;
  final $Res Function(_ProductionRequestItem) _then;

/// Create a copy of ProductionRequestItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? menuTitle = null,Object? quantity = null,Object? isFinished = null,}) {
  return _then(_ProductionRequestItem(
menuTitle: null == menuTitle ? _self.menuTitle : menuTitle // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as num,isFinished: null == isFinished ? _self.isFinished : isFinished // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProductionRequestDetail {

 String get id; String get status; List<ProductionRequestItem> get items;@JsonKey(name: 'item_count') int? get itemCount;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of ProductionRequestDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductionRequestDetailCopyWith<ProductionRequestDetail> get copyWith => _$ProductionRequestDetailCopyWithImpl<ProductionRequestDetail>(this as ProductionRequestDetail, _$identity);

  /// Serializes this ProductionRequestDetail to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductionRequestDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,const DeepCollectionEquality().hash(items),itemCount,createdAt,updatedAt);

@override
String toString() {
  return 'ProductionRequestDetail(id: $id, status: $status, items: $items, itemCount: $itemCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProductionRequestDetailCopyWith<$Res>  {
  factory $ProductionRequestDetailCopyWith(ProductionRequestDetail value, $Res Function(ProductionRequestDetail) _then) = _$ProductionRequestDetailCopyWithImpl;
@useResult
$Res call({
 String id, String status, List<ProductionRequestItem> items,@JsonKey(name: 'item_count') int? itemCount,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$ProductionRequestDetailCopyWithImpl<$Res>
    implements $ProductionRequestDetailCopyWith<$Res> {
  _$ProductionRequestDetailCopyWithImpl(this._self, this._then);

  final ProductionRequestDetail _self;
  final $Res Function(ProductionRequestDetail) _then;

/// Create a copy of ProductionRequestDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? status = null,Object? items = null,Object? itemCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ProductionRequestItem>,itemCount: freezed == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductionRequestDetail].
extension ProductionRequestDetailPatterns on ProductionRequestDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductionRequestDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductionRequestDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductionRequestDetail value)  $default,){
final _that = this;
switch (_that) {
case _ProductionRequestDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductionRequestDetail value)?  $default,){
final _that = this;
switch (_that) {
case _ProductionRequestDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String status,  List<ProductionRequestItem> items, @JsonKey(name: 'item_count')  int? itemCount, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductionRequestDetail() when $default != null:
return $default(_that.id,_that.status,_that.items,_that.itemCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String status,  List<ProductionRequestItem> items, @JsonKey(name: 'item_count')  int? itemCount, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProductionRequestDetail():
return $default(_that.id,_that.status,_that.items,_that.itemCount,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String status,  List<ProductionRequestItem> items, @JsonKey(name: 'item_count')  int? itemCount, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProductionRequestDetail() when $default != null:
return $default(_that.id,_that.status,_that.items,_that.itemCount,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductionRequestDetail implements ProductionRequestDetail {
  const _ProductionRequestDetail({required this.id, required this.status, required final  List<ProductionRequestItem> items, @JsonKey(name: 'item_count') this.itemCount, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) this.updatedAt}): _items = items;
  factory _ProductionRequestDetail.fromJson(Map<String, dynamic> json) => _$ProductionRequestDetailFromJson(json);

@override final  String id;
@override final  String status;
 final  List<ProductionRequestItem> _items;
@override List<ProductionRequestItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey(name: 'item_count') final  int? itemCount;
@override@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of ProductionRequestDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductionRequestDetailCopyWith<_ProductionRequestDetail> get copyWith => __$ProductionRequestDetailCopyWithImpl<_ProductionRequestDetail>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductionRequestDetailToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductionRequestDetail&&(identical(other.id, id) || other.id == id)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.itemCount, itemCount) || other.itemCount == itemCount)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,status,const DeepCollectionEquality().hash(_items),itemCount,createdAt,updatedAt);

@override
String toString() {
  return 'ProductionRequestDetail(id: $id, status: $status, items: $items, itemCount: $itemCount, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProductionRequestDetailCopyWith<$Res> implements $ProductionRequestDetailCopyWith<$Res> {
  factory _$ProductionRequestDetailCopyWith(_ProductionRequestDetail value, $Res Function(_ProductionRequestDetail) _then) = __$ProductionRequestDetailCopyWithImpl;
@override @useResult
$Res call({
 String id, String status, List<ProductionRequestItem> items,@JsonKey(name: 'item_count') int? itemCount,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$ProductionRequestDetailCopyWithImpl<$Res>
    implements _$ProductionRequestDetailCopyWith<$Res> {
  __$ProductionRequestDetailCopyWithImpl(this._self, this._then);

  final _ProductionRequestDetail _self;
  final $Res Function(_ProductionRequestDetail) _then;

/// Create a copy of ProductionRequestDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? status = null,Object? items = null,Object? itemCount = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_ProductionRequestDetail(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ProductionRequestItem>,itemCount: freezed == itemCount ? _self.itemCount : itemCount // ignore: cast_nullable_to_non_nullable
as int?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
