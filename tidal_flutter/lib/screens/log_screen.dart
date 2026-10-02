import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../date_format.dart';
import '../theme.dart';
import '../widgets/log_sheets.dart';
import '../widgets/pain_sheets.dart';

/// The full-screen "Log" menu opened from the "+" button. For a future date
/// only Note can be logged; the other tiles are greyed out and explain why
/// when tapped.
class LogScreen extends StatefulWidget {
  final DateTime date;
  final DayLog? dayLog;

  const LogScreen({super.key, required this.date, required this.dayLog});

  @override
  State<LogScreen> createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  // Tracks whether anything was saved, so Home knows to refresh when we pop.
  bool _changed = false;

  bool get _isFuture => widget.date.isAfter(todayAsDateKey());

  /// Runs [log] for today or past dates; for future dates, explains that
  /// only notes can be added instead.
  VoidCallback _unlessFuture(String what, VoidCallback log) => () {
    if (!_isFuture) return log();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "You can't log $what for future dates. Only notes can be added.",
        ),
      ),
    );
  };

  void _comingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming in a later step.')),
    );
  }

  Future<void> _logFlow() async {
    final saved = await showFlowSheet(
      context,
      date: widget.date,
      current: widget.dayLog?.flow ?? FlowLevel.none,
    );
    if (saved && mounted) {
      setState(() => _changed = true);
      Navigator.pop(context, true);
    }
  }

  Future<void> _logMood() async {
    final saved = await showMoodSheet(
      context,
      date: widget.date,
      current: widget.dayLog?.mood,
    );
    if (saved && mounted) {
      setState(() => _changed = true);
      Navigator.pop(context, true);
    }
  }

  Future<void> _logNote() async {
    final saved = await showNoteSheet(
      context,
      date: widget.date,
      current: widget.dayLog?.note,
    );
    if (saved && mounted) {
      setState(() => _changed = true);
      Navigator.pop(context, true);
    }
  }

  Future<void> _logPain() async {
    final saved = await showPainSheet(context, date: widget.date);
    if (saved && mounted) {
      setState(() => _changed = true);
      Navigator.pop(context, true);
    }
  }

  Future<void> _logMedication() async {
    final saved = await showMedicationsSheet(context, date: widget.date);
    if (saved && mounted) {
      setState(() => _changed = true);
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) Navigator.pop(context, _changed);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Log · ${formatDayLabel(widget.date)}'),
          leading: BackButton(
            onPressed: () => Navigator.pop(context, _changed),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: GridView.count(
            crossAxisCount: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 16,
            children: [
              _LogTile(
                label: 'Flow',
                icon: Icons.water_drop,
                background: _isFuture
                    ? TidalColors.disabled
                    : TidalColors.roseBand,
                iconColor: _isFuture
                    ? TidalColors.disabledIcon
                    : TidalColors.rose,
                onTap: _unlessFuture('flow', _logFlow),
              ),
              _LogTile(
                label: 'Mood',
                icon: Icons.sentiment_satisfied_alt,
                background: _isFuture
                    ? TidalColors.disabled
                    : TidalColors.yellowBand,
                iconColor: _isFuture
                    ? TidalColors.disabledIcon
                    : TidalColors.yellowIcon,
                onTap: _unlessFuture('mood', _logMood),
              ),
              _LogTile(
                label: 'Note',
                icon: Icons.edit_note,
                background: TidalColors.lavenderBand,
                iconColor: TidalColors.lavender,
                onTap: _logNote,
              ),
              _LogTile(
                label: 'Pain',
                icon: Icons.bolt,
                background: _isFuture
                    ? TidalColors.disabled
                    : TidalColors.roseBand,
                iconColor: _isFuture
                    ? TidalColors.disabledIcon
                    : TidalColors.rose,
                onTap: _unlessFuture('pain', _logPain),
              ),
              _LogTile(
                label: 'Medications',
                icon: Icons.medication,
                background: _isFuture
                    ? TidalColors.disabled
                    : TidalColors.lavenderBand,
                iconColor: _isFuture
                    ? TidalColors.disabledIcon
                    : TidalColors.lavender,
                onTap: _unlessFuture('medications', _logMedication),
              ),
              _LogTile(
                label: 'Reminder',
                icon: Icons.notifications_outlined,
                background: TidalColors.disabled,
                iconColor: TidalColors.disabledIcon,
                onTap: () => _comingSoon('Reminders'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LogTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color iconColor;
  final VoidCallback onTap;

  const _LogTile({
    required this.label,
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TidalRadius.large),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: background,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ),
    );
  }
}
