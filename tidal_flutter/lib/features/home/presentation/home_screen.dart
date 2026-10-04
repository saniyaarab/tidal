import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../date_format.dart';
import '../../../screens/log_screen.dart';
import '../../../theme.dart';
import '../../../widgets/day_bands.dart';
import '../domain/cycle_outlook.dart';
import '../domain/day_status.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'home_text.dart';
import 'widgets/cycle_header.dart';
import 'widgets/day_circle.dart';
import 'widgets/reminder_banner.dart';

/// The "Today" tab: a big circle showing whether the selected day is a
/// period day (and its flow, if logged), with prev/next arrows to look at
/// other days, and bands below it showing that day's log. Tapping the
/// circle opens the Calendar on that day.
///
/// This widget only draws [HomeState] and reports what the user does; the
/// loading and the rules live in [HomeBloc] and the domain layer. It needs
/// a [HomeBloc] above it in the tree.
class HomeScreen extends StatelessWidget {
  /// Switches to the Calendar tab with the given date selected.
  final ValueChanged<DateTime> onOpenCalendar;

  const HomeScreen({super.key, required this.onOpenCalendar});

  Future<void> _openLogMenu(BuildContext context) async {
    final bloc = context.read<HomeBloc>();
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LogScreen(
          date: bloc.state.selectedDate,
          dayLog: bloc.state.day?.dayLog,
        ),
      ),
    );
    if (changed == true) bloc.add(const HomeReturnedFromLog());
  }

  /// Pull-to-refresh: asks for a reload and waits until the day has loaded.
  Future<void> _refresh(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    bloc.add(const HomeRefreshed());
    return bloc.stream.firstWhere((s) => s.dayStatus != DayLoadStatus.loading);
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<HomeBloc>();
    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openLogMenu(context),
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refresh(context),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            final prediction = state.prediction;
            final outlook = prediction == null
                ? null
                : buildCycleOutlook(prediction, todayAsDateKey());
            final status = buildDayStatus(
              date: state.selectedDate,
              period: state.day?.period,
              dayLog: state.day?.dayLog,
            );
            final day = state.day;

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                for (final reminder in state.dueReminders)
                  ReminderBanner(
                    medicationName: reminder.medicationName,
                    onLogDose: () => bloc.add(HomeReminderDoseLogged(reminder)),
                    onDismiss: () => bloc.add(HomeReminderDismissed(reminder)),
                  ),
                if (outlook != null) CycleHeader(outlook: outlook),
                DayCircle(
                  date: state.selectedDate,
                  status: dayStatusText(status),
                  onTap: () => onOpenCalendar(state.selectedDate),
                  onPrevious: () => bloc.add(const HomeDayChanged(-1)),
                  onNext: () => bloc.add(const HomeDayChanged(1)),
                ),
                const SizedBox(height: 24),
                if (state.dayStatus == DayLoadStatus.loading)
                  const Center(child: CircularProgressIndicator())
                else if (state.dayStatus == DayLoadStatus.failed)
                  Text(
                    'Could not load this day: ${state.error}',
                    style: const TextStyle(color: TidalColors.rose),
                  )
                else if (day != null)
                  DayBands(
                    dayLog: day.dayLog,
                    painEntries: day.painEntries,
                    bowelMovements: day.bowelMovements,
                    units: day.units,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
