import 'package:flutter/material.dart';

import '../../../../date_format.dart';
import '../../../../theme.dart';

/// The month name with previous and next arrows.
class MonthHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const MonthHeader({
    super.key,
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          key: const Key('calendar-previous-month'),
          icon: const Icon(Icons.chevron_left, color: TidalColors.lavender),
          onPressed: onPrevious,
        ),
        Text(
          formatMonthYear(month),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        IconButton(
          key: const Key('calendar-next-month'),
          icon: const Icon(Icons.chevron_right, color: TidalColors.lavender),
          onPressed: onNext,
        ),
      ],
    );
  }
}
