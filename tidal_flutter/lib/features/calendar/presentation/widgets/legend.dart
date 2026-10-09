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
      ],
    );
  }
}

/// One legend entry: a ringed circle (period/predicted/fertile) followed by
/// its label. Pain days keep their dot in the grid but have no legend entry.
class _LegendItem extends StatelessWidget {
  final Color ringColor;
  final String label;

  const _LegendItem({required this.ringColor, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: ringColor, width: 2),
          ),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
