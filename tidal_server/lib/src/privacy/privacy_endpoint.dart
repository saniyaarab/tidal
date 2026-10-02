import 'package:serverpod_auth_idp_server/core.dart';

import '../generated/protocol.dart';
import '../generated/serverpod.dart';

/// "Delete all my data" from the Privacy screen.
class PrivacyEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Permanently deletes everything tied to the signed-in user — day logs,
  /// periods, pain entries, medications and doses, sign-up answers — and
  /// then their account itself, signing them out everywhere. Nothing is
  /// kept, not even anonymously.
  ///
  /// Runs in one transaction, so either everything is deleted or nothing is.
  Future<void> deleteAllMyData(Session session) async {
    final userId = session.authenticated!.authUserId;

    await session.db.transaction((transaction) async {
      await DayLog.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId),
        transaction: transaction,
      );
      await Period.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId),
        transaction: transaction,
      );
      await PainEntry.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId),
        transaction: transaction,
      );
      // Doses point at medications, so they go first.
      await DoseLog.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId),
        transaction: transaction,
      );
      await Medication.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId),
        transaction: transaction,
      );
      await CycleSettings.db.deleteWhere(
        session,
        where: (t) => t.userId.equals(userId),
        transaction: transaction,
      );
      // Also removes the email login, profile and sessions, which are linked
      // to the account with cascading deletes.
      await const AuthUsers().delete(
        session,
        authUserId: userId,
        transaction: transaction,
      );
    });

    // Tell the rest of the server this user's sign-ins are no longer valid.
    await session.messages.authenticationRevoked(
      userId.uuid,
      RevokedAuthenticationUser(),
    );
  }
}
