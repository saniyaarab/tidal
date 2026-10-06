/// The dates the month grid shows: a Sunday-first, 6-week (42 day) grid that
/// includes a few days of the neighbouring months.
class CalendarGrid {
  /// The first day of the month (UTC date key).
  final DateTime month;

  const CalendarGrid(this.month);

  /// The last day of [month].
  DateTime get monthEnd => DateTime.utc(month.year, month.month + 1, 0);

  /// The Sunday the grid starts on. `DateTime.weekday` is 1=Mon..7=Sun, so
  /// `% 7` turns Sunday into 0 leading days, Monday into 1, and so on.
  DateTime get gridStart => month.subtract(Duration(days: month.weekday % 7));

  DateTime get gridEnd => gridStart.add(const Duration(days: 41));

  List<DateTime> get dates => [
    for (var i = 0; i < 42; i++) gridStart.add(Duration(days: i)),
  ];
}
