// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RecurringScheduleTime _$RecurringScheduleTimeFromJson(
  Map<String, dynamic> json,
) => _RecurringScheduleTime(
  hour: (json['hour'] as num).toInt(),
  minute: (json['minute'] as num).toInt(),
  second: (json['second'] as num).toInt(),
);

Map<String, dynamic> _$RecurringScheduleTimeToJson(
  _RecurringScheduleTime instance,
) => <String, dynamic>{
  'hour': instance.hour,
  'minute': instance.minute,
  'second': instance.second,
};

_RecurringSchedule _$RecurringScheduleFromJson(Map<String, dynamic> json) =>
    _RecurringSchedule(
      interval: $enumDecode(_$RecurringIntervalEnumMap, json['interval']),
      value: (json['value'] as num?)?.toInt(),
      time: RecurringScheduleTime.fromJson(
        json['time'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$RecurringScheduleToJson(_RecurringSchedule instance) =>
    <String, dynamic>{
      'interval': _$RecurringIntervalEnumMap[instance.interval]!,
      'value': instance.value,
      'time': instance.time,
    };

const _$RecurringIntervalEnumMap = {
  RecurringInterval.date: 'DATE',
  RecurringInterval.day: 'DAY',
  RecurringInterval.daily: 'DAILY',
};

_RecurringExpense _$RecurringExpenseFromJson(Map<String, dynamic> json) =>
    _RecurringExpense(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      amount: _amountFromJson(json['amount']),
      recurring: RecurringSchedule.fromJson(
        json['recurring'] as Map<String, dynamic>,
      ),
      isActive: json['is_active'] as bool? ?? true,
      nextRunAt: _nullableDateTimeFromJson(json['next_run_at']),
      lastRunAt: _nullableDateTimeFromJson(json['last_run_at']),
      createdAt: _nullableDateTimeFromJson(json['created_at']),
      updatedAt: _nullableDateTimeFromJson(json['updated_at']),
    );

Map<String, dynamic> _$RecurringExpenseToJson(_RecurringExpense instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'amount': _amountToJson(instance.amount),
      'recurring': instance.recurring,
      'is_active': instance.isActive,
      'next_run_at': instance.nextRunAt?.toIso8601String(),
      'last_run_at': instance.lastRunAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

_RecurringExpenseRequest _$RecurringExpenseRequestFromJson(
  Map<String, dynamic> json,
) => _RecurringExpenseRequest(
  title: json['title'] as String,
  description: json['description'] as String?,
  amount: _amountFromJson(json['amount']),
  recurring: RecurringSchedule.fromJson(
    json['recurring'] as Map<String, dynamic>,
  ),
  isActive: json['is_active'] as bool?,
);

Map<String, dynamic> _$RecurringExpenseRequestToJson(
  _RecurringExpenseRequest instance,
) => <String, dynamic>{
  'title': instance.title,
  'description': instance.description,
  'amount': _amountToJson(instance.amount),
  'recurring': instance.recurring,
  'is_active': instance.isActive,
};
