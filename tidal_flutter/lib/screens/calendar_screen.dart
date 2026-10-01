import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../theme.dart';
import '../widgets/day_bands.dart';
import 'log_screen.dart';

/// The "Calendar" tab: a month grid with a rose ring on period days and a
/// small dot on days with a pain entry. Tapping a day shows its full log
/// below, the same way Home does for the selected day.
///
/// Predicted period and fertile-window rings aren't shown yet — those need
/// cycle-length predictions, which come in a later step.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _month = firstOfMonth(todayAsDateKey());
  late DateTime _selectedDate = todayAsDateKey();

  Map<DateTime, DayLog> _dayLogsByDate = {};
  Set<DateTime> _datesWithPain = {};
  List<PainEntry> _selectedPainEntries = [];
  List<DoseLog> _selectedDoseLogs = [];
  Map<int, Medication> _medsById = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  DateTime get _monthEnd =>
      DateTime.utc(_month.year, _month.month + 1, 0); // last day of month

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
        client.pain.getDoseRange(_selectedDate, _selectedDate),
        client.pain.myMeds(),
      ]);
      final monthDayLogs = results[0] as List<DayLog>;
      final monthPainEntries = results[1] as List<PainEntry>;
      final meds = results[4] as List<Medication>;
      setState(() {
        _dayLogsByDate = {
          for (final log in monthDayLogs) log.date: log,
        };
        _datesWithPain = {
          for (final entry in monthPainEntries)
            DateTime.utc(
              entry.timestamp.year,
              entry.timestamp.month,
              entry.timestamp.day,
            ),
        };
        _selectedPainEntries = results[2] as List<PainEntry>;
        _selectedDoseLogs = results[3] as List<DoseLog>;
        _medsById = {for (final med in meds) med.id!: med};
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
              dayLogsByDate: _dayLogsByDate,
              datesWithPain: _datesWithPain,
              onSelect: _selectDate,
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
                doseLogs: _selectedDoseLogs,
                medsById: _medsById,
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
  final Map<DateTime, DayLog> dayLogsByDate;
  final Set<DateTime> datesWithPain;
  final ValueChanged<DateTime> onSelect;

  const _MonthGrid({
    required this.month,
    required this.selectedDate,
    required this.dayLogsByDate,
    required this.datesWithPain,
    required this.onSelect,
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
                flow: dayLogsByDate[gridStart.add(Duration(days: i))]?.flow,
                hasPain: datesWithPain.contains(
                  gridStart.add(Duration(days: i)),
                ),
                onTap: () => onSelect(gridStart.add(Duration(days: i))),
              ),
          ],
        ),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final bool inCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final FlowLevel? flow;
  final bool hasPain;
  final VoidCallback onTap;

  const _DayCell({
    required this.date,
    required this.inCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.flow,
    required this.hasPain,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPeriod = flow != null && flow != FlowLevel.none;
    final textColor = inCurrentMonth
        ? TidalColors.text
        : TidalColors.textSecondary;

    return InkWell(
      onTap: onTap,
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
                border: !isSelected && isPeriod
                    ? Border.all(color: TidalColors.rose, width: 2)
                    : (!isSelected && isToday
                          ? Border.all(color: TidalColors.lavender, width: 2)
                          : null),
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
    final style = Theme.of(context).textTheme.bodyMedium;
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: TidalColors.rose, width: 2),
              ),
            ),
            const SizedBox(width: 6),
            Text('Period', style: style),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: TidalColors.rose,
              ),
            ),
            const SizedBox(width: 6),
            Text('Pain day', style: style),
          ],
        ),
      ],
    );
  }
}
