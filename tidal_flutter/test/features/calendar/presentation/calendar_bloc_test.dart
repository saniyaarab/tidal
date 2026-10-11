import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/calendar/domain/calendar_data.dart';
import 'package:tidal_flutter/features/calendar/domain/period_message.dart';
import 'package:tidal_flutter/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:tidal_flutter/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:tidal_flutter/features/calendar/presentation/bloc/calendar_state.dart';

import '../../home/fakes/builders.dart';
import '../fakes/fake_calendar_repository.dart';

/// Empty data with a day log whose note says where it came from.
CalendarData dataWithNote(
  String note, {
  List<PeriodSpan> periods = const [],
  List<PainEntry> monthPain = const [],
}) => CalendarData(
  monthDayLogs: [dayLog(day(10, 3), note: note)],
  monthPainEntries: monthPain,
  periods: periods,
  selectedPainEntries: const [],
  selectedBowelMovements: const [],
  units: FakeCalendarRepository.emptyData.units,
  prediction: prediction(),
);

void main() {
  late FakeCalendarRepository repo;
  late CalendarBloc bloc;
  late List<CalendarState> states;

  // "Now" is 3 Oct 2026, mid-afternoon local time.
  CalendarBloc makeBloc() =>
      CalendarBloc(repository: repo, now: () => DateTime(2026, 10, 3, 15));

  /// Lets every pending future and microtask finish.
  Future<void> settle() => pumpEventQueue();

  /// The ids of the distinct messages seen, in order.
  List<int> messageIds() => {
    for (final s in states)
      if (s.message != null) s.message!.id,
  }.toList();

  setUp(() {
    repo = FakeCalendarRepository();
    bloc = makeBloc();
    states = [];
    bloc.stream.listen(states.add);
  });

  tearDown(() => bloc.close());

  test('starts on today, loading', () {
    expect(bloc.state.month, day(10, 1));
    expect(bloc.state.selectedDate, day(10, 3));
    expect(bloc.state.status, CalendarLoadStatus.loading);
  });

  group('started', () {
    test('loads today\'s month and day, then reports loaded', () async {
      repo.dataFor = (_, _) => dataWithNote(
        'x',
        periods: [period(day(10, 30), days: 4)],
        monthPain: [pain(day(10, 4))],
      );
      bloc.add(const CalendarStarted());
      await settle();

      expect(repo.loads, [(day(10, 1), day(10, 3))]);
      expect(states.first.status, CalendarLoadStatus.loading);
      final s = bloc.state;
      expect(s.status, CalendarLoadStatus.loaded);
      expect(s.dayLogs.keys, [day(10, 3)]);
      expect(s.painDates, {day(10, 4)});
      // The period spans two months, so its days run into November.
      expect(s.periodDates, {day(10, 30), day(10, 31), day(11, 1), day(11, 2)});
      expect(s.units, isNotNull);
      expect(s.prediction, isNotNull);
    });
  });

  group('changing month', () {
    test('next loads the following month and keeps the selected day', () async {
      bloc.add(const CalendarMonthChanged(1));
      await settle();
      expect(bloc.state.month, day(11, 1));
      expect(bloc.state.selectedDate, day(10, 3));
      expect(repo.loads.last, (day(11, 1), day(10, 3)));
    });

    test('previous loads the earlier month', () async {
      bloc.add(const CalendarMonthChanged(-1));
      await settle();
      expect(bloc.state.month, day(9, 1));
      expect(repo.loads.last, (day(9, 1), day(10, 3)));
    });
  });

  test('selecting a day loads that day\'s detail', () async {
    bloc.add(CalendarDateSelected(day(10, 10)));
    await settle();
    expect(bloc.state.selectedDate, day(10, 10));
    expect(repo.loads.last, (day(10, 1), day(10, 10)));
    expect(bloc.state.status, CalendarLoadStatus.loaded);
  });

  test('a date requested by Home jumps to its month and selects it', () async {
    bloc.add(CalendarDateRequested(day(11, 12)));
    await settle();
    expect(bloc.state.month, day(11, 1));
    expect(bloc.state.selectedDate, day(11, 12));
    expect(repo.loads.last, (day(11, 1), day(11, 12)));
  });

  group('failure and stale answers', () {
    test(
      'a failed load carries an error and keeps the grid on screen',
      () async {
        repo.dataFor = (_, _) =>
            dataWithNote('kept', periods: [period(day(10, 5), days: 2)]);
        bloc.add(const CalendarStarted());
        await settle();

        repo.loadError = 'offline';
        bloc.add(CalendarDateSelected(day(10, 9)));
        await settle();

        expect(bloc.state.status, CalendarLoadStatus.failed);
        expect(bloc.state.error, contains('offline'));
        expect(bloc.state.periodDates, {day(10, 5), day(10, 6)});
        expect(bloc.state.dayLogs[day(10, 3)]!.note, 'kept');
      },
    );

    test('a later load clears the error', () async {
      repo.loadError = 'offline';
      bloc.add(const CalendarStarted());
      await settle();
      repo.loadError = null;
      bloc.add(const CalendarRefreshed());
      await settle();
      expect(bloc.state.status, CalendarLoadStatus.loaded);
      expect(bloc.state.error, isNull);
    });

    test('an earlier, slower load does not overwrite a newer day', () async {
      final slow = Completer<CalendarData>();
      repo.pendingLoads[(day(10, 1), day(10, 3))] = slow;
      repo.dataFor = (_, selected) => dataWithNote('new');

      bloc.add(const CalendarStarted());
      await settle();
      bloc.add(CalendarDateSelected(day(10, 10)));
      await settle();
      slow.complete(dataWithNote('old'));
      await settle();

      expect(bloc.state.selectedDate, day(10, 10));
      expect(bloc.state.dayLogs[day(10, 3)]!.note, 'new');
    });

    test('an earlier, slower load does not overwrite a newer month', () async {
      final slow = Completer<CalendarData>();
      repo.pendingLoads[(day(11, 1), day(10, 3))] = slow;
      repo.dataFor = (_, _) => dataWithNote('latest');

      bloc.add(const CalendarMonthChanged(1));
      await settle();
      bloc.add(const CalendarMonthChanged(1));
      await settle();
      slow.complete(dataWithNote('stale'));
      await settle();

      expect(bloc.state.month, day(12, 1));
      expect(bloc.state.dayLogs[day(10, 3)]!.note, 'latest');
    });

    test(
      'a refresh superseded by a month change ends on the new month',
      () async {
        final slow = Completer<CalendarData>();
        repo.pendingLoads[(day(10, 1), day(10, 3))] = slow;
        repo.dataFor = (_, _) => dataWithNote('next');

        bloc.add(const CalendarRefreshed());
        await settle();
        bloc.add(const CalendarMonthChanged(1));
        await settle();
        slow.complete(dataWithNote('stale'));
        await settle();

        expect(bloc.state.month, day(11, 1));
        expect(bloc.state.status, CalendarLoadStatus.loaded);
        expect(bloc.state.dayLogs[day(10, 3)]!.note, 'next');
      },
    );

    test('an answer arriving after close emits nothing', () async {
      final slow = Completer<CalendarData>();
      repo.pendingLoads[(day(10, 1), day(10, 3))] = slow;
      bloc.add(const CalendarStarted());
      await settle();

      final closing = bloc.close();
      slow.complete(dataWithNote('late'));
      await closing;

      expect(bloc.state.status, CalendarLoadStatus.loading);
    });
  });

  group('long-press', () {
    test('on a future day makes no request and refuses', () async {
      bloc.add(CalendarDayLongPressed(day(10, 4)));
      await settle();

      expect(repo.longPresses, isEmpty);
      expect(repo.loads, isEmpty);
      expect(
        bloc.state.message!.kind,
        CalendarMessageKind.futureDateRefused,
      );
      expect(bloc.state.message!.canUndo, isFalse);
    });

    final cases = {
      PeriodChangeKind.started: CalendarMessageKind.periodStarted,
      PeriodChangeKind.ended: CalendarMessageKind.periodEnded,
      PeriodChangeKind.moved: CalendarMessageKind.periodMoved,
      PeriodChangeKind.removed: CalendarMessageKind.periodRemoved,
    };
    for (final entry in cases.entries) {
      test(
        '${entry.key.name}: selects the day, reloads, then says so once',
        () async {
          final change = periodChange(entry.key, 4);
          repo.changeToReturn = change;
          bloc.add(CalendarDayLongPressed(day(10, 2)));
          await settle();

          expect(repo.longPresses, [day(10, 2)]);
          expect(bloc.state.selectedDate, day(10, 2));
          expect(repo.loads.last, (day(10, 1), day(10, 2)));
          expect(bloc.state.status, CalendarLoadStatus.loaded);

          final message = bloc.state.message!;
          expect(message.kind, entry.value);
          expect(message.days, 4);
          expect(message.change, same(change));
          expect(messageIds(), hasLength(1));
          // The message arrives after the grid has reloaded.
          final firstWithMessage = states.indexWhere((s) => s.message != null);
          expect(
            states[firstWithMessage].status,
            CalendarLoadStatus.loaded,
          );
        },
      );
    }

    test('a second message replaces the first with a new id', () async {
      bloc.add(CalendarDayLongPressed(day(10, 2)));
      await settle();
      final first = bloc.state.message!;
      bloc.add(CalendarDayLongPressed(day(10, 1)));
      await settle();

      expect(bloc.state.message!.id, isNot(first.id));
      expect(messageIds(), hasLength(2));
    });

    test('a failed update says so and leaves the grid as it was', () async {
      bloc.add(const CalendarStarted());
      await settle();
      final before = bloc.state;
      final loadsBefore = repo.loads.length;

      repo.longPressError = 'offline';
      bloc.add(CalendarDayLongPressed(day(10, 2)));
      await settle();

      expect(bloc.state.message!.kind, CalendarMessageKind.updateFailed);
      expect(bloc.state.message!.error, contains('offline'));
      expect(bloc.state.message!.canUndo, isFalse);
      expect(repo.loads, hasLength(loadsBefore));
      expect(bloc.state.selectedDate, before.selectedDate);
      expect(bloc.state.dayLogs, before.dayLogs);
    });

    test('saved but reload failed: failed state, message with Undo', () async {
      repo.loadError = 'offline';
      bloc.add(CalendarDayLongPressed(day(10, 2)));
      await settle();

      expect(bloc.state.status, CalendarLoadStatus.failed);
      expect(bloc.state.message!.kind, CalendarMessageKind.periodStarted);
      expect(bloc.state.message!.canUndo, isTrue);
    });

    test('a month change during its reload keeps the newer month', () async {
      final slow = Completer<CalendarData>();
      repo.pendingLoads[(day(10, 1), day(10, 2))] = slow;

      bloc.add(CalendarDayLongPressed(day(10, 2)));
      await settle();
      bloc.add(const CalendarMonthChanged(1));
      await settle();
      slow.complete(dataWithNote('stale'));
      await settle();

      expect(bloc.state.month, day(11, 1));
      expect(repo.loads.last.$1, day(11, 1));
      expect(bloc.state.dayLogs, isNot(contains(day(10, 3))));
    });
  });

  group('undo', () {
    final change = periodChange(PeriodChangeKind.started, 5);

    test('reverses the change and reloads', () async {
      bloc.add(CalendarUndoPressed(change));
      await settle();
      expect(repo.undone, [change]);
      expect(repo.loads, hasLength(1));
      expect(bloc.state.status, CalendarLoadStatus.loaded);
    });

    test(
      'when it fails the grid is reloaded anyway, without crashing',
      () async {
        repo.undoError = 'offline';
        bloc.add(CalendarUndoPressed(change));
        await settle();
        expect(repo.undone, [change]);
        expect(repo.loads, hasLength(1));
        expect(bloc.state.status, CalendarLoadStatus.loaded);
      },
    );
  });

  group('doses', () {
    final tylenol = doseLog(7, 10, DateTime.utc(2026, 10, 3, 8));

    test('deleting calls the repository, reloads, then says so', () async {
      bloc.add(CalendarDoseDeleted(tylenol));
      await settle();

      expect(repo.deletedDoses, [tylenol]);
      expect(repo.loads, hasLength(1));
      final message = bloc.state.message!;
      expect(message.kind, CalendarMessageKind.doseRemoved);
      expect(message.dose, tylenol);
      expect(message.canUndo, isTrue);
    });

    test('deleting a dose that is already gone reloads, no message', () async {
      repo.deleteReturnsNull = true;

      bloc.add(CalendarDoseDeleted(tylenol));
      await settle();

      expect(repo.loads, hasLength(1));
      expect(bloc.state.message, isNull);
    });

    test('a failing delete says so and does not reload', () async {
      repo.deleteDoseError = Exception('offline');

      bloc.add(CalendarDoseDeleted(tylenol));
      await settle();

      expect(repo.loads, isEmpty);
      expect(
        bloc.state.message!.kind,
        CalendarMessageKind.doseDeleteFailed,
      );
      expect(bloc.state.message!.canUndo, isFalse);
    });

    test('restoring calls the repository, then reloads', () async {
      bloc.add(CalendarDoseRestored(tylenol));
      await settle();

      expect(repo.restoredDoses, [tylenol]);
      expect(repo.loads, hasLength(1));
    });

    test('a failing restore says so and reloads', () async {
      repo.restoreDoseError = Exception('offline');

      bloc.add(CalendarDoseRestored(tylenol));
      await settle();

      expect(
        bloc.state.message!.kind,
        CalendarMessageKind.doseRestoreFailed,
      );
      expect(repo.loads, hasLength(1));
    });

    test('run in order with period edits', () async {
      final order = <String>[];
      final gate = Completer<void>();
      repo.longPressGate = gate.future;
      repo.onLongPress = () => order.add('period');
      repo.onDeleteDose = () => order.add('dose');

      bloc.add(CalendarDayLongPressed(day(10, 2)));
      bloc.add(CalendarDoseDeleted(tylenol));
      await settle();
      expect(order, ['period']);

      gate.complete();
      await settle();

      expect(order, ['period', 'dose']);
    });
  });

  test('refresh and returning from the log reload the same data', () async {
    bloc.add(const CalendarRefreshed());
    await settle();
    bloc.add(const CalendarReturnedFromLog());
    await settle();
    expect(repo.loads, [
      (day(10, 1), day(10, 3)),
      (day(10, 1), day(10, 3)),
    ]);
  });
}
