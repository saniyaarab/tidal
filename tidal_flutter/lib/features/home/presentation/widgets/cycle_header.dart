import 'package:flutter/material.dart';

import '../../../../theme.dart';
import '../../domain/cycle_outlook.dart';
import '../home_text.dart';

/// "Cycle day 5 · Next period in 23 days" header. Always about today,
/// whichever day the arrows are showing in the circle below it.
class CycleHeader extends StatelessWidget {
  final CycleOutlook outlook;
  const CycleHeader({super.key, required this.outlook});

  @override
  Widget build(BuildContext context) {
    final subtitle = cycleSubtitleText(outlook);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Text(
            cycleTitleText(outlook),
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(color: TidalColors.lavender),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ],
      ),
    );
  }
}
