import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Marks a medication reminder as due, so Home shows "Ibuprofen due
/// now". Scheduled by `PainEndpoint.logDose` for the dose time plus the
/// medication's `reminderEveryHours`.
class MedicationReminderFutureCall extends FutureCall {
  Future<void> markDue(Session session, int reminderId) async {
    final reminder = await MedicationReminder.db.findById(session, reminderId);
    if (reminder == null || reminder.isDue) return;
    // A newer dose may have pushed the reminder later since this call was
    // scheduled; that dose scheduled its own call, so leave it to that one.
    final now = DateTime.now().toUtc();
    if (reminder.dueAt.isAfter(now.add(const Duration(minutes: 1)))) return;

    await MedicationReminder.db.updateRow(
      session,
      reminder.copyWith(isDue: true),
    );
  }
}
