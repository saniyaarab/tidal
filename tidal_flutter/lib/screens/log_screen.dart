import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../date_format.dart';
import '../theme.dart';
import '../widgets/log_sheets.dart';
import '../widgets/pain_sheets.dart';

/// The full-screen "Log" menu opened from the "+" button. Flow, Mood, and
/// Note are wired up; the rest are later steps in the MVP and show a
/// "coming soon" message for now.
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
    final saved = await showPainSheet(context);
    if (saved && mounted) {
      setState(() => _changed = true);
      Navigator.pop(context, true);
    }
  }

  Future<void> _logPainkiller() async {
    final saved = await showPainkillerSheet(context);
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
                background: TidalColors.roseBand,
                iconColor: TidalColors.rose,
                onTap: _logFlow,
              ),
              _LogTile(
                label: 'Mood',
                icon: Icons.sentiment_satisfied_alt,
                background: TidalColors.yellowBand,
                iconColor: TidalColors.yellowIcon,
                onTap: _logMood,
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
                background: TidalColors.roseBand,
                iconColor: TidalColors.rose,
                onTap: _logPain,
              ),
              _LogTile(
                label: 'Painkiller',
                icon: Icons.medication,
                background: TidalColors.lavenderBand,
                iconColor: TidalColors.lavender,
                onTap: _logPainkiller,
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
