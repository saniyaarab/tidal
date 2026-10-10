import 'package:equatable/equatable.dart';
import 'package:tidal_client/tidal_client.dart';

import '../../domain/period_message.dart';

enum CalendarLoadStatus { loading, loaded, failed }

/// What the Calendar shows. A failed load keeps the previous data, so the
/// grid stays on screen while an error replaces the day's log.
class CalendarState extends Equatable {
  /// The first day of the shown month.
  final DateTime month;
  final DateTime selectedDate;
  final CalendarLoadStatus status;

  /// Why the last load failed; set only when [status] is failed.
  final String? error;

  final Map<DateTime, DayLog> dayLogs;
  final Set<DateTime> periodDates;
  final Set<DateTime> painDates;
  final List<PainEntry> selectedPainEntries;
  final List<BowelMovement> selectedBowelMovements;
  final List<DoseLog> selectedDoses;
  final Map<int, Medication> medicationsById;

  /// Null until the first load succeeds.
  final UnitPreferences? units;
  final Prediction? prediction;

  /// The latest one-time message. It stays here after being shown; the
  /// screen shows each message id once, when it first appears.
  final CalendarMessage? message;

  const CalendarState({
    required this.month,
    required this.selectedDate,
    this.status = CalendarLoadStatus.loading,
    this.error,
    this.dayLogs = const {},
    this.periodDates = const {},
    this.painDates = const {},
    this.selectedPainEntries = const [],
    this.selectedBowelMovements = const [],
    this.selectedDoses = const [],
    this.medicationsById = const {},
    this.units,
    this.prediction,
    this.message,
  });

  DayLog? dayLogFor(DateTime date) => dayLogs[date];

  CalendarState copyWith({
    DateTime? month,
    DateTime? selectedDate,
    CalendarLoadStatus? status,
    String? Function()? error,
    Map<DateTime, DayLog>? dayLogs,
    Set<DateTime>? periodDates,
    Set<DateTime>? painDates,
    List<PainEntry>? selectedPainEntries,
    List<BowelMovement>? selectedBowelMovements,
    List<DoseLog>? selectedDoses,
    Map<int, Medication>? medicationsById,
    UnitPreferences? units,
    Prediction? prediction,
    CalendarMessage? message,
  }) {
    return CalendarState(
      month: month ?? this.month,
      selectedDate: selectedDate ?? this.selectedDate,
      status: status ?? this.status,
      error: error != null ? error() : this.error,
      dayLogs: dayLogs ?? this.dayLogs,
      periodDates: periodDates ?? this.periodDates,
      painDates: painDates ?? this.painDates,
      selectedPainEntries: selectedPainEntries ?? this.selectedPainEntries,
      selectedBowelMovements:
          selectedBowelMovements ?? this.selectedBowelMovements,
      selectedDoses: selectedDoses ?? this.selectedDoses,
      medicationsById: medicationsById ?? this.medicationsById,
      units: units ?? this.units,
      prediction: prediction ?? this.prediction,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    month,
    selectedDate,
    status,
    error,
    dayLogs,
    periodDates,
    painDates,
    selectedPainEntries,
    selectedBowelMovements,
    selectedDoses,
    medicationsById,
    units,
    prediction,
    message,
  ];
}
