import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/home/domain/day_data.dart';
import 'package:tidal_flutter/features/home/domain/due_reminder.dart';
import 'package:tidal_flutter/features/home/presentation/bloc/home_bloc.dart';
import 'package:tidal_flutter/features/home/presentation/bloc/home_event.dart';
import 'package:tidal_flutter/features/home/presentation/bloc/home_state.dart';

import '../fakes/builders.dart';
import '../fakes/fake_home_repository.dart';

const ibuprofen = DueReminder(
  reminderId: 1,
  medicationId: 10,
  medicationName: 'Ibuprofen',
);

DayData dayWithNote(String note) => DayData(
  dayLog: dayLog(day(10, 3), note: note),
  period: null,
  painEntries: const [],
  bowelMovements: const [],
  units: FakeHomeRepository.emptyDay.units,
);

void main() {
  late FakeHomeRepository repo;
  late StreamController<void> ticks;
  late HomeBloc bloc;

  // "Now" is 3 Oct 2026, mid-afternoon local time.
  HomeBloc makeBloc() => HomeBloc(
    repository: repo,
    now: () => DateTime(2026, 10, 3, 15),
    reminderTicks: ticks.stream,
  );

  /// Lets every pending future and microtask finish.
  Future<void> settle() => pumpEventQueue();

  setUp(() {
    repo = FakeHomeRepository();
    ticks = StreamController<void>.broadcast();
    bloc = makeBloc();
  });

  tearDown(() async {
    await bloc.close();
    await ticks.close();
  });

  test('starts on today, loading', () {
    expect(bloc.state.selectedDate, day(10, 3));
    expect(bloc.state.dayStatus, DayLoadStatus.loading);
  });

  group('start', () {
    test('loads the day, the prediction and the reminders', () async {
      repo.prediction = Prediction(currentCycleDay: 4);
      repo.reminders = [ibuprofen];

      bloc.add(const HomeStarted());
      await settle();

      expect(bloc.state.dayStatus, DayLoadStatus.loaded);
      expect(bloc.state.day, FakeHomeRepository.emptyDay);
      expect(bloc.state.prediction?.currentCycleDay, 4);
      expect(bloc.state.dueReminders, [ibuprofen]);
      expect(repo.loadedDays, [day(10, 3)]);
    });

    test('a failed day load shows an error but keeps the rest', () async {
      repo.dayError = Exception('boom');
      repo.reminders = [ibuprofen];

      bloc.add(const HomeStarted());
      await settle();

      expect(bloc.state.dayStatus, DayLoadStatus.failed);
      expect(bloc.state.error, contains('boom'));
      expect(bloc.state.prediction, isNotNull);
      expect(bloc.state.dueReminders, [ibuprofen]);
    });

    test('a failed prediction load is silent', () async {
      repo.predictionError = Exception('boom');

      bloc.add(const HomeStarted());
      await settle();

      expect(bloc.state.dayStatus, DayLoadStatus.loaded);
      expect(bloc.state.error, isNull);
      expect(bloc.state.prediction, isNull);
    });

    test('a failed reminder load is silent and keeps what was shown', () async {
      repo.reminders = [ibuprofen];
      bloc.add(const HomeStarted());
      await settle();

      repo.remindersError = Exception('boom');
      ticks.add(null);
      await settle();

      expect(bloc.state.dueReminders, [ibuprofen]);
      expect(bloc.state.dayStatus, DayLoadStatus.loaded);
    });
  });

  group('changing day', () {
    test('loads the new day and leaves the prediction alone', () async {
      bloc.add(const HomeStarted());
      await settle();

      bloc.add(const HomeDayChanged(-1));
      await settle();

      expect(bloc.state.selectedDate, day(10, 2));
      expect(bloc.state.dayStatus, DayLoadStatus.loaded);
      expect(repo.loadedDays, [day(10, 3), day(10, 2)]);
      expect(repo.predictionLoads, 1);
    });

    test('shows loading while the new day loads', () async {
      bloc.add(const HomeStarted());
      await settle();
      repo.pendingDays[day(10, 4)] = Completer();

      bloc.add(const HomeDayChanged(1));
      await settle();

      expect(bloc.state.selectedDate, day(10, 4));
      expect(bloc.state.dayStatus, DayLoadStatus.loading);
    });

    test('only the last chosen day is shown, even if an earlier load '
        'finishes late', () async {
      bloc.add(const HomeStarted());
      await settle();
      final slow = Completer<DayData>();
      final fast = Completer<DayData>();
      repo.pendingDays[day(10, 2)] = slow;
      repo.pendingDays[day(10, 1)] = fast;

      bloc
        ..add(const HomeDayChanged(-1))
        ..add(const HomeDayChanged(-1));
      await settle();
      fast.complete(dayWithNote('first of October'));
      await settle();
      slow.complete(dayWithNote('second of October'));
      await settle();

      expect(bloc.state.selectedDate, day(10, 1));
      expect(bloc.state.day?.dayLog?.note, 'first of October');
      expect(bloc.state.dayStatus, DayLoadStatus.loaded);
    });
  });

  group('refreshing', () {
    setUp(() async {
      bloc.add(const HomeStarted());
      await settle();
    });

    test('pull-to-refresh reloads only the day', () async {
      bloc.add(const HomeRefreshed());
      await settle();

      expect(repo.loadedDays, [day(10, 3), day(10, 3)]);
      expect(repo.predictionLoads, 1);
      expect(repo.reminderLoads, 1);
    });

    test('returning from the log screen reloads the day and reminders, '
        'not the prediction', () async {
      bloc.add(const HomeReturnedFromLog());
      await settle();

      expect(repo.loadedDays, hasLength(2));
      expect(repo.reminderLoads, 2);
      expect(repo.predictionLoads, 1);
    });

    test('a tick reloads the reminders only', () async {
      repo.reminders = [ibuprofen];

      ticks.add(null);
      await settle();

      expect(bloc.state.dueReminders, [ibuprofen]);
      expect(repo.reminderLoads, 2);
      expect(repo.loadedDays, hasLength(1));
    });
  });

  group('reminder actions', () {
    setUp(() async {
      repo.reminders = [ibuprofen];
      bloc.add(const HomeStarted());
      await settle();
    });

    test(
      'logging a dose calls the repository, then reloads reminders',
      () async {
        repo.reminders = [];

        bloc.add(const HomeReminderDoseLogged(ibuprofen));
        await settle();

        expect(repo.loggedDoses, [ibuprofen]);
        expect(bloc.state.dueReminders, isEmpty);
      },
    );

    test('dismissing calls the repository, then reloads reminders', () async {
      repo.reminders = [];

      bloc.add(const HomeReminderDismissed(ibuprofen));
      await settle();

      expect(repo.dismissed, [ibuprofen]);
      expect(bloc.state.dueReminders, isEmpty);
    });

    test('a failing log dose keeps the banner and does not throw', () async {
      repo.logDoseError = Exception('offline');

      bloc.add(const HomeReminderDoseLogged(ibuprofen));
      await settle();

      expect(bloc.state.dueReminders, [ibuprofen]);
      expect(repo.reminderLoads, 2);
    });

    test('a failing dismiss keeps the banner and does not throw', () async {
      repo.dismissError = Exception('offline');

      bloc.add(const HomeReminderDismissed(ibuprofen));
      await settle();

      expect(bloc.state.dueReminders, [ibuprofen]);
      expect(repo.reminderLoads, 2);
    });
  });

  group('closing', () {
    test('a day load that finishes after close emits nothing and throws '
        'nothing', () async {
      final late = Completer<DayData>();
      repo.pendingDays[day(10, 3)] = late;
      final emitted = <HomeState>[];
      final subscription = bloc.stream.listen(emitted.add);

      bloc.add(const HomeStarted());
      await settle();
      final closing = bloc.close();
      late.complete(dayWithNote('too late'));
      await closing;
      await settle();
      await subscription.cancel();

      expect(emitted.any((s) => s.day != null), isFalse);
    });

    test('stops listening to the reminder ticks', () async {
      expect(ticks.hasListener, isTrue);

      await bloc.close();

      expect(ticks.hasListener, isFalse);
    });
  });
}
