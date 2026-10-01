import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Marks a dose log ready for its "did it help?" check-in. Scheduled by
/// [PainEndpoint.logDose] an hour after the dose, and again 30 minutes
/// after a snooze (see [PainEndpoint.snoozeCheckIn]).
class CheckInFutureCall extends FutureCall {
  Future<void> check(Session session, int doseLogId) async {
    final dose = await DoseLog.db.findById(session, doseLogId);
    // The dose may have been answered (or deleted) before this fires.
    if (dose == null || dose.painAfter != null) return;

    await DoseLog.db.updateRow(session, dose.copyWith(checkInDue: true));
  }
}
