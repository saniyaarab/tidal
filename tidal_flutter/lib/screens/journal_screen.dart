import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../log_labels.dart';
import '../theme.dart';

/// The "Journal" tab: a daily self-care journal. One page per day, with
/// prev/next arrows (no future days): a "Self care today" checklist and a
/// "Best moment of the day" text box. Everything saves as the user taps or
/// types (see "Journal" in CLAUDE.md).
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late DateTime _date = todayAsDateKey();
  Set<SelfCareActivity> _activities = {};
  final _bestMoment = TextEditingController();
  bool _loading = true;
  String? _error;

  // Typing is saved shortly after the user pauses, not on every keystroke.
  Timer? _saveTimer;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _flushPendingSave();
    _bestMoment.dispose();
    super.dispose();
  }

  bool get _isToday => !_date.isBefore(todayAsDateKey());

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final entry = await client.journal.getDay(_date);
      if (!mounted) return;
      setState(() {
        _activities = {...?entry?.activities};
        _bestMoment.text = entry?.bestMoment ?? '';
        _loading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '$e';
          _loading = false;
        });
      }
    }
  }

  Future<void> _save() async {
    try {
      await client.journal.saveDay(
        _date,
        _activities.toList(),
        _bestMoment.text,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not save: $e')));
      }
    }
  }

  /// Saves right away if typing is still waiting to be saved.
  void _flushPendingSave() {
    if (_saveTimer?.isActive ?? false) {
      _saveTimer!.cancel();
      _save();
    }
  }

  void _toggle(SelfCareActivity activity) {
    setState(() {
      if (!_activities.remove(activity)) _activities.add(activity);
    });
    _save();
  }

  void _onBestMomentChanged(String _) {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(milliseconds: 800), _save);
  }

  void _changeDay(int deltaDays) {
    _flushPendingSave();
    setState(() => _date = _date.add(Duration(days: deltaDays)));
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.chevron_left,
                  color: TidalColors.lavender,
                ),
                onPressed: () => _changeDay(-1),
              ),
              Text(
                formatDayLabel(_date),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                color: TidalColors.lavender,
                // No future days.
                onPressed: _isToday ? null : () => _changeDay(1),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_error != null)
            Text(
              'Could not load: $_error',
              style: const TextStyle(color: TidalColors.rose),
            )
          else ...[
            Text(
              'Self care today',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            for (final (i, activity) in SelfCareActivity.values.indexed)
              _ActivityRow(
                activity: activity,
                iconColor: _iconColors[i % _iconColors.length],
                checked: _activities.contains(activity),
                onTap: () => _toggle(activity),
              ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TidalColors.card,
                borderRadius: BorderRadius.circular(TidalRadius.large),
                border: Border.all(color: TidalColors.roseBand, width: 6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Best moment of the day',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _bestMoment,
                    onChanged: _onBestMomentChanged,
                    onEditingComplete: _flushPendingSave,
                    minLines: 4,
                    maxLines: 8,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // The app's three pastel accents, cycled down the checklist.
  static const _iconColors = [
    TidalColors.rose,
    TidalColors.lavender,
    TidalColors.yellowIcon,
  ];
}

/// One checklist row: the activity's icon and name, and a circle that's
/// filled when it's ticked.
class _ActivityRow extends StatelessWidget {
  final SelfCareActivity activity;
  final Color iconColor;
  final bool checked;
  final VoidCallback onTap;

  const _ActivityRow({
    required this.activity,
    required this.iconColor,
    required this.checked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TidalRadius.small),
      child: Padding(
        // Rows are at least 44px tall, per the design system.
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            Icon(_icon(activity), color: iconColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                activity.label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Icon(
              checked ? Icons.check_circle : Icons.circle_outlined,
              color: checked ? TidalColors.lavender : TidalColors.border,
            ),
          ],
        ),
      ),
    );
  }

  /// Outline icon for each activity (stand-ins until illustrations exist).
  static IconData _icon(SelfCareActivity activity) => switch (activity) {
    SelfCareActivity.meditated => Icons.self_improvement,
    SelfCareActivity.calledFriend => Icons.phone_outlined,
    SelfCareActivity.hitSnooze => Icons.alarm_outlined,
    SelfCareActivity.listenedToMusic => Icons.music_note_outlined,
    SelfCareActivity.snackedHealthy => Icons.eco_outlined,
    SelfCareActivity.wentOutside => Icons.park_outlined,
    SelfCareActivity.readBook => Icons.menu_book_outlined,
    SelfCareActivity.tookBath => Icons.bathtub_outlined,
    SelfCareActivity.drewOrPainted => Icons.palette_outlined,
    SelfCareActivity.cookedMeal => Icons.restaurant_outlined,
    SelfCareActivity.plannedTrip => Icons.public_outlined,
    SelfCareActivity.huggedSomeone => Icons.favorite_border,
    SelfCareActivity.madeTea => Icons.emoji_food_beverage_outlined,
    SelfCareActivity.complimentedMe => Icons.sentiment_satisfied_outlined,
    SelfCareActivity.tookNap => Icons.bedtime_outlined,
  };
}
