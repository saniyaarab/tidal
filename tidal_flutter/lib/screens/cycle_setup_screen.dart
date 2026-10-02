import 'package:flutter/material.dart';

import '../client.dart';
import '../theme.dart';
import '../widgets/birth_year_picker.dart';
import '../widgets/sheet_common.dart';

/// Shown once, right after sign-up, to collect a starting guess for cycle
/// length and period length, plus a birth year. Tidal uses the cycle/period
/// guesses to seed predictions until there's enough logged history to
/// measure the real averages instead (see [CycleSetupGate]).
class CycleSetupScreen extends StatefulWidget {
  final VoidCallback onDone;
  const CycleSetupScreen({super.key, required this.onDone});

  @override
  State<CycleSetupScreen> createState() => _CycleSetupScreenState();
}

class _CycleSetupScreenState extends State<CycleSetupScreen> {
  static const _cycleOptions = [21, 24, 26, 28, 30, 32, 35];
  static const _periodOptions = [3, 4, 5, 6, 7, 8, 9, 10];

  int _cycleLength = 28;
  int _periodLength = 5;
  int? _birthYear;
  bool _saving = false;
  String? _error;

  Future<void> _pickBirthYear() async {
    final picked = await pickBirthYear(context, initial: _birthYear);
    if (picked != null) setState(() => _birthYear = picked);
  }

  Future<void> _save() async {
    final birthYear = _birthYear;
    if (birthYear == null) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await client.insight.saveCycleLength(_cycleLength);
      await client.insight.savePeriodLength(_periodLength);
      await client.insight.saveBirthYear(birthYear);
      widget.onDone();
    } catch (e) {
      setState(() {
        _saving = false;
        _error = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final birthYear = _birthYear;
    return Scaffold(
      appBar: AppBar(title: const Text('A couple of quick questions')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              "These are just starting guesses — once you've logged a "
              'couple of periods, Tidal predicts from your own history '
              'instead.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 28),
            Text(
              'How many days from one period to the next?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _cycleOptions.map((days) {
                return OptionChip(
                  label: '$days',
                  selected: days == _cycleLength,
                  selectedBackground: TidalColors.lavenderBand,
                  selectedForeground: TidalColors.lavender,
                  onTap: () => setState(() => _cycleLength = days),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            Text(
              'How many days does your period usually last?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _periodOptions.map((days) {
                return OptionChip(
                  label: '$days',
                  selected: days == _periodLength,
                  selectedBackground: TidalColors.roseBand,
                  selectedForeground: TidalColors.rose,
                  onTap: () => setState(() => _periodLength = days),
                );
              }).toList(),
            ),
            const SizedBox(height: 28),
            Text(
              'What year were you born?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              "Just the year, for privacy — that's all Tidal needs.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: _pickBirthYear,
              borderRadius: BorderRadius.circular(TidalRadius.large),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: TidalColors.card,
                  borderRadius: BorderRadius.circular(TidalRadius.large),
                  border: Border.all(color: TidalColors.border),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      color: TidalColors.lavender,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      birthYear == null ? 'Select birth year' : '$birthYear',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(
                'Could not save: $_error',
                style: const TextStyle(color: TidalColors.rose),
              ),
            ],
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: (_saving || birthYear == null) ? null : _save,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
