import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/home/domain/day_status.dart';

import '../fakes/builders.dart';

void main() {
  test('first day of a period is day 1', () {
    final status = buildDayStatus(
      date: day(10, 1),
      period: period(day(10, 1)),
      dayLog: null,
    );
    expect(status.isPeriodDay, isTrue);
    expect(status.periodDayNumber, 1);
    expect(status.flow, FlowLevel.none);
  });

  test('counts days from the period start', () {
    final status = buildDayStatus(
      date: day(10, 3),
      period: period(day(10, 1)),
      dayLog: null,
    );
    expect(status.periodDayNumber, 3);
  });

  test('carries the flow logged inside a period', () {
    final status = buildDayStatus(
      date: day(10, 2),
      period: period(day(10, 1)),
      dayLog: dayLog(day(10, 2), flow: FlowLevel.heavy),
    );
    expect(status.periodDayNumber, 2);
    expect(status.flow, FlowLevel.heavy);
  });

  test('flow logged outside a period is not a period day', () {
    final status = buildDayStatus(
      date: day(10, 20),
      period: null,
      dayLog: dayLog(day(10, 20), flow: FlowLevel.light),
    );
    expect(status.isPeriodDay, isFalse);
    expect(status.periodDayNumber, isNull);
    expect(status.flow, FlowLevel.light);
  });

  test('no period and no flow', () {
    final status = buildDayStatus(
      date: day(10, 20),
      period: null,
      dayLog: null,
    );
    expect(status.isPeriodDay, isFalse);
    expect(status.flow, FlowLevel.none);
  });

  group('with a prediction', () {
    // Next period predicted for Oct 25–29, fertile window Oct 6–11.
    final prediction = Prediction(
      nextPeriodStart: day(10, 25),
      predictedPeriodEnd: day(10, 29),
      fertileWindowStart: day(10, 6),
      fertileWindowEnd: day(10, 11),
    );

    test('a day in the predicted period is an expected period day', () {
      final status = buildDayStatus(
        date: day(10, 29),
        period: null,
        dayLog: null,
        prediction: prediction,
      );
      expect(status.forecast, DayForecast.expectedPeriod);
    });

    test('a day in the fertile window is a fertile day', () {
      final status = buildDayStatus(
        date: day(10, 6),
        period: null,
        dayLog: null,
        prediction: prediction,
      );
      expect(status.forecast, DayForecast.fertileWindow);
    });

    test('the 7 days before the predicted period are PMS days', () {
      for (final date in [day(10, 24), day(10, 18)]) {
        final status = buildDayStatus(
          date: date,
          period: null,
          dayLog: null,
          prediction: prediction,
        );
        expect(status.forecast, DayForecast.pms, reason: '$date');
      }
    });

    test('8 days before the predicted period is not a PMS day', () {
      final status = buildDayStatus(
        date: day(10, 17),
        period: null,
        dayLog: null,
        prediction: prediction,
      );
      expect(status.forecast, DayForecast.none);
    });

    test('a day outside both has no forecast', () {
      final status = buildDayStatus(
        date: day(10, 15),
        period: null,
        dayLog: null,
        prediction: prediction,
      );
      expect(status.forecast, DayForecast.none);
    });

    test('a logged period beats the prediction', () {
      final status = buildDayStatus(
        date: day(10, 25),
        period: period(day(10, 25)),
        dayLog: null,
        prediction: prediction,
      );
      expect(status.periodDayNumber, 1);
      expect(status.forecast, DayForecast.none);
    });
  });
}
