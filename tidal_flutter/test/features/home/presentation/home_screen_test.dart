import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_flutter/features/home/domain/day_data.dart';
import 'package:tidal_flutter/features/home/domain/due_reminder.dart';
import 'package:tidal_flutter/features/home/presentation/bloc/home_bloc.dart';
import 'package:tidal_flutter/features/home/presentation/bloc/home_event.dart';
import 'package:tidal_flutter/features/home/presentation/home_screen.dart';
import 'package:tidal_flutter/features/home/presentation/widgets/day_circle.dart';
import 'package:tidal_flutter/features/home/presentation/widgets/reminder_banner.dart';
import 'package:tidal_flutter/widgets/day_bands.dart';

import '../fakes/builders.dart';
import '../fakes/fake_home_repository.dart';

// Happy paths only: widgets are found by key or type, never by their text,
// and nothing here depends on how many items are shown. The rules behind
// the screen are tested headlessly (home_bloc_test, day_status_test, ...).
void main() {
  late FakeHomeRepository repo;
  late StreamController<void> ticks;
  late HomeBloc bloc;
  late List<DateTime> openedCalendar;

  Future<void> pumpHome(WidgetTester tester) async {
    bloc = HomeBloc(
      repository: repo,
      now: () => DateTime(2026, 10, 3, 15),
      reminderTicks: ticks.stream,
    )..add(const HomeStarted());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: HomeScreen(onOpenCalendar: openedCalendar.add),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Unmount the screen, then close the bloc without waiting for it, as
    // BlocProvider does. (Awaiting close() never finishes on the test's fake
    // clock.)
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox());
      unawaited(bloc.close());
      unawaited(ticks.close());
      await tester.pump();
    });
  }

  setUp(() {
    repo = FakeHomeRepository();
    ticks = StreamController<void>.broadcast();
    openedCalendar = [];
  });

  testWidgets('shows the day, its bands and a due reminder', (tester) async {
    repo.dayFor = (date) => DayData(
      dayLog: null,
      period: period(day(10, 1)),
      painEntries: [pain(date)],
      bowelMovements: const [],
      units: FakeHomeRepository.emptyDay.units,
    );
    repo.reminders = [
      const DueReminder(
        reminderId: 1,
        medicationId: 10,
        medicationName: 'Ibuprofen',
      ),
    ];

    await pumpHome(tester);

    expect(find.byKey(DayCircle.circleKey), findsOneWidget);
    expect(find.byType(DayBands), findsOneWidget);
    expect(find.byType(ReminderBanner), findsOneWidget);
  });

  testWidgets('tapping the circle opens the calendar on that day', (
    tester,
  ) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(DayCircle.circleKey));

    expect(openedCalendar, [day(10, 3)]);
  });

  testWidgets('the next arrow moves to the next day', (tester) async {
    await pumpHome(tester);

    await tester.tap(find.byKey(DayCircle.nextKey));
    await tester.pumpAndSettle();

    expect(repo.loadedDays.last, day(10, 4));
  });
}
