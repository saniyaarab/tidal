import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../log_labels.dart';
import '../theme.dart';
import '../widgets/day_bands.dart';
import 'log_screen.dart';

/// The "Today" tab: a big circle showing whether the selected day is a
/// period day (and its flow, if logged), with prev/next arrows to look at
/// other days, and bands below it showing that day's log. Tapping the
/// circle opens the Calendar on that day.
class HomeScreen extends StatefulWidget {
  /// Switches to the Calendar tab with the given date selected.
  final ValueChanged<DateTime> onOpenCalendar;

  const HomeScreen({super.key, required this.onOpenCalendar});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate = todayAsDateKey();
  DayLog? _dayLog;
  // The period the selected day falls in, if any.
  PeriodSpan? _period;
  List<PainEntry> _painEntries = [];
  List<BowelMovement> _bowelMovements = [];
  UnitPreferences? _units;
  bool _loading = true;
  String? _error;

  // Independent of _selectedDate: this always reflects where the user
  // actually is in their cycle today, not whichever day the prev/next
  // arrows are currently showing below it.
  Prediction? _prediction;

  // Medication reminders that are due now, shown as banners at the top.
  // Checked every minute while Home is open, since the server marks them
  // due in the background (see `MedicationReminderFutureCall`).
  List<MedicationReminder> _dueReminders = [];
  Map<int, Medication> _medsById = {};
  Timer? _reminderTimer;

  @override
  void initState() {
    super.initState();
    _loadDay();
    _loadPrediction();
    _loadReminders();
    _reminderTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => _loadReminders(),
    );
  }

  @override
  void dispose() {
    _reminderTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadReminders() async {
    try {
      final results = await Future.wait([
        client.pain.getReminders(),
        client.pain.myMeds(),
      ]);
      final reminders = results[0] as List<MedicationReminder>;
      final meds = results[1] as List<Medication>;
      if (!mounted) return;
      setState(() {
        _dueReminders = [
          for (final r in reminders)
            if (r.isDue) r,
        ];
        _medsById = {for (final med in meds) med.id!: med};
      });
    } catch (_) {
      // A failed reminder check shouldn't block the rest of Home.
    }
  }

  /// "Log dose" on a reminder banner: logs the medication as taken now
  /// (which also sets the next reminder).
  Future<void> _logReminderDose(MedicationReminder reminder) async {
    final now = DateTime.now();
    await client.pain.logDose(
      reminder.medicationId,
      DateTime.utc(now.year, now.month, now.day),
      now.toUtc(),
    );
    await _loadReminders();
  }

  Future<void> _dismissReminder(MedicationReminder reminder) async {
    await client.pain.dismissReminder(reminder.id!);
    await _loadReminders();
  }

  Future<void> _loadPrediction() async {
    try {
      final prediction = await client.insight.getPrediction();
      if (mounted) setState(() => _prediction = prediction);
    } catch (_) {
      // A failed prediction lookup shouldn't block the rest of Home; the
      // header just won't show.
    }
  }

  Future<void> _loadDay() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final results = await Future.wait([
        client.log.getRange(_selectedDate, _selectedDate),
        client.pain.getPainRange(_selectedDate, _selectedDate),
        client.period.getPeriods(_selectedDate, _selectedDate),
        client.digestion.getBowelMovementRange(_selectedDate, _selectedDate),
        client.insight.getUnitPreferences(),
      ]);
      final dayLogs = results[0] as List<DayLog>;
      final periods = results[2] as List<PeriodSpan>;
      setState(() {
        _dayLog = dayLogs.isEmpty ? null : dayLogs.first;
        _period = periods.isEmpty ? null : periods.first;
        _painEntries = results[1] as List<PainEntry>;
        _bowelMovements = results[3] as List<BowelMovement>;
        _units = results[4] as UnitPreferences;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  /// The text inside the day circle, e.g. "Period · Day 2 · Heavy",
  /// "Light flow" (flow logged outside a period), or "No period".
  String _dayStatus() {
    final flow = _dayLog?.flow ?? FlowLevel.none;
    final period = _period;
    if (period != null) {
      final day = _selectedDate.difference(period.startDate).inDays + 1;
      return flow == FlowLevel.none
          ? 'Period · Day $day'
          : 'Period · Day $day\n${flow.label}';
    }
    return flow == FlowLevel.none ? 'No period' : '${flow.label} flow';
  }

  void _changeDay(int deltaDays) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: deltaDays));
    });
    _loadDay();
  }

  Future<void> _openLogMenu() async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => LogScreen(date: _selectedDate, dayLog: _dayLog),
      ),
    );
    if (changed == true) {
      _loadDay();
      _loadReminders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      floatingActionButton: FloatingActionButton(
        onPressed: _openLogMenu,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 28),
      ),
      body: RefreshIndicator(
        onRefresh: _loadDay,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
          children: [
            for (final reminder in _dueReminders)
              _ReminderBanner(
                medicationName:
                    _medsById[reminder.medicationId]?.name ?? 'Medication',
                onLogDose: () => _logReminderDose(reminder),
                onDismiss: () => _dismissReminder(reminder),
              ),
            if (_prediction != null) _CycleHeader(prediction: _prediction!),
            _DayCircle(
              date: _selectedDate,
              status: _dayStatus(),
              onTap: () => widget.onOpenCalendar(_selectedDate),
              onPrevious: () => _changeDay(-1),
              onNext: () => _changeDay(1),
            ),
            const SizedBox(height: 24),
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (_error != null)
              Text(
                'Could not load this day: $_error',
                style: const TextStyle(color: TidalColors.rose),
              )
            else
              DayBands(
                dayLog: _dayLog,
                painEntries: _painEntries,
                bowelMovements: _bowelMovements,
                units: _units,
              ),
          ],
        ),
      ),
    );
  }
}

/// The big lavender circle: the date, prev/next arrows, and the period
/// status. Tapping the circle opens the Calendar on that date.
class _DayCircle extends StatelessWidget {
  final DateTime date;
  final String status;
  final VoidCallback onTap;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _DayCircle({
    required this.date,
    required this.status,
    required this.onTap,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ArrowButton(icon: Icons.chevron_left, onPressed: onPrevious),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: TidalColors.lavenderCircle,
              border: Border.fromBorderSide(
                BorderSide(color: TidalColors.lavenderRing, width: 8),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatDayLabel(date),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    status,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _ArrowButton(icon: Icons.chevron_right, onPressed: onNext),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _ArrowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        icon: Icon(icon, color: TidalColors.lavender),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: TidalColors.card,
          side: const BorderSide(color: TidalColors.border),
        ),
      ),
    );
  }
}

/// "Cycle day 5 · Next period in 23 days" header, from the latest
/// [Prediction]. Always reflects today, regardless of which day the
/// prev/next arrows are currently showing in the day circle below it.
class _CycleHeader extends StatelessWidget {
  final Prediction prediction;
  const _CycleHeader({required this.prediction});

  @override
  Widget build(BuildContext context) {
    final cycleDay = prediction.currentCycleDay;
    if (cycleDay == null) return const SizedBox.shrink();

    final nextStart = prediction.nextPeriodStart;
    final daysUntilNext = nextStart?.difference(todayAsDateKey()).inDays;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            'Cycle day $cycleDay',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: TidalColors.lavender),
          ),
          if (daysUntilNext != null) ...[
            const SizedBox(height: 4),
            Text(
              daysUntilNext <= 0
                  ? 'Next period expected any day now'
                  : 'Next period in $daysUntilNext days (±${prediction.confidenceDays})',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

/// "Ibuprofen due now", with "Log dose" and "Dismiss".
class _ReminderBanner extends StatelessWidget {
  final String medicationName;
  final VoidCallback onLogDose;
  final VoidCallback onDismiss;

  const _ReminderBanner({
    required this.medicationName,
    required this.onLogDose,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
      decoration: BoxDecoration(
        color: TidalColors.lavenderBand,
        borderRadius: BorderRadius.circular(TidalRadius.large),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.notifications_active_outlined,
            color: TidalColors.lavender,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '$medicationName due now',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(onPressed: onLogDose, child: const Text('Log dose')),
          TextButton(onPressed: onDismiss, child: const Text('Dismiss')),
        ],
      ),
    );
  }
}
