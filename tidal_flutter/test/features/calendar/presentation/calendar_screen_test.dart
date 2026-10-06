import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_flutter/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:tidal_flutter/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:tidal_flutter/features/calendar/presentation/calendar_screen.dart';

import '../../home/fakes/builders.dart';
import '../fakes/fake_calendar_repository.dart';

// Happy paths only: widgets are found by key or type, never by their text,
// and nothing here depends on how many items are shown. The rules behind
// the screen are tested headlessly (calendar_bloc_test, day_marks_test, ...).
void main() {
  late FakeCalendarRepository repo;
  late CalendarBloc bloc;

  Future<void> pumpCalendar(WidgetTester tester) async {
    bloc = CalendarBloc(
      repository: repo,
      now: () => DateTime(2026, 10, 3, 15),
    )..add(const CalendarStarted());
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const CalendarScreen(),
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
      await tester.pump();
    });
  }

  setUp(() => repo = FakeCalendarRepository());

  testWidgets('tapping a day selects it and loads its detail', (tester) async {
    await pumpCalendar(tester);

    await tester.tap(find.byKey(ValueKey(day(10, 10))));
    await tester.pumpAndSettle();

    expect(bloc.state.selectedDate, day(10, 10));
    expect(repo.loads.last, (day(10, 1), day(10, 10)));
  });

  testWidgets('the next arrow shows the next month', (tester) async {
    await pumpCalendar(tester);

    await tester.tap(find.byKey(const Key('calendar-next-month')));
    await tester.pumpAndSettle();

    expect(bloc.state.month, day(11, 1));
    expect(find.byKey(ValueKey(day(11, 15))), findsOneWidget);
  });

  testWidgets('a long-press shows a message whose Undo reaches the server', (
    tester,
  ) async {
    await pumpCalendar(tester);

    await tester.longPress(find.byKey(ValueKey(day(10, 2))));
    await tester.pumpAndSettle();
    expect(repo.longPresses, [day(10, 2)]);
    expect(find.byType(SnackBar), findsOneWidget);

    await tester.tap(find.byType(SnackBarAction));
    await tester.pumpAndSettle();
    expect(repo.undone, hasLength(1));
  });
}
