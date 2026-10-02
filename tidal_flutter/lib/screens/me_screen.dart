import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme.dart';
import 'privacy_screen.dart';

/// The "Me" tab. Shows who's signed in, their age (from the birth year
/// asked at sign-up), the Privacy screen, and a way to sign out. Cycle and period length are only asked at sign-up; their learned
/// averages are on Insights. Privacy controls (like "delete all my data") are added in a later
/// step.
class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  String? _email;
  int? _age;
  // Separate from _age being null, which also means "not set" — this just
  // tracks whether the initial load has finished.
  bool _ageLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadAge();
  }

  Future<void> _loadProfile() async {
    final profile = await client.modules.serverpod_auth_core.userProfileInfo
        .get();
    if (mounted) setState(() => _email = profile.email);
  }

  Future<void> _loadAge() async {
    final age = await client.insight.getAge();
    if (mounted) {
      setState(() {
        _age = age;
        _ageLoaded = true;
      });
    }
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
            // Read-only: birth year is asked once, at sign-up, and this shows
            // the age computed from it.
            _SettingsRow(
              label: 'Age',
              value: !_ageLoaded
                  ? null
                  : (_age == null ? 'Not set' : '$_age yrs'),
            ),
            const SizedBox(height: 8),
            _SettingsRow(
              label: 'Privacy',
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PrivacyScreen()),
              ),
            ),
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

/// One settings row: a label on the left and either a value (read-only,
/// like Age) or a chevron (tappable, like Privacy) on the right.
class _SettingsRow extends StatelessWidget {
  final String label;
  final String? value;
  final VoidCallback? onTap;

  const _SettingsRow({required this.label, this.value, this.onTap});

  @override
  Widget build(BuildContext context) {
    final row = Container(
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
          if (onTap == null)
            Text(value ?? '…', style: Theme.of(context).textTheme.bodyMedium)
          else
            const Icon(Icons.chevron_right, color: TidalColors.textSecondary),
        ],
      ),
    );
    if (onTap == null) return row;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(TidalRadius.large),
      child: row,
    );
  }
}
