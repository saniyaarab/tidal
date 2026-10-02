import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../date_format.dart';
import '../log_labels.dart';
import '../theme.dart';

/// The pastel bands showing what's logged for a day: pain entries, doses,
/// mood, and note. Pain and dose bands are ordered by time; mood and note
/// (at most one each per day) always come last. Shows [emptyMessage] when
/// nothing is logged.
class DayBands extends StatelessWidget {
  final DayLog? dayLog;
  final List<PainEntry> painEntries;
  final List<DoseLog> doseLogs;
  final Map<int, Medication> medsById;
  final String emptyMessage;

  const DayBands({
    super.key,
    required this.dayLog,
    required this.painEntries,
    required this.doseLogs,
    required this.medsById,
    this.emptyMessage =
        'Nothing logged yet today. Tap + to add your flow, mood, or a note.',
  });

  @override
  Widget build(BuildContext context) {
    final mood = dayLog?.mood;
    final note = dayLog?.note;
    final hasNote = note != null && note.isNotEmpty;

    final timedBands = <(DateTime, Widget)>[
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
            trailing: formatTimeOfDay(entry.timestamp),
          ),
        ),
      for (final dose in doseLogs)
        (
          dose.timestamp,
          Band(
            color: TidalColors.lavenderBand,
            iconColor: TidalColors.lavender,
            icon: Icons.medication,
            text: _doseText(medsById[dose.medicationId]?.name, dose),
            trailing: formatTimeOfDay(dose.timestamp),
          ),
        ),
    ]..sort((a, b) => a.$1.compareTo(b.$1));

    final bands = <Widget>[
      for (final (_, band) in timedBands) band,
      if (mood != null)
        Band(
          color: TidalColors.yellowBand,
          iconColor: TidalColors.yellowIcon,
          icon: Icons.sentiment_satisfied_alt,
          text: '${mood.label} · ${mood.subtitle}',
        ),
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

  /// "Medication dose", e.g. "Ibuprofen 400 mg".
  String _doseText(String? medicationName, DoseLog dose) =>
      '${medicationName ?? 'Medication'} ${dose.dose}';
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
