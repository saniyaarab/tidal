import 'package:tidal_client/tidal_client.dart';

import 'calendar_data.dart';

/// Where the Calendar gets its data. The real implementation talks to the
/// server; tests use a fake. Every call is scoped to the signed-in user.
abstract class CalendarRepository {
  /// Everything the screen shows for [month] (the first of the month) with
  /// [selectedDate] selected. Throws if any part can't be loaded.
  Future<CalendarData> load(DateTime month, DateTime selectedDate);

  /// Long-press on [date]: starts, ends, moves or removes a period (the
  /// rules live in the server's `PeriodEndpoint.longPress`).
  Future<PeriodChange> longPress(DateTime date);

  /// Reverses [change].
  Future<void> undo(PeriodChange change);

  /// Deletes [dose]. Returns the deleted dose (for Undo), or null if it was
  /// already gone.
  Future<DoseLog?> deleteDose(DoseLog dose);

  /// Puts back a dose returned by [deleteDose] (Undo).
  Future<void> restoreDose(DoseLog dose);
}
