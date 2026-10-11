import 'package:tidal_client/tidal_client.dart';

import 'day_data.dart';
import 'due_reminder.dart';

/// Where Home gets its data. The real implementation talks to the server;
/// tests use a fake. Every call is scoped to the signed-in user.
abstract class HomeRepository {
  /// The day's log, period, pain entries, bowel movements, doses, the
  /// user's medications and unit preferences. Throws if any of them can't
  /// be loaded.
  Future<DayData> loadDay(DateTime date);

  /// The cycle prediction for today (independent of the selected day).
  Future<Prediction> loadPrediction();

  /// Reminders that are due now, each with its medication's name.
  Future<List<DueReminder>> loadDueReminders();

  /// Logs the reminder's medication as taken at [now]. The server then sets
  /// the next reminder.
  Future<void> logReminderDose(DueReminder reminder, DateTime now);

  Future<void> dismissReminder(DueReminder reminder);

  /// Deletes [dose]. Returns the deleted dose (for Undo), or null if it was
  /// already gone.
  Future<DoseLog?> deleteDose(DoseLog dose);

  /// Puts back a dose returned by [deleteDose] (Undo).
  Future<void> restoreDose(DoseLog dose);
}
