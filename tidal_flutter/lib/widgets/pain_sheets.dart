import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../log_labels.dart';
import '../theme.dart';
import 'sheet_common.dart';

/// A row showing one medication, used by both the Pain sheet (tap to mark
/// "took this, with the pain level just entered") and the Painkiller sheet
/// (tap to log a dose right now).
class _MedicationTile extends StatelessWidget {
  final Medication medication;
  final Widget trailing;
  final bool highlighted;
  final VoidCallback? onTap;

  const _MedicationTile({
    required this.medication,
    required this.trailing,
    this.highlighted = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(TidalRadius.small),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: highlighted
                ? TidalColors.lavenderBand
                : TidalColors.background,
            borderRadius: BorderRadius.circular(TidalRadius.small),
            border: Border.all(
              color: highlighted ? TidalColors.lavender : TidalColors.border,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  '${medication.name} · ${medication.usualDose}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              trailing,
            ],
          ),
        ),
      ),
    );
  }
}

/// Opens the "Add a medication" sheet. Returns the new [Medication], or
/// null if the user closed the sheet without saving.
Future<Medication?> showAddMedicationSheet(BuildContext context) {
  return showTidalSheet<Medication>(context, const _AddMedicationSheet());
}

class _AddMedicationSheet extends StatefulWidget {
  const _AddMedicationSheet();

  @override
  State<_AddMedicationSheet> createState() => _AddMedicationSheetState();
}

class _AddMedicationSheetState extends State<_AddMedicationSheet> {
  final _nameController = TextEditingController();
  final _doseController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      _nameController.text.trim().isNotEmpty &&
      _doseController.text.trim().isNotEmpty;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final medication = await client.pain.addMedication(
        _nameController.text.trim(),
        _doseController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context, medication);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showSheetError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Add a medication',
      saving: _saving,
      onSave: (_saving || !_canSave) ? null : _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameController,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Name, e.g. Ibuprofen',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TidalRadius.small),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _doseController,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Usual dose, e.g. 400 mg',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TidalRadius.small),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Opens the "How's the pain?" sheet: a 0-10 level, location chips, and an
/// optional one-tap "took something". Saves a [PainEntry] and, if a
/// medication was picked, a [DoseLog] with `painBefore` set to that level.
/// Returns true if something was saved.
Future<bool> showPainSheet(BuildContext context) async {
  final result = await showTidalSheet<bool>(context, const _PainSheet());
  return result ?? false;
}

class _PainSheet extends StatefulWidget {
  const _PainSheet();

  @override
  State<_PainSheet> createState() => _PainSheetState();
}

class _PainSheetState extends State<_PainSheet> {
  int? _level;
  final Set<PainLocation> _locations = {};
  List<Medication>? _meds;
  int? _selectedMedicationId;
  bool _saving = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _loadMeds();
  }

  Future<void> _loadMeds() async {
    try {
      final meds = await client.pain.myMeds();
      if (mounted) setState(() => _meds = meds);
    } catch (e) {
      if (mounted) setState(() => _loadError = '$e');
    }
  }

  Future<void> _save() async {
    final level = _level;
    if (level == null) return;
    setState(() => _saving = true);
    try {
      await client.pain.logPain(level, _locations.toList());
      final medicationId = _selectedMedicationId;
      if (medicationId != null) {
        await client.pain.logDose(medicationId, painBefore: level);
      }
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
    final meds = _meds;
    return SheetScaffold(
      title: "How's the pain?",
      saving: _saving,
      onSave: (_saving || _level == null) ? null : _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(11, (level) {
              return OptionChip(
                label: '$level',
                selected: level == _level,
                selectedBackground: TidalColors.roseBand,
                selectedForeground: TidalColors.rose,
                onTap: () => setState(() => _level = level),
              );
            }),
          ),
          const SizedBox(height: 20),
          Text('Where?', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: PainLocation.values.map((location) {
              final selected = _locations.contains(location);
              return OptionChip(
                label: location.label,
                selected: selected,
                selectedBackground: TidalColors.roseBand,
                selectedForeground: TidalColors.rose,
                onTap: () => setState(() {
                  if (selected) {
                    _locations.remove(location);
                  } else {
                    _locations.add(location);
                  }
                }),
              );
            }).toList(),
          ),
          if (_loadError != null) ...[
            const SizedBox(height: 20),
            Text(
              'Could not load your meds: $_loadError',
              style: const TextStyle(color: TidalColors.rose),
            ),
          ],
          if (meds != null && meds.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Took something? One tap',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            ...meds.map((med) {
              final selected = med.id == _selectedMedicationId;
              return _MedicationTile(
                medication: med,
                highlighted: selected,
                trailing: Icon(
                  selected ? Icons.check_circle : Icons.circle_outlined,
                  color: selected
                      ? TidalColors.lavender
                      : TidalColors.textSecondary,
                ),
                onTap: () => setState(() {
                  _selectedMedicationId = selected ? null : med.id;
                }),
              );
            }),
          ],
        ],
      ),
    );
  }
}

/// Opens the "Painkiller" sheet: "time since last dose" plus a one-tap list
/// of the user's medications. Tapping one immediately logs a [DoseLog] and
/// closes the sheet. Returns true if a dose was logged.
Future<bool> showPainkillerSheet(BuildContext context) async {
  final result = await showTidalSheet<bool>(context, const _PainkillerSheet());
  return result ?? false;
}

class _PainkillerSheet extends StatefulWidget {
  const _PainkillerSheet();

  @override
  State<_PainkillerSheet> createState() => _PainkillerSheetState();
}

class _PainkillerSheetState extends State<_PainkillerSheet> {
  List<Medication>? _meds;
  DoseLog? _lastDose;
  String? _loadError;
  int? _loggingMedicationId;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final meds = await client.pain.myMeds();
      final lastDose = await client.pain.getLastDose();
      if (!mounted) return;
      setState(() {
        _meds = meds;
        _lastDose = lastDose;
      });
    } catch (e) {
      if (mounted) setState(() => _loadError = '$e');
    }
  }

  Future<void> _logDose(Medication medication) async {
    setState(() => _loggingMedicationId = medication.id);
    try {
      await client.pain.logDose(medication.id!);
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loggingMedicationId = null);
      showSheetError(context, e);
    }
  }

  Future<void> _addMedication() async {
    final added = await showAddMedicationSheet(context);
    if (added != null && mounted) {
      setState(() => _meds = [...?_meds, added]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final meds = _meds;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Painkiller',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
          Text(
            _lastDose == null
                ? "You haven't logged a dose yet"
                : 'Last dose: ${formatRelativeTime(_lastDose!.timestamp)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          if (meds == null && _loadError == null)
            const Center(child: CircularProgressIndicator())
          else if (_loadError != null)
            Text(
              'Could not load: $_loadError',
              style: const TextStyle(color: TidalColors.rose),
            )
          else if (meds!.isEmpty)
            Text(
              "You haven't added any medications yet.",
              style: Theme.of(context).textTheme.bodyMedium,
            )
          else
            ...meds.map((med) {
              final logging = _loggingMedicationId == med.id;
              return _MedicationTile(
                medication: med,
                trailing: logging
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(
                        Icons.chevron_right,
                        color: TidalColors.lavender,
                      ),
                onTap: _loggingMedicationId == null
                    ? () => _logDose(med)
                    : null,
              );
            }),
          const SizedBox(height: 4),
          TextButton.icon(
            onPressed: _addMedication,
            icon: const Icon(Icons.add),
            label: const Text('Add a medication'),
          ),
        ],
      ),
    );
  }
}
