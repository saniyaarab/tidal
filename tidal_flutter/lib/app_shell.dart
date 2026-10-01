import 'package:flutter/material.dart';

import 'screens/calendar_screen.dart';
import 'screens/coming_soon_screen.dart';
import 'screens/home_screen.dart';
import 'screens/me_screen.dart';

/// The app's shell: bottom navigation between Home, Calendar, Insights,
/// Partner, and Me. Each tab keeps its own state (via IndexedStack), and
/// each tab's screen owns its own "+" button if it needs one.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;

  static const _tabs = [
    HomeScreen(),
    CalendarScreen(),
    ComingSoonScreen(title: 'Insights'),
    ComingSoonScreen(title: 'Partner'),
    MeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
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
            icon: Icon(Icons.favorite_border),
            label: 'Partner',
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
