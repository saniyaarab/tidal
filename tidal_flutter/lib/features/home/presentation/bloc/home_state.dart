import 'package:equatable/equatable.dart';
import 'package:tidal_client/tidal_client.dart';

import '../../domain/day_data.dart';
import '../../domain/due_reminder.dart';

enum DayLoadStatus { loading, loaded, failed }

/// What Home shows. The three parts load independently: the selected day,
/// the cycle prediction (always about today), and the due reminders.
class HomeState extends Equatable {
  final DateTime selectedDate;
  final DayLoadStatus dayStatus;

  /// The selected day's data; null until the first load succeeds.
  final DayData? day;

  /// Why the day failed to load; set only when [dayStatus] is failed.
  final String? error;

  /// Null until loaded, or if loading it failed (Home just omits the header).
  final Prediction? prediction;

  final List<DueReminder> dueReminders;

  const HomeState({
    required this.selectedDate,
    this.dayStatus = DayLoadStatus.loading,
    this.day,
    this.error,
    this.prediction,
    this.dueReminders = const [],
  });

  HomeState copyWith({
    DateTime? selectedDate,
    DayLoadStatus? dayStatus,
    DayData? Function()? day,
    String? Function()? error,
    Prediction? prediction,
    List<DueReminder>? dueReminders,
  }) {
    return HomeState(
      selectedDate: selectedDate ?? this.selectedDate,
      dayStatus: dayStatus ?? this.dayStatus,
      day: day != null ? day() : this.day,
      error: error != null ? error() : this.error,
      prediction: prediction ?? this.prediction,
      dueReminders: dueReminders ?? this.dueReminders,
    );
  }

  @override
  List<Object?> get props => [
    selectedDate,
    dayStatus,
    day,
    error,
    prediction,
    dueReminders,
  ];
}
