import 'package:test/test.dart';
import 'package:tidal_server/src/generated/protocol.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Insight endpoint', (sessionBuilder, endpoints) {
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

    // Logs a day of period flow, the same way the Pain log sheet's "Flow"
    // tile would.
    Future<void> logFlowDay(TestSessionBuilder session, DateTime date) =>
        endpoints.log.saveDay(session, date, flow: FlowLevel.heavy);

    group('when not signed in', () {
      test('then getPrediction throws', () async {
        await expectLater(
          endpoints.insight.getPrediction(unauthenticated),
          throwsA(isA<ServerpodUnauthenticatedException>()),
        );
      });
    });

    group('when no flow has ever been logged', () {
      test('then the prediction is empty', () async {
        final prediction = await endpoints.insight.getPrediction(asUserA);

        expect(prediction.lastPeriodStart, isNull);
        expect(prediction.currentCycleDay, isNull);
        expect(prediction.nextPeriodStart, isNull);
        expect(prediction.confidenceDays, 0);
      });
    });

    group('when only one period has ever been logged', () {
      test(
        'then the next period is seeded from the default cycle length',
        () async {
          final start = today.subtract(const Duration(days: 4));
          await logFlowDay(asUserA, start);

          final prediction = await endpoints.insight.getPrediction(asUserA);

          expect(prediction.lastPeriodStart, start);
          expect(prediction.currentCycleDay, 5);
          // No completed cycle yet, so the default 28-day cycle length
          // (and default 5-day period length) seed the prediction.
          expect(
            prediction.nextPeriodStart,
            start.add(const Duration(days: 28)),
          );
          expect(prediction.confidenceDays, 4);
          expect(
            prediction.predictedPeriodEnd,
            start.add(const Duration(days: 28 + 4)),
          );
        },
      );

      test('then a saved cycle length seeds it instead of 28', () async {
        final start = today.subtract(const Duration(days: 4));
        await logFlowDay(asUserA, start);
        await endpoints.insight.saveCycleLength(asUserA, 32);

        final prediction = await endpoints.insight.getPrediction(asUserA);

        expect(
          prediction.nextPeriodStart,
          start.add(const Duration(days: 32)),
        );
      });
    });

    group('when a period spans several days', () {
      test('then only its first day counts as the period start', () async {
        final start = today.subtract(const Duration(days: 4));
        await logFlowDay(asUserA, start);
        await logFlowDay(asUserA, start.add(const Duration(days: 1)));
        await logFlowDay(asUserA, start.add(const Duration(days: 2)));

        final prediction = await endpoints.insight.getPrediction(asUserA);

        expect(prediction.lastPeriodStart, start);
        expect(
          prediction.nextPeriodStart,
          start.add(const Duration(days: 28)),
        );
      });
    });

    group('when exactly one cycle is complete', () {
      test(
        'then the next period is predicted from that one length',
        () async {
          final firstStart = today.subtract(const Duration(days: 58));
          final secondStart = firstStart.add(const Duration(days: 30));
          await logFlowDay(asUserA, firstStart);
          await logFlowDay(asUserA, secondStart);

          final prediction = await endpoints.insight.getPrediction(asUserA);

          expect(prediction.lastPeriodStart, secondStart);
          expect(
            prediction.nextPeriodStart,
            secondStart.add(const Duration(days: 30)),
          );
          // A single data point has no spread to measure; falls back to a
          // small default rather than a falsely-precise 0.
          expect(prediction.confidenceDays, 2);
          // Period length defaults to 5 days until the user sets their own.
          expect(
            prediction.predictedPeriodEnd,
            secondStart.add(const Duration(days: 30 + 4)),
          );
        },
      );
    });

    group('when several cycles of different lengths are logged', () {
      test('then the next period uses their average and spread', () async {
        final start1 = today.subtract(const Duration(days: 150));
        final start2 = start1.add(const Duration(days: 28));
        final start3 = start2.add(const Duration(days: 30));
        final start4 = start3.add(const Duration(days: 26));
        for (final date in [start1, start2, start3, start4]) {
          await logFlowDay(asUserA, date);
        }

        final prediction = await endpoints.insight.getPrediction(asUserA);

        // Lengths were 28, 30, 26 -> average 28, spread (30-26)/2 = 2.
        expect(
          prediction.nextPeriodStart,
          start4.add(const Duration(days: 28)),
        );
        expect(prediction.confidenceDays, 2);
      });
    });

    group('when more than 6 cycles are logged', () {
      test('then only the 6 most recent lengths are averaged', () async {
        // An outlier 10-day "cycle" far in the past, followed by six
        // uniform 30-day cycles.
        final starts = [today.subtract(const Duration(days: 250))];
        starts.add(starts.last.add(const Duration(days: 10)));
        for (var i = 0; i < 6; i++) {
          starts.add(starts.last.add(const Duration(days: 30)));
        }
        for (final date in starts) {
          await logFlowDay(asUserA, date);
        }

        final prediction = await endpoints.insight.getPrediction(asUserA);

        // The 10-day outlier is dropped, leaving six identical 30-day
        // lengths: average 30, and no spread among them (clamped to 1).
        expect(
          prediction.nextPeriodStart,
          starts.last.add(const Duration(days: 30)),
        );
        expect(prediction.confidenceDays, 1);
      });
    });

    group('when two users have both logged periods', () {
      test(
        'then getPrediction only uses the signed-in user\'s own flow',
        () async {
          final userAStart1 = today.subtract(const Duration(days: 58));
          final userAStart2 = userAStart1.add(const Duration(days: 30));
          await logFlowDay(asUserA, userAStart1);
          await logFlowDay(asUserA, userAStart2);

          // User B's periods are a totally different length and position in
          // time; if they leaked in, they'd change A's prediction.
          await logFlowDay(asUserB, today.subtract(const Duration(days: 10)));
          await logFlowDay(asUserB, today.subtract(const Duration(days: 5)));

          final prediction = await endpoints.insight.getPrediction(asUserA);

          expect(prediction.lastPeriodStart, userAStart2);
          expect(
            prediction.nextPeriodStart,
            userAStart2.add(const Duration(days: 30)),
          );
        },
      );
    });

    group('when the period length has never been set', () {
      test('then getPeriodLength defaults to 5', () async {
        expect(await endpoints.insight.getPeriodLength(asUserA), 5);
      });
    });

    group('when saving a period length', () {
      test('then getPeriodLength returns it afterwards', () async {
        await endpoints.insight.savePeriodLength(asUserA, 7);

        expect(await endpoints.insight.getPeriodLength(asUserA), 7);
      });

      test('then saving again overwrites the previous value', () async {
        await endpoints.insight.savePeriodLength(asUserA, 7);
        await endpoints.insight.savePeriodLength(asUserA, 4);

        expect(await endpoints.insight.getPeriodLength(asUserA), 4);
      });

      test('then a value outside 1-14 throws', () async {
        await expectLater(
          endpoints.insight.savePeriodLength(asUserA, 0),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.insight.savePeriodLength(asUserA, 15),
          throwsArgumentError,
        );
      });

      test('then it only affects the signed-in user', () async {
        await endpoints.insight.savePeriodLength(asUserA, 7);

        expect(await endpoints.insight.getPeriodLength(asUserB), 5);
      });

      test('then it sizes the predicted period window', () async {
        final firstStart = today.subtract(const Duration(days: 58));
        final secondStart = firstStart.add(const Duration(days: 30));
        await logFlowDay(asUserA, firstStart);
        await logFlowDay(asUserA, secondStart);
        await endpoints.insight.savePeriodLength(asUserA, 7);

        final prediction = await endpoints.insight.getPrediction(asUserA);

        expect(
          prediction.predictedPeriodEnd,
          secondStart.add(const Duration(days: 30 + 6)),
        );
      });
    });

    group('when the cycle length has never been set', () {
      test('then getCycleLength defaults to 28', () async {
        expect(await endpoints.insight.getCycleLength(asUserA), 28);
      });
    });

    group('when saving a cycle length', () {
      test('then getCycleLength returns it afterwards', () async {
        await endpoints.insight.saveCycleLength(asUserA, 32);

        expect(await endpoints.insight.getCycleLength(asUserA), 32);
      });

      test('then saving again overwrites the previous value', () async {
        await endpoints.insight.saveCycleLength(asUserA, 32);
        await endpoints.insight.saveCycleLength(asUserA, 24);

        expect(await endpoints.insight.getCycleLength(asUserA), 24);
      });

      test('then a value outside 15-45 throws', () async {
        await expectLater(
          endpoints.insight.saveCycleLength(asUserA, 14),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.insight.saveCycleLength(asUserA, 46),
          throwsArgumentError,
        );
      });

      test('then it only affects the signed-in user', () async {
        await endpoints.insight.saveCycleLength(asUserA, 32);

        expect(await endpoints.insight.getCycleLength(asUserB), 28);
      });
    });

    group('when cycle settings have never been saved', () {
      test('then hasCycleSettings is false', () async {
        expect(await endpoints.insight.hasCycleSettings(asUserA), isFalse);
      });
    });

    group('when cycle length is saved but birth year is not', () {
      test('then hasCycleSettings is still false', () async {
        await endpoints.insight.saveCycleLength(asUserA, 32);

        // Birth year is part of the one-time sign-up step too, so it isn't
        // "done" until that's saved as well.
        expect(await endpoints.insight.hasCycleSettings(asUserA), isFalse);
      });
    });

    group('when birth year has also been saved', () {
      test('then hasCycleSettings becomes true for just that user', () async {
        await endpoints.insight.saveCycleLength(asUserA, 32);
        await endpoints.insight.saveBirthYear(asUserA, today.year - 25);

        expect(await endpoints.insight.hasCycleSettings(asUserA), isTrue);
        expect(await endpoints.insight.hasCycleSettings(asUserB), isFalse);
      });
    });

    group('when birth year has never been set', () {
      test('then getBirthYear and getAge are both null', () async {
        expect(await endpoints.insight.getBirthYear(asUserA), isNull);
        expect(await endpoints.insight.getAge(asUserA), isNull);
      });
    });

    group('when saving a birth year', () {
      test('then getAge computes the year difference', () async {
        await endpoints.insight.saveBirthYear(asUserA, today.year - 20);

        expect(await endpoints.insight.getBirthYear(asUserA), today.year - 20);
        expect(await endpoints.insight.getAge(asUserA), 20);
      });

      test('then a year in the future throws', () async {
        await expectLater(
          endpoints.insight.saveBirthYear(asUserA, today.year + 1),
          throwsArgumentError,
        );
      });

      test('then an age outside 8-100 throws', () async {
        await expectLater(
          endpoints.insight.saveBirthYear(asUserA, today.year - 5),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.insight.saveBirthYear(asUserA, today.year - 101),
          throwsArgumentError,
        );
      });

      test('then it only affects the signed-in user', () async {
        await endpoints.insight.saveBirthYear(asUserA, today.year - 25);

        expect(await endpoints.insight.getBirthYear(asUserB), isNull);
      });
    });
  });
}
