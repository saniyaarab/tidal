import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_flutter/features/calendar/domain/period_days.dart';

import '../../home/fakes/builders.dart';

void main() {
  test('covers the start through the end, inclusive', () {
    expect(expandPeriodDays([period(day(10, 3), days: 3)]), {
      day(10, 3),
      day(10, 4),
      day(10, 5),
    });
  });

  test('a period spanning two months includes days in both', () {
    final days = expandPeriodDays([period(day(10, 30), days: 4)]);
    expect(days, {day(10, 30), day(10, 31), day(11, 1), day(11, 2)});
  });

  test('a one-day period is one day', () {
    expect(expandPeriodDays([period(day(10, 3), days: 1)]), {day(10, 3)});
  });

  test('overlapping spans merge', () {
    final days = expandPeriodDays([
      period(day(10, 3), days: 3),
      period(day(10, 5), days: 3),
    ]);
    expect(days, hasLength(5));
  });

  test('no spans gives no days', () {
    expect(expandPeriodDays([]), isEmpty);
  });
}
