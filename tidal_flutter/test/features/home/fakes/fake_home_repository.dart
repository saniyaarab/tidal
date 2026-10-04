import 'dart:async';

import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/home/domain/day_data.dart';
import 'package:tidal_flutter/features/home/domain/due_reminder.dart';
import 'package:tidal_flutter/features/home/domain/home_repository.dart';

/// A hand-written [HomeRepository] for tests: settable results and failures,
/// optional completers to control when a response arrives, and a record of
/// the calls made.
class FakeHomeRepository implements HomeRepository {
  /// Returns data for a date; set per test. Defaults to an empty day.
  DayData Function(DateTime date) dayFor = (_) => emptyDay;

  /// When set for a date, [loadDay] waits for this completer's future.
  final Map<DateTime, Completer<DayData>> pendingDays = {};

  Object? dayError;
  Prediction? prediction;
  Object? predictionError;
  List<DueReminder> reminders = [];
  Object? remindersError;
  Object? logDoseError;
  Object? dismissError;

  final List<DateTime> loadedDays = [];
  int predictionLoads = 0;
  int reminderLoads = 0;
  final List<DueReminder> loggedDoses = [];
  final List<DueReminder> dismissed = [];

  static final emptyDay = DayData(
    dayLog: null,
    period: null,
    painEntries: const [],
    bowelMovements: const [],
    units: UnitPreferences(
      weightUnit: WeightUnit.kg,
      temperatureUnit: TemperatureUnit.celsius,
    ),
  );

  @override
  Future<DayData> loadDay(DateTime date) async {
    loadedDays.add(date);
    final pending = pendingDays[date];
    if (pending != null) return pending.future;
    if (dayError != null) throw dayError!;
    return dayFor(date);
  }

  @override
  Future<Prediction> loadPrediction() async {
    predictionLoads++;
    if (predictionError != null) throw predictionError!;
    return prediction ?? Prediction(confidenceDays: 2);
  }

  @override
  Future<List<DueReminder>> loadDueReminders() async {
    reminderLoads++;
    if (remindersError != null) throw remindersError!;
    return List.of(reminders);
  }

  @override
  Future<void> logReminderDose(DueReminder reminder, DateTime now) async {
    if (logDoseError != null) throw logDoseError!;
    loggedDoses.add(reminder);
  }

  @override
  Future<void> dismissReminder(DueReminder reminder) async {
    if (dismissError != null) throw dismissError!;
    dismissed.add(reminder);
  }
}
