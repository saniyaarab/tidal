import 'package:serverpod/serverpod.dart' show UuidValue;
import 'package:test/test.dart';
import 'package:tidal_server/src/generated/protocol.dart';
import 'package:tidal_server/src/pain/medication_reminder_future_call.dart';

import 'test_tools/serverpod_test_tools.dart';

void main() {
  withServerpod('Given the daily details', (sessionBuilder, endpoints) {
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
    final nextWeek = today.add(const Duration(days: 7));

    Future<DayLog> dayOfA() async =>
        (await endpoints.log.getRange(asUserA, today, today)).single;

    group('when saving drink counts', () {
      test('then each drink is counted separately', () async {
        await endpoints.log.saveDrinkCount(asUserA, today, DrinkType.water, 6);
        await endpoints.log.saveDrinkCount(
          asUserA,
          today,
          DrinkType.caffeine,
          2,
        );

        final day = await dayOfA();

        expect(day.waterGlasses, 6);
        expect(day.caffeineDrinks, 2);
        expect(day.alcoholDrinks, 0);
      });

      test('then a negative count throws', () async {
        await expectLater(
          endpoints.log.saveDrinkCount(asUserA, today, DrinkType.alcohol, -1),
          throwsArgumentError,
        );
      });
    });

    group('when saving the other once-a-day details', () {
      test('then they are saved without touching flow, mood or note', () async {
        await endpoints.log.saveDay(asUserA, today, note: 'hello');
        await endpoints.log.saveSleep(asUserA, today, 4, 7.5);
        await endpoints.log.saveDigestionDay(
          asUserA,
          today,
          Severity.mild,
          Severity.none,
        );
        await endpoints.log.saveWeight(asUserA, today, 62.5);
        await endpoints.log.saveTemperature(asUserA, today, 36.6);
        await endpoints.log.saveMucus(asUserA, today, MucusType.eggWhite);
        await endpoints.log.saveLove(asUserA, today, LoveType.protected);

        final day = await dayOfA();

        expect(day.note, 'hello');
        expect(day.sleepQuality, 4);
        expect(day.sleepHours, 7.5);
        expect(day.bloating, Severity.mild);
        expect(day.acidReflux, Severity.none);
        expect(day.weightKg, 62.5);
        expect(day.temperatureC, 36.6);
        expect(day.mucus, MucusType.eggWhite);
        expect(day.love, LoveType.protected);
      });

      test('then saving null clears a value', () async {
        await endpoints.log.saveWeight(asUserA, today, 62.5);
        await endpoints.log.saveWeight(asUserA, today, null);

        expect((await dayOfA()).weightKg, isNull);
      });

      test('then out-of-range values throw', () async {
        await expectLater(
          endpoints.log.saveSleep(asUserA, today, 6, null),
          throwsArgumentError,
        );
        await expectLater(
          endpoints.log.saveTemperature(asUserA, today, 45),
          throwsArgumentError,
        );
      });

      test('then future dates throw', () async {
        await expectLater(
          endpoints.log.saveLove(asUserA, nextWeek, LoveType.unprotected),
          throwsArgumentError,
        );
      });
    });

    group('when logging bowel movements', () {
      test('then several per day are kept, in time order', () async {
        final morning = today.add(const Duration(hours: 8));
        await endpoints.digestion.logBowelMovement(asUserA, today, now, 4);
        await endpoints.digestion.logBowelMovement(
          asUserA,
          today,
          morning.isAfter(now) ? now : morning,
          6,
        );

        final entries = await endpoints.digestion.getBowelMovementRange(
          asUserA,
          today,
          today,
        );

        expect(entries, hasLength(2));
        expect(
          await endpoints.digestion.getBowelMovementRange(
            asUserB,
            today,
            today,
          ),
          isEmpty,
        );
      });

      test('then a type outside 1-7 throws', () async {
        await expectLater(
          endpoints.digestion.logBowelMovement(asUserA, today, now, 8),
          throwsArgumentError,
        );
      });
    });

    group('when choosing units', () {
      test('then they are remembered, kg and °C by default', () async {
        var units = await endpoints.insight.getUnitPreferences(asUserA);
        expect(units.weightUnit, WeightUnit.kg);
        expect(units.temperatureUnit, TemperatureUnit.celsius);

        await endpoints.insight.saveWeightUnit(asUserA, WeightUnit.lb);
        await endpoints.insight.saveTemperatureUnit(
          asUserA,
          TemperatureUnit.fahrenheit,
        );

        units = await endpoints.insight.getUnitPreferences(asUserA);
        expect(units.weightUnit, WeightUnit.lb);
        expect(units.temperatureUnit, TemperatureUnit.fahrenheit);
      });
    });

    group('when a medication has a reminder', () {
      Future<Medication> ibuprofenEvery4h() => endpoints.pain.addMedication(
        asUserA,
        'Ibuprofen',
        '400 mg',
        reminderEveryHours: 4,
      );

      test('then logging a dose sets it for 4 hours later', () async {
        final medication = await ibuprofenEvery4h();

        await endpoints.pain.logDose(asUserA, medication.id!, today, now);

        final reminder = (await endpoints.pain.getReminders(asUserA)).single;
        expect(reminder.medicationId, medication.id);
        expect(reminder.isDue, isFalse);
        expect(
          reminder.dueAt.difference(now).inMinutes,
          closeTo(4 * 60, 1),
        );
      });

      test('then a dose logged long ago is due right away', () async {
        final medication = await ibuprofenEvery4h();

        await endpoints.pain.logDose(
          asUserA,
          medication.id!,
          today,
          now.subtract(const Duration(hours: 5)),
        );

        expect(
          (await endpoints.pain.getReminders(asUserA)).single.isDue,
          isTrue,
        );
      });

      test('then the future call marks it due once the time comes', () async {
        final medication = await ibuprofenEvery4h();
        await endpoints.pain.logDose(
          asUserA,
          medication.id!,
          today,
          now.subtract(const Duration(hours: 3, minutes: 59, seconds: 30)),
        );
        final reminder = (await endpoints.pain.getReminders(asUserA)).single;
        expect(reminder.isDue, isFalse);

        // The real call fires after a delay that can't be awaited in a
        // test, so run it directly. The reminder is 30 seconds away, within
        // the call's one-minute leeway, so it counts as time having come.
        await MedicationReminderFutureCall().markDue(
          sessionBuilder.build(),
          reminder.id!,
        );

        expect(
          (await endpoints.pain.getReminders(asUserA)).single.isDue,
          isTrue,
        );
      });

      test(
        'then the future call does nothing if a newer dose moved it',
        () async {
          final medication = await ibuprofenEvery4h();
          await endpoints.pain.logDose(asUserA, medication.id!, today, now);
          final reminder = (await endpoints.pain.getReminders(asUserA)).single;

          await MedicationReminderFutureCall().markDue(
            sessionBuilder.build(),
            reminder.id!,
          );

          expect(
            (await endpoints.pain.getReminders(asUserA)).single.isDue,
            isFalse,
          );
        },
      );

      test('then dismissing hides it until the next dose', () async {
        final medication = await ibuprofenEvery4h();
        await endpoints.pain.logDose(
          asUserA,
          medication.id!,
          today,
          now.subtract(const Duration(hours: 5)),
        );
        final reminder = (await endpoints.pain.getReminders(asUserA)).single;

        await endpoints.pain.dismissReminder(asUserA, reminder.id!);

        expect(
          (await endpoints.pain.getReminders(asUserA)).single.isDue,
          isFalse,
        );
      });

      test('then turning it off removes the reminder', () async {
        final medication = await ibuprofenEvery4h();
        await endpoints.pain.logDose(asUserA, medication.id!, today, now);

        await endpoints.pain.setReminder(asUserA, medication.id!, null);

        expect(await endpoints.pain.getReminders(asUserA), isEmpty);
      });

      test('then another user cannot dismiss it', () async {
        final medication = await ibuprofenEvery4h();
        await endpoints.pain.logDose(
          asUserA,
          medication.id!,
          today,
          now.subtract(const Duration(hours: 5)),
        );
        final reminder = (await endpoints.pain.getReminders(asUserA)).single;

        await expectLater(
          endpoints.pain.dismissReminder(asUserB, reminder.id!),
          throwsArgumentError,
        );
      });
    });

    group('when removing and restoring a dose', () {
      Future<Medication> ibuprofenEvery4h() => endpoints.pain.addMedication(
        asUserA,
        'Ibuprofen',
        '400 mg',
        reminderEveryHours: 4,
      );

      Future<DoseLog> takeAt(Medication medication, Duration ago) =>
          endpoints.pain.logDose(
            asUserA,
            medication.id!,
            today,
            now.subtract(ago),
          );

      Future<List<DoseLog>> dosesOfA() =>
          endpoints.pain.getDoseRange(asUserA, today, today);

      test('then deleteDose removes the dose and returns it', () async {
        final medication = await ibuprofenEvery4h();
        final dose = await takeAt(medication, const Duration(hours: 1));

        final deleted = await endpoints.pain.deleteDose(asUserA, dose.id!);

        expect(deleted?.id, dose.id);
        expect(deleted?.dose, '400 mg');
        expect(await dosesOfA(), isEmpty);
      });

      test('then another user cannot delete it', () async {
        final medication = await ibuprofenEvery4h();
        final dose = await takeAt(medication, const Duration(hours: 1));

        final result = await endpoints.pain.deleteDose(asUserB, dose.id!);

        expect(result, isNull);
        expect(await dosesOfA(), hasLength(1));
      });

      test('then a missing dose, or a second delete, returns null', () async {
        final medication = await ibuprofenEvery4h();
        final dose = await takeAt(medication, const Duration(hours: 1));

        expect(
          await endpoints.pain.deleteDose(asUserA, dose.id! + 1000),
          isNull,
        );
        expect(await endpoints.pain.deleteDose(asUserA, dose.id!), isNotNull);
        expect(await endpoints.pain.deleteDose(asUserA, dose.id!), isNull);
      });

      test('then deleting the latest dose recalculates the reminder', () async {
        final medication = await ibuprofenEvery4h();
        final earlier = await takeAt(medication, const Duration(hours: 3));
        final latest = await takeAt(medication, const Duration(hours: 1));

        await endpoints.pain.deleteDose(asUserA, latest.id!);

        final reminder = (await endpoints.pain.getReminders(asUserA)).single;
        final expected = earlier.timestamp.add(const Duration(hours: 4));
        expect(
          reminder.dueAt.difference(expected).inSeconds.abs(),
          lessThan(2),
        );
        expect(reminder.isDue, isFalse);
      });

      test('then deleting the only dose removes the reminder', () async {
        final medication = await ibuprofenEvery4h();
        final dose = await takeAt(medication, const Duration(hours: 1));
        expect(await endpoints.pain.getReminders(asUserA), hasLength(1));

        await endpoints.pain.deleteDose(asUserA, dose.id!);

        expect(await endpoints.pain.getReminders(asUserA), isEmpty);
      });

      test('then deleting an older dose leaves the reminder alone', () async {
        final medication = await ibuprofenEvery4h();
        final older = await takeAt(medication, const Duration(hours: 6));
        await takeAt(medication, const Duration(hours: 5));
        final before = (await endpoints.pain.getReminders(asUserA)).single;
        await endpoints.pain.dismissReminder(asUserA, before.id!);

        await endpoints.pain.deleteDose(asUserA, older.id!);

        final after = (await endpoints.pain.getReminders(asUserA)).single;
        expect(after.isDue, isFalse);
        expect(after.dueAt, before.dueAt);
      });

      test('then restoreDose brings back the same dose and reminder', () async {
        final medication = await ibuprofenEvery4h();
        final dose = await takeAt(medication, const Duration(hours: 1));
        final deleted = await endpoints.pain.deleteDose(asUserA, dose.id!);
        expect(await endpoints.pain.getReminders(asUserA), isEmpty);

        await endpoints.pain.restoreDose(asUserA, deleted!);

        final restored = (await dosesOfA()).single;
        expect(restored.medicationId, medication.id);
        expect(restored.date, dose.date);
        expect(restored.timestamp, dose.timestamp);
        expect(restored.dose, dose.dose);
        expect(restored.loggedAt, dose.loggedAt);
        final reminder = (await endpoints.pain.getReminders(asUserA)).single;
        final expected = dose.timestamp.add(const Duration(hours: 4));
        expect(
          reminder.dueAt.difference(expected).inSeconds.abs(),
          lessThan(2),
        );
      });

      test('then restoring an older dose leaves the reminder alone', () async {
        final medication = await ibuprofenEvery4h();
        final older = await takeAt(medication, const Duration(hours: 6));
        await takeAt(medication, const Duration(hours: 5));
        final before = (await endpoints.pain.getReminders(asUserA)).single;
        final deleted = await endpoints.pain.deleteDose(asUserA, older.id!);
        await endpoints.pain.dismissReminder(asUserA, before.id!);

        await endpoints.pain.restoreDose(asUserA, deleted!);

        final after = (await endpoints.pain.getReminders(asUserA)).single;
        expect(after.isDue, isFalse);
        expect(after.dueAt, before.dueAt);
      });

      test('then another user cannot restore into my medication', () async {
        final medication = await ibuprofenEvery4h();
        final dose = await takeAt(medication, const Duration(hours: 1));

        await expectLater(
          endpoints.pain.restoreDose(asUserB, dose),
          throwsArgumentError,
        );
        expect(await dosesOfA(), hasLength(1));
      });

      test('then restoring a future dose throws and saves nothing', () async {
        final medication = await ibuprofenEvery4h();
        final future = DoseLog(
          userId: UuidValue.fromString(userAId),
          medicationId: medication.id!,
          date: today,
          timestamp: now.add(const Duration(hours: 2)),
          loggedAt: now,
          dose: '400 mg',
        );

        await expectLater(
          endpoints.pain.restoreDose(asUserA, future),
          throwsArgumentError,
        );
        expect(await dosesOfA(), isEmpty);
      });

      test('then a restored dose is saved under the signed-in user', () async {
        final medication = await ibuprofenEvery4h();
        final stranger = DoseLog(
          userId: UuidValue.fromString(userBId),
          medicationId: medication.id!,
          date: today,
          timestamp: now.subtract(const Duration(hours: 1)),
          loggedAt: now,
          dose: '400 mg',
        );

        await endpoints.pain.restoreDose(asUserA, stranger);

        expect((await dosesOfA()).single.userId.toString(), userAId);
        expect(
          await endpoints.pain.getDoseRange(asUserB, today, today),
          isEmpty,
        );
      });
    });
  });
}
