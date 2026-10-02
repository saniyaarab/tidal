import 'package:flutter/material.dart';

import '../client.dart';
import '../theme.dart';
import 'sheet_common.dart';

/// Opens the "Period length" sheet and saves the chosen value. Returns true
/// if a change was saved.
Future<bool> showPeriodLengthSheet(
  BuildContext context, {
  required int current,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _PeriodLengthSheet(initial: current),
  );
  return result ?? false;
}

class _PeriodLengthSheet extends StatefulWidget {
  final int initial;
  const _PeriodLengthSheet({required this.initial});

  @override
  State<_PeriodLengthSheet> createState() => _PeriodLengthSheetState();
}

class _PeriodLengthSheetState extends State<_PeriodLengthSheet> {
  // Covers the range almost everyone falls into; InsightEndpoint accepts
  // anything from 1-14 if a wider range is ever needed.
  static const _options = [3, 4, 5, 6, 7, 8, 9, 10];

  late int _selected = widget.initial;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await client.insight.savePeriodLength(_selected);
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
      title: 'Period length',
      saving: _saving,
      onSave: _saving ? null : _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How many days does your period usually last? This sizes the '
            "predicted period on your Calendar — it doesn't change what "
            "you've already logged.",
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
                selectedBackground: TidalColors.roseBand,
                selectedForeground: TidalColors.rose,
                onTap: () => setState(() => _selected = days),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
