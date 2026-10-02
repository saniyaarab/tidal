import 'package:flutter/material.dart';

import '../date_format.dart';
import '../theme.dart';

/// The day and time something happened, as picked in a [WhenPicker].
class LogMoment {
  /// The calendar day it belongs to, as a UTC-midnight date key (how dates
  /// are stored on the server).
  final DateTime day;

  /// When it happened, in local time.
  final DateTime time;

  const LogMoment(this.day, this.time);

  /// Starts on [day] at the current time of day (hours, minutes, seconds).
  factory LogMoment.nowOn(DateTime day) {
    final now = DateTime.now();
    return LogMoment(
      day,
      DateTime(day.year, day.month, day.day, now.hour, now.minute, now.second),
    );
  }

  bool get isInFuture => time.isAfter(DateTime.now());
}

/// A tappable "Wed 1 Oct · 14:32" row used by the Pain and Medications
/// sheets. Tapping it lets the user change the day, then the time — useful
/// when logging something after the fact. Future days can't be picked.
class WhenPicker extends StatelessWidget {
  final LogMoment value;
  final ValueChanged<LogMoment> onChanged;

  const WhenPicker({super.key, required this.value, required this.onChanged});

  Future<void> _pick(BuildContext context) async {
    final today = todayAsDateKey();
    final pickedDay = await showDatePicker(
      context: context,
      initialDate: value.day,
      firstDate: today.subtract(const Duration(days: 365)),
      lastDate: today,
    );
    if (pickedDay == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value.time),
    );
    if (!context.mounted) return;

    final day = DateTime.utc(pickedDay.year, pickedDay.month, pickedDay.day);
    // Keep the original seconds unless the user picked a different time.
    final time = pickedTime == null
        ? DateTime(
            day.year,
            day.month,
            day.day,
            value.time.hour,
            value.time.minute,
            value.time.second,
          )
        : DateTime(
            day.year,
            day.month,
            day.day,
            pickedTime.hour,
            pickedTime.minute,
          );
    onChanged(LogMoment(day, time));
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _pick(context),
      borderRadius: BorderRadius.circular(TidalRadius.small),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TidalRadius.small),
          border: Border.all(color: TidalColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.schedule,
              size: 18,
              color: TidalColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              '${formatDayLabel(value.day)} · ${formatClockTime(value.time)}',
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.edit_outlined,
              size: 16,
              color: TidalColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
