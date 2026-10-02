import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../theme.dart';
import '../widgets/day_detail_sheets.dart';
import '../widgets/log_sheets.dart';
import '../widgets/pain_sheets.dart';

/// The full-screen "Log" menu opened from the "+" button: one tile per
/// thing that can be logged for [date]. For a future date only Note can be
/// logged; the other tiles are greyed out and explain why when tapped.
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

  DayLog? get _day => widget.dayLog;

  /// Opens a sheet via [show]; if it saved something, closes the Log screen
  /// so the day refreshes. For future dates (except notes), explains that
  /// only notes can be added instead.
  Future<void> _open(
    String what,
    Future<bool> Function() show, {
    bool allowFuture = false,
  }) async {
    if (_isFuture && !allowFuture) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "You can't log $what for future dates. Only notes can be added.",
          ),
        ),
      );
      return;
    }
    final saved = await show();
    if (saved && mounted) {
      setState(() => _changed = true);
      Navigator.pop(context, true);
    }
  }

  Future<bool> _showWeight() async {
    final units = await client.insight.getUnitPreferences();
    if (!mounted) return false;
    return showWeightSheet(
      context,
      date: widget.date,
      kg: _day?.weightKg,
      unit: units.weightUnit,
    );
  }

  Future<bool> _showTemperature() async {
    final units = await client.insight.getUnitPreferences();
    if (!mounted) return false;
    return showTemperatureSheet(
      context,
      date: widget.date,
      celsius: _day?.temperatureC,
      unit: units.temperatureUnit,
    );
  }

  @override
  Widget build(BuildContext context) {
    final date = widget.date;
    // (label, icon, band colour, icon colour, what it's called in the
    // future-date message, how to open its sheet, allowed on future dates)
    final tiles = <_TileSpec>[
      _TileSpec(
        'Flow',
        Icons.water_drop,
        TidalColors.roseBand,
        TidalColors.rose,
        'flow',
        () => showFlowSheet(
          context,
          date: date,
          current: _day?.flow ?? FlowLevel.none,
        ),
      ),
      _TileSpec(
        'Mood',
        Icons.sentiment_satisfied_alt,
        TidalColors.yellowBand,
        TidalColors.yellowIcon,
        'mood',
        () => showMoodSheet(context, date: date, current: _day?.mood),
      ),
      _TileSpec(
        'Note',
        Icons.edit_note,
        TidalColors.lavenderBand,
        TidalColors.lavender,
        'notes',
        () => showNoteSheet(context, date: date, current: _day?.note),
        allowFuture: true,
      ),
      _TileSpec(
        'Pain',
        Icons.bolt,
        TidalColors.roseBand,
        TidalColors.rose,
        'pain',
        () => showPainSheet(context, date: date),
      ),
      _TileSpec(
        'Medications',
        Icons.medication,
        TidalColors.lavenderBand,
        TidalColors.lavender,
        'medications',
        () => showMedicationsSheet(context, date: date),
      ),
      _TileSpec(
        'Digestion',
        Icons.rice_bowl_outlined,
        TidalColors.yellowBand,
        TidalColors.yellowIcon,
        'digestion',
        () => showDigestionSheet(
          context,
          date: date,
          bloating: _day?.bloating,
          acidReflux: _day?.acidReflux,
        ),
      ),
      _TileSpec(
        'Water',
        Icons.local_drink_outlined,
        TidalColors.lavenderBand,
        TidalColors.lavender,
        'water',
        () => showDrinkSheet(
          context,
          date: date,
          drink: DrinkType.water,
          current: _day?.waterGlasses ?? 0,
        ),
      ),
      _TileSpec(
        'Caffeine',
        Icons.coffee_outlined,
        TidalColors.yellowBand,
        TidalColors.yellowIcon,
        'caffeine',
        () => showDrinkSheet(
          context,
          date: date,
          drink: DrinkType.caffeine,
          current: _day?.caffeineDrinks ?? 0,
        ),
      ),
      _TileSpec(
        'Alcohol',
        Icons.wine_bar_outlined,
        TidalColors.lavenderBand,
        TidalColors.lavender,
        'alcohol',
        () => showDrinkSheet(
          context,
          date: date,
          drink: DrinkType.alcohol,
          current: _day?.alcoholDrinks ?? 0,
        ),
      ),
      _TileSpec(
        'Sleep',
        Icons.bedtime_outlined,
        TidalColors.lavenderBand,
        TidalColors.lavender,
        'sleep',
        () => showSleepSheet(
          context,
          date: date,
          quality: _day?.sleepQuality,
          hours: _day?.sleepHours,
        ),
      ),
      _TileSpec(
        'Weight',
        Icons.monitor_weight_outlined,
        TidalColors.yellowBand,
        TidalColors.yellowIcon,
        'weight',
        _showWeight,
      ),
      _TileSpec(
        'Temperature',
        Icons.thermostat_outlined,
        TidalColors.yellowBand,
        TidalColors.yellowIcon,
        'temperature',
        _showTemperature,
      ),
      _TileSpec(
        'Mucus',
        Icons.opacity,
        TidalColors.lavenderBand,
        TidalColors.lavender,
        'mucus',
        () => showMucusSheet(context, date: date, current: _day?.mucus),
      ),
      _TileSpec(
        'Love',
        Icons.favorite_border,
        TidalColors.roseBand,
        TidalColors.rose,
        'love',
        () => showLoveSheet(context, date: date, current: _day?.love),
      ),
    ];

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
        body: GridView.count(
          padding: const EdgeInsets.all(20),
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 16,
          children: [
            for (final tile in tiles)
              _LogTile(
                label: tile.label,
                icon: tile.icon,
                background: _isFuture && !tile.allowFuture
                    ? TidalColors.disabled
                    : tile.background,
                iconColor: _isFuture && !tile.allowFuture
                    ? TidalColors.disabledIcon
                    : tile.iconColor,
                onTap: () => _open(
                  tile.what,
                  tile.show,
                  allowFuture: tile.allowFuture,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Everything one Log screen tile needs.
class _TileSpec {
  final String label;
  final IconData icon;
  final Color background;
  final Color iconColor;
  final String what;
  final Future<bool> Function() show;
  final bool allowFuture;

  const _TileSpec(
    this.label,
    this.icon,
    this.background,
    this.iconColor,
    this.what,
    this.show, {
    this.allowFuture = false,
  });
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
