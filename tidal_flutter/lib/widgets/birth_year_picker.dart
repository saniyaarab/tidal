import 'package:flutter/material.dart';

import '../client.dart';
import '../theme.dart';

/// Shows a year-only picker, constrained to a plausible birth-year range
/// (8-100 years old, matching what `InsightEndpoint.saveBirthYear` accepts).
/// Only the year is ever asked for or stored, never a full birth date.
/// Returns null if the user cancelled.
Future<int?> pickBirthYear(BuildContext context, {int? initial}) {
  final now = DateTime.now();
  final firstYear = now.year - 100;
  final lastYear = now.year - 8;

  return showDialog<int>(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TidalRadius.large),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Birth year', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              SizedBox(
                width: 300,
                height: 300,
                child: YearPicker(
                  firstDate: DateTime(firstYear),
                  lastDate: DateTime(lastYear),
                  selectedDate: DateTime(initial ?? (now.year - 25)),
                  onChanged: (date) => Navigator.pop(context, date.year),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Picks a birth year and saves it right away. Returns true if a year was
/// chosen and saved.
Future<bool> pickAndSaveBirthYear(BuildContext context, {int? initial}) async {
  final picked = await pickBirthYear(context, initial: initial);
  if (picked == null) return false;

  try {
    await client.insight.saveBirthYear(picked);
    return true;
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
    return false;
  }
}
