import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart';
import 'package:test/test.dart';
import 'package:tidal_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Privacy endpoint', (sessionBuilder, endpoints) {
    final unauthenticated = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);

    // A real account (unlike the made-up ids in other tests), since this
    // endpoint deletes the account itself.
    Future<(TestSessionBuilder, UuidValue)> signedInUser() async {
      final account = await const AuthUsers().create(sessionBuilder.build());
      final asUser = sessionBuilder.copyWith(
        authentication: AuthenticationOverride.authenticationInfo(
          account.id.uuid,
          {},
        ),
      );
      return (asUser, account.id);
    }

    // Logs one of everything the app can store for [asUser].
    Future<void> logEverything(TestSessionBuilder asUser) async {
      await endpoints.insight.saveCycleLength(asUser, 28);
      await endpoints.insight.saveBirthYear(asUser, 1994);
      await endpoints.log.saveDay(asUser, today, note: 'hello');
      await endpoints.period.longPress(
        asUser,
        today.subtract(const Duration(days: 3)),
      );
      await endpoints.pain.logPain(asUser, 6, [], today, now);
      final medication = await endpoints.pain.addMedication(
        asUser,
        'Ibuprofen',
        '400 mg',
      );
      await endpoints.pain.setReminder(asUser, medication.id!, 4);
      await endpoints.pain.logDose(asUser, medication.id!, today, now);
      await endpoints.digestion.logBowelMovement(asUser, today, now, 4);
      await endpoints.journal.saveDay(
        asUser,
        today,
        [SelfCareActivity.madeTea],
        'Tea in the sun',
      );
    }

    group('when not signed in', () {
      test('then deleteAllMyData throws', () async {
        await expectLater(
          endpoints.privacy.deleteAllMyData(unauthenticated),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });

    group('when a user deletes all their data', () {
      test('then everything tied to them is gone, account included', () async {
        final (asUser, userId) = await signedInUser();
        await logEverything(asUser);

        await endpoints.privacy.deleteAllMyData(asUser);

        final session = sessionBuilder.build();
        expect(
          await DayLog.db.count(session, where: (t) => t.userId.equals(userId)),
          0,
        );
        expect(
          await Period.db.count(session, where: (t) => t.userId.equals(userId)),
          0,
        );
        expect(
          await PainEntry.db.count(
            session,
            where: (t) => t.userId.equals(userId),
          ),
          0,
        );
        expect(
          await DoseLog.db.count(
            session,
            where: (t) => t.userId.equals(userId),
          ),
          0,
        );
        expect(
          await Medication.db.count(
            session,
            where: (t) => t.userId.equals(userId),
          ),
          0,
        );
        expect(
          await BowelMovement.db.count(
            session,
            where: (t) => t.userId.equals(userId),
          ),
          0,
        );
        expect(
          await MedicationReminder.db.count(
            session,
            where: (t) => t.userId.equals(userId),
          ),
          0,
        );
        expect(
          await JournalEntry.db.count(
            session,
            where: (t) => t.userId.equals(userId),
          ),
          0,
        );
        expect(
          await CycleSettings.db.count(
            session,
            where: (t) => t.userId.equals(userId),
          ),
          0,
        );
        await expectLater(
          const AuthUsers().get(session, authUserId: userId),
          throwsA(isA<AuthUserNotFoundException>()),
        );
      });

      test('then another user\'s data is untouched', () async {
        final (asUser, _) = await signedInUser();
        final (asOther, otherId) = await signedInUser();
        await logEverything(asUser);
        await logEverything(asOther);

        await endpoints.privacy.deleteAllMyData(asUser);

        final session = sessionBuilder.build();
        expect(
          await PainEntry.db.count(
            session,
            where: (t) => t.userId.equals(otherId),
          ),
          1,
        );
        expect(
          (await const AuthUsers().get(session, authUserId: otherId)).id,
          otherId,
        );
      });
    });
  });
}
