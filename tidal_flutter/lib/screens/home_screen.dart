import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../log_labels.dart';
import '../theme.dart';
import '../widgets/day_bands.dart';
import 'check_in_screen.dart';
import 'log_screen.dart';

/// The "Today" tab: a big circle showing the selected day's period flow,
/// with prev/next arrows to look at other days, and bands below it showing
/// that day's mood and note (if logged).
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DateTime _selectedDate = todayAsDateKey();
  DayLog? _dayLog;
  List<PainEntry> _painEntries = [];
  List<DoseLog> _doseLogs = [];
  Map<int, Medication> _medsById = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDay();
    _checkForPendingCheckIn();
  }

  Future<void> _checkForPendingCheckIn() async {
    try {
      final pending = await client.pain.getPendingCheckIn();
      if (pending == null || !mounted) return;

      final meds = await client.pain.myMeds();
      Medication? medication;
      for (final med in meds) {
        if (med.id == pending.medicationId) {
          medication = med;
          break;
        }
      }
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CheckInScreen(
            doseLog: pending,
            medicationName: medication?.name ?? 'your medication',
          ),
        ),
      );
      if (mounted) _loadDay();
    } catch (_) {
      // A failed check-in lookup shouldn't block the rest of Home.
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
        client.pain.getDoseRange(_selectedDate, _selectedDate),
        client.pain.myMeds(),
      ]);
      final dayLogs = results[0] as List<DayLog>;
      final meds = results[3] as List<Medication>;
      setState(() {
        _dayLog = dayLogs.isEmpty ? null : dayLogs.first;
        _painEntries = results[1] as List<PainEntry>;
        _doseLogs = results[2] as List<DoseLog>;
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
    if (changed == true) _loadDay();
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
            _DayCircle(
              date: _selectedDate,
              flow: _dayLog?.flow ?? FlowLevel.none,
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
                doseLogs: _doseLogs,
                medsById: _medsById,
              ),
          ],
        ),
      ),
    );
  }
}

/// The big lavender circle: the date, prev/next arrows, and the flow status.
class _DayCircle extends StatelessWidget {
  final DateTime date;
  final FlowLevel flow;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _DayCircle({
    required this.date,
    required this.flow,
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
        Container(
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
                  flow.label,
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
