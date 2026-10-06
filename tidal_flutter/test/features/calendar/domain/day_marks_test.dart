import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/calendar/domain/day_marks.dart';

import '../../home/fakes/builders.dart';

final _today = day(10, 15);
final _month = day(10, 1);

DayMarks marks(
  DateTime date, {
  DateTime? selected,
  Set<DateTime> periodDates = const {},
  Set<DateTime> painDates = const {},
  Prediction? prediction,
}) => DayMarks.of(
  date: date,
  month: _month,
  selectedDate: selected ?? day(10, 1),
  today: _today,
  periodDates: periodDates,
  painDates: painDates,
  prediction: prediction,
);

void main() {
  final predicted = prediction(
    nextPeriodStart: day(10, 20),
    predictedPeriodEnd: day(10, 24),
    fertileWindowStart: day(10, 8),
    fertileWindowEnd: day(10, 13),
  );

  group('rings', () {
    test('a logged period day', () {
      expect(marks(day(10, 5), periodDates: {day(10, 5)}).ring, DayRing.period);
    });

    test('a predicted period day', () {
      expect(marks(day(10, 22), prediction: predicted).ring, DayRing.predicted);
    });

    test('a fertile day', () {
      expect(marks(day(10, 10), prediction: predicted).ring, DayRing.fertile);
    });

    test('today', () {
      expect(marks(_today).ring, DayRing.today);
    });

    test('an ordinary day has no ring', () {
      expect(marks(day(10, 17)).ring, DayRing.none);
    });

    test('logged beats predicted beats fertile beats today', () {
      final everything = prediction(
        nextPeriodStart: day(10, 15),
        predictedPeriodEnd: day(10, 15),
        fertileWindowStart: day(10, 15),
        fertileWindowEnd: day(10, 15),
      );
      expect(
        marks(_today, periodDates: {_today}, prediction: everything).ring,
        DayRing.period,
      );
      expect(marks(_today, prediction: everything).ring, DayRing.predicted);
      final fertileToo = prediction(
        fertileWindowStart: day(10, 15),
        fertileWindowEnd: day(10, 15),
      );
      expect(marks(_today, prediction: fertileToo).ring, DayRing.fertile);
    });

    test('the selected day has no ring', () {
      expect(
        marks(day(10, 5), selected: day(10, 5), periodDates: {day(10, 5)}).ring,
        DayRing.none,
      );
    });

    test('range ends are inclusive', () {
      expect(marks(day(10, 20), prediction: predicted).ring, DayRing.predicted);
      expect(marks(day(10, 24), prediction: predicted).ring, DayRing.predicted);
      expect(marks(day(10, 8), prediction: predicted).ring, DayRing.fertile);
      expect(marks(day(10, 13), prediction: predicted).ring, DayRing.fertile);
      expect(marks(day(10, 25), prediction: predicted).ring, DayRing.none);
    });

    test('no prediction, or one without dates, adds no ring', () {
      expect(marks(day(10, 22)).ring, DayRing.none);
      expect(marks(day(10, 22), prediction: prediction()).ring, DayRing.none);
    });
  });

  test('flags: current month, selected, today, pain', () {
    final m = marks(
      _today,
      selected: _today,
      painDates: {_today},
    );
    expect(m.inCurrentMonth, isTrue);
    expect(m.isSelected, isTrue);
    expect(m.isToday, isTrue);
    expect(m.hasPain, isTrue);

    final other = marks(day(11, 2));
    expect(other.inCurrentMonth, isFalse);
    expect(other.isSelected, isFalse);
    expect(other.isToday, isFalse);
    expect(other.hasPain, isFalse);
  });
}
