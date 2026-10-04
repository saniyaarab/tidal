import 'package:equatable/equatable.dart';

import '../../domain/due_reminder.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

/// Home was opened: load the day, the prediction and the reminders.
class HomeStarted extends HomeEvent {
  const HomeStarted();
}

/// The previous (-1) or next (+1) arrow was tapped.
class HomeDayChanged extends HomeEvent {
  final int deltaDays;
  const HomeDayChanged(this.deltaDays);

  @override
  List<Object?> get props => [deltaDays];
}

/// Pull-to-refresh: reloads the selected day only.
class HomeRefreshed extends HomeEvent {
  const HomeRefreshed();
}

/// The user came back from the log screen having saved something: reloads
/// the selected day and the reminders.
class HomeReturnedFromLog extends HomeEvent {
  const HomeReturnedFromLog();
}

/// Time to re-check which reminders are due (the server marks them due in
/// the background).
class HomeRemindersChecked extends HomeEvent {
  const HomeRemindersChecked();
}

/// "Log dose" on a reminder banner.
class HomeReminderDoseLogged extends HomeEvent {
  final DueReminder reminder;
  const HomeReminderDoseLogged(this.reminder);

  @override
  List<Object?> get props => [reminder];
}

/// "Dismiss" on a reminder banner.
class HomeReminderDismissed extends HomeEvent {
  final DueReminder reminder;
  const HomeReminderDismissed(this.reminder);

  @override
  List<Object?> get props => [reminder];
}
