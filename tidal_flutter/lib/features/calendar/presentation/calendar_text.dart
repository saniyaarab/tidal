import '../domain/period_message.dart';

/// The words the Calendar shows for the values its state holds. This is the
/// place to localize later; the bloc and domain only carry values.

/// The text of a one-time message.
String messageText(CalendarMessage message) => switch (message.kind) {
  CalendarMessageKind.periodStarted =>
    'Period started · assumed ${message.days} days',
  CalendarMessageKind.periodEnded => 'Period ended · ${message.days} days',
  CalendarMessageKind.periodMoved =>
    'Period start moved · ${message.days} days',
  CalendarMessageKind.periodRemoved => 'Period removed',
  CalendarMessageKind.futureDateRefused =>
    "Periods can't be logged for future dates.",
  CalendarMessageKind.updateFailed =>
    'Could not update the period: ${message.error}',
  CalendarMessageKind.doseRemoved => 'Dose removed',
  CalendarMessageKind.doseDeleteFailed =>
    "Couldn't delete the dose: ${message.error}",
  CalendarMessageKind.doseRestoreFailed =>
    "Couldn't restore the dose: ${message.error}",
};

const undoLabel = 'Undo';

String loadErrorText(String error) => 'Could not load this day: $error';

const emptyDayText = 'Nothing logged for this day.';

const legendPeriod = 'Period';
const legendPredicted = 'Predicted';
const legendFertile = 'Fertile window';
