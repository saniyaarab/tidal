import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../generated/serverpod.dart';

/// Endpoint for pain logging and the user's medications list. Tidal only
/// ever records what the user says they took; it never suggests doses.
///
/// Pain entries and doses each store the day they belong to, the time they
/// happened (chosen by the user, defaulting to now in the app), and the
/// exact moment they were saved.
///
/// Every method only ever reads or writes the signed-in user's own data.
class PainEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // Allows for a phone clock running slightly ahead of the server's when
  // checking that a chosen time isn't in the future.
  static const _clockSkew = Duration(minutes: 5);

  /// Logs a pain entry for [date] (the calendar day it belongs to) that
  /// happened at [timestamp].
  Future<PainEntry> logPain(
    Session session,
    int level,
    List<PainLocation> locations,
    DateTime date,
    DateTime timestamp,
  ) async {
    if (level < 0 || level > 10) {
      throw ArgumentError('level must be between 0 and 10');
    }
    _checkNotFuture(date, timestamp);

    final entry = PainEntry(
      userId: session.authenticated!.authUserId,
      date: _dateOnly(date),
      timestamp: timestamp.toUtc(),
      loggedAt: DateTime.now().toUtc(),
      level: level,
      locations: locations,
    );
    return PainEntry.db.insertRow(session, entry);
  }

  /// Returns the pain entries for the days [start] through [end]
  /// (inclusive), ordered by time.
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
          t.date.between(_dateOnly(start), _dateOnly(end)),
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

  /// Adds a new medication to the signed-in user's list. [type] and
  /// [reminderEveryHours] are optional.
  Future<Medication> addMedication(
    Session session,
    String name,
    String usualDose, {
    MedicationType? type,
    int? reminderEveryHours,
  }) async {
    _checkReminderHours(reminderEveryHours);
    final medication = Medication(
      userId: session.authenticated!.authUserId,
      name: name,
      usualDose: usualDose,
      type: type,
      reminderEveryHours: reminderEveryHours,
    );
    return Medication.db.insertRow(session, medication);
  }

  /// Turns the reminder for [medicationId] on ("every [hours] hours after a
  /// dose") or off (null). Turning it off also clears any pending reminder.
  Future<Medication> setReminder(
    Session session,
    int medicationId,
    int? hours,
  ) async {
    _checkReminderHours(hours);
    final medication = await _ownMedication(session, medicationId);
    if (hours == null) {
      await MedicationReminder.db.deleteWhere(
        session,
        where: (t) => t.medicationId.equals(medicationId),
      );
    }
    return Medication.db.updateRow(
      session,
      medication.copyWith(reminderEveryHours: hours),
    );
  }

  /// Every reminder the user has (due or upcoming), for "next in 2h".
  Future<List<MedicationReminder>> getReminders(Session session) {
    final userId = session.authenticated!.authUserId;
    return MedicationReminder.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.dueAt,
    );
  }

  /// Hides a due reminder until the next dose is logged.
  Future<void> dismissReminder(Session session, int reminderId) async {
    final userId = session.authenticated!.authUserId;
    final reminder = await MedicationReminder.db.findById(session, reminderId);
    if (reminder == null || reminder.userId != userId) {
      throw ArgumentError('Reminder not found.');
    }
    await MedicationReminder.db.updateRow(
      session,
      reminder.copyWith(isDue: false),
    );
  }

  /// One-tap logging: records that [medicationId] was taken at [timestamp],
  /// on [date] (the calendar day it belongs to), using its usual dose.
  Future<DoseLog> logDose(
    Session session,
    int medicationId,
    DateTime date,
    DateTime timestamp,
  ) async {
    final userId = session.authenticated!.authUserId;
    final medication = await _ownMedication(session, medicationId);
    _checkNotFuture(date, timestamp);

    final dose = DoseLog(
      userId: userId,
      medicationId: medicationId,
      date: _dateOnly(date),
      timestamp: timestamp.toUtc(),
      loggedAt: DateTime.now().toUtc(),
      dose: medication.usualDose,
    );
    final saved = await DoseLog.db.insertRow(session, dose);
    await _scheduleReminder(session, medication, saved.timestamp);
    return saved;
  }

  /// If [medication] has a reminder, sets its next due time to [takenAt]
  /// plus its interval, and schedules [MedicationReminderFutureCall] to mark
  /// it due then. A dose logged after the fact may already be overdue.
  Future<void> _scheduleReminder(
    Session session,
    Medication medication,
    DateTime takenAt,
  ) async {
    final hours = medication.reminderEveryHours;
    if (hours == null) return;

    final dueAt = takenAt.add(Duration(hours: hours));
    final now = DateTime.now().toUtc();
    // An older dose logged after the fact mustn't push back a reminder set
    // by a more recent dose.
    final existing = await MedicationReminder.db.findFirstRow(
      session,
      where: (t) => t.medicationId.equals(medication.id!),
    );
    if (existing != null && existing.dueAt.isAfter(dueAt)) return;

    final reminder = existing == null
        ? await MedicationReminder.db.insertRow(
            session,
            MedicationReminder(
              userId: medication.userId,
              medicationId: medication.id!,
              dueAt: dueAt,
              isDue: !dueAt.isAfter(now),
            ),
          )
        : await MedicationReminder.db.updateRow(
            session,
            existing.copyWith(dueAt: dueAt, isDue: !dueAt.isAfter(now)),
          );

    if (dueAt.isAfter(now)) {
      await session.serverpod.futureCalls
          .callWithDelay(
            dueAt.difference(now),
            identifier:
                'med-reminder-${reminder.id}-${dueAt.toIso8601String()}',
          )
          .medicationReminder
          .markDue(reminder.id!);
    }
  }

  Future<Medication> _ownMedication(Session session, int medicationId) async {
    final medication = await Medication.db.findById(session, medicationId);
    if (medication == null ||
        medication.userId != session.authenticated!.authUserId) {
      throw ArgumentError('Medication not found.');
    }
    return medication;
  }

  void _checkReminderHours(int? hours) {
    if (hours != null && (hours < 1 || hours > 48)) {
      throw ArgumentError('reminder hours must be between 1 and 48');
    }
  }

  /// Returns the dose logs for the days [start] through [end] (inclusive),
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
          t.date.between(_dateOnly(start), _dateOnly(end)),
      orderBy: (t) => t.timestamp,
    );
  }

  /// The most recent dose of each medication the user has ever taken, so
  /// the Medications sheet can show "last taken 3h ago" per medication.
  Future<List<DoseLog>> getLastDosePerMedication(Session session) async {
    final userId = session.authenticated!.authUserId;
    final doses = await DoseLog.db.find(
      session,
      where: (t) => t.userId.equals(userId),
      orderBy: (t) => t.timestamp.desc(),
    );
    final latest = <int, DoseLog>{};
    for (final dose in doses) {
      latest.putIfAbsent(dose.medicationId, () => dose);
    }
    return latest.values.toList();
  }

  /// Throws if [date] or [timestamp] is in the future — only today and
  /// earlier can be logged.
  void _checkNotFuture(DateTime date, DateTime timestamp) {
    final now = DateTime.now().toUtc();
    if (_dateOnly(date).isAfter(_dateOnly(now).add(const Duration(days: 1))) ||
        timestamp.toUtc().isAfter(now.add(_clockSkew))) {
      throw ArgumentError("Can't log for a future date or time.");
    }
  }

  /// Strips the time part off [date], keeping just the calendar day as
  /// midnight UTC. This is how dates are stored, so lookups by date match.
  DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);
}
