import 'package:tidal_client/tidal_client.dart';

import 'server_calendar_repository.dart';

/// Connects [CalendarServerApi] to the generated Serverpod [Client]. Only
/// forwards calls, so there is nothing to test beyond what the client's
/// own endpoints already cover.
class ClientCalendarServerApi implements CalendarServerApi {
  final Client _client;

  ClientCalendarServerApi(this._client);

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
  Future<PeriodChange> longPress(DateTime date) =>
      _client.period.longPress(date);

  @override
  Future<void> undo(PeriodChange change) => _client.period.undo(change);
}
