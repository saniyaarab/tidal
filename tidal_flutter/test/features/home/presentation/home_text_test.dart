import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/home/domain/cycle_outlook.dart';
import 'package:tidal_flutter/features/home/domain/day_status.dart';
import 'package:tidal_flutter/features/home/presentation/home_text.dart';

/// Pins the wording Home showed before the migration.
void main() {
  group('dayStatusText', () {
    test('period day without flow', () {
      const status = DayStatus(periodDayNumber: 2, flow: FlowLevel.none);
      expect(dayStatusText(status), 'Period · Day 2');
    });

    test('period day with flow', () {
      const status = DayStatus(periodDayNumber: 2, flow: FlowLevel.heavy);
      expect(dayStatusText(status), 'Period · Day 2\nHeavy');
    });

    test('flow outside a period', () {
      const status = DayStatus(periodDayNumber: null, flow: FlowLevel.light);
      expect(dayStatusText(status), 'Light flow');
    });

    test('an ordinary day has no text', () {
      const status = DayStatus(periodDayNumber: null, flow: FlowLevel.none);
      expect(dayStatusText(status), isNull);
    });

    test('a day in the predicted period', () {
      const status = DayStatus(
        periodDayNumber: null,
        flow: FlowLevel.none,
        forecast: DayForecast.expectedPeriod,
      );
      expect(dayStatusText(status), 'Period expected');
    });

    test('a day in the fertile window', () {
      const status = DayStatus(
        periodDayNumber: null,
        flow: FlowLevel.none,
        forecast: DayForecast.fertileWindow,
      );
      expect(dayStatusText(status), 'Fertile window');
    });

    test('a PMS day', () {
      const status = DayStatus(
        periodDayNumber: null,
        flow: FlowLevel.none,
        forecast: DayForecast.pms,
      );
      expect(dayStatusText(status), 'PMS possible');
    });

    test('logged flow beats the prediction', () {
      const status = DayStatus(
        periodDayNumber: null,
        flow: FlowLevel.light,
        forecast: DayForecast.fertileWindow,
      );
      expect(dayStatusText(status), 'Light flow');
    });
  });

  group('cycle header text', () {
    test('title', () {
      const outlook = CycleOutlook(
        cycleDay: 5,
        daysUntilNextPeriod: 23,
        confidenceDays: 3,
      );
      expect(cycleTitleText(outlook), 'Cycle day 5');
    });

    test('countdown with the spread', () {
      const outlook = CycleOutlook(
        cycleDay: 5,
        daysUntilNextPeriod: 23,
        confidenceDays: 3,
      );
      expect(cycleSubtitleText(outlook), 'Next period in 23 days (±3)');
    });

    test('due now', () {
      const outlook = CycleOutlook(
        cycleDay: 30,
        daysUntilNextPeriod: 0,
        confidenceDays: 3,
      );
      expect(cycleSubtitleText(outlook), 'Next period expected any day now');
    });

    test('no subtitle when the next period is unknown', () {
      const outlook = CycleOutlook(
        cycleDay: 12,
        daysUntilNextPeriod: null,
        confidenceDays: 3,
      );
      expect(cycleSubtitleText(outlook), isNull);
    });
  });
}
