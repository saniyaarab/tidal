import 'package:equatable/equatable.dart';
import 'package:tidal_client/tidal_client.dart';

sealed class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object?> get props => [];
}

/// The Calendar was opened: load today's month and day.
class CalendarStarted extends CalendarEvent {
  const CalendarStarted();
}

/// The previous (-1) or next (+1) month arrow was tapped.
class CalendarMonthChanged extends CalendarEvent {
  final int delta;
  const CalendarMonthChanged(this.delta);

  @override
  List<Object?> get props => [delta];
}

/// A day in the grid was tapped.
class CalendarDateSelected extends CalendarEvent {
  final DateTime date;
  const CalendarDateSelected(this.date);

  @override
  List<Object?> get props => [date];
}

/// Home asked the Calendar to show [date]: jump to its month and select it.
class CalendarDateRequested extends CalendarEvent {
  final DateTime date;
  const CalendarDateRequested(this.date);

  @override
  List<Object?> get props => [date];
}

/// Pull-to-refresh.
class CalendarRefreshed extends CalendarEvent {
  const CalendarRefreshed();
}

/// The log screen was closed after something was saved.
class CalendarReturnedFromLog extends CalendarEvent {
  const CalendarReturnedFromLog();
}

/// Changes to periods. They share one base type so they run one at a time:
/// two quick presses must not interleave their server writes.
sealed class CalendarPeriodEdit extends CalendarEvent {
  const CalendarPeriodEdit();
}

/// A day in the grid was long-pressed: start, end, move or remove a period.
class CalendarDayLongPressed extends CalendarPeriodEdit {
  final DateTime date;
  const CalendarDayLongPressed(this.date);

  @override
  List<Object?> get props => [date];
}

/// Undo was tapped on a period-change message.
class CalendarUndoPressed extends CalendarPeriodEdit {
  final PeriodChange change;
  const CalendarUndoPressed(this.change);

  @override
  List<Object?> get props => [change];
}
