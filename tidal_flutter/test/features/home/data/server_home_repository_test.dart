import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/home/data/server_home_repository.dart';
import 'package:tidal_flutter/features/home/domain/due_reminder.dart';

import '../fakes/builders.dart';

/// A hand-written [HomeServerApi] with settable results and recorded calls.
class FakeHomeServerApi implements HomeServerApi {
  List<DayLog> dayLogs = [];
  List<PainEntry> painEntries = [];
  List<PeriodSpan> periods = [];
  List<BowelMovement> bowelMovements = [];
  List<MedicationReminder> reminders = [];
  List<Medication> medications = [];
  List<DoseLog> doses = [];
  Object? error;
  Object? dosesError;
  Object? medicationsError;

  final rangeCalls = <(DateTime, DateTime)>[];
  (int, DateTime, DateTime)? loggedDose;
  int? dismissedReminderId;
  final deletedDoseIds = <int>[];
  final restoredDoses = <DoseLog>[];
  DoseLog? deleteResult;

  final units = UnitPreferences(
    weightUnit: WeightUnit.kg,
    temperatureUnit: TemperatureUnit.celsius,
  );

  @override
  Future<List<DayLog>> getDayLogs(DateTime from, DateTime to) async {
    rangeCalls.add((from, to));
    if (error != null) throw error!;
    return dayLogs;
  }

  @override
  Future<List<PainEntry>> getPainEntries(DateTime from, DateTime to) async =>
      painEntries;

  @override
  Future<List<PeriodSpan>> getPeriods(DateTime from, DateTime to) async =>
      periods;

  @override
  Future<List<BowelMovement>> getBowelMovements(
    DateTime from,
    DateTime to,
  ) async => bowelMovements;

  @override
  Future<UnitPreferences> getUnitPreferences() async => units;

  @override
  Future<Prediction> getPrediction() async => Prediction(currentCycleDay: 4);

  @override
  Future<List<MedicationReminder>> getReminders() async => reminders;

  @override
  Future<List<Medication>> getMedications() async {
    if (medicationsError != null) throw medicationsError!;
    return medications;
  }

  @override
  Future<List<DoseLog>> getDoses(DateTime from, DateTime to) async {
    if (dosesError != null) throw dosesError!;
    return doses;
  }

  @override
  Future<DoseLog?> deleteDose(int doseLogId) async {
    deletedDoseIds.add(doseLogId);
    return deleteResult;
  }

  @override
  Future<void> restoreDose(DoseLog dose) async => restoredDoses.add(dose);

  @override
  Future<void> logDose(
    int medicationId,
    DateTime date,
    DateTime timestamp,
  ) async {
    loggedDose = (medicationId, date, timestamp);
  }

  @override
  Future<void> dismissReminder(int reminderId) async {
    dismissedReminderId = reminderId;
  }
}

void main() {
  late FakeHomeServerApi api;
  late ServerHomeRepository repository;

  setUp(() {
    api = FakeHomeServerApi();
    repository = ServerHomeRepository(api);
  });

  group('loadDay', () {
    test('bundles everything for the date', () async {
      final date = day(10, 2);
      api.dayLogs = [dayLog(date, flow: FlowLevel.medium)];
      api.periods = [period(day(10, 1))];
      api.painEntries = [pain(date)];

      final data = await repository.loadDay(date);

      expect(data.dayLog?.flow, FlowLevel.medium);
      expect(data.period?.startDate, day(10, 1));
      expect(data.painEntries, hasLength(1));
      expect(data.units, api.units);
      expect(api.rangeCalls, [(date, date)]);
    });

    test('empty results give no day log and no period', () async {
      final data = await repository.loadDay(day(10, 2));
      expect(data.dayLog, isNull);
      expect(data.period, isNull);
      expect(data.painEntries, isEmpty);
    });

    test('propagates failures', () async {
      api.error = Exception('offline');
      expect(repository.loadDay(day(10, 2)), throwsException);
    });

    test('includes the day\'s doses and the medications by id', () async {
      final date = day(10, 2);
      api.doses = [doseLog(1, 10, date.add(const Duration(hours: 8)))];
      api.medications = [medication(10, 'Tylenol')];

      final data = await repository.loadDay(date);

      expect(data.doses, api.doses);
      expect(data.medicationsById, {10: api.medications.single});
    });

    test('fails as a whole if the doses can\'t be loaded', () async {
      api.dosesError = Exception('offline');
      expect(repository.loadDay(day(10, 2)), throwsException);
    });

    test('fails as a whole if the medications can\'t be loaded', () async {
      api.medicationsError = Exception('offline');
      expect(repository.loadDay(day(10, 2)), throwsException);
    });
  });

  group('loadDueReminders', () {
    test('keeps only due reminders and joins medication names', () async {
      api.reminders = [
        reminder(1, 10),
        reminder(2, 11, isDue: false),
        reminder(3, 99),
      ];
      api.medications = [medication(10, 'Ibuprofen'), medication(11, 'Iron')];

      final due = await repository.loadDueReminders();

      expect(due, [
        const DueReminder(
          reminderId: 1,
          medicationId: 10,
          medicationName: 'Ibuprofen',
        ),
        const DueReminder(
          reminderId: 3,
          medicationId: 99,
          medicationName: DueReminder.unknownMedicationName,
        ),
      ]);
    });
  });

  test(
    'logReminderDose sends the medication, the day key and the moment',
    () async {
      const reminder = DueReminder(
        reminderId: 1,
        medicationId: 10,
        medicationName: 'Ibuprofen',
      );
      final now = DateTime.utc(2026, 10, 3, 14, 30);

      await repository.logReminderDose(reminder, now);

      expect(api.loggedDose, (10, day(10, 3), now));
    },
  );

  test('dismissReminder sends the reminder id', () async {
    await repository.dismissReminder(
      const DueReminder(
        reminderId: 7,
        medicationId: 10,
        medicationName: 'Ibuprofen',
      ),
    );
    expect(api.dismissedReminderId, 7);
  });

  group('doses', () {
    final dose = doseLog(7, 10, DateTime.utc(2026, 10, 3, 8));

    test(
      'deleteDose sends the id and returns what the server answers',
      () async {
        api.deleteResult = dose;

        expect(await repository.deleteDose(dose), dose);
        expect(api.deletedDoseIds, [7]);
      },
    );

    test('deleteDose passes on a null answer (already gone)', () async {
      expect(await repository.deleteDose(dose), isNull);
    });

    test('restoreDose sends the whole dose', () async {
      await repository.restoreDose(dose);
      expect(api.restoredDoses, [dose]);
    });
  });
}
