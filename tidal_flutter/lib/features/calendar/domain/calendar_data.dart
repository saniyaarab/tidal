import 'package:equatable/equatable.dart';
import 'package:tidal_client/tidal_client.dart';

/// Everything the Calendar loads in one go for a month and a selected day:
/// the month's day logs and pain entries, the periods covering the grid, the
/// selected day's pain entries and bowel movements, the user's unit
/// preferences and the cycle prediction.
class CalendarData extends Equatable {
  final List<DayLog> monthDayLogs;
  final List<PainEntry> monthPainEntries;

  /// Spans for the whole 6-week grid, with assumed ends already filled in.
  final List<PeriodSpan> periods;
  final List<PainEntry> selectedPainEntries;
  final List<BowelMovement> selectedBowelMovements;
  final UnitPreferences units;
  final Prediction prediction;

  const CalendarData({
    required this.monthDayLogs,
    required this.monthPainEntries,
    required this.periods,
    required this.selectedPainEntries,
    required this.selectedBowelMovements,
    required this.units,
    required this.prediction,
  });

  @override
  List<Object?> get props => [
    monthDayLogs,
    monthPainEntries,
    periods,
    selectedPainEntries,
    selectedBowelMovements,
    units,
    prediction,
  ];
}
