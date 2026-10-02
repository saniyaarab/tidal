import 'package:test/test.dart';
import 'package:tidal_server/src/generated/protocol.dart';

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

    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));

    group('when logging a pain level outside 0-10', () {
      test('then logPain throws', () async {
        await expectLater(
          endpoints.pain.logPain(asUserA, 11, [], today, now),
          throwsArgumentError,
        );
      });
    });

    group('when logging pain with a level and locations', () {
      test('then it is saved and shows up in getPainRange', () async {
        final saved = await endpoints.pain.logPain(
          asUserA,
          7,
          [PainLocation.cramps, PainLocation.lowerBack],
          today,
          now,
        );
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

    group('when logging pain for a past day and time', () {
      test('then it is saved on that day with that time', () async {
        final lastNight = yesterday.add(const Duration(hours: 21));

        final saved = await endpoints.pain.logPain(
          asUserA,
          6,
          [],
          yesterday,
          lastNight,
        );

        expect(saved.date, yesterday);
        expect(saved.timestamp, lastNight);
        // The moment it was saved is recorded separately.
        expect(saved.loggedAt.isAfter(lastNight), isTrue);
        expect(
          await endpoints.pain.getPainRange(asUserA, yesterday, yesterday),
          hasLength(1),
        );
        expect(
          await endpoints.pain.getPainRange(asUserA, today, today),
          isEmpty,
        );
      });
    });

    group('when logging pain for a future time', () {
      test('then logPain throws', () async {
        await expectLater(
          endpoints.pain.logPain(
            asUserA,
            5,
            [],
            today,
            now.add(const Duration(hours: 2)),
          ),
          throwsArgumentError,
        );
      });
    });

    group('when two users have logged pain on the same day', () {
      test(
        'then getPainRange only returns the signed-in user\'s entries',
        () async {
          await endpoints.pain.logPain(asUserA, 5, [], today, now);
          await endpoints.pain.logPain(asUserB, 9, [], today, now);

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

    group('when adding a medication with a type', () {
      test('then the type is saved', () async {
        final medication = await endpoints.pain.addMedication(
          asUserA,
          'Yaz',
          '1 pill',
          type: MedicationType.birthControl,
        );

        expect(medication.type, MedicationType.birthControl);
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
            today,
            now,
          );

          expect(dose.dose, '400 mg');

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
          endpoints.pain.logDose(asUserB, medication.id!, today, now),
          throwsArgumentError,
        );
      });
    });

    group('when a user has taken two medications several times', () {
      test(
        'then getLastDosePerMedication returns the latest of each',
        () async {
          final ibuprofen = await endpoints.pain.addMedication(
            asUserA,
            'Ibuprofen',
            '400 mg',
          );
          final vitaminD = await endpoints.pain.addMedication(
            asUserA,
            'Vitamin D',
            '1000 IU',
            type: MedicationType.vitamin,
          );
          final earlier = now.subtract(const Duration(hours: 5));
          await endpoints.pain.logDose(asUserA, ibuprofen.id!, today, earlier);
          final latestIbuprofen = await endpoints.pain.logDose(
            asUserA,
            ibuprofen.id!,
            today,
            now,
          );
          final latestVitamin = await endpoints.pain.logDose(
            asUserA,
            vitaminD.id!,
            today,
            earlier,
          );

          final latest = await endpoints.pain.getLastDosePerMedication(
            asUserA,
          );

          expect(
            {for (final dose in latest) dose.id},
            {latestIbuprofen.id, latestVitamin.id},
          );
        },
      );
    });

    group('when a user has never logged a dose', () {
      test('then getLastDosePerMedication is empty', () async {
        expect(await endpoints.pain.getLastDosePerMedication(asUserB), isEmpty);
      });
    });
  });
}
