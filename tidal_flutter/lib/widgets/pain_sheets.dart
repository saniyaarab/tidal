import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../date_format.dart';
import '../log_labels.dart';
import '../theme.dart';
import 'sheet_common.dart';
import 'when_picker.dart';

/// Icon shown next to a medication, by its type.
IconData medicationIcon(MedicationType? type) => switch (type) {
  MedicationType.painkiller => Icons.medication_outlined,
  MedicationType.birthControl => Icons.event_repeat_outlined,
  MedicationType.vitamin => Icons.eco_outlined,
  MedicationType.other || null => Icons.medication_liquid_outlined,
};

/// Shown when a chosen time is later than now.
void _showFutureTimeError(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("That time hasn't happened yet.")),
  );
}

/// Opens the "How's the pain?" sheet: a 0-10 level, location chips, and the
/// day/time it happened (defaulting to [date] at the current time). Saves a
/// [PainEntry]. Returns true if something was saved.
Future<bool> showPainSheet(
  BuildContext context, {
  required DateTime date,
}) async {
  final result = await showTidalSheet<bool>(context, _PainSheet(date: date));
  return result ?? false;
}

class _PainSheet extends StatefulWidget {
  final DateTime date;
  const _PainSheet({required this.date});

  @override
  State<_PainSheet> createState() => _PainSheetState();
}

class _PainSheetState extends State<_PainSheet> {
  int? _level;
  final Set<PainLocation> _locations = {};
  late LogMoment _when = LogMoment.nowOn(widget.date);
  bool _saving = false;

  Future<void> _save() async {
    final level = _level;
    if (level == null) return;
    if (_when.isInFuture) return _showFutureTimeError(context);
    setState(() => _saving = true);
    try {
      await client.pain.logPain(
        level,
        _locations.toList(),
        _when.day,
        _when.time.toUtc(),
      );
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
      title: "How's the pain?",
      saving: _saving,
      onSave: (_saving || _level == null) ? null : _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WhenPicker(
            value: _when,
            onChanged: (when) => setState(() => _when = when),
          ),
          const SizedBox(height: 16),
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
        ],
      ),
    );
  }
}

/// Opens the "Medications" sheet: the user's list of anything they take
/// (painkillers, birth control, vitamins...), each with when it was last
/// taken. Tapping one logs it as taken at the chosen day/time (defaulting
/// to [date] at the current time) and closes the sheet. Returns true if one
/// was logged.
Future<bool> showMedicationsSheet(
  BuildContext context, {
  required DateTime date,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _MedicationsSheet(date: date),
  );
  return result ?? false;
}

class _MedicationsSheet extends StatefulWidget {
  final DateTime date;
  const _MedicationsSheet({required this.date});

  @override
  State<_MedicationsSheet> createState() => _MedicationsSheetState();
}

class _MedicationsSheetState extends State<_MedicationsSheet> {
  List<Medication>? _meds;
  Map<int, DoseLog> _lastDoseByMedicationId = {};
  Map<int, MedicationReminder> _reminderByMedicationId = {};
  late LogMoment _when = LogMoment.nowOn(widget.date);
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
      final lastDoses = await client.pain.getLastDosePerMedication();
      final reminders = await client.pain.getReminders();
      if (!mounted) return;
      setState(() {
        _meds = meds;
        _lastDoseByMedicationId = {
          for (final dose in lastDoses) dose.medicationId: dose,
        };
        _reminderByMedicationId = {
          for (final reminder in reminders) reminder.medicationId: reminder,
        };
      });
    } catch (e) {
      if (mounted) setState(() => _loadError = '$e');
    }
  }

  Future<void> _logDose(Medication medication) async {
    if (_when.isInFuture) return _showFutureTimeError(context);
    setState(() => _loggingMedicationId = medication.id);
    try {
      await client.pain.logDose(
        medication.id!,
        _when.day,
        _when.time.toUtc(),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _loggingMedicationId = null);
      showSheetError(context, e);
    }
  }

  /// The bell on a medication: pick how often to be reminded after a dose.
  Future<void> _editReminder(Medication medication) async {
    final hours = await showReminderSheet(
      context,
      current: medication.reminderEveryHours,
    );
    // The sheet returns -1 when closed without saving.
    if (hours == -1 || !mounted) return;
    try {
      await client.pain.setReminder(medication.id!, hours);
      await _load();
    } catch (e) {
      if (mounted) showSheetError(context, e);
    }
  }

  /// "Last taken 2h ago · next in 2h", "… · due now", or "Not taken yet".
  String _subtitle(Medication med) {
    final lastDose = _lastDoseByMedicationId[med.id];
    final reminder = _reminderByMedicationId[med.id];
    final last = lastDose == null
        ? 'Not taken yet'
        : 'Last taken ${formatRelativeTime(lastDose.timestamp)}';
    if (med.reminderEveryHours == null || reminder == null) return last;
    return reminder.isDue
        ? '$last · due now'
        : '$last · next ${formatTimeUntil(reminder.dueAt)}';
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
                  'Medications',
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
            'Tap one to log it as taken',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          WhenPicker(
            value: _when,
            onChanged: (when) => setState(() => _when = when),
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
                subtitle: _subtitle(med),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: 'Reminder',
                      onPressed: () => _editReminder(med),
                      icon: Icon(
                        med.reminderEveryHours == null
                            ? Icons.notifications_none
                            : Icons.notifications_active,
                        color: TidalColors.lavender,
                      ),
                    ),
                    logging
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(
                            Icons.add_circle_outline,
                            color: TidalColors.lavender,
                          ),
                  ],
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

/// One medication in the Medications sheet: type icon, name and usual dose,
/// and a subtitle such as "Last taken 3h ago".
class _MedicationTile extends StatelessWidget {
  final Medication medication;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _MedicationTile({
    required this.medication,
    required this.subtitle,
    required this.trailing,
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
            color: TidalColors.background,
            borderRadius: BorderRadius.circular(TidalRadius.small),
            border: Border.all(color: TidalColors.border),
          ),
          child: Row(
            children: [
              Icon(
                medicationIcon(medication.type),
                color: TidalColors.lavender,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${medication.name} · ${medication.usualDose}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
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

/// Opens the "Add a medication" sheet: name, usual dose, and an optional
/// type. Returns the new [Medication], or null if the user closed the sheet
/// without saving.
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
  MedicationType? _type;
  int? _reminderEveryHours;
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
        type: _type,
        reminderEveryHours: _reminderEveryHours,
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
              hintText: 'Usual dose, e.g. 400 mg or 1 pill',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(TidalRadius.small),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Type (optional)',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: MedicationType.values.map((type) {
              final selected = type == _type;
              return OptionChip(
                label: type.label,
                selected: selected,
                selectedBackground: TidalColors.lavenderBand,
                selectedForeground: TidalColors.lavender,
                onTap: () => setState(() => _type = selected ? null : type),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text('Remind me', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          _ReminderChips(
            selected: _reminderEveryHours,
            onPick: (hours) => setState(() => _reminderEveryHours = hours),
          ),
        ],
      ),
    );
  }
}

/// How often a reminder can repeat after each dose (null = off).
const _reminderOptions = <int?>[null, 4, 6, 8, 12, 24];

/// "Off", "Every 4h", "Every 6h"… chips.
class _ReminderChips extends StatelessWidget {
  final int? selected;
  final ValueChanged<int?> onPick;
  const _ReminderChips({required this.selected, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final hours in _reminderOptions)
          OptionChip(
            label: hours == null ? 'Off' : 'Every ${hours}h',
            selected: hours == selected,
            selectedBackground: TidalColors.lavenderBand,
            selectedForeground: TidalColors.lavender,
            onTap: () => onPick(hours),
          ),
      ],
    );
  }
}

/// Opens the "Reminder" sheet for one medication. Returns the chosen hours
/// (null = off), or -1 if the sheet was closed without saving.
Future<int?> showReminderSheet(
  BuildContext context, {
  required int? current,
}) async {
  final result = await showTidalSheet<Object?>(
    context,
    _ReminderSheet(current: current),
  );
  // Closing with X (false) or by swiping (null) isn't a choice.
  return result is _ReminderChoice ? result.hours : -1;
}

/// What the Reminder sheet's Save returns, so "Off" (null hours) can be
/// told apart from closing the sheet.
class _ReminderChoice {
  final int? hours;
  const _ReminderChoice(this.hours);
}

class _ReminderSheet extends StatefulWidget {
  final int? current;
  const _ReminderSheet({required this.current});

  @override
  State<_ReminderSheet> createState() => _ReminderSheetState();
}

class _ReminderSheetState extends State<_ReminderSheet> {
  late int? _hours = widget.current;

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Remind me',
      saving: false,
      onSave: () => Navigator.pop(context, _ReminderChoice(_hours)),
      child: _ReminderChips(
        selected: _hours,
        onPick: (hours) => setState(() => _hours = hours),
      ),
    );
  }
}
