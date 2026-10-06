import 'package:flutter/material.dart';

import '../../../../theme.dart';
import '../calendar_text.dart';

class Legend extends StatelessWidget {
  const Legend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 16,
      runSpacing: 8,
      children: const [
        _LegendItem(ringColor: TidalColors.rose, label: legendPeriod),
        _LegendItem(
          ringColor: Color(0x73B04A68), // rose at ~45% opacity
          label: legendPredicted,
        ),
        _LegendItem(ringColor: TidalColors.lavenderRing, label: legendFertile),
        _LegendItem(dotColor: TidalColors.rose, label: legendPain),
      ],
    );
  }
}

/// One legend entry: either a ringed circle (period/predicted/fertile) or a
/// small filled dot (pain day), followed by its label.
class _LegendItem extends StatelessWidget {
  final Color? ringColor;
  final Color? dotColor;
  final String label;

  const _LegendItem({this.ringColor, this.dotColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: dotColor != null ? 8 : 14,
          height: dotColor != null ? 8 : 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
            border: ringColor != null
                ? Border.all(color: ringColor!, width: 2)
                : null,
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
