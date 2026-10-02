import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../generated/serverpod.dart';

/// The daily self-care journal: which activities the user did each day and
/// their best moment of the day.
///
/// Every method only ever reads or writes the signed-in user's own data.
class JournalEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// The journal entry for [date], or null if nothing was saved that day.
  Future<JournalEntry?> getDay(Session session, DateTime date) async {
    final userId = session.authenticated!.authUserId;
    return JournalEntry.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId) & t.date.equals(_dateOnly(date)),
    );
  }

  /// Saves the whole journal entry for [date], replacing what was there.
  /// Throws for future dates — only today and earlier can be journaled.
  Future<JournalEntry> saveDay(
    Session session,
    DateTime date,
    List<SelfCareActivity> activities,
    String? bestMoment,
  ) async {
    final userId = session.authenticated!.authUserId;
    final day = _dateOnly(date);
    // A day of slack for users whose local date is ahead of UTC.
    final latestAllowed = _dateOnly(
      DateTime.now().toUtc(),
    ).add(const Duration(days: 1));
    if (day.isAfter(latestAllowed)) {
      throw ArgumentError("Can't journal for a future date.");
    }

    final text = bestMoment?.trim();
    final existing = await getDay(session, day);
    final entry = JournalEntry(
      id: existing?.id,
      userId: userId,
      date: day,
      // No duplicates, in checklist order.
      activities: SelfCareActivity.values.where(activities.contains).toList(),
      bestMoment: (text == null || text.isEmpty) ? null : text,
    );
    return existing == null
        ? JournalEntry.db.insertRow(session, entry)
        : JournalEntry.db.updateRow(session, entry);
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);
}
