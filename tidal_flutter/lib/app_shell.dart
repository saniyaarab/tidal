import 'package:flutter/material.dart';

import 'screens/calendar_screen.dart';
import 'screens/home_screen.dart';
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

  // Home sets this when its day circle is tapped; the Calendar listens and
  // jumps to that date.
  final _calendarDate = ValueNotifier<DateTime?>(null);

  // Bumped every time Insights is opened, so it's rebuilt and reloads with
  // the latest periods instead of showing what it loaded at startup.
  int _insightsVisits = 0;

  late final HomeScreen _home = HomeScreen(onOpenCalendar: _openCalendar);
  late final CalendarScreen _calendar = CalendarScreen(
    dateToShow: _calendarDate,
  );

  List<Widget> get _tabs => [
    _home,
    _calendar,
    InsightsScreen(key: ValueKey(_insightsVisits)),
    const JournalScreen(),
    const MeScreen(),
  ];

  void _openCalendar(DateTime date) {
    _calendarDate.value = date;
    setState(() => _index = _calendarTab);
  }

  @override
  void dispose() {
    _calendarDate.dispose();
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
