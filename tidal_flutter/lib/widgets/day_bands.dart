import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../date_format.dart';
import '../log_labels.dart';
import '../theme.dart';
import '../units.dart';

/// The pastel bands showing what's logged for a day: pain entries and bowel
/// movements (ordered by time), then the once-a-day details (mood, drinks,
/// sleep, digestion, body, love) and the note last. Medications aren't
/// shown here — they're in the Medications sheet. Weight and temperature
/// are shown in [units]. Shows [emptyMessage] when nothing is logged.
class DayBands extends StatelessWidget {
  final DayLog? dayLog;
  final List<PainEntry> painEntries;
  final List<BowelMovement> bowelMovements;
  final UnitPreferences? units;
  final String emptyMessage;

  const DayBands({
    super.key,
    required this.dayLog,
    required this.painEntries,
    this.bowelMovements = const [],
    this.units,
    this.emptyMessage =
        'Nothing logged yet today. Tap + to add your flow, mood, or a note.',
  });

  @override
  Widget build(BuildContext context) {
    final mood = dayLog?.mood;
    final note = dayLog?.note;
    final hasNote = note != null && note.isNotEmpty;

    final day = dayLog;
    final units = this.units ?? defaultUnits;

    // Timed entries first, in the order they happened.
    final timed = <(DateTime, Widget)>[
      for (final entry in painEntries)
        (
          entry.timestamp,
          Band(
            color: TidalColors.roseBand,
            iconColor: TidalColors.rose,
            icon: Icons.bolt,
            text: entry.locations.isEmpty
                ? 'Pain ${entry.level}/10'
                : 'Pain ${entry.level}/10 · ${formatPainLocations(entry.locations)}',
            trailing: formatRelativeTime(entry.timestamp),
          ),
        ),
      for (final movement in bowelMovements)
        (
          movement.timestamp,
          _yellow(
            Icons.rice_bowl_outlined,
            'Digestion · Type ${movement.bristolType} · '
            '${bristolLabels[movement.bristolType - 1]}',
            trailing: formatRelativeTime(movement.timestamp),
          ),
        ),
    ]..sort((a, b) => a.$1.compareTo(b.$1));

    final bands = <Widget>[
      for (final (_, band) in timed) band,
      if (mood != null)
        Band(
          color: TidalColors.yellowBand,
          iconColor: TidalColors.yellowIcon,
          icon: Icons.sentiment_satisfied_alt,
          text: '${mood.label} · ${mood.subtitle}',
        ),
      if (day != null) ...[
        if (day.waterGlasses > 0)
          _lavender(
            Icons.local_drink_outlined,
            'Water · ${_plural(day.waterGlasses, 'glass', 'glasses')}',
          ),
        if (day.caffeineDrinks > 0)
          _yellow(
            Icons.coffee_outlined,
            'Caffeine · ${_plural(day.caffeineDrinks, 'drink', 'drinks')}',
          ),
        if (day.alcoholDrinks > 0)
          _lavender(
            Icons.wine_bar_outlined,
            'Alcohol · ${_plural(day.alcoholDrinks, 'drink', 'drinks')}',
          ),
        if (day.sleepQuality != null || day.sleepHours != null)
          _lavender(Icons.bedtime_outlined, _sleepText(day)),
        if (day.bloating != null)
          _yellow(Icons.air, 'Bloating · ${day.bloating!.label}'),
        if (day.acidReflux != null)
          _yellow(
            Icons.local_fire_department_outlined,
            'Acid reflux · ${day.acidReflux!.label}',
          ),
        if (day.weightKg != null)
          _yellow(
            Icons.monitor_weight_outlined,
            'Weight · ${formatOneDecimal(kgTo(units.weightUnit, day.weightKg!))} '
            '${weightSymbol(units.weightUnit)}',
          ),
        if (day.temperatureC != null)
          _yellow(
            Icons.thermostat_outlined,
            'Temperature · '
            '${formatOneDecimal(celsiusTo(units.temperatureUnit, day.temperatureC!))} '
            '${temperatureSymbol(units.temperatureUnit)}',
          ),
        if (day.mucus != null)
          _lavender(Icons.opacity, 'Mucus · ${day.mucus!.label}'),
        if (day.love != null)
          _lavender(Icons.favorite_border, 'Love · ${day.love!.label}'),
      ],
      if (hasNote)
        Band(
          color: TidalColors.lavenderBand,
          iconColor: TidalColors.lavender,
          icon: Icons.edit_note,
          text: note,
        ),
    ];

    if (bands.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: TidalColors.card,
          borderRadius: BorderRadius.circular(TidalRadius.large),
          border: Border.all(color: TidalColors.border),
        ),
        child: Text(
          emptyMessage,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: TidalColors.textSecondary),
        ),
      );
    }

    return Column(
      children: [
        for (var i = 0; i < bands.length; i++) ...[
          bands[i],
          if (i != bands.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  static Band _lavender(IconData icon, String text) => Band(
    color: TidalColors.lavenderBand,
    iconColor: TidalColors.lavender,
    icon: icon,
    text: text,
  );

  static Band _yellow(IconData icon, String text, {String? trailing}) => Band(
    color: TidalColors.yellowBand,
    iconColor: TidalColors.yellowIcon,
    icon: icon,
    text: text,
    trailing: trailing,
  );

  static String _plural(int count, String one, String many) =>
      '$count ${count == 1 ? one : many}';

  /// "Sleep · Good · 7.5 h", leaving out whichever part wasn't logged.
  static String _sleepText(DayLog day) {
    final quality = day.sleepQuality;
    final hours = day.sleepHours;
    return [
      'Sleep',
      if (quality != null) sleepQualityLabels[quality - 1],
      if (hours != null) '${formatOneDecimal(hours)} h',
    ].join(' · ');
  }
}

class Band extends StatelessWidget {
  final Color color;
  final Color iconColor;
  final IconData icon;
  final String text;
  final String? trailing;

  const Band({
    super.key,
    required this.color,
    required this.iconColor,
    required this.icon,
    required this.text,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(TidalRadius.large),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 8),
            Text(trailing!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
