import 'package:flutter/material.dart';

import '../client.dart';
import 'cycle_setup_screen.dart';

/// Sits between sign-in and the app shell: checks whether the signed-in
/// user has ever saved cycle settings, and shows [CycleSetupScreen] first
/// if not. A fresh [State] here (one per sign-in — see [SignInScreen])
/// means this check runs again for every new session, so switching
/// accounts on the same device asks the new user too.
class CycleSetupGate extends StatefulWidget {
  final Widget child;
  const CycleSetupGate({super.key, required this.child});

  @override
  State<CycleSetupGate> createState() => _CycleSetupGateState();
}

class _CycleSetupGateState extends State<CycleSetupGate> {
  // Null while checking; true/false once known.
  bool? _needsSetup;

  @override
  void initState() {
    super.initState();
    _check();
  }

  Future<void> _check() async {
    try {
      final hasSettings = await client.insight.hasCycleSettings();
      if (mounted) setState(() => _needsSetup = !hasSettings);
    } catch (_) {
      // If the check fails, don't block sign-in on it — the Me screen's
      // cycle settings still default sensibly either way.
      if (mounted) setState(() => _needsSetup = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_needsSetup == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_needsSetup!) {
      return CycleSetupScreen(
        onDone: () => setState(() => _needsSetup = false),
      );
    }
    return widget.child;
  }
}
