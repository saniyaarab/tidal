import 'package:flutter/material.dart';

import '../../../../date_format.dart';
import '../../../../theme.dart';

/// The big lavender circle: the date, prev/next arrows, and the status text.
/// Tapping the circle opens the Calendar on that date.
class DayCircle extends StatelessWidget {
  // Keys let tests find the parts without relying on their text.
  static const circleKey = Key('home-day-circle');
  static const previousKey = Key('home-day-previous');
  static const nextKey = Key('home-day-next');

  final DateTime date;

  /// The line under the date, or null to show the date alone.
  final String? status;
  final VoidCallback onTap;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const DayCircle({
    super.key,
    required this.date,
    required this.status,
    required this.onTap,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ArrowButton(
          key: previousKey,
          icon: Icons.chevron_left,
          onPressed: onPrevious,
        ),
        const SizedBox(width: 12),
        GestureDetector(
          key: circleKey,
          onTap: onTap,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: TidalColors.lavenderCircle,
              border: Border.fromBorderSide(
                BorderSide(color: TidalColors.lavenderRing, width: 8),
              ),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    formatDayLabel(date),
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  if (status != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      status!,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        _ArrowButton(
          key: nextKey,
          icon: Icons.chevron_right,
          onPressed: onNext,
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  const _ArrowButton({super.key, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 44,
      child: IconButton(
        icon: Icon(icon, color: TidalColors.lavender),
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: TidalColors.card,
          side: const BorderSide(color: TidalColors.border),
        ),
      ),
    );
  }
}
