// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pos_menu.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$POSMenusResponse {

@JsonKey(defaultValue: <POSCategoryGroup>[]) List<POSCategoryGroup> get categories;
/// Create a copy of POSMenusResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$POSMenusResponseCopyWith<POSMenusResponse> get copyWith => _$POSMenusResponseCopyWithImpl<POSMenusResponse>(this as POSMenusResponse, _$identity);

  /// Serializes this POSMenusResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is POSMenusResponse&&const DeepCollectionEquality().equals(other.categories, categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(categories));

@override
String toString() {
  return 'POSMenusResponse(categories: $categories)';
}


}

/// @nodoc
abstract mixin class $POSMenusResponseCopyWith<$Res>  {
  factory $POSMenusResponseCopyWith(POSMenusResponse value, $Res Function(POSMenusResponse) _then) = _$POSMenusResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(defaultValue: <POSCategoryGroup>[]) List<POSCategoryGroup> categories
});




}
/// @nodoc
class _$POSMenusResponseCopyWithImpl<$Res>
    implements $POSMenusResponseCopyWith<$Res> {
  _$POSMenusResponseCopyWithImpl(this._self, this._then);

  final POSMenusResponse _self;
  final $Res Function(POSMenusResponse) _then;

/// Create a copy of POSMenusResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categories = null,}) {
  return _then(_self.copyWith(
categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<POSCategoryGroup>,
  ));
}

}


/// Adds pattern-matching-related methods to [POSMenusResponse].
extension POSMenusResponsePatterns on POSMenusResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _POSMenusResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _POSMenusResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _POSMenusResponse value)  $default,){
final _that = this;
switch (_that) {
case _POSMenusResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _POSMenusResponse value)?  $default,){
final _that = this;
switch (_that) {
case _POSMenusResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: <POSCategoryGroup>[])  List<POSCategoryGroup> categories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _POSMenusResponse() when $default != null:
return $default(_that.categories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(defaultValue: <POSCategoryGroup>[])  List<POSCategoryGroup> categories)  $default,) {final _that = this;
switch (_that) {
case _POSMenusResponse():
return $default(_that.categories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(defaultValue: <POSCategoryGroup>[])  List<POSCategoryGroup> categories)?  $default,) {final _that = this;
switch (_that) {
case _POSMenusResponse() when $default != null:
return $default(_that.categories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _POSMenusResponse implements POSMenusResponse {
  const _POSMenusResponse({@JsonKey(defaultValue: <POSCategoryGroup>[]) required final  List<POSCategoryGroup> categories}): _categories = categories;
  factory _POSMenusResponse.fromJson(Map<String, dynamic> json) => _$POSMenusResponseFromJson(json);

 final  List<POSCategoryGroup> _categories;
@override@JsonKey(defaultValue: <POSCategoryGroup>[]) List<POSCategoryGroup> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}


/// Create a copy of POSMenusResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$POSMenusResponseCopyWith<_POSMenusResponse> get copyWith => __$POSMenusResponseCopyWithImpl<_POSMenusResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$POSMenusResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _POSMenusResponse&&const DeepCollectionEquality().equals(other._categories, _categories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_categories));

@override
String toString() {
  return 'POSMenusResponse(categories: $categories)';
}


}

/// @nodoc
abstract mixin class _$POSMenusResponseCopyWith<$Res> implements $POSMenusResponseCopyWith<$Res> {
  factory _$POSMenusResponseCopyWith(_POSMenusResponse value, $Res Function(_POSMenusResponse) _then) = __$POSMenusResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(defaultValue: <POSCategoryGroup>[]) List<POSCategoryGroup> categories
});




}
/// @nodoc
class __$POSMenusResponseCopyWithImpl<$Res>
    implements _$POSMenusResponseCopyWith<$Res> {
  __$POSMenusResponseCopyWithImpl(this._self, this._then);

  final _POSMenusResponse _self;
  final $Res Function(_POSMenusResponse) _then;

/// Create a copy of POSMenusResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categories = null,}) {
  return _then(_POSMenusResponse(
categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<POSCategoryGroup>,
  ));
}


}


/// @nodoc
mixin _$POSCategoryGroup {

 String get id; String get name;@JsonKey(defaultValue: <POSMenuItem>[]) List<POSMenuItem> get menus;
/// Create a copy of POSCategoryGroup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$POSCategoryGroupCopyWith<POSCategoryGroup> get copyWith => _$POSCategoryGroupCopyWithImpl<POSCategoryGroup>(this as POSCategoryGroup, _$identity);

  /// Serializes this POSCategoryGroup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is POSCategoryGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.menus, menus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(menus));

@override
String toString() {
  return 'POSCategoryGroup(id: $id, name: $name, menus: $menus)';
}


}

/// @nodoc
abstract mixin class $POSCategoryGroupCopyWith<$Res>  {
  factory $POSCategoryGroupCopyWith(POSCategoryGroup value, $Res Function(POSCategoryGroup) _then) = _$POSCategoryGroupCopyWithImpl;
@useResult
$Res call({
 String id, String name,@JsonKey(defaultValue: <POSMenuItem>[]) List<POSMenuItem> menus
});




}
/// @nodoc
class _$POSCategoryGroupCopyWithImpl<$Res>
    implements $POSCategoryGroupCopyWith<$Res> {
  _$POSCategoryGroupCopyWithImpl(this._self, this._then);

  final POSCategoryGroup _self;
  final $Res Function(POSCategoryGroup) _then;

/// Create a copy of POSCategoryGroup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? menus = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,menus: null == menus ? _self.menus : menus // ignore: cast_nullable_to_non_nullable
as List<POSMenuItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [POSCategoryGroup].
extension POSCategoryGroupPatterns on POSCategoryGroup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _POSCategoryGroup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _POSCategoryGroup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _POSCategoryGroup value)  $default,){
final _that = this;
switch (_that) {
case _POSCategoryGroup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _POSCategoryGroup value)?  $default,){
final _that = this;
switch (_that) {
case _POSCategoryGroup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(defaultValue: <POSMenuItem>[])  List<POSMenuItem> menus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _POSCategoryGroup() when $default != null:
return $default(_that.id,_that.name,_that.menus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name, @JsonKey(defaultValue: <POSMenuItem>[])  List<POSMenuItem> menus)  $default,) {final _that = this;
switch (_that) {
case _POSCategoryGroup():
return $default(_that.id,_that.name,_that.menus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name, @JsonKey(defaultValue: <POSMenuItem>[])  List<POSMenuItem> menus)?  $default,) {final _that = this;
switch (_that) {
case _POSCategoryGroup() when $default != null:
return $default(_that.id,_that.name,_that.menus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _POSCategoryGroup implements POSCategoryGroup {
  const _POSCategoryGroup({required this.id, required this.name, @JsonKey(defaultValue: <POSMenuItem>[]) required final  List<POSMenuItem> menus}): _menus = menus;
  factory _POSCategoryGroup.fromJson(Map<String, dynamic> json) => _$POSCategoryGroupFromJson(json);

@override final  String id;
@override final  String name;
 final  List<POSMenuItem> _menus;
@override@JsonKey(defaultValue: <POSMenuItem>[]) List<POSMenuItem> get menus {
  if (_menus is EqualUnmodifiableListView) return _menus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_menus);
}


/// Create a copy of POSCategoryGroup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$POSCategoryGroupCopyWith<_POSCategoryGroup> get copyWith => __$POSCategoryGroupCopyWithImpl<_POSCategoryGroup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$POSCategoryGroupToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _POSCategoryGroup&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other._menus, _menus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_menus));

@override
String toString() {
  return 'POSCategoryGroup(id: $id, name: $name, menus: $menus)';
}


}

/// @nodoc
abstract mixin class _$POSCategoryGroupCopyWith<$Res> implements $POSCategoryGroupCopyWith<$Res> {
  factory _$POSCategoryGroupCopyWith(_POSCategoryGroup value, $Res Function(_POSCategoryGroup) _then) = __$POSCategoryGroupCopyWithImpl;
@override @useResult
$Res call({
 String id, String name,@JsonKey(defaultValue: <POSMenuItem>[]) List<POSMenuItem> menus
});




}
/// @nodoc
class __$POSCategoryGroupCopyWithImpl<$Res>
    implements _$POSCategoryGroupCopyWith<$Res> {
  __$POSCategoryGroupCopyWithImpl(this._self, this._then);

  final _POSCategoryGroup _self;
  final $Res Function(_POSCategoryGroup) _then;

/// Create a copy of POSCategoryGroup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? menus = null,}) {
  return _then(_POSCategoryGroup(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,menus: null == menus ? _self._menus : menus // ignore: cast_nullable_to_non_nullable
as List<POSMenuItem>,
  ));
}


}


/// @nodoc
mixin _$POSMenuItem {

 String get id; String get title; String? get description;@JsonKey(name: 'photo_url') String? get photoUrl;@JsonKey(name: 'available_stock') int get availableStock;@JsonKey(name: 'sell_price') int get sellPrice;
/// Create a copy of POSMenuItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$POSMenuItemCopyWith<POSMenuItem> get copyWith => _$POSMenuItemCopyWithImpl<POSMenuItem>(this as POSMenuItem, _$identity);

  /// Serializes this POSMenuItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is POSMenuItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,photoUrl,availableStock,sellPrice);

@override
String toString() {
  return 'POSMenuItem(id: $id, title: $title, description: $description, photoUrl: $photoUrl, availableStock: $availableStock, sellPrice: $sellPrice)';
}


}

/// @nodoc
abstract mixin class $POSMenuItemCopyWith<$Res>  {
  factory $POSMenuItemCopyWith(POSMenuItem value, $Res Function(POSMenuItem) _then) = _$POSMenuItemCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'available_stock') int availableStock,@JsonKey(name: 'sell_price') int sellPrice
});




}
/// @nodoc
class _$POSMenuItemCopyWithImpl<$Res>
    implements $POSMenuItemCopyWith<$Res> {
  _$POSMenuItemCopyWithImpl(this._self, this._then);

  final POSMenuItem _self;
  final $Res Function(POSMenuItem) _then;

/// Create a copy of POSMenuItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? photoUrl = freezed,Object? availableStock = null,Object? sellPrice = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as int,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [POSMenuItem].
extension POSMenuItemPatterns on POSMenuItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _POSMenuItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _POSMenuItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _POSMenuItem value)  $default,){
final _that = this;
switch (_that) {
case _POSMenuItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _POSMenuItem value)?  $default,){
final _that = this;
switch (_that) {
case _POSMenuItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'available_stock')  int availableStock, @JsonKey(name: 'sell_price')  int sellPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _POSMenuItem() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.photoUrl,_that.availableStock,_that.sellPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'available_stock')  int availableStock, @JsonKey(name: 'sell_price')  int sellPrice)  $default,) {final _that = this;
switch (_that) {
case _POSMenuItem():
return $default(_that.id,_that.title,_that.description,_that.photoUrl,_that.availableStock,_that.sellPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description, @JsonKey(name: 'photo_url')  String? photoUrl, @JsonKey(name: 'available_stock')  int availableStock, @JsonKey(name: 'sell_price')  int sellPrice)?  $default,) {final _that = this;
switch (_that) {
case _POSMenuItem() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.photoUrl,_that.availableStock,_that.sellPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _POSMenuItem extends POSMenuItem {
  const _POSMenuItem({required this.id, required this.title, this.description, @JsonKey(name: 'photo_url') this.photoUrl, @JsonKey(name: 'available_stock') required this.availableStock, @JsonKey(name: 'sell_price') required this.sellPrice}): super._();
  factory _POSMenuItem.fromJson(Map<String, dynamic> json) => _$POSMenuItemFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'photo_url') final  String? photoUrl;
@override@JsonKey(name: 'available_stock') final  int availableStock;
@override@JsonKey(name: 'sell_price') final  int sellPrice;

/// Create a copy of POSMenuItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$POSMenuItemCopyWith<_POSMenuItem> get copyWith => __$POSMenuItemCopyWithImpl<_POSMenuItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$POSMenuItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _POSMenuItem&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.photoUrl, photoUrl) || other.photoUrl == photoUrl)&&(identical(other.availableStock, availableStock) || other.availableStock == availableStock)&&(identical(other.sellPrice, sellPrice) || other.sellPrice == sellPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,photoUrl,availableStock,sellPrice);

@override
String toString() {
  return 'POSMenuItem(id: $id, title: $title, description: $description, photoUrl: $photoUrl, availableStock: $availableStock, sellPrice: $sellPrice)';
}


}

/// @nodoc
abstract mixin class _$POSMenuItemCopyWith<$Res> implements $POSMenuItemCopyWith<$Res> {
  factory _$POSMenuItemCopyWith(_POSMenuItem value, $Res Function(_POSMenuItem) _then) = __$POSMenuItemCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'photo_url') String? photoUrl,@JsonKey(name: 'available_stock') int availableStock,@JsonKey(name: 'sell_price') int sellPrice
});




}
/// @nodoc
class __$POSMenuItemCopyWithImpl<$Res>
    implements _$POSMenuItemCopyWith<$Res> {
  __$POSMenuItemCopyWithImpl(this._self, this._then);

  final _POSMenuItem _self;
  final $Res Function(_POSMenuItem) _then;

/// Create a copy of POSMenuItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? photoUrl = freezed,Object? availableStock = null,Object? sellPrice = null,}) {
  return _then(_POSMenuItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,photoUrl: freezed == photoUrl ? _self.photoUrl : photoUrl // ignore: cast_nullable_to_non_nullable
as String?,availableStock: null == availableStock ? _self.availableStock : availableStock // ignore: cast_nullable_to_non_nullable
as int,sellPrice: null == sellPrice ? _self.sellPrice : sellPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
