import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../theme.dart';
import '../widgets/day_bands.dart';
import 'log_screen.dart';

/// The "Calendar" tab: a month grid with a rose ring on period days (solid
/// for logged periods, faded for the predicted window), a soft lavender ring
/// on fertile days, and a small dot on days with a pain entry. Tapping a
/// day shows its full log below, the same way Home does for the selected
/// day. Long-pressing a day starts, ends, or removes a period (see "Period
/// tracking" in CLAUDE.md; the rules live in `PeriodEndpoint.longPress`).
class CalendarScreen extends StatefulWidget {
  /// Set by Home when its day circle is tapped: the Calendar jumps to that
  /// date and selects it.
  final ValueNotifier<DateTime?> dateToShow;

  const CalendarScreen({super.key, required this.dateToShow});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _month = firstOfMonth(todayAsDateKey());
  late DateTime _selectedDate = todayAsDateKey();

  Map<DateTime, DayLog> _dayLogsByDate = {};
  Set<DateTime> _periodDates = {};
  Set<DateTime> _datesWithPain = {};
  List<PainEntry> _selectedPainEntries = [];
  Prediction? _prediction;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.dateToShow.addListener(_showRequestedDate);
    _load();
  }

  @override
  void dispose() {
    widget.dateToShow.removeListener(_showRequestedDate);
    super.dispose();
  }

  /// Jumps to the date Home asked for (see [CalendarScreen.dateToShow]).
  void _showRequestedDate() {
    final date = widget.dateToShow.value;
    if (date == null) return;
    setState(() {
      _month = firstOfMonth(date);
      _selectedDate = date;
    });
    _load();
  }

  DateTime get _monthEnd =>
      DateTime.utc(_month.year, _month.month + 1, 0); // last day of month

  // The grid also shows a few days of the previous and next months, so
  // periods are fetched for a slightly wider range than the month itself.
  DateTime get _gridStart =>
      _month.subtract(Duration(days: _month.weekday % 7));
  DateTime get _gridEnd => _gridStart.add(const Duration(days: 41));

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        client.log.getRange(_month, _monthEnd),
        client.pain.getPainRange(_month, _monthEnd),
        client.pain.getPainRange(_selectedDate, _selectedDate),
        client.insight.getPrediction(),
        client.period.getPeriods(_gridStart, _gridEnd),
      ]);
      final monthDayLogs = results[0] as List<DayLog>;
      final monthPainEntries = results[1] as List<PainEntry>;
      final periods = results[4] as List<PeriodSpan>;
      setState(() {
        // Every day from each period's start through its (confirmed or
        // assumed) end.
        _periodDates = {
          for (final period in periods)
            for (
              var day = period.startDate;
              !day.isAfter(period.endDate);
              day = day.add(const Duration(days: 1))
            )
              day,
        };
        _dayLogsByDate = {
          for (final log in monthDayLogs) log.date: log,
        };
        _datesWithPain = {for (final entry in monthPainEntries) entry.date};
        _selectedPainEntries = results[2] as List<PainEntry>;
        _prediction = results[3] as Prediction;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  void _changeMonth(int delta) {
    setState(() => _month = addMonths(_month, delta));
    _load();
  }

  void _selectDate(DateTime date) {
    setState(() => _selectedDate = date);
    _load();
  }

  /// Long-press on a day: starts, ends, moves, or removes a period, then
  /// says what happened in a message with an Undo button.
  Future<void> _longPress(DateTime date) async {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    if (date.isAfter(todayAsDateKey())) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text("Periods can't be logged for future dates."),
        ),
      );
      return;
    }

    try {
      final change = await client.period.longPress(date);
      setState(() => _selectedDate = date);
      await _load();
      messenger.showSnackBar(
        SnackBar(
          content: Text(_describe(change)),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () async {
              await client.period.undo(change);
              await _load();
            },
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(
        SnackBar(content: Text('Could not update the period: $e')),
      );
    }
  }

  String _describe(PeriodChange change) => switch (change.kind) {
    PeriodChangeKind.started =>
      'Period started · assumed ${change.lengthDays} days',
    PeriodChangeKind.ended => 'Period ended · ${change.lengthDays} days',
    PeriodChangeKind.moved => 'Period start moved · ${change.lengthDays} days',
    PeriodChangeKind.removed => 'Period removed',
  };

  Future<void> _openLogMenu() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LogScreen(
          date: _selectedDate,
          dayLog: _dayLogsByDate[_selectedDate],
        ),
      ),
    );
    if (changed == true) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openLogMenu,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            _MonthHeader(
              month: _month,
              onPrevious: () => _changeMonth(-1),
              onNext: () => _changeMonth(1),
            ),
            const SizedBox(height: 16),
            _MonthGrid(
              month: _month,
              selectedDate: _selectedDate,
              periodDates: _periodDates,
              datesWithPain: _datesWithPain,
              prediction: _prediction,
              onSelect: _selectDate,
              onLongPress: _longPress,
            ),
            const SizedBox(height: 12),
            const _Legend(),
            const SizedBox(height: 24),
            Text(
              formatDayLabel(_selectedDate),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Text(
                'Could not load this day: $_error',
                style: const TextStyle(color: TidalColors.rose),
              )
            else
              DayBands(
                dayLog: _dayLogsByDate[_selectedDate],
                painEntries: _selectedPainEntries,
                emptyMessage: 'Nothing logged for this day.',
              ),
          ],
        ),
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: TidalColors.lavender),
          onPressed: onPrevious,
        ),
        Text(
          formatMonthYear(month),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: TidalColors.lavender),
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final Set<DateTime> periodDates;
  final Set<DateTime> datesWithPain;
  final Prediction? prediction;
  final ValueChanged<DateTime> onSelect;
  final ValueChanged<DateTime> onLongPress;

  const _MonthGrid({
    required this.month,
    required this.selectedDate,
    required this.periodDates,
    required this.datesWithPain,
    required this.prediction,
    required this.onSelect,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    // Sunday-first grid: DateTime.weekday is 1=Mon..7=Sun, so `% 7` turns
    // Sunday into 0 leading cells, Monday into 1, etc.
    final leadingDays = month.weekday % 7;
    final gridStart = month.subtract(Duration(days: leadingDays));
    final today = todayAsDateKey();

    return Column(
      children: [
        Row(
          children: [
            for (final label in weekdayHeaderLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (var i = 0; i < 42; i++)
              _DayCell(
                date: gridStart.add(Duration(days: i)),
                inCurrentMonth:
                    gridStart.add(Duration(days: i)).month == month.month,
                isSelected: isSameDay(
                  gridStart.add(Duration(days: i)),
                  selectedDate,
                ),
                isToday: isSameDay(gridStart.add(Duration(days: i)), today),
                isPeriod: periodDates.contains(
                  gridStart.add(Duration(days: i)),
                ),
                hasPain: datesWithPain.contains(
                  gridStart.add(Duration(days: i)),
                ),
                isPredictedPeriod: _isPredictedPeriodDay(
                  gridStart.add(Duration(days: i)),
                  prediction,
                ),
                isFertile: _isFertileDay(
                  gridStart.add(Duration(days: i)),
                  prediction,
                ),
                onTap: () => onSelect(gridStart.add(Duration(days: i))),
                onLongPress: () =>
                    onLongPress(gridStart.add(Duration(days: i))),
              ),
          ],
        ),
      ],
    );
  }
}

/// Whether [date] falls within the predicted period (the predicted start
/// date through the user's typical period length — see Me > Period length).
bool _isPredictedPeriodDay(DateTime date, Prediction? prediction) {
  final nextStart = prediction?.nextPeriodStart;
  final periodEnd = prediction?.predictedPeriodEnd;
  if (nextStart == null || periodEnd == null) return false;
  return !date.isBefore(nextStart) && !date.isAfter(periodEnd);
}

/// Whether [date] falls within the predicted fertile window.
bool _isFertileDay(DateTime date, Prediction? prediction) {
  final start = prediction?.fertileWindowStart;
  final end = prediction?.fertileWindowEnd;
  if (start == null || end == null) return false;
  return !date.isBefore(start) && !date.isAfter(end);
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool inCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final bool isPeriod;
  final bool hasPain;
  final bool isPredictedPeriod;
  final bool isFertile;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _DayCell({
    required this.date,
    required this.inCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.isPeriod,
    required this.hasPain,
    required this.isPredictedPeriod,
    required this.isFertile,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = inCurrentMonth
        ? TidalColors.text
        : TidalColors.textSecondary;

    // Logged period beats predicted period beats fertile window beats
    // today — only one ring is drawn per day, in that priority order.
    Border? ring;
    if (!isSelected) {
      if (isPeriod) {
        ring = Border.all(color: TidalColors.rose, width: 2);
      } else if (isPredictedPeriod) {
        ring = Border.all(
          color: TidalColors.rose.withValues(alpha: 0.45),
          width: 2,
        );
      } else if (isFertile) {
        ring = Border.all(color: TidalColors.lavenderRing, width: 2);
      } else if (isToday) {
        ring = Border.all(color: TidalColors.lavender, width: 2);
      }
    }

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? TidalColors.lavenderCircle : null,
                border: ring,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: isSelected ? Colors.white : textColor,
                    fontWeight: isToday || isSelected
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            if (hasPain)
              Positioned(
                bottom: 2,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: TidalColors.rose,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: const [
        _LegendItem(ringColor: TidalColors.rose, label: 'Period'),
        _LegendItem(
          ringColor: Color(0x73B04A68), // rose at ~45% opacity
          label: 'Predicted',
        ),
        _LegendItem(
          ringColor: TidalColors.lavenderRing,
          label: 'Fertile window',
        ),
        _LegendItem(dotColor: TidalColors.rose, label: 'Pain day'),
      ],
    );
  }
}

/// One legend entry: either a ringed circle (period/predicted/fertile) or a
/// small filled dot (pain day), followed by its label.
class _LegendItem extends StatelessWidget {
  final Color? ringColor;
  final Color? dotColor;
  final String label;

  const _LegendItem({this.ringColor, this.dotColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dotColor != null ? 8 : 14,
          height: dotColor != null ? 8 : 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            border: ringColor != null
                ? Border.all(color: ringColor!, width: 2)
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
