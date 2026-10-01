const _weekdayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _monthNames = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', //
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];
const _fullMonthNames = [
  'January', 'February', 'March', 'April', 'May', 'June', //
  'July', 'August', 'September', 'October', 'November', 'December',
];

/// The two-letter labels used for the calendar's weekday header, Sunday
/// first (Su, Mo, Tu, We, Th, Fr, Sa).
const weekdayHeaderLabels = ['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'];

/// Formats a date like "Wed 1 Oct". Hand-rolled to avoid pulling in a
/// whole date-formatting package for one line of text.
String formatDayLabel(DateTime date) {
  final weekday = _weekdayNames[date.weekday - 1];
  final month = _monthNames[date.month - 1];
  return '$weekday ${date.day} $month';
}

/// Returns today's date as a UTC midnight timestamp, which is how dates are
/// stored and compared on the server (see `LogEndpoint._dateOnly`).
DateTime todayAsDateKey() {
  final now = DateTime.now();
  return DateTime.utc(now.year, now.month, now.day);
}

/// Formats a month and year, e.g. "October 2026".
String formatMonthYear(DateTime date) {
  return '${_fullMonthNames[date.month - 1]} ${date.year}';
}

/// Midnight UTC on the first day of [date]'s month.
DateTime firstOfMonth(DateTime date) => DateTime.utc(date.year, date.month);

/// [date]'s month, shifted by [months] (negative goes back).
DateTime addMonths(DateTime date, int months) =>
    DateTime.utc(date.year, date.month + months, date.day);

/// Whether [a] and [b] fall on the same calendar day.
bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Formats a timestamp's time of day in the user's local time, e.g. "7:40".
String formatTimeOfDay(DateTime timestamp) {
  final local = timestamp.toLocal();
  return '${local.hour}:${local.minute.toString().padLeft(2, '0')}';
}

/// Formats how long ago [timestamp] was, e.g. "2h ago", "5 min ago",
/// "just now". Hand-rolled for the same reason as [formatDayLabel].
String formatRelativeTime(DateTime timestamp) {
  final elapsed = DateTime.now().toUtc().difference(timestamp.toUtc());
  if (elapsed.inMinutes < 1) return 'just now';
  if (elapsed.inMinutes < 60) return '${elapsed.inMinutes} min ago';
  if (elapsed.inHours < 24) return '${elapsed.inHours}h ago';
  final days = elapsed.inDays;
  return days == 1 ? '1 day ago' : '$days days ago';
}
