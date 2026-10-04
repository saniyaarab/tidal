import 'package:tidal_client/tidal_client.dart';

import 'server_home_repository.dart';

/// Connects [HomeServerApi] to the generated Serverpod [Client]. Only
/// forwards calls, so there is nothing to test beyond what the client's
/// own endpoints already cover.
class ClientHomeServerApi implements HomeServerApi {
  final Client _client;

  ClientHomeServerApi(this._client);

  @override
  Future<List<DayLog>> getDayLogs(DateTime from, DateTime to) =>
      _client.log.getRange(from, to);

  @override
  Future<List<PainEntry>> getPainEntries(DateTime from, DateTime to) =>
      _client.pain.getPainRange(from, to);

  @override
  Future<List<PeriodSpan>> getPeriods(DateTime from, DateTime to) =>
      _client.period.getPeriods(from, to);

  @override
  Future<List<BowelMovement>> getBowelMovements(DateTime from, DateTime to) =>
      _client.digestion.getBowelMovementRange(from, to);

  @override
  Future<UnitPreferences> getUnitPreferences() =>
      _client.insight.getUnitPreferences();

  @override
  Future<Prediction> getPrediction() => _client.insight.getPrediction();

  @override
  Future<List<MedicationReminder>> getReminders() =>
      _client.pain.getReminders();

  @override
  Future<List<Medication>> getMedications() => _client.pain.myMeds();

  @override
  Future<void> logDose(int medicationId, DateTime date, DateTime timestamp) =>
      _client.pain.logDose(medicationId, date, timestamp);

  @override
  Future<void> dismissReminder(int reminderId) =>
      _client.pain.dismissReminder(reminderId);
}
