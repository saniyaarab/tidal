import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/calendar/data/server_calendar_repository.dart';

import '../../home/fakes/builders.dart';

/// Records the ranges asked for and returns settable results.
class FakeCalendarServerApi implements CalendarServerApi {
  final List<(String, DateTime, DateTime)> calls = [];
  Object? failOn;

  final dayLogs = [dayLog(day(10, 3), note: 'hi')];
  final painEntries = [pain(day(10, 4))];
  final periods = [period(day(10, 1))];
  final bowelMovements = <BowelMovement>[];
  final units = UnitPreferences(
    weightUnit: WeightUnit.kg,
    temperatureUnit: TemperatureUnit.celsius,
  );
  final predictionResult = prediction();
  final change = periodChange(PeriodChangeKind.started, 5);
  final List<DateTime> longPresses = [];
  final List<PeriodChange> undone = [];

  Future<T> _answer<T>(String name, DateTime from, DateTime to, T value) async {
    calls.add((name, from, to));
    if (failOn == name) throw StateError('$name failed');
    return value;
  }

  @override
  Future<List<DayLog>> getDayLogs(DateTime from, DateTime to) =>
      _answer('dayLogs', from, to, dayLogs);

  @override
  Future<List<PainEntry>> getPainEntries(DateTime from, DateTime to) =>
      _answer('pain', from, to, painEntries);

  @override
  Future<List<PeriodSpan>> getPeriods(DateTime from, DateTime to) =>
      _answer('periods', from, to, periods);

  @override
  Future<List<BowelMovement>> getBowelMovements(DateTime from, DateTime to) =>
      _answer('bowel', from, to, bowelMovements);

  @override
  Future<UnitPreferences> getUnitPreferences() =>
      _answer('units', DateTime(0), DateTime(0), units);

  @override
  Future<Prediction> getPrediction() =>
      _answer('prediction', DateTime(0), DateTime(0), predictionResult);

  @override
  Future<PeriodChange> longPress(DateTime date) async {
    longPresses.add(date);
    return change;
  }

  @override
  Future<void> undo(PeriodChange change) async => undone.add(change);
}

void main() {
  late FakeCalendarServerApi api;
  late ServerCalendarRepository repo;

  setUp(() {
    api = FakeCalendarServerApi();
    repo = ServerCalendarRepository(api);
  });

  test('load asks for the month, the grid and the selected day', () async {
    final data = await repo.load(day(10, 1), day(10, 20));

    expect(
      api.calls,
      containsAll([
        ('dayLogs', day(10, 1), day(10, 31)),
        ('pain', day(10, 1), day(10, 31)),
        ('pain', day(10, 20), day(10, 20)),
        ('bowel', day(10, 20), day(10, 20)),
        // 1 Oct 2026 is a Thursday: the grid starts Sun 27 Sep, 42 days long.
        ('periods', day(9, 27), day(11, 7)),
      ]),
    );
    expect(data.monthDayLogs, api.dayLogs);
    expect(data.monthPainEntries, api.painEntries);
    expect(data.periods, api.periods);
    expect(data.units, api.units);
    expect(data.prediction, api.predictionResult);
  });

  test('a selected day outside the month still gets its own range', () async {
    await repo.load(day(10, 1), day(9, 28));
    expect(api.calls, contains(('pain', day(9, 28), day(9, 28))));
    expect(api.calls, contains(('bowel', day(9, 28), day(9, 28))));
  });

  test('selected-day pain entries come from the single-day request', () async {
    final selectedPain = [pain(day(10, 20), level: 9)];
    final monthPain = [pain(day(10, 4))];
    final custom = _RoutingApi(monthPain: monthPain, dayPain: selectedPain);
    final data = await ServerCalendarRepository(
      custom,
    ).load(day(10, 1), day(10, 20));
    expect(data.monthPainEntries, monthPain);
    expect(data.selectedPainEntries, selectedPain);
  });

  for (final name in [
    'dayLogs',
    'pain',
    'periods',
    'bowel',
    'units',
    'prediction',
  ]) {
    test('load throws when $name fails', () async {
      api.failOn = name;
      await expectLater(
        repo.load(day(10, 1), day(10, 1)),
        throwsA(isA<StateError>()),
      );
    });
  }

  test('longPress returns the server change untouched', () async {
    expect(await repo.longPress(day(10, 3)), same(api.change));
    expect(api.longPresses, [day(10, 3)]);
  });

  test('undo forwards the same change', () async {
    await repo.undo(api.change);
    expect(api.undone.single, same(api.change));
  });
}

/// Returns different pain entries for the month and single-day requests.
class _RoutingApi extends FakeCalendarServerApi {
  final List<PainEntry> monthPain;
  final List<PainEntry> dayPain;
  _RoutingApi({required this.monthPain, required this.dayPain});

  @override
  Future<List<PainEntry>> getPainEntries(DateTime from, DateTime to) async =>
      from == to ? dayPain : monthPain;
}
