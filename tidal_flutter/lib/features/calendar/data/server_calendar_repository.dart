import 'package:tidal_client/tidal_client.dart';

import '../domain/calendar_data.dart';
import '../domain/calendar_grid.dart';
import '../domain/calendar_repository.dart';

/// The calls the Calendar makes to the server. The app implements this over
/// the generated client (see `ClientCalendarServerApi`); tests use a fake.
abstract class CalendarServerApi {
  Future<List<DayLog>> getDayLogs(DateTime from, DateTime to);
  Future<List<PainEntry>> getPainEntries(DateTime from, DateTime to);
  Future<List<PeriodSpan>> getPeriods(DateTime from, DateTime to);
  Future<List<BowelMovement>> getBowelMovements(DateTime from, DateTime to);
  Future<UnitPreferences> getUnitPreferences();
  Future<Prediction> getPrediction();
  Future<List<DoseLog>> getDoses(DateTime from, DateTime to);
  Future<List<Medication>> getMedications();
  Future<DoseLog?> deleteDose(int doseLogId);
  Future<void> restoreDose(DoseLog dose);
  Future<PeriodChange> longPress(DateTime date);
  Future<void> undo(PeriodChange change);
}

/// [CalendarRepository] backed by the server.
class ServerCalendarRepository implements CalendarRepository {
  final CalendarServerApi _api;

  ServerCalendarRepository(this._api);

  @override
  Future<CalendarData> load(DateTime month, DateTime selectedDate) async {
    final grid = CalendarGrid(month);
    // The grid also shows a few days of the neighbouring months, so periods
    // are fetched for the whole grid rather than just the month.
    final results = await Future.wait([
      _api.getDayLogs(month, grid.monthEnd),
      _api.getPainEntries(month, grid.monthEnd),
      _api.getPainEntries(selectedDate, selectedDate),
      _api.getPrediction(),
      _api.getPeriods(grid.gridStart, grid.gridEnd),
      _api.getBowelMovements(selectedDate, selectedDate),
      _api.getUnitPreferences(),
      _api.getDoses(selectedDate, selectedDate),
      _api.getMedications(),
    ]);
    return CalendarData(
      monthDayLogs: results[0] as List<DayLog>,
      monthPainEntries: results[1] as List<PainEntry>,
      selectedPainEntries: results[2] as List<PainEntry>,
      prediction: results[3] as Prediction,
      periods: results[4] as List<PeriodSpan>,
      selectedBowelMovements: results[5] as List<BowelMovement>,
      units: results[6] as UnitPreferences,
      selectedDoses: results[7] as List<DoseLog>,
      medicationsById: {
        for (final med in results[8] as List<Medication>) med.id!: med,
      },
    );
  }

  @override
  Future<PeriodChange> longPress(DateTime date) => _api.longPress(date);

  @override
  Future<void> undo(PeriodChange change) => _api.undo(change);

  @override
  Future<DoseLog?> deleteDose(DoseLog dose) => _api.deleteDose(dose.id!);

  @override
  Future<void> restoreDose(DoseLog dose) => _api.restoreDose(dose);
}
