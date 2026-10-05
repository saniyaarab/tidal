import 'package:flutter/material.dart';
import 'package:tidal_client/tidal_client.dart';

import '../../../../date_format.dart';
import '../../domain/calendar_grid.dart';
import '../../domain/day_marks.dart';
import 'day_cell.dart';

/// The Sunday-first, 6-week grid for [month].
class MonthGrid extends StatelessWidget {
  final DateTime month;
  final DateTime selectedDate;
  final DateTime today;
  final Set<DateTime> periodDates;
  final Set<DateTime> painDates;
  final Prediction? prediction;
  final ValueChanged<DateTime> onSelect;
  final ValueChanged<DateTime> onLongPress;

  const MonthGrid({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.today,
    required this.periodDates,
    required this.painDates,
    required this.prediction,
    required this.onSelect,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            for (final label in weekdayHeaderLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final date in CalendarGrid(month).dates)
              DayCell(
                key: ValueKey(date),
                date: date,
                marks: DayMarks.of(
                  date: date,
                  month: month,
                  selectedDate: selectedDate,
                  today: today,
                  periodDates: periodDates,
                  painDates: painDates,
                  prediction: prediction,
                ),
                onTap: () => onSelect(date),
                onLongPress: () => onLongPress(date),
              ),
          ],
        ),
      ],
    );
  }
}
