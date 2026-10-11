import 'dart:async';

import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/calendar/domain/calendar_data.dart';
import 'package:tidal_flutter/features/calendar/domain/calendar_repository.dart';

import '../../home/fakes/builders.dart';

/// A hand-written [CalendarRepository] for tests: settable results and
/// failures, an optional completer per request to control when a response
/// arrives, and a record of the calls made.
class FakeCalendarRepository implements CalendarRepository {
  /// Data for a load; set per test. Defaults to an empty month.
  CalendarData Function(DateTime month, DateTime selectedDate) dataFor =
      (_, _) => emptyData;

  /// When set for a (month, selected date) pair, [load] waits for it.
  final Map<(DateTime, DateTime), Completer<CalendarData>> pendingLoads = {};

  Object? loadError;
  PeriodChange changeToReturn = periodChange(PeriodChangeKind.started, 5);
  Object? longPressError;
  Object? undoError;
  Object? deleteDoseError;
  Object? restoreDoseError;

  /// When true, [deleteDose] answers null (the dose was already gone).
  bool deleteReturnsNull = false;

  /// When set, [longPress] waits for it, and [onLongPress] and
  /// [onDeleteDose] are called when those calls start (to check ordering).
  Future<void>? longPressGate;
  void Function()? onLongPress;
  void Function()? onDeleteDose;

  final List<(DateTime, DateTime)> loads = [];
  final List<DateTime> longPresses = [];
  final List<PeriodChange> undone = [];
  final List<DoseLog> deletedDoses = [];
  final List<DoseLog> restoredDoses = [];

  static final emptyData = CalendarData(
    monthDayLogs: const [],
    monthPainEntries: const [],
    periods: const [],
    selectedPainEntries: const [],
    selectedBowelMovements: const [],
    units: UnitPreferences(
      weightUnit: WeightUnit.kg,
      temperatureUnit: TemperatureUnit.celsius,
    ),
    prediction: prediction(),
  );

  @override
  Future<CalendarData> load(DateTime month, DateTime selectedDate) async {
    loads.add((month, selectedDate));
    final pending = pendingLoads[(month, selectedDate)];
    if (pending != null) return pending.future;
    if (loadError != null) throw loadError!;
    return dataFor(month, selectedDate);
  }

  @override
  Future<PeriodChange> longPress(DateTime date) async {
    longPresses.add(date);
    onLongPress?.call();
    await longPressGate;
    if (longPressError != null) throw longPressError!;
    return changeToReturn;
  }

  @override
  Future<void> undo(PeriodChange change) async {
    undone.add(change);
    if (undoError != null) throw undoError!;
  }

  @override
  Future<DoseLog?> deleteDose(DoseLog dose) async {
    onDeleteDose?.call();
    if (deleteDoseError != null) throw deleteDoseError!;
    deletedDoses.add(dose);
    return deleteReturnsNull ? null : dose;
  }

  @override
  Future<void> restoreDose(DoseLog dose) async {
    if (restoreDoseError != null) throw restoreDoseError!;
    restoredDoses.add(dose);
  }
}
