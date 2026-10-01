import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../client.dart';
import '../theme.dart';

/// The "Me" tab. For now just shows who's signed in and a way to sign out.
/// Privacy controls (like "delete all my data") are added in a later step.
class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await client.modules.serverpod_auth_core.userProfileInfo
        .get();
    if (mounted) setState(() => _email = profile.email);
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
