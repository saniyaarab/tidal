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
    // An older dose logged after the fact mustn't push back a reminder set
    // by a more recent dose.
    final existing = await _reminderOf(session, medication);
    if (existing != null && existing.dueAt.isAfter(dueAt)) return;

    await _setReminder(session, medication, existing, dueAt);
  }

  Future<MedicationReminder?> _reminderOf(
    Session session,
    Medication medication,
  ) {
    return MedicationReminder.db.findFirstRow(
      session,
      where: (t) => t.medicationId.equals(medication.id!),
    );
  }

  /// Saves [dueAt] as the reminder time for [medication] (creating or
  /// updating its one reminder, [existing]) and, if it's still ahead,
  /// schedules [MedicationReminderFutureCall] to mark it due then.
  Future<void> _setReminder(
    Session session,
    Medication medication,
    MedicationReminder? existing,
    DateTime dueAt,
  ) async {
    final now = DateTime.now().toUtc();
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
            identifier: _reminderCallId(reminder.id!, dueAt),
          )
          .medicationReminder
          .markDue(reminder.id!);
    }
  }

  String _reminderCallId(int reminderId, DateTime dueAt) =>
      'med-reminder-$reminderId-${dueAt.toIso8601String()}';

  /// After [changed] was deleted or restored, points [medication]'s reminder
  /// at its latest dose, or removes it if no dose is left. Does nothing if
  /// [changed] isn't the latest dose, so a reminder the user already
  /// dismissed isn't brought back by an older dose coming or going. Unlike
  /// [_scheduleReminder], this may move the due time earlier.
  Future<void> _recalculateReminder(
    Session session,
    Medication medication,
    DoseLog changed,
  ) async {
    final hours = medication.reminderEveryHours;
    if (hours == null) return;

    final latest = await DoseLog.db.findFirstRow(
      session,
      where: (t) => t.medicationId.equals(medication.id!),
      orderBy: (t) => t.timestamp.desc(),
    );
    if (latest != null && latest.timestamp.isAfter(changed.timestamp)) return;

    final existing = await _reminderOf(session, medication);
    if (latest == null) {
      if (existing != null) {
        await session.serverpod.futureCalls.cancel(
          _reminderCallId(existing.id!, existing.dueAt),
        );
        await MedicationReminder.db.deleteRow(session, existing);
      }
      return;
    }

    final dueAt = latest.timestamp.add(Duration(hours: hours));
    if (existing != null) {
      // The call for the old time would find the reminder dismissed and
      // mark it due again, so cancel it.
      await session.serverpod.futureCalls.cancel(
        _reminderCallId(existing.id!, existing.dueAt),
      );
    }
    await _setReminder(session, medication, existing, dueAt);
  }

  /// Deletes one of the signed-in user's doses (e.g. one logged by mistake)
  /// and returns it, so the app can offer Undo through [restoreDose].
  /// Returns null if there's no such dose, or it isn't the user's: the same
  /// answer either way, so it doesn't reveal that someone else's dose exists.
  Future<DoseLog?> deleteDose(Session session, int doseLogId) async {
    final userId = session.authenticated!.authUserId;
    final dose = await DoseLog.db.findById(session, doseLogId);
    if (dose == null || dose.userId != userId) return null;

    final medication = await Medication.db.findById(session, dose.medicationId);
    await DoseLog.db.deleteRow(session, dose);
    if (medication != null) {
      await _recalculateReminder(session, medication, dose);
    }
    return dose;
  }

  /// Puts back a dose returned by [deleteDose] (Undo): the same medication,
  /// day, time, dose text and saved-at time, as a new row. Always saved under
  /// the signed-in user, whatever the passed dose says.
  Future<DoseLog> restoreDose(Session session, DoseLog dose) async {
    final medication = await _ownMedication(session, dose.medicationId);
    _checkNotFuture(dose.date, dose.timestamp);

    final saved = await DoseLog.db.insertRow(
      session,
      DoseLog(
        userId: session.authenticated!.authUserId,
        medicationId: medication.id!,
        date: _dateOnly(dose.date),
        timestamp: dose.timestamp.toUtc(),
        loggedAt: dose.loggedAt.toUtc(),
        dose: dose.dose,
      ),
    );
    await _recalculateReminder(session, medication, saved);
    return saved;
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
