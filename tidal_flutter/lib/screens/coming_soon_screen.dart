import 'package:flutter/material.dart';

import '../theme.dart';

/// Placeholder for tabs that haven't been built yet. Replace with the real
/// screen when its step in the MVP is reached (see CLAUDE.md).
class ComingSoonScreen extends StatelessWidget {
  final String title;

  const ComingSoonScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title is coming in a later step.',
          style: const TextStyle(color: TidalColors.textSecondary),
        ),
      ),
    );
  }
}
