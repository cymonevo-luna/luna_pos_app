// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'daily_menu_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DailyMenuSummaryItem {

@JsonKey(name: 'menu_id') String get menuId;@JsonKey(name: 'menu_title') String get menuTitle;@JsonKey(name: 'quantity_sold') int get quantitySold;@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int get revenue;
/// Create a copy of DailyMenuSummaryItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyMenuSummaryItemCopyWith<DailyMenuSummaryItem> get copyWith => _$DailyMenuSummaryItemCopyWithImpl<DailyMenuSummaryItem>(this as DailyMenuSummaryItem, _$identity);

  /// Serializes this DailyMenuSummaryItem to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyMenuSummaryItem&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.menuTitle, menuTitle) || other.menuTitle == menuTitle)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuId,menuTitle,quantitySold,revenue);

@override
String toString() {
  return 'DailyMenuSummaryItem(menuId: $menuId, menuTitle: $menuTitle, quantitySold: $quantitySold, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class $DailyMenuSummaryItemCopyWith<$Res>  {
  factory $DailyMenuSummaryItemCopyWith(DailyMenuSummaryItem value, $Res Function(DailyMenuSummaryItem) _then) = _$DailyMenuSummaryItemCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'menu_id') String menuId,@JsonKey(name: 'menu_title') String menuTitle,@JsonKey(name: 'quantity_sold') int quantitySold,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int revenue
});




}
/// @nodoc
class _$DailyMenuSummaryItemCopyWithImpl<$Res>
    implements $DailyMenuSummaryItemCopyWith<$Res> {
  _$DailyMenuSummaryItemCopyWithImpl(this._self, this._then);

  final DailyMenuSummaryItem _self;
  final $Res Function(DailyMenuSummaryItem) _then;

/// Create a copy of DailyMenuSummaryItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? menuId = null,Object? menuTitle = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(_self.copyWith(
menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,menuTitle: null == menuTitle ? _self.menuTitle : menuTitle // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyMenuSummaryItem].
extension DailyMenuSummaryItemPatterns on DailyMenuSummaryItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyMenuSummaryItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyMenuSummaryItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyMenuSummaryItem value)  $default,){
final _that = this;
switch (_that) {
case _DailyMenuSummaryItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyMenuSummaryItem value)?  $default,){
final _that = this;
switch (_that) {
case _DailyMenuSummaryItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'menu_id')  String menuId, @JsonKey(name: 'menu_title')  String menuTitle, @JsonKey(name: 'quantity_sold')  int quantitySold, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int revenue)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyMenuSummaryItem() when $default != null:
return $default(_that.menuId,_that.menuTitle,_that.quantitySold,_that.revenue);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'menu_id')  String menuId, @JsonKey(name: 'menu_title')  String menuTitle, @JsonKey(name: 'quantity_sold')  int quantitySold, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int revenue)  $default,) {final _that = this;
switch (_that) {
case _DailyMenuSummaryItem():
return $default(_that.menuId,_that.menuTitle,_that.quantitySold,_that.revenue);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'menu_id')  String menuId, @JsonKey(name: 'menu_title')  String menuTitle, @JsonKey(name: 'quantity_sold')  int quantitySold, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int revenue)?  $default,) {final _that = this;
switch (_that) {
case _DailyMenuSummaryItem() when $default != null:
return $default(_that.menuId,_that.menuTitle,_that.quantitySold,_that.revenue);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyMenuSummaryItem implements DailyMenuSummaryItem {
  const _DailyMenuSummaryItem({@JsonKey(name: 'menu_id') required this.menuId, @JsonKey(name: 'menu_title') required this.menuTitle, @JsonKey(name: 'quantity_sold') required this.quantitySold, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) required this.revenue});
  factory _DailyMenuSummaryItem.fromJson(Map<String, dynamic> json) => _$DailyMenuSummaryItemFromJson(json);

@override@JsonKey(name: 'menu_id') final  String menuId;
@override@JsonKey(name: 'menu_title') final  String menuTitle;
@override@JsonKey(name: 'quantity_sold') final  int quantitySold;
@override@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) final  int revenue;

/// Create a copy of DailyMenuSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyMenuSummaryItemCopyWith<_DailyMenuSummaryItem> get copyWith => __$DailyMenuSummaryItemCopyWithImpl<_DailyMenuSummaryItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyMenuSummaryItemToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyMenuSummaryItem&&(identical(other.menuId, menuId) || other.menuId == menuId)&&(identical(other.menuTitle, menuTitle) || other.menuTitle == menuTitle)&&(identical(other.quantitySold, quantitySold) || other.quantitySold == quantitySold)&&(identical(other.revenue, revenue) || other.revenue == revenue));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,menuId,menuTitle,quantitySold,revenue);

@override
String toString() {
  return 'DailyMenuSummaryItem(menuId: $menuId, menuTitle: $menuTitle, quantitySold: $quantitySold, revenue: $revenue)';
}


}

/// @nodoc
abstract mixin class _$DailyMenuSummaryItemCopyWith<$Res> implements $DailyMenuSummaryItemCopyWith<$Res> {
  factory _$DailyMenuSummaryItemCopyWith(_DailyMenuSummaryItem value, $Res Function(_DailyMenuSummaryItem) _then) = __$DailyMenuSummaryItemCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'menu_id') String menuId,@JsonKey(name: 'menu_title') String menuTitle,@JsonKey(name: 'quantity_sold') int quantitySold,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int revenue
});




}
/// @nodoc
class __$DailyMenuSummaryItemCopyWithImpl<$Res>
    implements _$DailyMenuSummaryItemCopyWith<$Res> {
  __$DailyMenuSummaryItemCopyWithImpl(this._self, this._then);

  final _DailyMenuSummaryItem _self;
  final $Res Function(_DailyMenuSummaryItem) _then;

/// Create a copy of DailyMenuSummaryItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? menuId = null,Object? menuTitle = null,Object? quantitySold = null,Object? revenue = null,}) {
  return _then(_DailyMenuSummaryItem(
menuId: null == menuId ? _self.menuId : menuId // ignore: cast_nullable_to_non_nullable
as String,menuTitle: null == menuTitle ? _self.menuTitle : menuTitle // ignore: cast_nullable_to_non_nullable
as String,quantitySold: null == quantitySold ? _self.quantitySold : quantitySold // ignore: cast_nullable_to_non_nullable
as int,revenue: null == revenue ? _self.revenue : revenue // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$DailyMenuSummaryResponse {

@JsonKey(name: 'date_from') String get dateFrom;@JsonKey(name: 'date_to') String get dateTo;@JsonKey(name: 'total_revenue', fromJson: _amountFromJson, toJson: _amountToJson) int get totalRevenue;@JsonKey(name: 'total_quantity') int get totalQuantity; List<DailyMenuSummaryItem> get menus;
/// Create a copy of DailyMenuSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DailyMenuSummaryResponseCopyWith<DailyMenuSummaryResponse> get copyWith => _$DailyMenuSummaryResponseCopyWithImpl<DailyMenuSummaryResponse>(this as DailyMenuSummaryResponse, _$identity);

  /// Serializes this DailyMenuSummaryResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DailyMenuSummaryResponse&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&const DeepCollectionEquality().equals(other.menus, menus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dateFrom,dateTo,totalRevenue,totalQuantity,const DeepCollectionEquality().hash(menus));

@override
String toString() {
  return 'DailyMenuSummaryResponse(dateFrom: $dateFrom, dateTo: $dateTo, totalRevenue: $totalRevenue, totalQuantity: $totalQuantity, menus: $menus)';
}


}

/// @nodoc
abstract mixin class $DailyMenuSummaryResponseCopyWith<$Res>  {
  factory $DailyMenuSummaryResponseCopyWith(DailyMenuSummaryResponse value, $Res Function(DailyMenuSummaryResponse) _then) = _$DailyMenuSummaryResponseCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'date_from') String dateFrom,@JsonKey(name: 'date_to') String dateTo,@JsonKey(name: 'total_revenue', fromJson: _amountFromJson, toJson: _amountToJson) int totalRevenue,@JsonKey(name: 'total_quantity') int totalQuantity, List<DailyMenuSummaryItem> menus
});




}
/// @nodoc
class _$DailyMenuSummaryResponseCopyWithImpl<$Res>
    implements $DailyMenuSummaryResponseCopyWith<$Res> {
  _$DailyMenuSummaryResponseCopyWithImpl(this._self, this._then);

  final DailyMenuSummaryResponse _self;
  final $Res Function(DailyMenuSummaryResponse) _then;

/// Create a copy of DailyMenuSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dateFrom = null,Object? dateTo = null,Object? totalRevenue = null,Object? totalQuantity = null,Object? menus = null,}) {
  return _then(_self.copyWith(
dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as int,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,menus: null == menus ? _self.menus : menus // ignore: cast_nullable_to_non_nullable
as List<DailyMenuSummaryItem>,
  ));
}

}


/// Adds pattern-matching-related methods to [DailyMenuSummaryResponse].
extension DailyMenuSummaryResponsePatterns on DailyMenuSummaryResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DailyMenuSummaryResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DailyMenuSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DailyMenuSummaryResponse value)  $default,){
final _that = this;
switch (_that) {
case _DailyMenuSummaryResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DailyMenuSummaryResponse value)?  $default,){
final _that = this;
switch (_that) {
case _DailyMenuSummaryResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'date_from')  String dateFrom, @JsonKey(name: 'date_to')  String dateTo, @JsonKey(name: 'total_revenue', fromJson: _amountFromJson, toJson: _amountToJson)  int totalRevenue, @JsonKey(name: 'total_quantity')  int totalQuantity,  List<DailyMenuSummaryItem> menus)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DailyMenuSummaryResponse() when $default != null:
return $default(_that.dateFrom,_that.dateTo,_that.totalRevenue,_that.totalQuantity,_that.menus);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'date_from')  String dateFrom, @JsonKey(name: 'date_to')  String dateTo, @JsonKey(name: 'total_revenue', fromJson: _amountFromJson, toJson: _amountToJson)  int totalRevenue, @JsonKey(name: 'total_quantity')  int totalQuantity,  List<DailyMenuSummaryItem> menus)  $default,) {final _that = this;
switch (_that) {
case _DailyMenuSummaryResponse():
return $default(_that.dateFrom,_that.dateTo,_that.totalRevenue,_that.totalQuantity,_that.menus);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'date_from')  String dateFrom, @JsonKey(name: 'date_to')  String dateTo, @JsonKey(name: 'total_revenue', fromJson: _amountFromJson, toJson: _amountToJson)  int totalRevenue, @JsonKey(name: 'total_quantity')  int totalQuantity,  List<DailyMenuSummaryItem> menus)?  $default,) {final _that = this;
switch (_that) {
case _DailyMenuSummaryResponse() when $default != null:
return $default(_that.dateFrom,_that.dateTo,_that.totalRevenue,_that.totalQuantity,_that.menus);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DailyMenuSummaryResponse implements DailyMenuSummaryResponse {
  const _DailyMenuSummaryResponse({@JsonKey(name: 'date_from') required this.dateFrom, @JsonKey(name: 'date_to') required this.dateTo, @JsonKey(name: 'total_revenue', fromJson: _amountFromJson, toJson: _amountToJson) required this.totalRevenue, @JsonKey(name: 'total_quantity') required this.totalQuantity, required final  List<DailyMenuSummaryItem> menus}): _menus = menus;
  factory _DailyMenuSummaryResponse.fromJson(Map<String, dynamic> json) => _$DailyMenuSummaryResponseFromJson(json);

@override@JsonKey(name: 'date_from') final  String dateFrom;
@override@JsonKey(name: 'date_to') final  String dateTo;
@override@JsonKey(name: 'total_revenue', fromJson: _amountFromJson, toJson: _amountToJson) final  int totalRevenue;
@override@JsonKey(name: 'total_quantity') final  int totalQuantity;
 final  List<DailyMenuSummaryItem> _menus;
@override List<DailyMenuSummaryItem> get menus {
  if (_menus is EqualUnmodifiableListView) return _menus;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_menus);
}


/// Create a copy of DailyMenuSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DailyMenuSummaryResponseCopyWith<_DailyMenuSummaryResponse> get copyWith => __$DailyMenuSummaryResponseCopyWithImpl<_DailyMenuSummaryResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DailyMenuSummaryResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DailyMenuSummaryResponse&&(identical(other.dateFrom, dateFrom) || other.dateFrom == dateFrom)&&(identical(other.dateTo, dateTo) || other.dateTo == dateTo)&&(identical(other.totalRevenue, totalRevenue) || other.totalRevenue == totalRevenue)&&(identical(other.totalQuantity, totalQuantity) || other.totalQuantity == totalQuantity)&&const DeepCollectionEquality().equals(other._menus, _menus));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dateFrom,dateTo,totalRevenue,totalQuantity,const DeepCollectionEquality().hash(_menus));

@override
String toString() {
  return 'DailyMenuSummaryResponse(dateFrom: $dateFrom, dateTo: $dateTo, totalRevenue: $totalRevenue, totalQuantity: $totalQuantity, menus: $menus)';
}


}

/// @nodoc
abstract mixin class _$DailyMenuSummaryResponseCopyWith<$Res> implements $DailyMenuSummaryResponseCopyWith<$Res> {
  factory _$DailyMenuSummaryResponseCopyWith(_DailyMenuSummaryResponse value, $Res Function(_DailyMenuSummaryResponse) _then) = __$DailyMenuSummaryResponseCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'date_from') String dateFrom,@JsonKey(name: 'date_to') String dateTo,@JsonKey(name: 'total_revenue', fromJson: _amountFromJson, toJson: _amountToJson) int totalRevenue,@JsonKey(name: 'total_quantity') int totalQuantity, List<DailyMenuSummaryItem> menus
});




}
/// @nodoc
class __$DailyMenuSummaryResponseCopyWithImpl<$Res>
    implements _$DailyMenuSummaryResponseCopyWith<$Res> {
  __$DailyMenuSummaryResponseCopyWithImpl(this._self, this._then);

  final _DailyMenuSummaryResponse _self;
  final $Res Function(_DailyMenuSummaryResponse) _then;

/// Create a copy of DailyMenuSummaryResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dateFrom = null,Object? dateTo = null,Object? totalRevenue = null,Object? totalQuantity = null,Object? menus = null,}) {
  return _then(_DailyMenuSummaryResponse(
dateFrom: null == dateFrom ? _self.dateFrom : dateFrom // ignore: cast_nullable_to_non_nullable
as String,dateTo: null == dateTo ? _self.dateTo : dateTo // ignore: cast_nullable_to_non_nullable
as String,totalRevenue: null == totalRevenue ? _self.totalRevenue : totalRevenue // ignore: cast_nullable_to_non_nullable
as int,totalQuantity: null == totalQuantity ? _self.totalQuantity : totalQuantity // ignore: cast_nullable_to_non_nullable
as int,menus: null == menus ? _self._menus : menus // ignore: cast_nullable_to_non_nullable
as List<DailyMenuSummaryItem>,
  ));
}


}

// dart format on
