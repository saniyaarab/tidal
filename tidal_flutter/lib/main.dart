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

/// The widest the app gets on a big screen, in logical pixels.
const _phoneWidth = 430.0;

class TidalApp extends StatelessWidget {
  const TidalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tidal',
      theme: buildTidalTheme(),
      // Tidal is a phone app: on a wide screen (the web build in a desktop
      // browser), keep it phone-width and centred instead of stretched.
      // Wrapping here keeps sheets, dialogs and messages inside it too, and
      // the screen size reported to them is the phone width, not the
      // window's, so they size and centre themselves correctly.
      builder: (context, child) {
        final media = MediaQuery.of(context);
        final width = media.size.width < _phoneWidth
            ? media.size.width
            : _phoneWidth;
        return ColoredBox(
          color: TidalColors.background,
          child: Center(
            child: SizedBox(
              width: width,
              child: MediaQuery(
                data: media.copyWith(size: Size(width, media.size.height)),
                child: child!,
              ),
            ),
          ),
        );
      },
      home: const Scaffold(
        body: SignInScreen(
          child: CycleSetupGate(child: AppShell()),
        ),
      ),
    );
  }
}
