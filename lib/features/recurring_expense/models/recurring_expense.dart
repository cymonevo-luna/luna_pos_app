import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_expense.freezed.dart';
part 'recurring_expense.g.dart';

enum RecurringInterval {
  @JsonValue('DATE')
  date,
  @JsonValue('DAY')
  day,
  @JsonValue('DAILY')
  daily,
}

int _amountFromJson(dynamic value) {
  if (value is num) return value.toInt();
  if (value is String) return int.parse(value);
  throw FormatException('Invalid amount: $value');
}

dynamic _amountToJson(int value) => value;

DateTime? _nullableDateTimeFromJson(Object? value) {
  if (value == null) return null;
  if (value is String && value.isEmpty) return null;
  return DateTime.parse(value as String);
}

@freezed
abstract class RecurringScheduleTime with _$RecurringScheduleTime {
  const factory RecurringScheduleTime({
    required int hour,
    required int minute,
    required int second,
  }) = _RecurringScheduleTime;

  factory RecurringScheduleTime.fromJson(Map<String, dynamic> json) =>
      _$RecurringScheduleTimeFromJson(json);
}

@freezed
abstract class RecurringSchedule with _$RecurringSchedule {
  const factory RecurringSchedule({
    required RecurringInterval interval,
    int? value,
    required RecurringScheduleTime time,
  }) = _RecurringSchedule;

  factory RecurringSchedule.fromJson(Map<String, dynamic> json) =>
      _$RecurringScheduleFromJson(json);
}

@freezed
abstract class RecurringExpense with _$RecurringExpense {
  const factory RecurringExpense({
    required String id,
    required String title,
    String? description,
    @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
    required int amount,
    required RecurringSchedule recurring,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'next_run_at', fromJson: _nullableDateTimeFromJson)
    DateTime? nextRunAt,
    @JsonKey(name: 'last_run_at', fromJson: _nullableDateTimeFromJson)
    DateTime? lastRunAt,
    @JsonKey(name: 'created_at', fromJson: _nullableDateTimeFromJson)
    DateTime? createdAt,
    @JsonKey(name: 'updated_at', fromJson: _nullableDateTimeFromJson)
    DateTime? updatedAt,
    @JsonKey(name: 'staff_id') String? staffId,
  }) = _RecurringExpense;

  const RecurringExpense._();

  bool get isStaffManaged => staffId != null;

  factory RecurringExpense.fromJson(Map<String, dynamic> json) =>
      _$RecurringExpenseFromJson(json);
}

@freezed
abstract class RecurringExpenseRequest with _$RecurringExpenseRequest {
  const factory RecurringExpenseRequest({
    required String title,
    String? description,
    @JsonKey(fromJson: _amountFromJson, toJson: _amountToJson)
    required int amount,
    required RecurringSchedule recurring,
    @JsonKey(name: 'is_active') bool? isActive,
  }) = _RecurringExpenseRequest;

  factory RecurringExpenseRequest.fromJson(Map<String, dynamic> json) =>
      _$RecurringExpenseRequestFromJson(json);
}
