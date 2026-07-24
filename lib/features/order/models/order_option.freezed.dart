// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OrderOption {

 String get id; String get name; int get priority;@JsonKey(name: 'additional_price') int get additionalPrice;
/// Create a copy of OrderOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderOptionCopyWith<OrderOption> get copyWith => _$OrderOptionCopyWithImpl<OrderOption>(this as OrderOption, _$identity);

  /// Serializes this OrderOption to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.additionalPrice, additionalPrice) || other.additionalPrice == additionalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,priority,additionalPrice);

@override
String toString() {
  return 'OrderOption(id: $id, name: $name, priority: $priority, additionalPrice: $additionalPrice)';
}


}

/// @nodoc
abstract mixin class $OrderOptionCopyWith<$Res>  {
  factory $OrderOptionCopyWith(OrderOption value, $Res Function(OrderOption) _then) = _$OrderOptionCopyWithImpl;
@useResult
$Res call({
 String id, String name, int priority,@JsonKey(name: 'additional_price') int additionalPrice
});




}
/// @nodoc
class _$OrderOptionCopyWithImpl<$Res>
    implements $OrderOptionCopyWith<$Res> {
  _$OrderOptionCopyWithImpl(this._self, this._then);

  final OrderOption _self;
  final $Res Function(OrderOption) _then;

/// Create a copy of OrderOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? priority = null,Object? additionalPrice = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,additionalPrice: null == additionalPrice ? _self.additionalPrice : additionalPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderOption].
extension OrderOptionPatterns on OrderOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderOption value)  $default,){
final _that = this;
switch (_that) {
case _OrderOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderOption value)?  $default,){
final _that = this;
switch (_that) {
case _OrderOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  int priority, @JsonKey(name: 'additional_price')  int additionalPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderOption() when $default != null:
return $default(_that.id,_that.name,_that.priority,_that.additionalPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  int priority, @JsonKey(name: 'additional_price')  int additionalPrice)  $default,) {final _that = this;
switch (_that) {
case _OrderOption():
return $default(_that.id,_that.name,_that.priority,_that.additionalPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  int priority, @JsonKey(name: 'additional_price')  int additionalPrice)?  $default,) {final _that = this;
switch (_that) {
case _OrderOption() when $default != null:
return $default(_that.id,_that.name,_that.priority,_that.additionalPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderOption implements OrderOption {
  const _OrderOption({required this.id, required this.name, required this.priority, @JsonKey(name: 'additional_price') this.additionalPrice = 0});
  factory _OrderOption.fromJson(Map<String, dynamic> json) => _$OrderOptionFromJson(json);

@override final  String id;
@override final  String name;
@override final  int priority;
@override@JsonKey(name: 'additional_price') final  int additionalPrice;

/// Create a copy of OrderOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderOptionCopyWith<_OrderOption> get copyWith => __$OrderOptionCopyWithImpl<_OrderOption>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderOptionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderOption&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.additionalPrice, additionalPrice) || other.additionalPrice == additionalPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,priority,additionalPrice);

@override
String toString() {
  return 'OrderOption(id: $id, name: $name, priority: $priority, additionalPrice: $additionalPrice)';
}


}

/// @nodoc
abstract mixin class _$OrderOptionCopyWith<$Res> implements $OrderOptionCopyWith<$Res> {
  factory _$OrderOptionCopyWith(_OrderOption value, $Res Function(_OrderOption) _then) = __$OrderOptionCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, int priority,@JsonKey(name: 'additional_price') int additionalPrice
});




}
/// @nodoc
class __$OrderOptionCopyWithImpl<$Res>
    implements _$OrderOptionCopyWith<$Res> {
  __$OrderOptionCopyWithImpl(this._self, this._then);

  final _OrderOption _self;
  final $Res Function(_OrderOption) _then;

/// Create a copy of OrderOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? priority = null,Object? additionalPrice = null,}) {
  return _then(_OrderOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as int,additionalPrice: null == additionalPrice ? _self.additionalPrice : additionalPrice // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$OrderOptionsResponse {

 List<OrderOption> get options;
/// Create a copy of OrderOptionsResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OrderOptionsResponseCopyWith<OrderOptionsResponse> get copyWith => _$OrderOptionsResponseCopyWithImpl<OrderOptionsResponse>(this as OrderOptionsResponse, _$identity);

  /// Serializes this OrderOptionsResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OrderOptionsResponse&&const DeepCollectionEquality().equals(other.options, options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(options));

@override
String toString() {
  return 'OrderOptionsResponse(options: $options)';
}


}

/// @nodoc
abstract mixin class $OrderOptionsResponseCopyWith<$Res>  {
  factory $OrderOptionsResponseCopyWith(OrderOptionsResponse value, $Res Function(OrderOptionsResponse) _then) = _$OrderOptionsResponseCopyWithImpl;
@useResult
$Res call({
 List<OrderOption> options
});




}
/// @nodoc
class _$OrderOptionsResponseCopyWithImpl<$Res>
    implements $OrderOptionsResponseCopyWith<$Res> {
  _$OrderOptionsResponseCopyWithImpl(this._self, this._then);

  final OrderOptionsResponse _self;
  final $Res Function(OrderOptionsResponse) _then;

/// Create a copy of OrderOptionsResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? options = null,}) {
  return _then(_self.copyWith(
options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<OrderOption>,
  ));
}

}


/// Adds pattern-matching-related methods to [OrderOptionsResponse].
extension OrderOptionsResponsePatterns on OrderOptionsResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OrderOptionsResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OrderOptionsResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OrderOptionsResponse value)  $default,){
final _that = this;
switch (_that) {
case _OrderOptionsResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OrderOptionsResponse value)?  $default,){
final _that = this;
switch (_that) {
case _OrderOptionsResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<OrderOption> options)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OrderOptionsResponse() when $default != null:
return $default(_that.options);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<OrderOption> options)  $default,) {final _that = this;
switch (_that) {
case _OrderOptionsResponse():
return $default(_that.options);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<OrderOption> options)?  $default,) {final _that = this;
switch (_that) {
case _OrderOptionsResponse() when $default != null:
return $default(_that.options);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OrderOptionsResponse implements OrderOptionsResponse {
  const _OrderOptionsResponse({required final  List<OrderOption> options}): _options = options;
  factory _OrderOptionsResponse.fromJson(Map<String, dynamic> json) => _$OrderOptionsResponseFromJson(json);

 final  List<OrderOption> _options;
@override List<OrderOption> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}


/// Create a copy of OrderOptionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OrderOptionsResponseCopyWith<_OrderOptionsResponse> get copyWith => __$OrderOptionsResponseCopyWithImpl<_OrderOptionsResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OrderOptionsResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OrderOptionsResponse&&const DeepCollectionEquality().equals(other._options, _options));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_options));

@override
String toString() {
  return 'OrderOptionsResponse(options: $options)';
}


}

/// @nodoc
abstract mixin class _$OrderOptionsResponseCopyWith<$Res> implements $OrderOptionsResponseCopyWith<$Res> {
  factory _$OrderOptionsResponseCopyWith(_OrderOptionsResponse value, $Res Function(_OrderOptionsResponse) _then) = __$OrderOptionsResponseCopyWithImpl;
@override @useResult
$Res call({
 List<OrderOption> options
});




}
/// @nodoc
class __$OrderOptionsResponseCopyWithImpl<$Res>
    implements _$OrderOptionsResponseCopyWith<$Res> {
  __$OrderOptionsResponseCopyWithImpl(this._self, this._then);

  final _OrderOptionsResponse _self;
  final $Res Function(_OrderOptionsResponse) _then;

/// Create a copy of OrderOptionsResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? options = null,}) {
  return _then(_OrderOptionsResponse(
options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<OrderOption>,
  ));
}


}

// dart format on
