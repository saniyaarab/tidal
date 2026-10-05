import 'package:equatable/equatable.dart';
import 'package:tidal_client/tidal_client.dart';

import '../../../date_format.dart';

/// The one ring a day in the grid can have.
enum DayRing { none, period, predicted, fertile, today }

/// What the grid shows for one date.
class DayMarks extends Equatable {
  final bool inCurrentMonth;
  final bool isSelected;
  final bool isToday;
  final bool hasPain;

  /// Logged period beats predicted period beats fertile window beats today;
  /// only one ring is drawn per day. The selected day has none (it is filled
  /// instead).
  final DayRing ring;

  const DayMarks({
    required this.inCurrentMonth,
    required this.isSelected,
    required this.isToday,
    required this.hasPain,
    required this.ring,
  });

  factory DayMarks.of({
    required DateTime date,
    required DateTime month,
    required DateTime selectedDate,
    required DateTime today,
    required Set<DateTime> periodDates,
    required Set<DateTime> painDates,
    required Prediction? prediction,
  }) {
    final isSelected = isSameDay(date, selectedDate);
    final isToday = isSameDay(date, today);

    var ring = DayRing.none;
    if (!isSelected) {
      if (periodDates.contains(date)) {
        ring = DayRing.period;
      } else if (_within(
        date,
        prediction?.nextPeriodStart,
        prediction?.predictedPeriodEnd,
      )) {
        ring = DayRing.predicted;
      } else if (_within(
        date,
        prediction?.fertileWindowStart,
        prediction?.fertileWindowEnd,
      )) {
        ring = DayRing.fertile;
      } else if (isToday) {
        ring = DayRing.today;
      }
    }

    return DayMarks(
      inCurrentMonth: date.month == month.month,
      isSelected: isSelected,
      isToday: isToday,
      hasPain: painDates.contains(date),
      ring: ring,
    );
  }

  @override
  List<Object?> get props => [
    inCurrentMonth,
    isSelected,
    isToday,
    hasPain,
    ring,
  ];
}

/// Whether [date] is between [start] and [end], inclusive. False if either
/// end is unknown.
bool _within(DateTime date, DateTime? start, DateTime? end) {
  if (start == null || end == null) return false;
  return !date.isBefore(start) && !date.isAfter(end);
}
