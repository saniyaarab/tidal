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
}
