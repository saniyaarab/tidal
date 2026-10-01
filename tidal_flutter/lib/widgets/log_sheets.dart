import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../log_labels.dart';
import '../theme.dart';
import 'sheet_common.dart';

/// Opens the "Flow" sheet and saves the chosen level for [date].
/// Returns true if a change was saved.
Future<bool> showFlowSheet(
  BuildContext context, {
  required DateTime date,
  required FlowLevel current,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _FlowSheet(date: date, initial: current),
  );
  return result ?? false;
}

class _FlowSheet extends StatefulWidget {
  final DateTime date;
  final FlowLevel initial;
  const _FlowSheet({required this.date, required this.initial});

  @override
  State<_FlowSheet> createState() => _FlowSheetState();
}

class _FlowSheetState extends State<_FlowSheet> {
  late FlowLevel _selected = widget.initial;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await client.log.saveDay(widget.date, flow: _selected);
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
      title: 'Flow',
      saving: _saving,
      onSave: _saving ? null : _save,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: FlowLevel.values.map((level) {
          return OptionChip(
            label: level.label,
            selected: level == _selected,
            selectedBackground: TidalColors.roseBand,
            selectedForeground: TidalColors.rose,
            onTap: () => setState(() => _selected = level),
          );
        }).toList(),
      ),
    );
  }
}

/// Opens the "Mood" sheet and saves the chosen mood for [date].
/// Returns true if a change was saved.
Future<bool> showMoodSheet(
  BuildContext context, {
  required DateTime date,
  Mood? current,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _MoodSheet(date: date, initial: current),
  );
  return result ?? false;
}

class _MoodSheet extends StatefulWidget {
  final DateTime date;
  final Mood? initial;
  const _MoodSheet({required this.date, required this.initial});

  @override
  State<_MoodSheet> createState() => _MoodSheetState();
}

class _MoodSheetState extends State<_MoodSheet> {
  late Mood? _selected = widget.initial;
  bool _saving = false;

  Future<void> _save() async {
    final mood = _selected;
    if (mood == null) return;
    setState(() => _saving = true);
    try {
      await client.log.saveDay(widget.date, mood: mood);
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
      title: 'Mood',
      saving: _saving,
      onSave: (_saving || _selected == null) ? null : _save,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: Mood.values.map((mood) {
          return OptionChip(
            label: mood.label,
            selected: mood == _selected,
            selectedBackground: TidalColors.yellowBand,
            selectedForeground: TidalColors.yellowIcon,
            onTap: () => setState(() => _selected = mood),
          );
        }).toList(),
      ),
    );
  }
}

/// Opens the "Note" sheet and saves the note text for [date].
/// Returns true if a change was saved.
Future<bool> showNoteSheet(
  BuildContext context, {
  required DateTime date,
  String? current,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _NoteSheet(date: date, initial: current),
  );
  return result ?? false;
}

class _NoteSheet extends StatefulWidget {
  final DateTime date;
  final String? initial;
  const _NoteSheet({required this.date, required this.initial});

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  late final _controller = TextEditingController(text: widget.initial ?? '');
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await client.log.saveDay(widget.date, note: _controller.text.trim());
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
      title: 'Note',
      saving: _saving,
      onSave: _saving ? null : _save,
      child: TextField(
        controller: _controller,
        maxLines: 4,
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'How are you doing today?',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(TidalRadius.small),
            borderSide: const BorderSide(color: TidalColors.border),
          ),
        ),
      ),
    );
  }
}
