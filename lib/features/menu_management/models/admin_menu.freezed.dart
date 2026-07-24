// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'admin_menu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AdminMenu {

 String get id; String get title; String? get description;@JsonKey(name: 'category_id') String get categoryId;@JsonKey(name: 'category_name') String get categoryName;@JsonKey(name: 'photo_url') String? get photoUrl;@JsonKey(name: 'available_stock', fromJson: _intFromJson, toJson: _intToJson) int get availableStock;@JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) int get sellPrice;@JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) int get recipeYield;@JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num get marginPercent;@JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num get vatPercent;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? get updatedAt;
/// Create a copy of AdminMenu
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminMenuCopyWith<AdminMenu> get copyWith => _$AdminMenuCopyWithImpl<AdminMenu>(this as AdminMenu, _$identity);

  /// Serializes this AdminMenu to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminMenu&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.recipeYield, recipeYield) || other.recipeYield == recipeYield)&&(identical(other.marginPercent, marginPercent) || other.marginPercent == marginPercent)&&(identical(other.vatPercent, vatPercent) || other.vatPercent == vatPercent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,categoryId,categoryName,photoUrl,availableStock,sellPrice,recipeYield,marginPercent,vatPercent,createdAt,updatedAt);

@override
String toString() {
  return 'AdminMenu(id: $id, title: $title, description: $description, categoryId: $categoryId, categoryName: $categoryName, photoUrl: $photoUrl, availableStock: $availableStock, sellPrice: $sellPrice, recipeYield: $recipeYield, marginPercent: $marginPercent, vatPercent: $vatPercent, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AdminMenuCopyWith<$Res>  {
  factory $AdminMenuCopyWith(AdminMenu value, $Res Function(AdminMenu) _then) = _$AdminMenuCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'category_name') String categoryName,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'available_stock', fromJson: _intFromJson, toJson: _intToJson) int availableStock,@JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) int sellPrice,@JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) int recipeYield,@JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num marginPercent,@JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num vatPercent,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class _$AdminMenuCopyWithImpl<$Res>
    implements $AdminMenuCopyWith<$Res> {
  _$AdminMenuCopyWithImpl(this._self, this._then);

  final AdminMenu _self;
  final $Res Function(AdminMenu) _then;

/// Create a copy of AdminMenu
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? categoryId = null,Object? categoryName = null,Object? photoUrl = freezed,Object? availableStock = null,Object? sellPrice = null,Object? recipeYield = null,Object? marginPercent = null,Object? vatPercent = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as int,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as int,recipeYield: null == recipeYield ? _self.recipeYield : recipeYield // ignore: cast_nullable_to_non_nullable
as int,marginPercent: null == marginPercent ? _self.marginPercent : marginPercent // ignore: cast_nullable_to_non_nullable
as num,vatPercent: null == vatPercent ? _self.vatPercent : vatPercent // ignore: cast_nullable_to_non_nullable
as num,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminMenu].
extension AdminMenuPatterns on AdminMenu {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminMenu value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminMenu() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminMenu value)  $default,){
final _that = this;
switch (_that) {
case _AdminMenu():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminMenu value)?  $default,){
final _that = this;
switch (_that) {
case _AdminMenu() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'category_name')  String categoryName, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'available_stock', fromJson: _intFromJson, toJson: _intToJson)  int availableStock, @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson)  int sellPrice, @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson)  int recipeYield, @JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num marginPercent, @JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num vatPercent, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminMenu() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.categoryId,_that.categoryName,_that.photoUrl,_that.availableStock,_that.sellPrice,_that.recipeYield,_that.marginPercent,_that.vatPercent,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'category_name')  String categoryName, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'available_stock', fromJson: _intFromJson, toJson: _intToJson)  int availableStock, @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson)  int sellPrice, @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson)  int recipeYield, @JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num marginPercent, @JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num vatPercent, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AdminMenu():
return $default(_that.id,_that.title,_that.description,_that.categoryId,_that.categoryName,_that.photoUrl,_that.availableStock,_that.sellPrice,_that.recipeYield,_that.marginPercent,_that.vatPercent,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'category_name')  String categoryName, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'available_stock', fromJson: _intFromJson, toJson: _intToJson)  int availableStock, @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson)  int sellPrice, @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson)  int recipeYield, @JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num marginPercent, @JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num vatPercent, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AdminMenu() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.categoryId,_that.categoryName,_that.photoUrl,_that.availableStock,_that.sellPrice,_that.recipeYield,_that.marginPercent,_that.vatPercent,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminMenu implements AdminMenu {
  const _AdminMenu({required this.id, required this.title, this.description, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'category_name') required this.categoryName, @JsonKey(name: 'photo_url') this.photoUrl, @JsonKey(name: 'available_stock', fromJson: _intFromJson, toJson: _intToJson) required this.availableStock, @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) required this.sellPrice, @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) required this.recipeYield, @JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) required this.marginPercent, @JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) required this.vatPercent, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) this.updatedAt});
  factory _AdminMenu.fromJson(Map<String, dynamic> json) => _$AdminMenuFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'category_id') final  String categoryId;
@override@JsonKey(name: 'category_name') final  String categoryName;
@override@JsonKey(name: 'photo_url') final  String? photoUrl;
@override@JsonKey(name: 'available_stock', fromJson: _intFromJson, toJson: _intToJson) final  int availableStock;
@override@JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) final  int sellPrice;
@override@JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) final  int recipeYield;
@override@JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) final  num marginPercent;
@override@JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) final  num vatPercent;
@override@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) final  DateTime? updatedAt;

/// Create a copy of AdminMenu
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminMenuCopyWith<_AdminMenu> get copyWith => __$AdminMenuCopyWithImpl<_AdminMenu>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminMenuToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminMenu&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.recipeYield, recipeYield) || other.recipeYield == recipeYield)&&(identical(other.marginPercent, marginPercent) || other.marginPercent == marginPercent)&&(identical(other.vatPercent, vatPercent) || other.vatPercent == vatPercent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,categoryId,categoryName,photoUrl,availableStock,sellPrice,recipeYield,marginPercent,vatPercent,createdAt,updatedAt);

@override
String toString() {
  return 'AdminMenu(id: $id, title: $title, description: $description, categoryId: $categoryId, categoryName: $categoryName, photoUrl: $photoUrl, availableStock: $availableStock, sellPrice: $sellPrice, recipeYield: $recipeYield, marginPercent: $marginPercent, vatPercent: $vatPercent, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AdminMenuCopyWith<$Res> implements $AdminMenuCopyWith<$Res> {
  factory _$AdminMenuCopyWith(_AdminMenu value, $Res Function(_AdminMenu) _then) = __$AdminMenuCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'category_name') String categoryName,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'available_stock', fromJson: _intFromJson, toJson: _intToJson) int availableStock,@JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) int sellPrice,@JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) int recipeYield,@JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num marginPercent,@JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num vatPercent,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt
});




}
/// @nodoc
class __$AdminMenuCopyWithImpl<$Res>
    implements _$AdminMenuCopyWith<$Res> {
  __$AdminMenuCopyWithImpl(this._self, this._then);

  final _AdminMenu _self;
  final $Res Function(_AdminMenu) _then;

/// Create a copy of AdminMenu
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? categoryId = null,Object? categoryName = null,Object? photoUrl = freezed,Object? availableStock = null,Object? sellPrice = null,Object? recipeYield = null,Object? marginPercent = null,Object? vatPercent = null,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_AdminMenu(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as int,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as int,recipeYield: null == recipeYield ? _self.recipeYield : recipeYield // ignore: cast_nullable_to_non_nullable
as int,marginPercent: null == marginPercent ? _self.marginPercent : marginPercent // ignore: cast_nullable_to_non_nullable
as num,vatPercent: null == vatPercent ? _self.vatPercent : vatPercent // ignore: cast_nullable_to_non_nullable
as num,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$AdminMenuRequest {

 String get title; String? get description;@JsonKey(name: 'category_id') String get categoryId;@JsonKey(name: 'photo_url') String? get photoUrl;@JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) int get sellPrice;@JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) int get recipeYield;@JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num get marginPercent;@JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num get vatPercent;
/// Create a copy of AdminMenuRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdminMenuRequestCopyWith<AdminMenuRequest> get copyWith => _$AdminMenuRequestCopyWithImpl<AdminMenuRequest>(this as AdminMenuRequest, _$identity);

  /// Serializes this AdminMenuRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdminMenuRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.recipeYield, recipeYield) || other.recipeYield == recipeYield)&&(identical(other.marginPercent, marginPercent) || other.marginPercent == marginPercent)&&(identical(other.vatPercent, vatPercent) || other.vatPercent == vatPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,categoryId,photoUrl,sellPrice,recipeYield,marginPercent,vatPercent);

@override
String toString() {
  return 'AdminMenuRequest(title: $title, description: $description, categoryId: $categoryId, photoUrl: $photoUrl, sellPrice: $sellPrice, recipeYield: $recipeYield, marginPercent: $marginPercent, vatPercent: $vatPercent)';
}


}

/// @nodoc
abstract mixin class $AdminMenuRequestCopyWith<$Res>  {
  factory $AdminMenuRequestCopyWith(AdminMenuRequest value, $Res Function(AdminMenuRequest) _then) = _$AdminMenuRequestCopyWithImpl;
@useResult
$Res call({
 String title, String? description,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) int sellPrice,@JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) int recipeYield,@JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num marginPercent,@JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num vatPercent
});




}
/// @nodoc
class _$AdminMenuRequestCopyWithImpl<$Res>
    implements $AdminMenuRequestCopyWith<$Res> {
  _$AdminMenuRequestCopyWithImpl(this._self, this._then);

  final AdminMenuRequest _self;
  final $Res Function(AdminMenuRequest) _then;

/// Create a copy of AdminMenuRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? categoryId = null,Object? photoUrl = freezed,Object? sellPrice = null,Object? recipeYield = null,Object? marginPercent = null,Object? vatPercent = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as int,recipeYield: null == recipeYield ? _self.recipeYield : recipeYield // ignore: cast_nullable_to_non_nullable
as int,marginPercent: null == marginPercent ? _self.marginPercent : marginPercent // ignore: cast_nullable_to_non_nullable
as num,vatPercent: null == vatPercent ? _self.vatPercent : vatPercent // ignore: cast_nullable_to_non_nullable
as num,
  ));
}

}


/// Adds pattern-matching-related methods to [AdminMenuRequest].
extension AdminMenuRequestPatterns on AdminMenuRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdminMenuRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdminMenuRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdminMenuRequest value)  $default,){
final _that = this;
switch (_that) {
case _AdminMenuRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdminMenuRequest value)?  $default,){
final _that = this;
switch (_that) {
case _AdminMenuRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson)  int sellPrice, @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson)  int recipeYield, @JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num marginPercent, @JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num vatPercent)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdminMenuRequest() when $default != null:
return $default(_that.title,_that.description,_that.categoryId,_that.photoUrl,_that.sellPrice,_that.recipeYield,_that.marginPercent,_that.vatPercent);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson)  int sellPrice, @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson)  int recipeYield, @JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num marginPercent, @JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num vatPercent)  $default,) {final _that = this;
switch (_that) {
case _AdminMenuRequest():
return $default(_that.title,_that.description,_that.categoryId,_that.photoUrl,_that.sellPrice,_that.recipeYield,_that.marginPercent,_that.vatPercent);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description, @JsonKey(name: 'category_id')  String categoryId, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson)  int sellPrice, @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson)  int recipeYield, @JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num marginPercent, @JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson)  num vatPercent)?  $default,) {final _that = this;
switch (_that) {
case _AdminMenuRequest() when $default != null:
return $default(_that.title,_that.description,_that.categoryId,_that.photoUrl,_that.sellPrice,_that.recipeYield,_that.marginPercent,_that.vatPercent);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdminMenuRequest implements AdminMenuRequest {
  const _AdminMenuRequest({required this.title, this.description, @JsonKey(name: 'category_id') required this.categoryId, @JsonKey(name: 'photo_url') this.photoUrl, @JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) required this.sellPrice, @JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) required this.recipeYield, @JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) required this.marginPercent, @JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) required this.vatPercent});
  factory _AdminMenuRequest.fromJson(Map<String, dynamic> json) => _$AdminMenuRequestFromJson(json);

@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'category_id') final  String categoryId;
@override@JsonKey(name: 'photo_url') final  String? photoUrl;
@override@JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) final  int sellPrice;
@override@JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) final  int recipeYield;
@override@JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) final  num marginPercent;
@override@JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) final  num vatPercent;

/// Create a copy of AdminMenuRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdminMenuRequestCopyWith<_AdminMenuRequest> get copyWith => __$AdminMenuRequestCopyWithImpl<_AdminMenuRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdminMenuRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdminMenuRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice)&&(identical(other.recipeYield, recipeYield) || other.recipeYield == recipeYield)&&(identical(other.marginPercent, marginPercent) || other.marginPercent == marginPercent)&&(identical(other.vatPercent, vatPercent) || other.vatPercent == vatPercent));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,categoryId,photoUrl,sellPrice,recipeYield,marginPercent,vatPercent);

@override
String toString() {
  return 'AdminMenuRequest(title: $title, description: $description, categoryId: $categoryId, photoUrl: $photoUrl, sellPrice: $sellPrice, recipeYield: $recipeYield, marginPercent: $marginPercent, vatPercent: $vatPercent)';
}


}

/// @nodoc
abstract mixin class _$AdminMenuRequestCopyWith<$Res> implements $AdminMenuRequestCopyWith<$Res> {
  factory _$AdminMenuRequestCopyWith(_AdminMenuRequest value, $Res Function(_AdminMenuRequest) _then) = __$AdminMenuRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description,@JsonKey(name: 'category_id') String categoryId,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'sell_price', fromJson: _intFromJson, toJson: _intToJson) int sellPrice,@JsonKey(name: 'recipe_yield', fromJson: _intFromJson, toJson: _intToJson) int recipeYield,@JsonKey(name: 'margin_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num marginPercent,@JsonKey(name: 'vat_percent', fromJson: _decimalFromJson, toJson: _decimalToJson) num vatPercent
});




}
/// @nodoc
class __$AdminMenuRequestCopyWithImpl<$Res>
    implements _$AdminMenuRequestCopyWith<$Res> {
  __$AdminMenuRequestCopyWithImpl(this._self, this._then);

  final _AdminMenuRequest _self;
  final $Res Function(_AdminMenuRequest) _then;

/// Create a copy of AdminMenuRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? categoryId = null,Object? photoUrl = freezed,Object? sellPrice = null,Object? recipeYield = null,Object? marginPercent = null,Object? vatPercent = null,}) {
  return _then(_AdminMenuRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as int,recipeYield: null == recipeYield ? _self.recipeYield : recipeYield // ignore: cast_nullable_to_non_nullable
as int,marginPercent: null == marginPercent ? _self.marginPercent : marginPercent // ignore: cast_nullable_to_non_nullable
as num,vatPercent: null == vatPercent ? _self.vatPercent : vatPercent // ignore: cast_nullable_to_non_nullable
as num,
  ));
}


}

// dart format on
