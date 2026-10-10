import 'package:tidal_client/tidal_client.dart';

import '../../../date_format.dart';
import '../domain/day_data.dart';
import '../domain/due_reminder.dart';
import '../domain/home_repository.dart';

/// The calls Home makes to the server. The app implements this over the
/// generated client (see `ClientHomeServerApi`); tests use a fake.
abstract class HomeServerApi {
  Future<List<DayLog>> getDayLogs(DateTime from, DateTime to);
  Future<List<PainEntry>> getPainEntries(DateTime from, DateTime to);
  Future<List<PeriodSpan>> getPeriods(DateTime from, DateTime to);
  Future<List<BowelMovement>> getBowelMovements(DateTime from, DateTime to);
  Future<UnitPreferences> getUnitPreferences();
  Future<Prediction> getPrediction();
  Future<List<MedicationReminder>> getReminders();
  Future<List<Medication>> getMedications();
  Future<List<DoseLog>> getDoses(DateTime from, DateTime to);
  Future<DoseLog?> deleteDose(int doseLogId);
  Future<void> restoreDose(DoseLog dose);
  Future<void> logDose(int medicationId, DateTime date, DateTime timestamp);
  Future<void> dismissReminder(int reminderId);
}

/// [HomeRepository] backed by the server.
class ServerHomeRepository implements HomeRepository {
  final HomeServerApi _api;

  ServerHomeRepository(this._api);

  @override
  Future<DayData> loadDay(DateTime date) async {
    final results = await Future.wait([
      _api.getDayLogs(date, date),
      _api.getPainEntries(date, date),
      _api.getPeriods(date, date),
      _api.getBowelMovements(date, date),
      _api.getUnitPreferences(),
      _api.getDoses(date, date),
      _api.getMedications(),
    ]);
    final dayLogs = results[0] as List<DayLog>;
    final periods = results[2] as List<PeriodSpan>;
    return DayData(
      dayLog: dayLogs.isEmpty ? null : dayLogs.first,
      period: periods.isEmpty ? null : periods.first,
      painEntries: results[1] as List<PainEntry>,
      bowelMovements: results[3] as List<BowelMovement>,
      units: results[4] as UnitPreferences,
      doses: results[5] as List<DoseLog>,
      medicationsById: {
        for (final med in results[6] as List<Medication>) med.id!: med,
      },
    );
  }

  @override
  Future<Prediction> loadPrediction() => _api.getPrediction();

  @override
  Future<List<DueReminder>> loadDueReminders() async {
    final results = await Future.wait([
      _api.getReminders(),
      _api.getMedications(),
    ]);
    final reminders = results[0] as List<MedicationReminder>;
    final namesById = {
      for (final med in results[1] as List<Medication>) med.id!: med.name,
    };
    return [
      for (final r in reminders)
        if (r.isDue)
          DueReminder(
            reminderId: r.id!,
            medicationId: r.medicationId,
            medicationName:
                namesById[r.medicationId] ?? DueReminder.unknownMedicationName,
          ),
    ];
  }

  @override
  Future<void> logReminderDose(DueReminder reminder, DateTime now) =>
      _api.logDose(reminder.medicationId, dateKeyOf(now), now.toUtc());

  @override
  Future<void> dismissReminder(DueReminder reminder) =>
      _api.dismissReminder(reminder.reminderId);

  @override
  Future<DoseLog?> deleteDose(DoseLog dose) => _api.deleteDose(dose.id!);

  @override
  Future<void> restoreDose(DoseLog dose) => _api.restoreDose(dose);
}
