import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:tidal_client/tidal_client.dart';

import '../client.dart';
import '../theme.dart';
import '../widgets/birth_year_picker.dart';
import '../widgets/cycle_length_sheet.dart';

/// The "Me" tab. Shows who's signed in, cycle settings, and a way to sign
/// out. Privacy controls (like "delete all my data") are added in a later
/// step.
class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  String? _email;
  int? _cycleLength;
  PeriodLengthInfo? _periodLength;
  List<CycleLength> _recentCycles = [];
  int? _birthYear;
  int? _age;
  // Separate from _birthYear/_age being null, which also means "not set
  // yet" — this just tracks whether the initial load has finished, so the
  // row isn't tappable before we know what to pre-fill the picker with.
  bool _birthYearLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadCycleLength();
    _loadPeriodLength();
    _loadRecentCycles();
    _loadBirthYear();
  }

  Future<void> _loadProfile() async {
    final profile = await client.modules.serverpod_auth_core.userProfileInfo
        .get();
    if (mounted) setState(() => _email = profile.email);
  }

  Future<void> _loadCycleLength() async {
    final days = await client.insight.getCycleLength();
    if (mounted) setState(() => _cycleLength = days);
  }

  Future<void> _loadPeriodLength() async {
    final info = await client.period.getDefaultPeriodLength();
    if (mounted) setState(() => _periodLength = info);
  }

  Future<void> _loadRecentCycles() async {
    final prediction = await client.insight.getPrediction();
    if (mounted) {
      setState(() => _recentCycles = prediction.recentCycles ?? []);
    }
  }

  /// "5 days · from your last 3 periods", or "· from sign-up" until any
  /// period has a confirmed end.
  String? _periodLengthText() {
    final info = _periodLength;
    if (info == null) return null;
    final source = info.fromPeriods == 0
        ? 'from sign-up'
        : info.fromPeriods == 1
        ? 'from your last period'
        : 'from your last ${info.fromPeriods} periods';
    return '${info.days} days · $source';
  }

  Future<void> _loadBirthYear() async {
    final results = await Future.wait([
      client.insight.getBirthYear(),
      client.insight.getAge(),
    ]);
    if (mounted) {
      setState(() {
        _birthYear = results[0];
        _age = results[1];
        _birthYearLoaded = true;
      });
    }
  }

  Future<void> _editCycleLength() async {
    final current = _cycleLength;
    if (current == null) return;
    final saved = await showCycleLengthSheet(context, current: current);
    if (saved) _loadCycleLength();
  }

  Future<void> _editBirthYear() async {
    final saved = await pickAndSaveBirthYear(context, initial: _birthYear);
    if (saved) _loadBirthYear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Me')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Signed in as',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            Text(_email ?? '…', style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            Text('Profile', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            _SettingsRow(
              label: 'Birth year',
              value: !_birthYearLoaded
                  ? null
                  : (_age == null ? 'Not set' : '$_age yrs'),
              onTap: _birthYearLoaded ? _editBirthYear : null,
            ),
            const SizedBox(height: 32),
            Text(
              'Cycle settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _SettingsRow(
              label: 'Cycle length',
              value: _cycleLength == null ? null : '$_cycleLength days',
              onTap: _cycleLength == null ? null : _editCycleLength,
            ),
            if (_recentCycles.isNotEmpty) ...[
              const SizedBox(height: 6),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  'Recent cycles: ${_recentCycles.map((c) => c.excludedFromAverage ? '${c.days}*' : '${c.days}').join(', ')}'
                  '${_recentCycles.any((c) => c.excludedFromAverage) ? '\n* over 45 days, not counted in predictions' : ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
            const SizedBox(height: 8),
            // Read-only: period length is only entered at sign-up, then
            // learned from the periods the user records.
            _SettingsRow(label: 'Period length', value: _periodLengthText()),
            const SizedBox(height: 32),
            OutlinedButton(
              onPressed: () => client.auth.signOutDevice(),
              style: OutlinedButton.styleFrom(
                foregroundColor: TidalColors.rose,
                side: const BorderSide(color: TidalColors.rose),
                minimumSize: const Size.fromHeight(44),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(TidalRadius.large),
                ),
              ),
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }
}

/// One settings row: a label on the left, the current value on the right,
/// plus a chevron when it's tappable (period length is read-only).
class _SettingsRow extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback? onTap;

  const _SettingsRow({required this.label, required this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
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
            Expanded(
              child: Text(label, style: Theme.of(context).textTheme.bodyLarge),
            ),
            Text(value ?? '…', style: Theme.of(context).textTheme.bodyMedium),
            if (onTap != null) ...[
              const SizedBox(width: 4),
              const Icon(
                Icons.chevron_right,
                color: TidalColors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
