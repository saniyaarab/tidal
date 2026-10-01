import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'client.dart';
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
      home: const Scaffold(
        body: SignInScreen(child: AppShell()),
      ),
    );
  }
}
