import 'package:test/test.dart';
import 'package:tidal_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Journal endpoint', (sessionBuilder, endpoints) {
    final userAId = '550e8400-e29b-41d4-a716-446655440000';
    final userBId = '550e8400-e29b-41d4-a716-446655440001';

    final asUserA = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userAId,
        {},
      ),
    );
    final asUserB = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.authenticationInfo(
        userBId,
        {},
      ),
    );
    final unauthenticated = sessionBuilder.copyWith(
      authentication: AuthenticationOverride.unauthenticated(),
    );

    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    group('when not signed in', () {
      test('then getDay throws', () async {
        await expectLater(
          endpoints.journal.getDay(unauthenticated, today),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });

    group('when nothing was journaled that day', () {
      test('then getDay returns null', () async {
        expect(await endpoints.journal.getDay(asUserA, today), isNull);
      });
    });

    group('when saving a day', () {
      test('then getDay returns it, in checklist order', () async {
        await endpoints.journal.saveDay(
          asUserA,
          today,
          [SelfCareActivity.tookNap, SelfCareActivity.meditated],
          'Sunset walk',
        );

        final entry = await endpoints.journal.getDay(asUserA, today);

        expect(entry!.activities, [
          SelfCareActivity.meditated,
          SelfCareActivity.tookNap,
        ]);
        expect(entry.bestMoment, 'Sunset walk');
      });

      test('then saving again replaces the day', () async {
        await endpoints.journal.saveDay(
          asUserA,
          today,
          [SelfCareActivity.madeTea],
          'First',
        );
        await endpoints.journal.saveDay(asUserA, today, [], '  ');

        final entry = await endpoints.journal.getDay(asUserA, today);

        expect(entry!.activities, isEmpty);
        // Blank text is saved as no text.
        expect(entry.bestMoment, isNull);
      });

      test('then each day is kept separately', () async {
        await endpoints.journal.saveDay(
          asUserA,
          yesterday,
          [SelfCareActivity.readBook],
          null,
        );
        await endpoints.journal.saveDay(
          asUserA,
          today,
          [SelfCareActivity.wentOutside],
          null,
        );

        final entry = await endpoints.journal.getDay(asUserA, yesterday);

        expect(entry!.activities, [SelfCareActivity.readBook]);
      });
    });

    group('when saving a future date', () {
      test('then it throws', () async {
        await expectLater(
          endpoints.journal.saveDay(
            asUserA,
            today.add(const Duration(days: 3)),
            [SelfCareActivity.meditated],
            null,
          ),
          throwsArgumentError,
        );
      });
    });

    group('when two users journal the same day', () {
      test('then each only sees their own entry', () async {
        await endpoints.journal.saveDay(
          asUserA,
          today,
          [SelfCareActivity.tookBath],
          null,
        );

        expect(await endpoints.journal.getDay(asUserB, today), isNull);
      });
    });
  });
}
