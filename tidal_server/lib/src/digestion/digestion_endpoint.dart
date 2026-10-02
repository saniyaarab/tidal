import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../generated/serverpod.dart';

/// Bowel movements (Bristol Stool Scale). Bloating and acid reflux are
/// once-a-day fields on `DayLog`, saved through `LogEndpoint`.
///
/// Every method only ever reads or writes the signed-in user's own data.
class DigestionEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  // Allows for a phone clock running slightly ahead of the server's.
  static const _clockSkew = Duration(minutes: 5);

  /// Logs a bowel movement of [bristolType] (1–7) on [date] at [timestamp].
  Future<BowelMovement> logBowelMovement(
    Session session,
    DateTime date,
    DateTime timestamp,
    int bristolType,
  ) async {
    if (bristolType < 1 || bristolType > 7) {
      throw ArgumentError('bristolType must be between 1 and 7');
    }
    final now = DateTime.now().toUtc();
    if (_dateOnly(date).isAfter(_dateOnly(now).add(const Duration(days: 1))) ||
        timestamp.toUtc().isAfter(now.add(_clockSkew))) {
      throw ArgumentError("Can't log for a future date or time.");
    }

    return BowelMovement.db.insertRow(
      session,
      BowelMovement(
        userId: session.authenticated!.authUserId,
        date: _dateOnly(date),
        timestamp: timestamp.toUtc(),
        loggedAt: now,
        bristolType: bristolType,
      ),
    );
  }

  /// Bowel movements for the days [start] through [end], ordered by time.
  Future<List<BowelMovement>> getBowelMovementRange(
    Session session,
    DateTime start,
    DateTime end,
  ) {
    final userId = session.authenticated!.authUserId;
    return BowelMovement.db.find(
      session,
      where: (t) =>
          t.userId.equals(userId) &
          t.date.between(_dateOnly(start), _dateOnly(end)),
      orderBy: (t) => t.timestamp,
    );
  }

  DateTime _dateOnly(DateTime date) =>
      DateTime.utc(date.year, date.month, date.day);
}
