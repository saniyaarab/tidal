import 'package:test/test.dart';
import 'package:tidal_server/src/generated/protocol.dart';
import 'package:tidal_server/src/pain/check_in_future_call.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given Pain endpoint', (sessionBuilder, endpoints) {
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

    final today = DateTime.now().toUtc();

    group('when logging a pain level outside 0-10', () {
      test('then logPain throws', () async {
        await expectLater(
          endpoints.pain.logPain(asUserA, 11, []),
          throwsArgumentError,
        );
      });
    });

    group('when logging pain with a level and locations', () {
      test('then it is saved and shows up in getPainRange', () async {
        final saved = await endpoints.pain.logPain(asUserA, 7, [
          PainLocation.cramps,
          PainLocation.lowerBack,
        ]);
        expect(saved.level, 7);
        expect(saved.locations, [PainLocation.cramps, PainLocation.lowerBack]);

        final range = await endpoints.pain.getPainRange(
          asUserA,
          today,
          today,
        );
        expect(range, hasLength(1));
        expect(range.single.level, 7);
      });
    });

    group('when two users have logged pain on the same day', () {
      test(
        'then getPainRange only returns the signed-in user\'s entries',
        () async {
          await endpoints.pain.logPain(asUserA, 5, []);
          await endpoints.pain.logPain(asUserB, 9, []);

          final result = await endpoints.pain.getPainRange(
            asUserA,
            today,
            today,
          );

          expect(result, hasLength(1));
          expect(result.single.level, 5);
        },
      );
    });

    group('when a user has no medications yet', () {
      test('then myMeds is empty', () async {
        final meds = await endpoints.pain.myMeds(asUserA);
        expect(meds, isEmpty);
      });
    });

    group('when adding a medication and logging a dose', () {
      test(
        'then the dose copies the usual dose and shows up in range',
        () async {
          final medication = await endpoints.pain.addMedication(
            asUserA,
            'Ibuprofen',
            '400 mg',
          );

          final dose = await endpoints.pain.logDose(
            asUserA,
            medication.id!,
            painBefore: 7,
          );

          expect(dose.dose, '400 mg');
          expect(dose.painBefore, 7);

          final range = await endpoints.pain.getDoseRange(
            asUserA,
            today,
            today,
          );
          expect(range, hasLength(1));
          expect(range.single.medicationId, medication.id);
        },
      );
    });

    group('when logging a dose for another user\'s medication', () {
      test('then logDose throws', () async {
        final medication = await endpoints.pain.addMedication(
          asUserA,
          'Paracetamol',
          '500 mg',
        );

        await expectLater(
          endpoints.pain.logDose(asUserB, medication.id!),
          throwsArgumentError,
        );
      });
    });

    group('when a user has logged two doses over time', () {
      test('then getLastDose returns the most recent one', () async {
        final medication = await endpoints.pain.addMedication(
          asUserA,
          'Ibuprofen',
          '400 mg',
        );

        await endpoints.pain.logDose(asUserA, medication.id!);
        final second = await endpoints.pain.logDose(asUserA, medication.id!);

        final last = await endpoints.pain.getLastDose(asUserA);
        expect(last, isNotNull);
        expect(last!.id, second.id);
      });
    });

    group('when a user has never logged a dose', () {
      test('then getLastDose returns null', () async {
        final last = await endpoints.pain.getLastDose(asUserB);
        expect(last, isNull);
      });
    });

    group('when a dose has just been logged', () {
      test('then its check-in is not pending yet', () async {
        final medication = await endpoints.pain.addMedication(
          asUserA,
          'Ibuprofen',
          '400 mg',
        );
        await endpoints.pain.logDose(asUserA, medication.id!);

        expect(await endpoints.pain.getPendingCheckIn(asUserA), isNull);
      });
    });

    group('when CheckInFutureCall runs for a dose', () {
      test('then getPendingCheckIn returns that dose', () async {
        final medication = await endpoints.pain.addMedication(
          asUserA,
          'Ibuprofen',
          '400 mg',
        );
        final dose = await endpoints.pain.logDose(
          asUserA,
          medication.id!,
          painBefore: 7,
        );

        await CheckInFutureCall().check(asUserA.build(), dose.id!);

        final pending = await endpoints.pain.getPendingCheckIn(asUserA);
        expect(pending, isNotNull);
        expect(pending!.id, dose.id);
      });

      test('then it leaves an already-answered dose alone', () async {
        final medication = await endpoints.pain.addMedication(
          asUserA,
          'Ibuprofen',
          '400 mg',
        );
        final dose = await endpoints.pain.logDose(asUserA, medication.id!);
        await endpoints.pain.recordRelief(asUserA, dose.id!, 2);

        await CheckInFutureCall().check(asUserA.build(), dose.id!);

        expect(await endpoints.pain.getPendingCheckIn(asUserA), isNull);
      });
    });

    group('when answering a pending check-in', () {
      test(
        'then recordRelief saves painAfter and clears the pending flag',
        () async {
          final medication = await endpoints.pain.addMedication(
            asUserA,
            'Ibuprofen',
            '400 mg',
          );
          final dose = await endpoints.pain.logDose(
            asUserA,
            medication.id!,
            painBefore: 7,
          );
          await CheckInFutureCall().check(asUserA.build(), dose.id!);

          final updated = await endpoints.pain.recordRelief(
            asUserA,
            dose.id!,
            3,
          );

          expect(updated.painAfter, 3);
          expect(updated.checkInDue, isFalse);
          expect(await endpoints.pain.getPendingCheckIn(asUserA), isNull);
        },
      );

      test('then an out-of-range value throws', () async {
        final medication = await endpoints.pain.addMedication(
          asUserA,
          'Ibuprofen',
          '400 mg',
        );
        final dose = await endpoints.pain.logDose(asUserA, medication.id!);

        await expectLater(
          endpoints.pain.recordRelief(asUserA, dose.id!, 11),
          throwsArgumentError,
        );
      });

      test('then another user cannot answer it', () async {
        final medication = await endpoints.pain.addMedication(
          asUserA,
          'Ibuprofen',
          '400 mg',
        );
        final dose = await endpoints.pain.logDose(asUserA, medication.id!);

        await expectLater(
          endpoints.pain.recordRelief(asUserB, dose.id!, 3),
          throwsArgumentError,
        );
      });
    });

    group('when snoozing a pending check-in', () {
      test('then it is no longer pending right away', () async {
        final medication = await endpoints.pain.addMedication(
          asUserA,
          'Ibuprofen',
          '400 mg',
        );
        final dose = await endpoints.pain.logDose(asUserA, medication.id!);
        await CheckInFutureCall().check(asUserA.build(), dose.id!);

        await endpoints.pain.snoozeCheckIn(asUserA, dose.id!);

        expect(await endpoints.pain.getPendingCheckIn(asUserA), isNull);
      });
    });
  });
}
