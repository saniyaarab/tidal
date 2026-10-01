import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../theme.dart';
import '../widgets/sheet_common.dart';

/// Shown automatically, about an hour after a dose was logged, asking
/// whether it helped. Saves `painAfter` on the matching [DoseLog].
class CheckInScreen extends StatefulWidget {
  final DoseLog doseLog;
  final String medicationName;

  const CheckInScreen({
    super.key,
    required this.doseLog,
    required this.medicationName,
  });

  @override
  State<CheckInScreen> createState() => _CheckInScreenState();
}

class _CheckInScreenState extends State<CheckInScreen> {
  // The wireframe uses these six values rather than a full 0-10 scale, to
  // keep the check-in a quick, one-tap answer.
  static const _levels = [0, 2, 4, 6, 8, 10];

  int? _painNow;
  bool _busy = false;

  Future<void> _saveRelief() async {
    final painNow = _painNow;
    if (painNow == null) return;
    setState(() => _busy = true);
    try {
      await client.pain.recordRelief(widget.doseLog.id!, painNow);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(e);
    }
  }

  Future<void> _snooze() async {
    setState(() => _busy = true);
    try {
      await client.pain.snoozeCheckIn(widget.doseLog.id!);
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      _showError(e);
    }
  }

  void _showError(Object error) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Could not save: $error')));
  }

  @override
  Widget build(BuildContext context) {
    final before = widget.doseLog.painBefore;

    return Scaffold(
      appBar: AppBar(title: const Text('Check-in')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: TidalColors.card,
                borderRadius: BorderRadius.circular(TidalRadius.large),
                border: Border.all(color: TidalColors.border),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.medication, color: TidalColors.lavender),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tidal · ${formatTimeOfDay(DateTime.now())}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "It's been a while since ${widget.medicationName}. "
                          "How's the pain?",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "Did it help?",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _BeforeNowBox(
                    label: 'Before',
                    value: before?.toString() ?? '–',
                    color: TidalColors.roseBand,
                    textColor: TidalColors.rose,
                  ),
                ),
                const SizedBox(width: 12),
                const Icon(
                  Icons.arrow_forward,
                  color: TidalColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BeforeNowBox(
                    label: 'Now',
                    value: _painNow?.toString() ?? '?',
                    color: TidalColors.lavenderBand,
                    textColor: TidalColors.lavender,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            Text(
              'Pain right now',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: _levels.map((level) {
                return OptionChip(
                  label: '$level',
                  selected: level == _painNow,
                  selectedBackground: TidalColors.lavenderBand,
                  selectedForeground: TidalColors.lavender,
                  onTap: () => setState(() => _painNow = level),
                );
              }).toList(),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: (_busy || _painNow == null) ? null : _saveRelief,
              child: _busy
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Save relief'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _busy ? null : _snooze,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TidalRadius.large),
                ),
              ),
              child: const Text('Ask me again in 30 min'),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeforeNowBox extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final Color textColor;

  const _BeforeNowBox({
    required this.label,
    required this.value,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(TidalRadius.large),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
