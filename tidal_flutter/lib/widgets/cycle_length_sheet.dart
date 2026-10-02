import 'package:flutter/material.dart';

import '../client.dart';
import '../theme.dart';
import 'sheet_common.dart';

/// Opens the "Cycle length" sheet and saves the chosen value. Returns true
/// if a change was saved.
Future<bool> showCycleLengthSheet(
  BuildContext context, {
  required int current,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _CycleLengthSheet(initial: current),
  );
  return result ?? false;
}

class _CycleLengthSheet extends StatefulWidget {
  final int initial;
  const _CycleLengthSheet({required this.initial});

  @override
  State<_CycleLengthSheet> createState() => _CycleLengthSheetState();
}

class _CycleLengthSheetState extends State<_CycleLengthSheet> {
  // Covers the range almost everyone falls into; InsightEndpoint accepts
  // anything from 15-45 if a wider range is ever needed.
  static const _options = [21, 24, 26, 28, 30, 32, 35];

  late int _selected = widget.initial;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await client.insight.saveCycleLength(_selected);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showSheetError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Cycle length',
      saving: _saving,
      onSave: _saving ? null : _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How many days are there usually from one period to the next? '
            "This is just a starting guess — once you've logged a couple "
            "of periods, Tidal predicts from your own history instead.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _options.map((days) {
              return OptionChip(
                label: '$days',
                selected: days == _selected,
                selectedBackground: TidalColors.lavenderBand,
                selectedForeground: TidalColors.lavender,
                onTap: () => setState(() => _selected = days),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
