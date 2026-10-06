import 'package:flutter/material.dart';

import '../../../../theme.dart';
import '../../domain/day_marks.dart';

/// One day in the month grid. Draws what [marks] says; holds no rules.
class DayCell extends StatelessWidget {
  final DateTime date;
  final DayMarks marks;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const DayCell({
    super.key,
    required this.date,
    required this.marks,
    required this.onTap,
    required this.onLongPress,
  });

  Border? get _ring => switch (marks.ring) {
    DayRing.none => null,
    DayRing.period => Border.all(color: TidalColors.rose, width: 2),
    DayRing.predicted => Border.all(
      color: TidalColors.rose.withValues(alpha: 0.45),
      width: 2,
    ),
    DayRing.fertile => Border.all(color: TidalColors.lavenderRing, width: 2),
    DayRing.today => Border.all(color: TidalColors.lavender, width: 2),
  };

  @override
  Widget build(BuildContext context) {
    final textColor = marks.inCurrentMonth
        ? TidalColors.text
        : TidalColors.textSecondary;

    return InkWell(
      onTap: onTap,
      onLongPress: onLongPress,
      customBorder: const CircleBorder(),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: marks.isSelected ? TidalColors.lavenderCircle : null,
                border: _ring,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  '${date.day}',
                  style: TextStyle(
                    color: marks.isSelected ? Colors.white : textColor,
                    fontWeight: marks.isToday || marks.isSelected
                        ? FontWeight.w700
                        : FontWeight.w400,
                  ),
                ),
              ),
            ),
            if (marks.hasPain)
              Positioned(
                bottom: 2,
                child: Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: TidalColors.rose,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
