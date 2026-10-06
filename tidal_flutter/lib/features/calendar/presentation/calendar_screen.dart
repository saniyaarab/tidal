import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../date_format.dart';
import '../../../screens/log_screen.dart';
import '../../../theme.dart';
import '../../../widgets/day_bands.dart';
import 'bloc/calendar_bloc.dart';
import 'bloc/calendar_event.dart';
import 'bloc/calendar_state.dart';
import 'calendar_text.dart';
import 'widgets/legend.dart';
import 'widgets/month_grid.dart';
import 'widgets/month_header.dart';

/// The "Calendar" tab: a month grid with a rose ring on period days (solid
/// for logged periods, faded for the predicted window), a soft lavender ring
/// on fertile days, and a small dot on days with a pain entry. Tapping a
/// day shows its full log below, the same way Home does for the selected
/// day. Long-pressing a day starts, ends, or removes a period (see "Period
/// tracking" in CLAUDE.md; the rules live in `PeriodEndpoint.longPress`).
///
/// This widget only draws [CalendarState] and reports what the user does;
/// the loading and the rules live in [CalendarBloc] and the domain layer. It
/// needs a [CalendarBloc] above it in the tree.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  Future<void> _openLogMenu(BuildContext context) async {
    final bloc = context.read<CalendarBloc>();
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LogScreen(
          date: bloc.state.selectedDate,
          dayLog: bloc.state.dayLogFor(bloc.state.selectedDate),
        ),
      ),
    );
    if (changed == true) bloc.add(const CalendarReturnedFromLog());
  }

  /// Pull-to-refresh: asks for a reload and waits until it has finished (or
  /// the bloc is gone, so the spinner can never hang).
  Future<void> _refresh(BuildContext context) {
    final bloc = context.read<CalendarBloc>();
    bloc.add(const CalendarRefreshed());
    return bloc.stream.firstWhere(
      (s) => s.status != CalendarLoadStatus.loading,
      orElse: () => bloc.state,
    );
  }

  /// Shows [state]'s newest message, replacing any still on screen.
  void _showMessage(BuildContext context, CalendarState state) {
    final message = state.message!;
    final bloc = context.read<CalendarBloc>();
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(messageText(message)),
        action: message.canUndo
            ? SnackBarAction(
                label: undoLabel,
                onPressed: () => bloc.add(CalendarUndoPressed(message.change!)),
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CalendarBloc>();
    return BlocListener<CalendarBloc, CalendarState>(
      // Only a message that is new (a different id) is shown, so rebuilding
      // the screen never repeats one.
      listenWhen: (previous, current) =>
          current.message != null &&
          previous.message?.id != current.message!.id,
      listener: _showMessage,
      child: Scaffold(
        appBar: AppBar(title: const Text('Calendar')),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openLogMenu(context),
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28),
        ),
        body: RefreshIndicator(
          onRefresh: () => _refresh(context),
          child: BlocBuilder<CalendarBloc, CalendarState>(
            builder: (context, state) => ListView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
              children: [
                MonthHeader(
                  month: state.month,
                  onPrevious: () => bloc.add(const CalendarMonthChanged(-1)),
                  onNext: () => bloc.add(const CalendarMonthChanged(1)),
                ),
                const SizedBox(height: 16),
                MonthGrid(
                  month: state.month,
                  selectedDate: state.selectedDate,
                  today: todayAsDateKey(),
                  periodDates: state.periodDates,
                  painDates: state.painDates,
                  prediction: state.prediction,
                  onSelect: (date) => bloc.add(CalendarDateSelected(date)),
                  onLongPress: (date) => bloc.add(CalendarDayLongPressed(date)),
                ),
                const SizedBox(height: 12),
                const Legend(),
                const SizedBox(height: 24),
                Text(
                  formatDayLabel(state.selectedDate),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                _DayDetail(state: state),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The selected day's log, or its spinner / error in its place.
class _DayDetail extends StatelessWidget {
  final CalendarState state;

  const _DayDetail({required this.state});

  @override
  Widget build(BuildContext context) {
    return switch (state.status) {
      CalendarLoadStatus.loading => const Center(
        child: CircularProgressIndicator(),
      ),
      CalendarLoadStatus.failed => Text(
        loadErrorText(state.error ?? ''),
        style: const TextStyle(color: TidalColors.rose),
      ),
      CalendarLoadStatus.loaded => DayBands(
        dayLog: state.dayLogFor(state.selectedDate),
        painEntries: state.selectedPainEntries,
        bowelMovements: state.selectedBowelMovements,
        units: state.units,
        emptyMessage: emptyDayText,
      ),
    };
  }
}
