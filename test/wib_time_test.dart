import 'package:flutter_test/flutter_test.dart';
import 'package:luna_pos/core/datetime/wib_time.dart';

void main() {
  tearDown(() {
    wibClock = DateTime.now;
  });

  group('nowWib', () {
    test('maps UTC instant to WIB wall clock', () {
      wibClock = () => DateTime.utc(2026, 1, 1, 10, 30);

      final wib = nowWib();

      expect(wib.year, 2026);
      expect(wib.month, 1);
      expect(wib.day, 1);
      expect(wib.hour, 17);
      expect(wib.minute, 30);
    });
  });

  group('todayWibDateString', () {
    test('uses previous WIB day before 17:00 UTC', () {
      wibClock = () => DateTime.utc(2025, 12, 31, 16, 59, 59);

      expect(todayWibDateString(), '2025-12-31');
    });

    test('rolls to next WIB day at 17:00 UTC boundary', () {
      wibClock = () => DateTime.utc(2025, 12, 31, 17, 0);

      expect(todayWibDateString(), '2026-01-01');
    });
  });

  group('formatWib', () {
    test('formats UTC instant in WIB with default pattern', () {
      final utc = DateTime.utc(2025, 12, 31, 16, 30);

      expect(formatWib(utc), '2025-12-31');
    });

    test('supports custom pattern', () {
      final utc = DateTime.utc(2026, 1, 1, 17, 30);

      expect(formatWib(utc, pattern: 'yyyy-MM-dd HH:mm'), '2026-01-02 00:30');
    });
  });

  group('defaultReportRange', () {
    test('returns 30 inclusive WIB days ending today', () {
      wibClock = () => DateTime.utc(2026, 1, 25, 20);

      final (from, to) = defaultReportRange();

      expect(to, '2026-01-26');
      expect(from, '2025-12-28');
    });
  });

  group('toApiDateParam', () {
    test('converts UTC instant to WIB calendar date', () {
      final utc = DateTime.utc(2025, 12, 31, 17, 0);

      expect(toApiDateParam(utc), '2026-01-01');
    });

    test('uses calendar fields for non-UTC values', () {
      final picked = DateTime(2026, 3, 15);

      expect(toApiDateParam(picked), '2026-03-15');
    });
  });
}
