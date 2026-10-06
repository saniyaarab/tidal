import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_flutter/features/calendar/domain/calendar_grid.dart';

import '../../home/fakes/builders.dart';

void main() {
  test('a month starting on a Sunday has no leading days', () {
    // 1 Nov 2026 is a Sunday.
    expect(CalendarGrid(day(11, 1)).gridStart, day(11, 1));
  });

  test('a month starting on a Monday has one leading day', () {
    // 1 Jun 2026 is a Monday.
    expect(CalendarGrid(day(6, 1)).gridStart, day(5, 31));
  });

  test('a month starting on a Saturday has six leading days', () {
    // 1 Aug 2026 is a Saturday.
    expect(CalendarGrid(day(8, 1)).gridStart, day(7, 26));
  });

  test('the grid is 42 consecutive days from gridStart', () {
    final grid = CalendarGrid(day(10, 1));
    expect(grid.dates, hasLength(42));
    expect(grid.dates.first, grid.gridStart);
    for (var i = 1; i < 42; i++) {
      expect(grid.dates[i].difference(grid.dates[i - 1]).inDays, 1);
    }
    expect(grid.gridEnd, grid.dates.last);
    expect(grid.gridEnd, grid.gridStart.add(const Duration(days: 41)));
  });

  test('monthEnd is the last day of 28, 29, 30 and 31 day months', () {
    expect(CalendarGrid(day(2, 1)).monthEnd, day(2, 28));
    expect(
      CalendarGrid(DateTime.utc(2028, 2)).monthEnd,
      DateTime.utc(2028, 2, 29),
    );
    expect(CalendarGrid(day(11, 1)).monthEnd, day(11, 30));
    expect(CalendarGrid(day(10, 1)).monthEnd, day(10, 31));
  });
}
