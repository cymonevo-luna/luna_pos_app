import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../models/recurring_expense.dart';

/// Compact schedule summary for recurring expense list rows.
class ScheduleSummaryChip extends StatelessWidget {
  const ScheduleSummaryChip({
    super.key,
    required this.schedule,
    this.isActive = true,
  });

  final RecurringSchedule schedule;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final timeLabel = _formatTime(schedule.time);
    final scheduleLabel = switch (schedule.interval) {
      RecurringInterval.daily => l10n.recurringScheduleDaily(timeLabel),
      RecurringInterval.date => l10n.recurringScheduleDate(
          schedule.value ?? 1,
          timeLabel,
        ),
      RecurringInterval.day => l10n.recurringScheduleDay(
          _weekdayLabel(l10n, schedule.value ?? 1),
          timeLabel,
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? context.colors.primary.withValues(alpha: 0.1)
            : context.colors.onSurface.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: 14,
            color: isActive ? context.colors.primary : context.colors.onSurface,
          ),
          const HGap(AppSpacing.xs),
          Flexible(
            child: Text(
              scheduleLabel,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isActive
                        ? context.colors.primary
                        : context.colors.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(RecurringScheduleTime time) {
    final dateTime = DateTime(2000, 1, 1, time.hour, time.minute, time.second);
    return DateFormat.Hms().format(dateTime);
  }

  String _weekdayLabel(AppLocalizations l10n, int value) => switch (value) {
        1 => l10n.weekdayMonday,
        2 => l10n.weekdayTuesday,
        3 => l10n.weekdayWednesday,
        4 => l10n.weekdayThursday,
        5 => l10n.weekdayFriday,
        6 => l10n.weekdaySaturday,
        7 => l10n.weekdaySunday,
        _ => value.toString(),
      };
}
