import 'package:test/test.dart';
import 'package:tidal_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Period endpoint', (sessionBuilder, endpoints) {
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

    final today = DateTime.utc(
      DateTime.now().toUtc().year,
      DateTime.now().toUtc().month,
      DateTime.now().toUtc().day,
    );
    DateTime daysAgo(int days) => today.subtract(Duration(days: days));

    // All of user A's periods across the last few months.
    Future<List<PeriodSpan>> periodsOfA() =>
        endpoints.period.getPeriods(asUserA, daysAgo(120), today);

    group('when not signed in', () {
      test('then longPress throws', () async {
        await expectLater(
          endpoints.period.longPress(unauthenticated, today),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });

    group('when long-pressing a day with no period nearby', () {
      test('then a period starts there with the default 5 days', () async {
        final change = await endpoints.period.longPress(asUserA, daysAgo(10));

        expect(change.kind, PeriodChangeKind.started);
        expect(change.lengthDays, 5);
        final periods = await periodsOfA();
        expect(periods, hasLength(1));
        expect(periods.single.startDate, daysAgo(10));
        expect(periods.single.endDate, daysAgo(6));
        expect(periods.single.endConfirmed, isFalse);
      });
    });

    group('when long-pressing a future date', () {
      test('then it throws and nothing is saved', () async {
        await expectLater(
          endpoints.period.longPress(
            asUserA,
            today.add(const Duration(days: 1)),
          ),
          throwsArgumentError,
        );
        expect(await periodsOfA(), isEmpty);
      });
    });

    group('when long-pressing a day after a period started', () {
      test('then a day inside the assumed days becomes the end', () async {
        await endpoints.period.longPress(asUserA, daysAgo(10));

        final change = await endpoints.period.longPress(asUserA, daysAgo(8));

        expect(change.kind, PeriodChangeKind.ended);
        expect(change.lengthDays, 3);
        final period = (await periodsOfA()).single;
        expect(period.endDate, daysAgo(8));
        expect(period.endConfirmed, isTrue);
      });

      test('then the 10th day can still be the end', () async {
        await endpoints.period.longPress(asUserA, daysAgo(20));

        final change = await endpoints.period.longPress(asUserA, daysAgo(11));

        expect(change.kind, PeriodChangeKind.ended);
        expect(change.lengthDays, 10);
      });

      test('then the 11th day starts a new period instead', () async {
        await endpoints.period.longPress(asUserA, daysAgo(20));

        final change = await endpoints.period.longPress(asUserA, daysAgo(10));

        expect(change.kind, PeriodChangeKind.started);
        expect(await periodsOfA(), hasLength(2));
      });
    });

    group('when long-pressing a period\'s start date', () {
      test('then the period is removed', () async {
        await endpoints.period.longPress(asUserA, daysAgo(10));

        final change = await endpoints.period.longPress(asUserA, daysAgo(10));

        expect(change.kind, PeriodChangeKind.removed);
        expect(await periodsOfA(), isEmpty);
      });
    });

    group('when long-pressing just before an existing period', () {
      test('then its start moves earlier instead of overlapping', () async {
        await endpoints.period.longPress(asUserA, daysAgo(10));

        final change = await endpoints.period.longPress(asUserA, daysAgo(12));

        expect(change.kind, PeriodChangeKind.moved);
        final period = (await periodsOfA()).single;
        expect(period.startDate, daysAgo(12));
      });
    });

    group('when undoing a change', () {
      test('then undoing a start removes the period', () async {
        final change = await endpoints.period.longPress(asUserA, daysAgo(10));

        await endpoints.period.undo(asUserA, change);

        expect(await periodsOfA(), isEmpty);
      });

      test('then undoing an end makes it assumed again', () async {
        await endpoints.period.longPress(asUserA, daysAgo(10));
        final change = await endpoints.period.longPress(asUserA, daysAgo(8));

        await endpoints.period.undo(asUserA, change);

        final period = (await periodsOfA()).single;
        expect(period.endConfirmed, isFalse);
        expect(period.endDate, daysAgo(6));
      });

      test('then undoing a removal brings the period back', () async {
        await endpoints.period.longPress(asUserA, daysAgo(10));
        await endpoints.period.longPress(asUserA, daysAgo(7));
        final change = await endpoints.period.longPress(asUserA, daysAgo(10));

        await endpoints.period.undo(asUserA, change);

        final period = (await periodsOfA()).single;
        expect(period.startDate, daysAgo(10));
        expect(period.endDate, daysAgo(7));
        expect(period.endConfirmed, isTrue);
      });

      test('then another user cannot undo it', () async {
        final change = await endpoints.period.longPress(asUserA, daysAgo(10));

        await expectLater(
          endpoints.period.undo(asUserB, change),
          throwsArgumentError,
        );
        expect(await periodsOfA(), hasLength(1));
      });
    });

    group('when periods have confirmed ends', () {
      test('then the default length is their average, rounded up', () async {
        await endpoints.period.longPress(asUserA, daysAgo(60));
        await endpoints.period.longPress(asUserA, daysAgo(57)); // 4 days
        await endpoints.period.longPress(asUserA, daysAgo(30));
        await endpoints.period.longPress(asUserA, daysAgo(26)); // 5 days
        await endpoints.period.longPress(asUserA, daysAgo(2)); // assumed

        final info = await endpoints.period.getDefaultPeriodLength(asUserA);

        // 4.5 rounds up to 5; the assumed period doesn't count.
        expect(info.days, 5);
        expect(info.fromPeriods, 2);
      });
    });

    group('when two users both have periods', () {
      test('then getPeriods only returns the signed-in user\'s', () async {
        await endpoints.period.longPress(asUserA, daysAgo(10));
        await endpoints.period.longPress(asUserB, daysAgo(40));

        final periods = await periodsOfA();

        expect(periods, hasLength(1));
        expect(periods.single.startDate, daysAgo(10));
      });
    });
  });
}
