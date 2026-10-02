import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../generated/serverpod.dart';

/// Endpoint for pain and medication logging. Tidal only ever records what
/// the user says they took; it never suggests doses.
///
/// Every method only ever reads or writes the signed-in user's own data.
class PainEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Logs a pain entry for right now.
  Future<PainEntry> logPain(
    Session session,
    int level,
    List<PainLocation> locations,
  ) async {
    if (level < 0 || level > 10) {
      throw ArgumentError('level must be between 0 and 10');
    }

    final entry = PainEntry(
      userId: session.authenticated!.authUserId,
      timestamp: DateTime.now().toUtc(),
      level: level,
      locations: locations,
    );
    return PainEntry.db.insertRow(session, entry);
  }

  /// Returns the pain entries logged between [start] and [end] (inclusive
  /// days), ordered by time.
  Future<List<PainEntry>> getPainRange(
    Session session,
    DateTime start,
    DateTime end,
  ) async {
    final userId = session.authenticated!.authUserId;
    return PainEntry.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.timestamp.between(_startOfDay(start), _endOfDay(end)),
      orderBy: (t) => t.timestamp,
    );
  }

  /// Returns the signed-in user's medications, in the order they were added.
  Future<List<Medication>> myMeds(Session session) async {
    final userId = session.authenticated!.authUserId;
    return Medication.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.id,
    );
  }

  /// Adds a new medication to the signed-in user's "my meds" list.
  Future<Medication> addMedication(
    Session session,
    String name,
    String usualDose,
  ) async {
    final medication = Medication(
      userId: session.authenticated!.authUserId,
      name: name,
      usualDose: usualDose,
    );
    return Medication.db.insertRow(session, medication);
  }

  /// One-tap dose logging: records that [medicationId] was taken right now,
  /// using its usual dose. [painBefore] is optional context, e.g. the pain
  /// level the user just logged in the same sheet.
  Future<DoseLog> logDose(
    Session session,
    int medicationId, {
    int? painBefore,
  }) async {
    final userId = session.authenticated!.authUserId;
    final medication = await Medication.db.findById(session, medicationId);
    if (medication == null || medication.userId != userId) {
      throw ArgumentError('Medication not found.');
    }

    final dose = DoseLog(
      userId: userId,
      medicationId: medicationId,
      timestamp: DateTime.now().toUtc(),
      dose: medication.usualDose,
      painBefore: painBefore,
    );
    return DoseLog.db.insertRow(session, dose);
  }

  /// Returns the dose logs between [start] and [end] (inclusive days),
  /// ordered by time.
  Future<List<DoseLog>> getDoseRange(
    Session session,
    DateTime start,
    DateTime end,
  ) async {
    final userId = session.authenticated!.authUserId;
    return DoseLog.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.timestamp.between(_startOfDay(start), _endOfDay(end)),
      orderBy: (t) => t.timestamp,
    );
  }

  /// Returns the most recent dose log of any medication, or null if the
  /// user hasn't logged one yet. Used to show "time since last dose".
  Future<DoseLog?> getLastDose(Session session) async {
    final userId = session.authenticated!.authUserId;
    return DoseLog.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.timestamp.desc(),
    );
  }

  /// Midnight UTC at the start of [date]'s calendar day.
  DateTime _startOfDay(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);

  /// The last microsecond of [date]'s calendar day.
  DateTime _endOfDay(DateTime date) => _startOfDay(
    date,
  ).add(const Duration(days: 1)).subtract(const Duration(microseconds: 1));
}
