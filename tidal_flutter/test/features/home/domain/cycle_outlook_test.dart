import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/home/domain/cycle_outlook.dart';

import '../fakes/builders.dart';

void main() {
  final today = day(10, 10);

  test('is null when there is no cycle day yet', () {
    expect(buildCycleOutlook(Prediction(), today), isNull);
  });

  test('counts the days until the next period', () {
    final outlook = buildCycleOutlook(
      Prediction(
        currentCycleDay: 5,
        nextPeriodStart: day(11, 2),
        confidenceDays: 3,
      ),
      today,
    )!;
    expect(outlook.cycleDay, 5);
    expect(outlook.daysUntilNextPeriod, 23);
    expect(outlook.confidenceDays, 3);
    expect(outlook.isDueNow, isFalse);
  });

  test('is due now when the next period is today or overdue', () {
    for (final next in [day(10, 10), day(10, 7)]) {
      final outlook = buildCycleOutlook(
        Prediction(currentCycleDay: 30, nextPeriodStart: next),
        today,
      )!;
      expect(outlook.isDueNow, isTrue);
    }
  });

  test('has no countdown when the next period is unknown', () {
    final outlook = buildCycleOutlook(
      Prediction(currentCycleDay: 12),
      today,
    )!;
    expect(outlook.daysUntilNextPeriod, isNull);
    expect(outlook.isDueNow, isFalse);
  });
}
