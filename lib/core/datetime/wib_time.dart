import 'package:intl/intl.dart';

/// Western Indonesian Time offset (GMT+07:00).
const Duration wibOffset = Duration(hours: 7);

/// Injectable clock for tests. Defaults to [DateTime.now].
DateTime Function() wibClock = DateTime.now;

/// Current instant as WIB wall-clock components (device timezone ignored).
DateTime nowWib() => utcToWib(wibClock().toUtc());

/// Today's WIB calendar date as `yyyy-MM-dd`.
String todayWibDateString() => toApiDateParam(nowWib());

/// Formats a UTC [instant] in WIB using [pattern] (default `yyyy-MM-dd`).
String formatWib(DateTime instant, {String pattern = 'yyyy-MM-dd'}) {
  return DateFormat(pattern).format(utcToWib(instant.toUtc()));
}

/// Last 30 WIB calendar days through today (inclusive).
(String from, String to) defaultReportRange() {
  final today = nowWib();
  final from = DateTime(today.year, today.month, today.day)
      .subtract(const Duration(days: 29));
  return (toApiDateParam(from), toApiDateParam(today));
}

/// WIB calendar date string (`yyyy-MM-dd`) for API `date_from` / `date_to` params.
///
/// UTC instants are shifted to WIB before extracting the calendar date.
/// Non-UTC values use their year/month/day as the WIB calendar date (e.g. date
/// picker selections that already represent a business day).
String toApiDateParam(DateTime dt) {
  if (dt.isUtc) {
    final wib = dt.add(wibOffset);
    return _formatYyyyMmDd(wib.year, wib.month, wib.day);
  }
  return _formatYyyyMmDd(dt.year, dt.month, dt.day);
}

/// Converts a UTC instant to WIB wall-clock components.
DateTime utcToWib(DateTime utc) {
  final shifted = utc.add(wibOffset);
  return DateTime(
    shifted.year,
    shifted.month,
    shifted.day,
    shifted.hour,
    shifted.minute,
    shifted.second,
    shifted.millisecond,
    shifted.microsecond,
  );
}

String _formatYyyyMmDd(int year, int month, int day) {
  final y = year.toString().padLeft(4, '0');
  final m = month.toString().padLeft(2, '0');
  final d = day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
