// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_supply.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodSupplyManualEditHistory {

@JsonKey(name: 'delta_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num get deltaQuantity;@JsonKey(name: 'previous_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num get previousQuantity;@JsonKey(name: 'new_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num get newQuantity;@JsonKey(name: 'changed_by_username') String get changedByUsername;@JsonKey(name: 'created_at') DateTime get createdAt;
/// Create a copy of FoodSupplyManualEditHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodSupplyManualEditHistoryCopyWith<FoodSupplyManualEditHistory> get copyWith => _$FoodSupplyManualEditHistoryCopyWithImpl<FoodSupplyManualEditHistory>(this as FoodSupplyManualEditHistory, _$identity);

  /// Serializes this FoodSupplyManualEditHistory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodSupplyManualEditHistory&&(identical(other.deltaQuantity, deltaQuantity) || other.deltaQuantity == deltaQuantity)&&(identical(other.previousQuantity, previousQuantity) || other.previousQuantity == previousQuantity)&&(identical(other.newQuantity, newQuantity) || other.newQuantity == newQuantity)&&(identical(other.changedByUsername, changedByUsername) || other.changedByUsername == changedByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deltaQuantity,previousQuantity,newQuantity,changedByUsername,createdAt);

@override
String toString() {
  return 'FoodSupplyManualEditHistory(deltaQuantity: $deltaQuantity, previousQuantity: $previousQuantity, newQuantity: $newQuantity, changedByUsername: $changedByUsername, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $FoodSupplyManualEditHistoryCopyWith<$Res>  {
  factory $FoodSupplyManualEditHistoryCopyWith(FoodSupplyManualEditHistory value, $Res Function(FoodSupplyManualEditHistory) _then) = _$FoodSupplyManualEditHistoryCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'delta_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num deltaQuantity,@JsonKey(name: 'previous_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num previousQuantity,@JsonKey(name: 'new_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num newQuantity,@JsonKey(name: 'changed_by_username') String changedByUsername,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class _$FoodSupplyManualEditHistoryCopyWithImpl<$Res>
    implements $FoodSupplyManualEditHistoryCopyWith<$Res> {
  _$FoodSupplyManualEditHistoryCopyWithImpl(this._self, this._then);

  final FoodSupplyManualEditHistory _self;
  final $Res Function(FoodSupplyManualEditHistory) _then;

/// Create a copy of FoodSupplyManualEditHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? deltaQuantity = null,Object? previousQuantity = null,Object? newQuantity = null,Object? changedByUsername = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
deltaQuantity: null == deltaQuantity ? _self.deltaQuantity : deltaQuantity // ignore: cast_nullable_to_non_nullable
as num,previousQuantity: null == previousQuantity ? _self.previousQuantity : previousQuantity // ignore: cast_nullable_to_non_nullable
as num,newQuantity: null == newQuantity ? _self.newQuantity : newQuantity // ignore: cast_nullable_to_non_nullable
as num,changedByUsername: null == changedByUsername ? _self.changedByUsername : changedByUsername // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodSupplyManualEditHistory].
extension FoodSupplyManualEditHistoryPatterns on FoodSupplyManualEditHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodSupplyManualEditHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodSupplyManualEditHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodSupplyManualEditHistory value)  $default,){
final _that = this;
switch (_that) {
case _FoodSupplyManualEditHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodSupplyManualEditHistory value)?  $default,){
final _that = this;
switch (_that) {
case _FoodSupplyManualEditHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'delta_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num deltaQuantity, @JsonKey(name: 'previous_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num previousQuantity, @JsonKey(name: 'new_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num newQuantity, @JsonKey(name: 'changed_by_username')  String changedByUsername, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodSupplyManualEditHistory() when $default != null:
return $default(_that.deltaQuantity,_that.previousQuantity,_that.newQuantity,_that.changedByUsername,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'delta_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num deltaQuantity, @JsonKey(name: 'previous_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num previousQuantity, @JsonKey(name: 'new_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num newQuantity, @JsonKey(name: 'changed_by_username')  String changedByUsername, @JsonKey(name: 'created_at')  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _FoodSupplyManualEditHistory():
return $default(_that.deltaQuantity,_that.previousQuantity,_that.newQuantity,_that.changedByUsername,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'delta_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num deltaQuantity, @JsonKey(name: 'previous_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num previousQuantity, @JsonKey(name: 'new_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num newQuantity, @JsonKey(name: 'changed_by_username')  String changedByUsername, @JsonKey(name: 'created_at')  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _FoodSupplyManualEditHistory() when $default != null:
return $default(_that.deltaQuantity,_that.previousQuantity,_that.newQuantity,_that.changedByUsername,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodSupplyManualEditHistory implements FoodSupplyManualEditHistory {
  const _FoodSupplyManualEditHistory({@JsonKey(name: 'delta_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) required this.deltaQuantity, @JsonKey(name: 'previous_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) required this.previousQuantity, @JsonKey(name: 'new_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) required this.newQuantity, @JsonKey(name: 'changed_by_username') required this.changedByUsername, @JsonKey(name: 'created_at') required this.createdAt});
  factory _FoodSupplyManualEditHistory.fromJson(Map<String, dynamic> json) => _$FoodSupplyManualEditHistoryFromJson(json);

@override@JsonKey(name: 'delta_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) final  num deltaQuantity;
@override@JsonKey(name: 'previous_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) final  num previousQuantity;
@override@JsonKey(name: 'new_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) final  num newQuantity;
@override@JsonKey(name: 'changed_by_username') final  String changedByUsername;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;

/// Create a copy of FoodSupplyManualEditHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodSupplyManualEditHistoryCopyWith<_FoodSupplyManualEditHistory> get copyWith => __$FoodSupplyManualEditHistoryCopyWithImpl<_FoodSupplyManualEditHistory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodSupplyManualEditHistoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodSupplyManualEditHistory&&(identical(other.deltaQuantity, deltaQuantity) || other.deltaQuantity == deltaQuantity)&&(identical(other.previousQuantity, previousQuantity) || other.previousQuantity == previousQuantity)&&(identical(other.newQuantity, newQuantity) || other.newQuantity == newQuantity)&&(identical(other.changedByUsername, changedByUsername) || other.changedByUsername == changedByUsername)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,deltaQuantity,previousQuantity,newQuantity,changedByUsername,createdAt);

@override
String toString() {
  return 'FoodSupplyManualEditHistory(deltaQuantity: $deltaQuantity, previousQuantity: $previousQuantity, newQuantity: $newQuantity, changedByUsername: $changedByUsername, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$FoodSupplyManualEditHistoryCopyWith<$Res> implements $FoodSupplyManualEditHistoryCopyWith<$Res> {
  factory _$FoodSupplyManualEditHistoryCopyWith(_FoodSupplyManualEditHistory value, $Res Function(_FoodSupplyManualEditHistory) _then) = __$FoodSupplyManualEditHistoryCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'delta_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num deltaQuantity,@JsonKey(name: 'previous_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num previousQuantity,@JsonKey(name: 'new_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num newQuantity,@JsonKey(name: 'changed_by_username') String changedByUsername,@JsonKey(name: 'created_at') DateTime createdAt
});




}
/// @nodoc
class __$FoodSupplyManualEditHistoryCopyWithImpl<$Res>
    implements _$FoodSupplyManualEditHistoryCopyWith<$Res> {
  __$FoodSupplyManualEditHistoryCopyWithImpl(this._self, this._then);

  final _FoodSupplyManualEditHistory _self;
  final $Res Function(_FoodSupplyManualEditHistory) _then;

/// Create a copy of FoodSupplyManualEditHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? deltaQuantity = null,Object? previousQuantity = null,Object? newQuantity = null,Object? changedByUsername = null,Object? createdAt = null,}) {
  return _then(_FoodSupplyManualEditHistory(
deltaQuantity: null == deltaQuantity ? _self.deltaQuantity : deltaQuantity // ignore: cast_nullable_to_non_nullable
as num,previousQuantity: null == previousQuantity ? _self.previousQuantity : previousQuantity // ignore: cast_nullable_to_non_nullable
as num,newQuantity: null == newQuantity ? _self.newQuantity : newQuantity // ignore: cast_nullable_to_non_nullable
as num,changedByUsername: null == changedByUsername ? _self.changedByUsername : changedByUsername // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$FoodSupply {

 String get id; String get title; String? get description;@JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num get stockQuantity; String get unit;@JsonKey(name: 'created_at') DateTime? get createdAt;@JsonKey(name: 'updated_at') DateTime? get updatedAt;@JsonKey(name: 'manual_edit_history', defaultValue: <FoodSupplyManualEditHistory>[]) List<FoodSupplyManualEditHistory> get manualEditHistory;
/// Create a copy of FoodSupply
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodSupplyCopyWith<FoodSupply> get copyWith => _$FoodSupplyCopyWithImpl<FoodSupply>(this as FoodSupply, _$identity);

  /// Serializes this FoodSupply to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodSupply&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other.manualEditHistory, manualEditHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,stockQuantity,unit,createdAt,updatedAt,const DeepCollectionEquality().hash(manualEditHistory));

@override
String toString() {
  return 'FoodSupply(id: $id, title: $title, description: $description, stockQuantity: $stockQuantity, unit: $unit, createdAt: $createdAt, updatedAt: $updatedAt, manualEditHistory: $manualEditHistory)';
}


}

/// @nodoc
abstract mixin class $FoodSupplyCopyWith<$Res>  {
  factory $FoodSupplyCopyWith(FoodSupply value, $Res Function(FoodSupply) _then) = _$FoodSupplyCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num stockQuantity, String unit,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'manual_edit_history', defaultValue: <FoodSupplyManualEditHistory>[]) List<FoodSupplyManualEditHistory> manualEditHistory
});




}
/// @nodoc
class _$FoodSupplyCopyWithImpl<$Res>
    implements $FoodSupplyCopyWith<$Res> {
  _$FoodSupplyCopyWithImpl(this._self, this._then);

  final FoodSupply _self;
  final $Res Function(FoodSupply) _then;

/// Create a copy of FoodSupply
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? stockQuantity = null,Object? unit = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? manualEditHistory = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as num,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,manualEditHistory: null == manualEditHistory ? _self.manualEditHistory : manualEditHistory // ignore: cast_nullable_to_non_nullable
as List<FoodSupplyManualEditHistory>,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodSupply].
extension FoodSupplyPatterns on FoodSupply {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodSupply value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodSupply() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodSupply value)  $default,){
final _that = this;
switch (_that) {
case _FoodSupply():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodSupply value)?  $default,){
final _that = this;
switch (_that) {
case _FoodSupply() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num stockQuantity,  String unit, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'manual_edit_history', defaultValue: <FoodSupplyManualEditHistory>[])  List<FoodSupplyManualEditHistory> manualEditHistory)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodSupply() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.stockQuantity,_that.unit,_that.createdAt,_that.updatedAt,_that.manualEditHistory);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num stockQuantity,  String unit, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'manual_edit_history', defaultValue: <FoodSupplyManualEditHistory>[])  List<FoodSupplyManualEditHistory> manualEditHistory)  $default,) {final _that = this;
switch (_that) {
case _FoodSupply():
return $default(_that.id,_that.title,_that.description,_that.stockQuantity,_that.unit,_that.createdAt,_that.updatedAt,_that.manualEditHistory);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description, @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num stockQuantity,  String unit, @JsonKey(name: 'created_at')  DateTime? createdAt, @JsonKey(name: 'updated_at')  DateTime? updatedAt, @JsonKey(name: 'manual_edit_history', defaultValue: <FoodSupplyManualEditHistory>[])  List<FoodSupplyManualEditHistory> manualEditHistory)?  $default,) {final _that = this;
switch (_that) {
case _FoodSupply() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.stockQuantity,_that.unit,_that.createdAt,_that.updatedAt,_that.manualEditHistory);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodSupply implements FoodSupply {
  const _FoodSupply({required this.id, required this.title, this.description, @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) required this.stockQuantity, required this.unit, @JsonKey(name: 'created_at') this.createdAt, @JsonKey(name: 'updated_at') this.updatedAt, @JsonKey(name: 'manual_edit_history', defaultValue: <FoodSupplyManualEditHistory>[]) final  List<FoodSupplyManualEditHistory> manualEditHistory = const <FoodSupplyManualEditHistory>[]}): _manualEditHistory = manualEditHistory;
  factory _FoodSupply.fromJson(Map<String, dynamic> json) => _$FoodSupplyFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) final  num stockQuantity;
@override final  String unit;
@override@JsonKey(name: 'created_at') final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at') final  DateTime? updatedAt;
 final  List<FoodSupplyManualEditHistory> _manualEditHistory;
@override@JsonKey(name: 'manual_edit_history', defaultValue: <FoodSupplyManualEditHistory>[]) List<FoodSupplyManualEditHistory> get manualEditHistory {
  if (_manualEditHistory is EqualUnmodifiableListView) return _manualEditHistory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_manualEditHistory);
}


/// Create a copy of FoodSupply
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodSupplyCopyWith<_FoodSupply> get copyWith => __$FoodSupplyCopyWithImpl<_FoodSupply>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodSupplyToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodSupply&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&const DeepCollectionEquality().equals(other._manualEditHistory, _manualEditHistory));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,stockQuantity,unit,createdAt,updatedAt,const DeepCollectionEquality().hash(_manualEditHistory));

@override
String toString() {
  return 'FoodSupply(id: $id, title: $title, description: $description, stockQuantity: $stockQuantity, unit: $unit, createdAt: $createdAt, updatedAt: $updatedAt, manualEditHistory: $manualEditHistory)';
}


}

/// @nodoc
abstract mixin class _$FoodSupplyCopyWith<$Res> implements $FoodSupplyCopyWith<$Res> {
  factory _$FoodSupplyCopyWith(_FoodSupply value, $Res Function(_FoodSupply) _then) = __$FoodSupplyCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description,@JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num stockQuantity, String unit,@JsonKey(name: 'created_at') DateTime? createdAt,@JsonKey(name: 'updated_at') DateTime? updatedAt,@JsonKey(name: 'manual_edit_history', defaultValue: <FoodSupplyManualEditHistory>[]) List<FoodSupplyManualEditHistory> manualEditHistory
});




}
/// @nodoc
class __$FoodSupplyCopyWithImpl<$Res>
    implements _$FoodSupplyCopyWith<$Res> {
  __$FoodSupplyCopyWithImpl(this._self, this._then);

  final _FoodSupply _self;
  final $Res Function(_FoodSupply) _then;

/// Create a copy of FoodSupply
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? stockQuantity = null,Object? unit = null,Object? createdAt = freezed,Object? updatedAt = freezed,Object? manualEditHistory = null,}) {
  return _then(_FoodSupply(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as num,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,manualEditHistory: null == manualEditHistory ? _self._manualEditHistory : manualEditHistory // ignore: cast_nullable_to_non_nullable
as List<FoodSupplyManualEditHistory>,
  ));
}


}


/// @nodoc
mixin _$FoodSupplyRequest {

 String get title; String? get description;@JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num get stockQuantity; String get unit;
/// Create a copy of FoodSupplyRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FoodSupplyRequestCopyWith<FoodSupplyRequest> get copyWith => _$FoodSupplyRequestCopyWithImpl<FoodSupplyRequest>(this as FoodSupplyRequest, _$identity);

  /// Serializes this FoodSupplyRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FoodSupplyRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,stockQuantity,unit);

@override
String toString() {
  return 'FoodSupplyRequest(title: $title, description: $description, stockQuantity: $stockQuantity, unit: $unit)';
}


}

/// @nodoc
abstract mixin class $FoodSupplyRequestCopyWith<$Res>  {
  factory $FoodSupplyRequestCopyWith(FoodSupplyRequest value, $Res Function(FoodSupplyRequest) _then) = _$FoodSupplyRequestCopyWithImpl;
@useResult
$Res call({
 String title, String? description,@JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num stockQuantity, String unit
});




}
/// @nodoc
class _$FoodSupplyRequestCopyWithImpl<$Res>
    implements $FoodSupplyRequestCopyWith<$Res> {
  _$FoodSupplyRequestCopyWithImpl(this._self, this._then);

  final FoodSupplyRequest _self;
  final $Res Function(FoodSupplyRequest) _then;

/// Create a copy of FoodSupplyRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? stockQuantity = null,Object? unit = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as num,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [FoodSupplyRequest].
extension FoodSupplyRequestPatterns on FoodSupplyRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FoodSupplyRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FoodSupplyRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FoodSupplyRequest value)  $default,){
final _that = this;
switch (_that) {
case _FoodSupplyRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FoodSupplyRequest value)?  $default,){
final _that = this;
switch (_that) {
case _FoodSupplyRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num stockQuantity,  String unit)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FoodSupplyRequest() when $default != null:
return $default(_that.title,_that.description,_that.stockQuantity,_that.unit);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num stockQuantity,  String unit)  $default,) {final _that = this;
switch (_that) {
case _FoodSupplyRequest():
return $default(_that.title,_that.description,_that.stockQuantity,_that.unit);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description, @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson)  num stockQuantity,  String unit)?  $default,) {final _that = this;
switch (_that) {
case _FoodSupplyRequest() when $default != null:
return $default(_that.title,_that.description,_that.stockQuantity,_that.unit);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FoodSupplyRequest implements FoodSupplyRequest {
  const _FoodSupplyRequest({required this.title, this.description, @JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) required this.stockQuantity, required this.unit});
  factory _FoodSupplyRequest.fromJson(Map<String, dynamic> json) => _$FoodSupplyRequestFromJson(json);

@override final  String title;
@override final  String? description;
@override@JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) final  num stockQuantity;
@override final  String unit;

/// Create a copy of FoodSupplyRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FoodSupplyRequestCopyWith<_FoodSupplyRequest> get copyWith => __$FoodSupplyRequestCopyWithImpl<_FoodSupplyRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FoodSupplyRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FoodSupplyRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.stockQuantity, stockQuantity) || other.stockQuantity == stockQuantity)&&(identical(other.unit, unit) || other.unit == unit));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,stockQuantity,unit);

@override
String toString() {
  return 'FoodSupplyRequest(title: $title, description: $description, stockQuantity: $stockQuantity, unit: $unit)';
}


}

/// @nodoc
abstract mixin class _$FoodSupplyRequestCopyWith<$Res> implements $FoodSupplyRequestCopyWith<$Res> {
  factory _$FoodSupplyRequestCopyWith(_FoodSupplyRequest value, $Res Function(_FoodSupplyRequest) _then) = __$FoodSupplyRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description,@JsonKey(name: 'stock_quantity', fromJson: _stockQuantityFromJson, toJson: _stockQuantityToJson) num stockQuantity, String unit
});




}
/// @nodoc
class __$FoodSupplyRequestCopyWithImpl<$Res>
    implements _$FoodSupplyRequestCopyWith<$Res> {
  __$FoodSupplyRequestCopyWithImpl(this._self, this._then);

  final _FoodSupplyRequest _self;
  final $Res Function(_FoodSupplyRequest) _then;

/// Create a copy of FoodSupplyRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? stockQuantity = null,Object? unit = null,}) {
  return _then(_FoodSupplyRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,stockQuantity: null == stockQuantity ? _self.stockQuantity : stockQuantity // ignore: cast_nullable_to_non_nullable
as num,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
