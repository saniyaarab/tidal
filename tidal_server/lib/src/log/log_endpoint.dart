import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';

/// Endpoint for logging day-to-day info: period flow, mood, and notes.
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
