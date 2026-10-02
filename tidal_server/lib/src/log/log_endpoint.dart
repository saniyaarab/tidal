import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Endpoint for logging day-to-day info: flow, mood, notes, and the other
/// once-a-day details (drinks, sleep, digestion, body, love).
///
/// Every method only ever reads or writes the signed-in user's own data.
class LogEndpoint extends Endpoint {
  // Require the caller to be signed in for every method on this endpoint.
  @override
  bool get requireLogin => true;

  /// Saves (or creates) the log for [date].
  ///
  /// Only the fields you pass in are changed. For example, calling this with
  /// just `mood` set leaves that day's `flow` and `note` untouched. To clear
  /// the flow back to "no period", pass `FlowLevel.none` explicitly.
  Future<DayLog> saveDay(
    Session session,
    DateTime date, {
    FlowLevel? flow,
    Mood? mood,
    String? note,
  }) async {
    final userId = session.authenticated!.authUserId;
    final day = _dateOnly(date);

    final existing = await DayLog.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.date.equals(day),
    );

    if (existing == null) {
      final created = DayLog(
        userId: userId,
        date: day,
        flow: flow ?? FlowLevel.none,
        mood: mood,
        note: note,
      );
      return DayLog.db.insertRow(session, created);
    }

    final updated = existing.copyWith(
      flow: flow ?? existing.flow,
      mood: mood ?? existing.mood,
      note: note ?? existing.note,
    );
    return DayLog.db.updateRow(session, updated);
  }

  /// Sets how many of [drink] were had on [date] (0 to clear).
  Future<DayLog> saveDrinkCount(
    Session session,
    DateTime date,
    DrinkType drink,
    int count,
  ) {
    if (count < 0 || count > 50) {
      throw ArgumentError('count must be between 0 and 50');
    }
    return _updateDay(
      session,
      date,
      (day) => switch (drink) {
        DrinkType.water => day.copyWith(waterGlasses: count),
        DrinkType.caffeine => day.copyWith(caffeineDrinks: count),
        DrinkType.alcohol => day.copyWith(alcoholDrinks: count),
      },
    );
  }

  /// Sets last night's sleep for [date]: [quality] 1–5 and optional
  /// [hours]. Null clears.
  Future<DayLog> saveSleep(
    Session session,
    DateTime date,
    int? quality,
    double? hours,
  ) {
    if (quality != null && (quality < 1 || quality > 5)) {
      throw ArgumentError('quality must be between 1 and 5');
    }
    if (hours != null && (hours < 0 || hours > 24)) {
      throw ArgumentError('hours must be between 0 and 24');
    }
    return _updateDay(
      session,
      date,
      (day) => day.copyWith(sleepQuality: quality, sleepHours: hours),
    );
  }

  /// Sets the day's bloating and acid reflux. Null clears.
  Future<DayLog> saveDigestionDay(
    Session session,
    DateTime date,
    Severity? bloating,
    Severity? acidReflux,
  ) => _updateDay(
    session,
    date,
    (day) => day.copyWith(bloating: bloating, acidReflux: acidReflux),
  );

  /// Sets the day's weight in kg. Null clears.
  Future<DayLog> saveWeight(Session session, DateTime date, double? kg) {
    if (kg != null && (kg < 20 || kg > 300)) {
      throw ArgumentError('weight must be between 20 and 300 kg');
    }
    return _updateDay(session, date, (day) => day.copyWith(weightKg: kg));
  }

  /// Sets the day's basal body temperature in °C. Null clears.
  Future<DayLog> saveTemperature(
    Session session,
    DateTime date,
    double? celsius,
  ) {
    if (celsius != null && (celsius < 34 || celsius > 42)) {
      throw ArgumentError('temperature must be between 34 and 42 °C');
    }
    return _updateDay(
      session,
      date,
      (day) => day.copyWith(temperatureC: celsius),
    );
  }

  /// Sets the day's cervical mucus. Null clears.
  Future<DayLog> saveMucus(Session session, DateTime date, MucusType? mucus) =>
      _updateDay(session, date, (day) => day.copyWith(mucus: mucus));

  /// Sets whether the user had sex that day, and how. Null clears.
  Future<DayLog> saveLove(Session session, DateTime date, LoveType? love) =>
      _updateDay(session, date, (day) => day.copyWith(love: love));

  /// Loads (or starts) the signed-in user's log for [date], applies
  /// [change], and saves it. Rejects future dates.
  Future<DayLog> _updateDay(
    Session session,
    DateTime date,
    DayLog Function(DayLog day) change,
  ) async {
    final userId = session.authenticated!.authUserId;
    final day = _dateOnly(date);
    // A day of slack for users whose local date is ahead of UTC.
    final latestAllowed = _dateOnly(
      DateTime.now().toUtc(),
    ).add(const Duration(days: 1));
    if (day.isAfter(latestAllowed)) {
      throw ArgumentError("Can't log for a future date.");
    }

    final existing = await DayLog.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.date.equals(day),
    );
    if (existing == null) {
      return DayLog.db.insertRow(
        session,
        change(DayLog(userId: userId, date: day)),
      );
    }
    return DayLog.db.updateRow(session, change(existing));
  }

  /// Returns all logged days between [start] and [end] (inclusive), ordered
  /// by date. Only the time part's day/month/year is used; it is normalized
  /// to midnight UTC, matching how dates are stored.
  Future<List<DayLog>> getRange(
    Session session,
    DateTime start,
    DateTime end,
  ) async {
    final userId = session.authenticated!.authUserId;

    return DayLog.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.date.between(_dateOnly(start), _dateOnly(end)),
      orderBy: (t) => t.date,
    );
  }

  /// Permanently deletes every day log belonging to the signed-in user.
  Future<void> deleteAll(Session session) async {
    final userId = session.authenticated!.authUserId;

    await DayLog.db.deleteWhere(
      session,
      where: (t) => t.userId.equals(userId),
    );
  }

  /// Strips the time part off [date], keeping just the calendar day as
  /// midnight UTC. This is how dates are stored, so lookups by date match.
  DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);
}
