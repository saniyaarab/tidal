import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'client.dart';
import 'screens/cycle_setup_gate.dart';
import 'screens/sign_in_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeClient();
  runApp(const TidalApp());
}

class TidalApp extends StatelessWidget {
  const TidalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tidal',
      theme: buildTidalTheme(),
      // Tidal is a phone app: on a wide screen (the web build in a desktop
      // browser), keep it phone-width and centred instead of stretched.
      // Wrapping here also keeps sheets, dialogs and messages inside it.
      builder: (context, child) => ColoredBox(
        color: TidalColors.background,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 430),
            child: child,
          ),
        ),
      ),
      home: const Scaffold(
        body: SignInScreen(
          child: CycleSetupGate(child: AppShell()),
        ),
      ),
    );
  }
}
