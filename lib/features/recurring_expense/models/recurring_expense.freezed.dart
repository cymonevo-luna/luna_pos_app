// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecurringScheduleTime {

 int get hour; int get minute; int get second;
/// Create a copy of RecurringScheduleTime
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringScheduleTimeCopyWith<RecurringScheduleTime> get copyWith => _$RecurringScheduleTimeCopyWithImpl<RecurringScheduleTime>(this as RecurringScheduleTime, _$identity);

  /// Serializes this RecurringScheduleTime to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringScheduleTime&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.second, second) || other.second == second));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,minute,second);

@override
String toString() {
  return 'RecurringScheduleTime(hour: $hour, minute: $minute, second: $second)';
}


}

/// @nodoc
abstract mixin class $RecurringScheduleTimeCopyWith<$Res>  {
  factory $RecurringScheduleTimeCopyWith(RecurringScheduleTime value, $Res Function(RecurringScheduleTime) _then) = _$RecurringScheduleTimeCopyWithImpl;
@useResult
$Res call({
 int hour, int minute, int second
});




}
/// @nodoc
class _$RecurringScheduleTimeCopyWithImpl<$Res>
    implements $RecurringScheduleTimeCopyWith<$Res> {
  _$RecurringScheduleTimeCopyWithImpl(this._self, this._then);

  final RecurringScheduleTime _self;
  final $Res Function(RecurringScheduleTime) _then;

/// Create a copy of RecurringScheduleTime
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? hour = null,Object? minute = null,Object? second = null,}) {
  return _then(_self.copyWith(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,second: null == second ? _self.second : second // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringScheduleTime].
extension RecurringScheduleTimePatterns on RecurringScheduleTime {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringScheduleTime value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringScheduleTime() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringScheduleTime value)  $default,){
final _that = this;
switch (_that) {
case _RecurringScheduleTime():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringScheduleTime value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringScheduleTime() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int hour,  int minute,  int second)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringScheduleTime() when $default != null:
return $default(_that.hour,_that.minute,_that.second);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int hour,  int minute,  int second)  $default,) {final _that = this;
switch (_that) {
case _RecurringScheduleTime():
return $default(_that.hour,_that.minute,_that.second);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int hour,  int minute,  int second)?  $default,) {final _that = this;
switch (_that) {
case _RecurringScheduleTime() when $default != null:
return $default(_that.hour,_that.minute,_that.second);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringScheduleTime implements RecurringScheduleTime {
  const _RecurringScheduleTime({required this.hour, required this.minute, required this.second});
  factory _RecurringScheduleTime.fromJson(Map<String, dynamic> json) => _$RecurringScheduleTimeFromJson(json);

@override final  int hour;
@override final  int minute;
@override final  int second;

/// Create a copy of RecurringScheduleTime
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringScheduleTimeCopyWith<_RecurringScheduleTime> get copyWith => __$RecurringScheduleTimeCopyWithImpl<_RecurringScheduleTime>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringScheduleTimeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringScheduleTime&&(identical(other.hour, hour) || other.hour == hour)&&(identical(other.minute, minute) || other.minute == minute)&&(identical(other.second, second) || other.second == second));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,hour,minute,second);

@override
String toString() {
  return 'RecurringScheduleTime(hour: $hour, minute: $minute, second: $second)';
}


}

/// @nodoc
abstract mixin class _$RecurringScheduleTimeCopyWith<$Res> implements $RecurringScheduleTimeCopyWith<$Res> {
  factory _$RecurringScheduleTimeCopyWith(_RecurringScheduleTime value, $Res Function(_RecurringScheduleTime) _then) = __$RecurringScheduleTimeCopyWithImpl;
@override @useResult
$Res call({
 int hour, int minute, int second
});




}
/// @nodoc
class __$RecurringScheduleTimeCopyWithImpl<$Res>
    implements _$RecurringScheduleTimeCopyWith<$Res> {
  __$RecurringScheduleTimeCopyWithImpl(this._self, this._then);

  final _RecurringScheduleTime _self;
  final $Res Function(_RecurringScheduleTime) _then;

/// Create a copy of RecurringScheduleTime
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? hour = null,Object? minute = null,Object? second = null,}) {
  return _then(_RecurringScheduleTime(
hour: null == hour ? _self.hour : hour // ignore: cast_nullable_to_non_nullable
as int,minute: null == minute ? _self.minute : minute // ignore: cast_nullable_to_non_nullable
as int,second: null == second ? _self.second : second // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$RecurringSchedule {

 RecurringInterval get interval; int? get value; RecurringScheduleTime get time;
/// Create a copy of RecurringSchedule
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringScheduleCopyWith<RecurringSchedule> get copyWith => _$RecurringScheduleCopyWithImpl<RecurringSchedule>(this as RecurringSchedule, _$identity);

  /// Serializes this RecurringSchedule to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringSchedule&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.value, value) || other.value == value)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,interval,value,time);

@override
String toString() {
  return 'RecurringSchedule(interval: $interval, value: $value, time: $time)';
}


}

/// @nodoc
abstract mixin class $RecurringScheduleCopyWith<$Res>  {
  factory $RecurringScheduleCopyWith(RecurringSchedule value, $Res Function(RecurringSchedule) _then) = _$RecurringScheduleCopyWithImpl;
@useResult
$Res call({
 RecurringInterval interval, int? value, RecurringScheduleTime time
});


$RecurringScheduleTimeCopyWith<$Res> get time;

}
/// @nodoc
class _$RecurringScheduleCopyWithImpl<$Res>
    implements $RecurringScheduleCopyWith<$Res> {
  _$RecurringScheduleCopyWithImpl(this._self, this._then);

  final RecurringSchedule _self;
  final $Res Function(RecurringSchedule) _then;

/// Create a copy of RecurringSchedule
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? interval = null,Object? value = freezed,Object? time = null,}) {
  return _then(_self.copyWith(
interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as RecurringInterval,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int?,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as RecurringScheduleTime,
  ));
}
/// Create a copy of RecurringSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurringScheduleTimeCopyWith<$Res> get time {
  
  return $RecurringScheduleTimeCopyWith<$Res>(_self.time, (value) {
    return _then(_self.copyWith(time: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecurringSchedule].
extension RecurringSchedulePatterns on RecurringSchedule {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringSchedule value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringSchedule() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringSchedule value)  $default,){
final _that = this;
switch (_that) {
case _RecurringSchedule():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringSchedule value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringSchedule() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecurringInterval interval,  int? value,  RecurringScheduleTime time)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringSchedule() when $default != null:
return $default(_that.interval,_that.value,_that.time);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecurringInterval interval,  int? value,  RecurringScheduleTime time)  $default,) {final _that = this;
switch (_that) {
case _RecurringSchedule():
return $default(_that.interval,_that.value,_that.time);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecurringInterval interval,  int? value,  RecurringScheduleTime time)?  $default,) {final _that = this;
switch (_that) {
case _RecurringSchedule() when $default != null:
return $default(_that.interval,_that.value,_that.time);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringSchedule implements RecurringSchedule {
  const _RecurringSchedule({required this.interval, this.value, required this.time});
  factory _RecurringSchedule.fromJson(Map<String, dynamic> json) => _$RecurringScheduleFromJson(json);

@override final  RecurringInterval interval;
@override final  int? value;
@override final  RecurringScheduleTime time;

/// Create a copy of RecurringSchedule
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringScheduleCopyWith<_RecurringSchedule> get copyWith => __$RecurringScheduleCopyWithImpl<_RecurringSchedule>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringScheduleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringSchedule&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.value, value) || other.value == value)&&(identical(other.time, time) || other.time == time));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,interval,value,time);

@override
String toString() {
  return 'RecurringSchedule(interval: $interval, value: $value, time: $time)';
}


}

/// @nodoc
abstract mixin class _$RecurringScheduleCopyWith<$Res> implements $RecurringScheduleCopyWith<$Res> {
  factory _$RecurringScheduleCopyWith(_RecurringSchedule value, $Res Function(_RecurringSchedule) _then) = __$RecurringScheduleCopyWithImpl;
@override @useResult
$Res call({
 RecurringInterval interval, int? value, RecurringScheduleTime time
});


@override $RecurringScheduleTimeCopyWith<$Res> get time;

}
/// @nodoc
class __$RecurringScheduleCopyWithImpl<$Res>
    implements _$RecurringScheduleCopyWith<$Res> {
  __$RecurringScheduleCopyWithImpl(this._self, this._then);

  final _RecurringSchedule _self;
  final $Res Function(_RecurringSchedule) _then;

/// Create a copy of RecurringSchedule
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? interval = null,Object? value = freezed,Object? time = null,}) {
  return _then(_RecurringSchedule(
interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as RecurringInterval,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as int?,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as RecurringScheduleTime,
  ));
}

/// Create a copy of RecurringSchedule
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurringScheduleTimeCopyWith<$Res> get time {
  
  return $RecurringScheduleTimeCopyWith<$Res>(_self.time, (value) {
    return _then(_self.copyWith(time: value));
  });
}
}


/// @nodoc
mixin _$RecurringExpense {

 String get id; String get title; String? get description;@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int get amount; RecurringSchedule get recurring;@JsonKey(name: 'is_active') bool get isActive;@JsonKey(name: 'next_run_at', fromJson: _nullableDateTimeFromJson) DateTime? get nextRunAt;@JsonKey(name: 'last_run_at', fromJson: _nullableDateTimeFromJson) DateTime? get lastRunAt;@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? get createdAt;@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? get updatedAt;@JsonKey(name: 'staff_id') String? get staffId;
/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringExpenseCopyWith<RecurringExpense> get copyWith => _$RecurringExpenseCopyWithImpl<RecurringExpense>(this as RecurringExpense, _$identity);

  /// Serializes this RecurringExpense to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.recurring, recurring) || other.recurring == recurring)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.nextRunAt, nextRunAt) || other.nextRunAt == nextRunAt)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.staffId, staffId) || other.staffId == staffId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,amount,recurring,isActive,nextRunAt,lastRunAt,createdAt,updatedAt,staffId);

@override
String toString() {
  return 'RecurringExpense(id: $id, title: $title, description: $description, amount: $amount, recurring: $recurring, isActive: $isActive, nextRunAt: $nextRunAt, lastRunAt: $lastRunAt, createdAt: $createdAt, updatedAt: $updatedAt, staffId: $staffId)';
}


}

/// @nodoc
abstract mixin class $RecurringExpenseCopyWith<$Res>  {
  factory $RecurringExpenseCopyWith(RecurringExpense value, $Res Function(RecurringExpense) _then) = _$RecurringExpenseCopyWithImpl;
@useResult
$Res call({
 String id, String title, String? description,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount, RecurringSchedule recurring,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'next_run_at', fromJson: _nullableDateTimeFromJson) DateTime? nextRunAt,@JsonKey(name: 'last_run_at', fromJson: _nullableDateTimeFromJson) DateTime? lastRunAt,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt,@JsonKey(name: 'staff_id') String? staffId
});


$RecurringScheduleCopyWith<$Res> get recurring;

}
/// @nodoc
class _$RecurringExpenseCopyWithImpl<$Res>
    implements $RecurringExpenseCopyWith<$Res> {
  _$RecurringExpenseCopyWithImpl(this._self, this._then);

  final RecurringExpense _self;
  final $Res Function(RecurringExpense) _then;

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? amount = null,Object? recurring = null,Object? isActive = null,Object? nextRunAt = freezed,Object? lastRunAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? staffId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as RecurringSchedule,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,nextRunAt: freezed == nextRunAt ? _self.nextRunAt : nextRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,staffId: freezed == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurringScheduleCopyWith<$Res> get recurring {
  
  return $RecurringScheduleCopyWith<$Res>(_self.recurring, (value) {
    return _then(_self.copyWith(recurring: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecurringExpense].
extension RecurringExpensePatterns on RecurringExpense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringExpense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringExpense value)  $default,){
final _that = this;
switch (_that) {
case _RecurringExpense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringExpense value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  RecurringSchedule recurring, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'next_run_at', fromJson: _nullableDateTimeFromJson)  DateTime? nextRunAt, @JsonKey(name: 'last_run_at', fromJson: _nullableDateTimeFromJson)  DateTime? lastRunAt, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt, @JsonKey(name: 'staff_id')  String? staffId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.amount,_that.recurring,_that.isActive,_that.nextRunAt,_that.lastRunAt,_that.createdAt,_that.updatedAt,_that.staffId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  RecurringSchedule recurring, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'next_run_at', fromJson: _nullableDateTimeFromJson)  DateTime? nextRunAt, @JsonKey(name: 'last_run_at', fromJson: _nullableDateTimeFromJson)  DateTime? lastRunAt, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt, @JsonKey(name: 'staff_id')  String? staffId)  $default,) {final _that = this;
switch (_that) {
case _RecurringExpense():
return $default(_that.id,_that.title,_that.description,_that.amount,_that.recurring,_that.isActive,_that.nextRunAt,_that.lastRunAt,_that.createdAt,_that.updatedAt,_that.staffId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  RecurringSchedule recurring, @JsonKey(name: 'is_active')  bool isActive, @JsonKey(name: 'next_run_at', fromJson: _nullableDateTimeFromJson)  DateTime? nextRunAt, @JsonKey(name: 'last_run_at', fromJson: _nullableDateTimeFromJson)  DateTime? lastRunAt, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)  DateTime? createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)  DateTime? updatedAt, @JsonKey(name: 'staff_id')  String? staffId)?  $default,) {final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.amount,_that.recurring,_that.isActive,_that.nextRunAt,_that.lastRunAt,_that.createdAt,_that.updatedAt,_that.staffId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringExpense extends RecurringExpense {
  const _RecurringExpense({required this.id, required this.title, this.description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) required this.amount, required this.recurring, @JsonKey(name: 'is_active') this.isActive = true, @JsonKey(name: 'next_run_at', fromJson: _nullableDateTimeFromJson) this.nextRunAt, @JsonKey(name: 'last_run_at', fromJson: _nullableDateTimeFromJson) this.lastRunAt, @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) this.createdAt, @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) this.updatedAt, @JsonKey(name: 'staff_id') this.staffId}): super._();
  factory _RecurringExpense.fromJson(Map<String, dynamic> json) => _$RecurringExpenseFromJson(json);

@override final  String id;
@override final  String title;
@override final  String? description;
@override@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) final  int amount;
@override final  RecurringSchedule recurring;
@override@JsonKey(name: 'is_active') final  bool isActive;
@override@JsonKey(name: 'next_run_at', fromJson: _nullableDateTimeFromJson) final  DateTime? nextRunAt;
@override@JsonKey(name: 'last_run_at', fromJson: _nullableDateTimeFromJson) final  DateTime? lastRunAt;
@override@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) final  DateTime? createdAt;
@override@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) final  DateTime? updatedAt;
@override@JsonKey(name: 'staff_id') final  String? staffId;

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringExpenseCopyWith<_RecurringExpense> get copyWith => __$RecurringExpenseCopyWithImpl<_RecurringExpense>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringExpenseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.recurring, recurring) || other.recurring == recurring)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.nextRunAt, nextRunAt) || other.nextRunAt == nextRunAt)&&(identical(other.lastRunAt, lastRunAt) || other.lastRunAt == lastRunAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.staffId, staffId) || other.staffId == staffId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,amount,recurring,isActive,nextRunAt,lastRunAt,createdAt,updatedAt,staffId);

@override
String toString() {
  return 'RecurringExpense(id: $id, title: $title, description: $description, amount: $amount, recurring: $recurring, isActive: $isActive, nextRunAt: $nextRunAt, lastRunAt: $lastRunAt, createdAt: $createdAt, updatedAt: $updatedAt, staffId: $staffId)';
}


}

/// @nodoc
abstract mixin class _$RecurringExpenseCopyWith<$Res> implements $RecurringExpenseCopyWith<$Res> {
  factory _$RecurringExpenseCopyWith(_RecurringExpense value, $Res Function(_RecurringExpense) _then) = __$RecurringExpenseCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String? description,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount, RecurringSchedule recurring,@JsonKey(name: 'is_active') bool isActive,@JsonKey(name: 'next_run_at', fromJson: _nullableDateTimeFromJson) DateTime? nextRunAt,@JsonKey(name: 'last_run_at', fromJson: _nullableDateTimeFromJson) DateTime? lastRunAt,@JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson) DateTime? createdAt,@JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson) DateTime? updatedAt,@JsonKey(name: 'staff_id') String? staffId
});


@override $RecurringScheduleCopyWith<$Res> get recurring;

}
/// @nodoc
class __$RecurringExpenseCopyWithImpl<$Res>
    implements _$RecurringExpenseCopyWith<$Res> {
  __$RecurringExpenseCopyWithImpl(this._self, this._then);

  final _RecurringExpense _self;
  final $Res Function(_RecurringExpense) _then;

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? amount = null,Object? recurring = null,Object? isActive = null,Object? nextRunAt = freezed,Object? lastRunAt = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,Object? staffId = freezed,}) {
  return _then(_RecurringExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as RecurringSchedule,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,nextRunAt: freezed == nextRunAt ? _self.nextRunAt : nextRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,lastRunAt: freezed == lastRunAt ? _self.lastRunAt : lastRunAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,staffId: freezed == staffId ? _self.staffId : staffId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurringScheduleCopyWith<$Res> get recurring {
  
  return $RecurringScheduleCopyWith<$Res>(_self.recurring, (value) {
    return _then(_self.copyWith(recurring: value));
  });
}
}


/// @nodoc
mixin _$RecurringExpenseRequest {

 String get title; String? get description;@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int get amount; RecurringSchedule get recurring;@JsonKey(name: 'is_active') bool? get isActive;
/// Create a copy of RecurringExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringExpenseRequestCopyWith<RecurringExpenseRequest> get copyWith => _$RecurringExpenseRequestCopyWithImpl<RecurringExpenseRequest>(this as RecurringExpenseRequest, _$identity);

  /// Serializes this RecurringExpenseRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringExpenseRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.recurring, recurring) || other.recurring == recurring)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,amount,recurring,isActive);

@override
String toString() {
  return 'RecurringExpenseRequest(title: $title, description: $description, amount: $amount, recurring: $recurring, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class $RecurringExpenseRequestCopyWith<$Res>  {
  factory $RecurringExpenseRequestCopyWith(RecurringExpenseRequest value, $Res Function(RecurringExpenseRequest) _then) = _$RecurringExpenseRequestCopyWithImpl;
@useResult
$Res call({
 String title, String? description,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount, RecurringSchedule recurring,@JsonKey(name: 'is_active') bool? isActive
});


$RecurringScheduleCopyWith<$Res> get recurring;

}
/// @nodoc
class _$RecurringExpenseRequestCopyWithImpl<$Res>
    implements $RecurringExpenseRequestCopyWith<$Res> {
  _$RecurringExpenseRequestCopyWithImpl(this._self, this._then);

  final RecurringExpenseRequest _self;
  final $Res Function(RecurringExpenseRequest) _then;

/// Create a copy of RecurringExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? description = freezed,Object? amount = null,Object? recurring = null,Object? isActive = freezed,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as RecurringSchedule,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}
/// Create a copy of RecurringExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurringScheduleCopyWith<$Res> get recurring {
  
  return $RecurringScheduleCopyWith<$Res>(_self.recurring, (value) {
    return _then(_self.copyWith(recurring: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecurringExpenseRequest].
extension RecurringExpenseRequestPatterns on RecurringExpenseRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringExpenseRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringExpenseRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringExpenseRequest value)  $default,){
final _that = this;
switch (_that) {
case _RecurringExpenseRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringExpenseRequest value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringExpenseRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  RecurringSchedule recurring, @JsonKey(name: 'is_active')  bool? isActive)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringExpenseRequest() when $default != null:
return $default(_that.title,_that.description,_that.amount,_that.recurring,_that.isActive);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  RecurringSchedule recurring, @JsonKey(name: 'is_active')  bool? isActive)  $default,) {final _that = this;
switch (_that) {
case _RecurringExpenseRequest():
return $default(_that.title,_that.description,_that.amount,_that.recurring,_that.isActive);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  String? description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)  int amount,  RecurringSchedule recurring, @JsonKey(name: 'is_active')  bool? isActive)?  $default,) {final _that = this;
switch (_that) {
case _RecurringExpenseRequest() when $default != null:
return $default(_that.title,_that.description,_that.amount,_that.recurring,_that.isActive);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecurringExpenseRequest implements RecurringExpenseRequest {
  const _RecurringExpenseRequest({required this.title, this.description, @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) required this.amount, required this.recurring, @JsonKey(name: 'is_active') this.isActive});
  factory _RecurringExpenseRequest.fromJson(Map<String, dynamic> json) => _$RecurringExpenseRequestFromJson(json);

@override final  String title;
@override final  String? description;
@override@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) final  int amount;
@override final  RecurringSchedule recurring;
@override@JsonKey(name: 'is_active') final  bool? isActive;

/// Create a copy of RecurringExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringExpenseRequestCopyWith<_RecurringExpenseRequest> get copyWith => __$RecurringExpenseRequestCopyWithImpl<_RecurringExpenseRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecurringExpenseRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringExpenseRequest&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.recurring, recurring) || other.recurring == recurring)&&(identical(other.isActive, isActive) || other.isActive == isActive));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,title,description,amount,recurring,isActive);

@override
String toString() {
  return 'RecurringExpenseRequest(title: $title, description: $description, amount: $amount, recurring: $recurring, isActive: $isActive)';
}


}

/// @nodoc
abstract mixin class _$RecurringExpenseRequestCopyWith<$Res> implements $RecurringExpenseRequestCopyWith<$Res> {
  factory _$RecurringExpenseRequestCopyWith(_RecurringExpenseRequest value, $Res Function(_RecurringExpenseRequest) _then) = __$RecurringExpenseRequestCopyWithImpl;
@override @useResult
$Res call({
 String title, String? description,@JsonKey(fromJson: _amountFromJson, toJson: _amountToJson) int amount, RecurringSchedule recurring,@JsonKey(name: 'is_active') bool? isActive
});


@override $RecurringScheduleCopyWith<$Res> get recurring;

}
/// @nodoc
class __$RecurringExpenseRequestCopyWithImpl<$Res>
    implements _$RecurringExpenseRequestCopyWith<$Res> {
  __$RecurringExpenseRequestCopyWithImpl(this._self, this._then);

  final _RecurringExpenseRequest _self;
  final $Res Function(_RecurringExpenseRequest) _then;

/// Create a copy of RecurringExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? description = freezed,Object? amount = null,Object? recurring = null,Object? isActive = freezed,}) {
  return _then(_RecurringExpenseRequest(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as int,recurring: null == recurring ? _self.recurring : recurring // ignore: cast_nullable_to_non_nullable
as RecurringSchedule,isActive: freezed == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}

/// Create a copy of RecurringExpenseRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecurringScheduleCopyWith<$Res> get recurring {
  
  return $RecurringScheduleCopyWith<$Res>(_self.recurring, (value) {
    return _then(_self.copyWith(recurring: value));
  });
}
}

// dart format on
