import 'package:test/test.dart';
import 'package:tidal_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Log endpoint', (sessionBuilder, endpoints) {
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

    final day = DateTime.utc(2026, 9, 30);

    group('when not signed in', () {
      test('then saveDay throws', () async {
        await expectLater(
          endpoints.log.saveDay(unauthenticated, day, mood: Mood.happy),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });

    group('when no day log exists yet', () {
      test('then saveDay creates one with the given fields', () async {
        final saved = await endpoints.log.saveDay(
          asUserA,
          day,
          mood: Mood.happy,
          note: 'Felt good today',
        );

        expect(saved.flow, FlowLevel.none);
        expect(saved.mood, Mood.happy);
        expect(saved.note, 'Felt good today');
      });
    });

    group('when a day log already has a flow and a note', () {
      test('then saving just the mood leaves the rest untouched', () async {
        await endpoints.log.saveDay(
          asUserA,
          day,
          flow: FlowLevel.heavy,
          note: 'Cramps today',
        );

        final updated = await endpoints.log.saveDay(
          asUserA,
          day,
          mood: Mood.tired,
        );

        expect(updated.flow, FlowLevel.heavy);
        expect(updated.mood, Mood.tired);
        expect(updated.note, 'Cramps today');
      });
    });

    group('when two users logged the same date', () {
      test('then getRange only returns the signed-in user\'s log', () async {
        await endpoints.log.saveDay(asUserA, day, mood: Mood.calm);
        await endpoints.log.saveDay(asUserB, day, mood: Mood.sad);

        final result = await endpoints.log.getRange(asUserA, day, day);

        expect(result, hasLength(1));
        expect(result.single.mood, Mood.calm);
      });
    });

    group('when a user has logged several days', () {
      test('then deleteAll removes only that user\'s logs', () async {
        await endpoints.log.saveDay(asUserA, day, mood: Mood.calm);
        await endpoints.log.saveDay(
          asUserA,
          day.add(const Duration(days: 1)),
          mood: Mood.happy,
        );
        await endpoints.log.saveDay(asUserB, day, mood: Mood.sad);

        await endpoints.log.deleteAll(asUserA);

        final remainingForA = await endpoints.log.getRange(
          asUserA,
          day,
          day.add(const Duration(days: 1)),
        );
        final remainingForB = await endpoints.log.getRange(asUserB, day, day);

        expect(remainingForA, isEmpty);
        expect(remainingForB, hasLength(1));
      });
    });
  });
}
