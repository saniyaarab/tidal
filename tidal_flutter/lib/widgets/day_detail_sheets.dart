import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../log_labels.dart';
import '../theme.dart';
import '../units.dart';
import 'sheet_common.dart';
import 'when_picker.dart';

/// The sheets for the once-a-day details on the Log screen: drink counters,
/// sleep, digestion, weight, temperature, mucus and love. Each saves for
/// [date] and returns true if something was saved. See "More daily logging"
/// in CLAUDE.md.

/// Runs [save], closing the sheet on success or showing the error.
Future<void> _saveAndClose(
  State state,
  void Function(bool saving) setSaving,
  Future<void> Function() save,
) async {
  setSaving(true);
  try {
    await save();
    if (state.mounted) Navigator.pop(state.context, true);
  } catch (e) {
    if (!state.mounted) return;
    setSaving(false);
    showSheetError(state.context, e);
  }
}

/// A small grey heading inside a sheet, e.g. "Bloating".
Widget _sectionLabel(BuildContext context, String text) => Padding(
  padding: const EdgeInsets.only(top: 16, bottom: 8),
  child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
);

// ---------------------------------------------------------------- Drinks

/// Water, caffeine or alcohol: a − / + counter for the day.
Future<bool> showDrinkSheet(
  BuildContext context, {
  required DateTime date,
  required DrinkType drink,
  required int current,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _DrinkSheet(date: date, drink: drink, initial: current),
  );
  return result ?? false;
}

class _DrinkSheet extends StatefulWidget {
  final DateTime date;
  final DrinkType drink;
  final int initial;
  const _DrinkSheet({
    required this.date,
    required this.drink,
    required this.initial,
  });

  @override
  State<_DrinkSheet> createState() => _DrinkSheetState();
}

class _DrinkSheetState extends State<_DrinkSheet> {
  late int _count = widget.initial;
  bool _saving = false;

  String get _title => switch (widget.drink) {
    DrinkType.water => 'Water',
    DrinkType.caffeine => 'Caffeine',
    DrinkType.alcohol => 'Alcohol',
  };

  String get _unit => switch (widget.drink) {
    DrinkType.water => _count == 1 ? 'glass (250 ml)' : 'glasses (250 ml)',
    _ => _count == 1 ? 'drink' : 'drinks',
  };

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: _title,
      saving: _saving,
      onSave: _saving
          ? null
          : () => _saveAndClose(
              this,
              (s) => setState(() => _saving = s),
              () =>
                  client.log.saveDrinkCount(widget.date, widget.drink, _count),
            ),
      child: _Stepper(
        value: '$_count',
        unit: _unit,
        onMinus: _count == 0 ? null : () => setState(() => _count--),
        onPlus: () => setState(() => _count++),
      ),
    );
  }
}

/// A big number with − and + buttons on either side.
class _Stepper extends StatelessWidget {
  final String value;
  final String unit;
  final VoidCallback? onMinus;
  final VoidCallback? onPlus;

  const _Stepper({
    required this.value,
    required this.unit,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    Widget button(IconData icon, VoidCallback? onPressed) => IconButton.filled(
      onPressed: onPressed,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: TidalColors.lavenderBand,
        foregroundColor: TidalColors.lavender,
        minimumSize: const Size(48, 48),
      ),
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        button(Icons.remove, onMinus),
        const SizedBox(width: 24),
        Column(
          children: [
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: TidalColors.lavender),
            ),
            Text(unit, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const SizedBox(width: 24),
        button(Icons.add, onPlus),
      ],
    );
  }
}

// ----------------------------------------------------------------- Sleep

/// Last night's sleep: quality 1–5 and optional hours.
Future<bool> showSleepSheet(
  BuildContext context, {
  required DateTime date,
  required int? quality,
  required double? hours,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _SleepSheet(date: date, quality: quality, hours: hours),
  );
  return result ?? false;
}

class _SleepSheet extends StatefulWidget {
  final DateTime date;
  final int? quality;
  final double? hours;
  const _SleepSheet({required this.date, this.quality, this.hours});

  @override
  State<_SleepSheet> createState() => _SleepSheetState();
}

class _SleepSheetState extends State<_SleepSheet> {
  late int? _quality = widget.quality;
  late double? _hours = widget.hours;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final hours = _hours;
    return SheetScaffold(
      title: 'Sleep',
      saving: _saving,
      onSave: _saving
          ? null
          : () => _saveAndClose(
              this,
              (s) => setState(() => _saving = s),
              () => client.log.saveSleep(widget.date, _quality, _hours),
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var q = 1; q <= 5; q++)
                OptionChip(
                  label: sleepQualityLabels[q - 1],
                  selected: q == _quality,
                  selectedBackground: TidalColors.lavenderBand,
                  selectedForeground: TidalColors.lavender,
                  onTap: () =>
                      setState(() => _quality = q == _quality ? null : q),
                ),
            ],
          ),
          _sectionLabel(context, 'Hours'),
          _Stepper(
            value: hours == null ? '–' : formatOneDecimal(hours),
            unit: 'hours',
            onMinus: hours == null || hours <= 0
                ? null
                : () => setState(() => _hours = hours - 0.5),
            onPlus: hours != null && hours >= 24
                ? null
                : () => setState(() => _hours = (hours ?? 7) + 0.5),
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------- Digestion

/// Digestion: an optional bowel movement (Bristol type, with day and time),
/// plus the day's bloating and acid reflux.
Future<bool> showDigestionSheet(
  BuildContext context, {
  required DateTime date,
  required Severity? bloating,
  required Severity? acidReflux,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _DigestionSheet(date: date, bloating: bloating, acidReflux: acidReflux),
  );
  return result ?? false;
}

class _DigestionSheet extends StatefulWidget {
  final DateTime date;
  final Severity? bloating;
  final Severity? acidReflux;
  const _DigestionSheet({required this.date, this.bloating, this.acidReflux});

  @override
  State<_DigestionSheet> createState() => _DigestionSheetState();
}

class _DigestionSheetState extends State<_DigestionSheet> {
  late LogMoment _when = LogMoment.nowOn(widget.date);
  int? _bristolType;
  late Severity? _bloating = widget.bloating;
  late Severity? _acidReflux = widget.acidReflux;
  bool _saving = false;

  Future<void> _save() async {
    final bristolType = _bristolType;
    if (bristolType != null && _when.isInFuture) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("That time hasn't happened yet.")),
      );
      return;
    }
    await _saveAndClose(this, (s) => setState(() => _saving = s), () async {
      if (bristolType != null) {
        await client.digestion.logBowelMovement(
          _when.day,
          _when.time.toUtc(),
          bristolType,
        );
      }
      await client.log.saveDigestionDay(widget.date, _bloating, _acidReflux);
    });
  }

  Widget _severityChips(Severity? selected, ValueChanged<Severity?> onPick) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: Severity.values.map((severity) {
        return OptionChip(
          label: severity.label,
          selected: severity == selected,
          selectedBackground: TidalColors.yellowBand,
          selectedForeground: TidalColors.yellowIcon,
          onTap: () => onPick(severity == selected ? null : severity),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: 'Digestion',
      saving: _saving,
      onSave: _saving ? null : _save,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Bowel movement', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          WhenPicker(
            value: _when,
            onChanged: (when) => setState(() => _when = when),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var type = 1; type <= 7; type++)
                OptionChip(
                  label: '$type · ${bristolLabels[type - 1]}',
                  selected: type == _bristolType,
                  selectedBackground: TidalColors.yellowBand,
                  selectedForeground: TidalColors.yellowIcon,
                  onTap: () => setState(
                    () => _bristolType = type == _bristolType ? null : type,
                  ),
                ),
            ],
          ),
          _sectionLabel(context, 'Bloating'),
          _severityChips(_bloating, (v) => setState(() => _bloating = v)),
          _sectionLabel(context, 'Acid reflux'),
          _severityChips(_acidReflux, (v) => setState(() => _acidReflux = v)),
        ],
      ),
    );
  }
}

// ------------------------------------------------ Weight and temperature

/// Weight for the day, with a kg / lb switch the app remembers.
Future<bool> showWeightSheet(
  BuildContext context, {
  required DateTime date,
  required double? kg,
  required WeightUnit unit,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _MeasurementSheet<WeightUnit>(
      date: date,
      title: 'Weight',
      storedValue: kg,
      unit: unit,
      units: WeightUnit.values,
      symbol: weightSymbol,
      toUnit: kgTo,
      fromUnit: kgFrom,
      saveValue: (stored) => client.log.saveWeight(date, stored),
      saveUnit: client.insight.saveWeightUnit,
    ),
  );
  return result ?? false;
}

/// Basal body temperature for the day, with a °C / °F switch the app
/// remembers.
Future<bool> showTemperatureSheet(
  BuildContext context, {
  required DateTime date,
  required double? celsius,
  required TemperatureUnit unit,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _MeasurementSheet<TemperatureUnit>(
      date: date,
      title: 'Temperature',
      storedValue: celsius,
      unit: unit,
      units: TemperatureUnit.values,
      symbol: temperatureSymbol,
      toUnit: celsiusTo,
      fromUnit: celsiusFrom,
      saveValue: (stored) => client.log.saveTemperature(date, stored),
      saveUnit: client.insight.saveTemperatureUnit,
    ),
  );
  return result ?? false;
}

/// One number with a unit switch. [storedValue] is in the stored unit (kg
/// or °C); [toUnit]/[fromUnit] convert to and from what the user sees.
/// Leaving the field empty clears the day's value.
class _MeasurementSheet<U> extends StatefulWidget {
  final DateTime date;
  final String title;
  final double? storedValue;
  final U unit;
  final List<U> units;
  final String Function(U unit) symbol;
  final double Function(U unit, double stored) toUnit;
  final double Function(U unit, double shown) fromUnit;
  final Future<void> Function(double? stored) saveValue;
  final Future<void> Function(U unit) saveUnit;

  const _MeasurementSheet({
    super.key,
    required this.date,
    required this.title,
    required this.storedValue,
    required this.unit,
    required this.units,
    required this.symbol,
    required this.toUnit,
    required this.fromUnit,
    required this.saveValue,
    required this.saveUnit,
  });

  @override
  State<_MeasurementSheet<U>> createState() => _MeasurementSheetState<U>();
}

class _MeasurementSheetState<U> extends State<_MeasurementSheet<U>> {
  late U _unit = widget.unit;
  late final _controller = TextEditingController(
    text: widget.storedValue == null
        ? ''
        : formatOneDecimal(widget.toUnit(widget.unit, widget.storedValue!)),
  );
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double? get _shownValue =>
      double.tryParse(_controller.text.trim().replaceAll(',', '.'));

  /// Switching unit converts what's typed, so the value stays the same.
  void _switchUnit(U unit) {
    final shown = _shownValue;
    setState(() {
      if (shown != null) {
        final stored = widget.fromUnit(_unit, shown);
        _controller.text = formatOneDecimal(widget.toUnit(unit, stored));
      }
      _unit = unit;
    });
  }

  bool get _canSave => _controller.text.trim().isEmpty || _shownValue != null;

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: widget.title,
      saving: _saving,
      onSave: (_saving || !_canSave)
          ? null
          : () => _saveAndClose(
              this,
              (s) => setState(() => _saving = s),
              () async {
                final shown = _shownValue;
                await widget.saveValue(
                  shown == null ? null : widget.fromUnit(_unit, shown),
                );
                if (_unit != widget.unit) await widget.saveUnit(_unit);
              },
            ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(TidalRadius.small),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          SegmentedButton<U>(
            segments: [
              for (final unit in widget.units)
                ButtonSegment(value: unit, label: Text(widget.symbol(unit))),
            ],
            selected: {_unit},
            showSelectedIcon: false,
            onSelectionChanged: (selection) => _switchUnit(selection.single),
          ),
        ],
      ),
    );
  }
}

// --------------------------------------------------------- Mucus and love

/// Cervical mucus for the day.
Future<bool> showMucusSheet(
  BuildContext context, {
  required DateTime date,
  required MucusType? current,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _ChoiceSheet<MucusType>(
      title: 'Mucus',
      options: MucusType.values,
      label: (m) => m.label,
      initial: current,
      save: (value) => client.log.saveMucus(date, value),
    ),
  );
  return result ?? false;
}

/// Sex for the day: protected or unprotected.
Future<bool> showLoveSheet(
  BuildContext context, {
  required DateTime date,
  required LoveType? current,
}) async {
  final result = await showTidalSheet<bool>(
    context,
    _ChoiceSheet<LoveType>(
      title: 'Love',
      options: LoveType.values,
      label: (l) => l.label,
      initial: current,
      save: (value) => client.log.saveLove(date, value),
    ),
  );
  return result ?? false;
}

/// Pick one of a few options (tap the selected one again to clear it).
class _ChoiceSheet<T> extends StatefulWidget {
  final String title;
  final List<T> options;
  final String Function(T option) label;
  final T? initial;
  final Future<void> Function(T? value) save;

  const _ChoiceSheet({
    super.key,
    required this.title,
    required this.options,
    required this.label,
    required this.initial,
    required this.save,
  });

  @override
  State<_ChoiceSheet<T>> createState() => _ChoiceSheetState<T>();
}

class _ChoiceSheetState<T> extends State<_ChoiceSheet<T>> {
  late T? _selected = widget.initial;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: widget.title,
      saving: _saving,
      onSave: _saving
          ? null
          : () => _saveAndClose(
              this,
              (s) => setState(() => _saving = s),
              () => widget.save(_selected),
            ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: widget.options.map((option) {
          return OptionChip(
            label: widget.label(option),
            selected: option == _selected,
            selectedBackground: TidalColors.lavenderBand,
            selectedForeground: TidalColors.lavender,
            onTap: () =>
                setState(() => _selected = option == _selected ? null : option),
          );
        }).toList(),
      ),
    );
  }
}
