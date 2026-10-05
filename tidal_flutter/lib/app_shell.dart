import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'client.dart';
import 'features/calendar/data/client_calendar_server_api.dart';
import 'features/calendar/data/server_calendar_repository.dart';
import 'features/calendar/presentation/bloc/calendar_bloc.dart';
import 'features/calendar/presentation/bloc/calendar_event.dart';
import 'features/calendar/presentation/calendar_screen.dart';
import 'features/home/data/client_home_server_api.dart';
import 'features/home/data/server_home_repository.dart';
import 'features/home/presentation/bloc/home_bloc.dart';
import 'features/home/presentation/bloc/home_event.dart';
import 'features/home/presentation/home_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/journal_screen.dart';
import 'screens/me_screen.dart';

/// The app's shell: bottom navigation between Home, Calendar, Insights,
/// Journal, and Me. Each tab keeps its own state (via IndexedStack), and
/// each tab's screen owns its own "+" button if it needs one.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const _calendarTab = 1;
  static const _insightsTab = 2;

  int _index = 0;

  // Bumped every time Insights is opened, so it's rebuilt and reloads with
  // the latest periods instead of showing what it loaded at startup.
  int _insightsVisits = 0;

  // Home's state lives in a HomeBloc, created once here and closed by the
  // provider when the shell goes away (so signing out drops it). It checks
  // for due medication reminders once a minute.
  late final Widget _home = BlocProvider(
    create: (_) => HomeBloc(
      repository: ServerHomeRepository(ClientHomeServerApi(client)),
      now: DateTime.now,
      reminderTicks: Stream<void>.periodic(const Duration(minutes: 1)),
    )..add(const HomeStarted()),
    child: HomeScreen(onOpenCalendar: _openCalendar),
  );

  // The Calendar's state lives in a CalendarBloc, created once here and
  // closed by the provider when the shell goes away. Kept in a field so
  // Home's day circle can ask it to show a date.
  late final CalendarBloc _calendarBloc = CalendarBloc(
    repository: ServerCalendarRepository(ClientCalendarServerApi(client)),
    now: DateTime.now,
  )..add(const CalendarStarted());
  late final Widget _calendar = BlocProvider.value(
    value: _calendarBloc,
    child: const CalendarScreen(),
  );

  List<Widget> get _tabs => [
    _home,
    _calendar,
    InsightsScreen(key: ValueKey(_insightsVisits)),
    const JournalScreen(),
    const MeScreen(),
  ];

  void _openCalendar(DateTime date) {
    _calendarBloc.add(CalendarDateRequested(date));
    setState(() => _index = _calendarTab);
  }

  @override
  void dispose() {
    // BlocProvider.value does not close the bloc, so the shell does.
    _calendarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() {
          if (i == _insightsTab) _insightsVisits++;
          _index = i;
        }),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Calendar',
          ),
          NavigationDestination(
            icon: Icon(Icons.insights_outlined),
            label: 'Insights',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            label: 'Journal',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Me',
          ),
        ],
      ),
    );
  }
}
