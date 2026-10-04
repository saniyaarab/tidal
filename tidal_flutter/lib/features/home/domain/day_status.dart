import 'package:tidal_client/tidal_client.dart';

/// What kind of day it is, in terms of the period and flow: whether it falls
/// in a period (and which day of it), and the flow logged. Holds values, not
/// text, so wording can change (or be localized) without touching the rule.
class DayStatus {
  /// 1-based day within the period, or null when the day is outside one.
  final int? periodDayNumber;
  final FlowLevel flow;

  const DayStatus({required this.periodDayNumber, required this.flow});

  bool get isPeriodDay => periodDayNumber != null;
}

/// Works out the [DayStatus] of [date] from the period it falls in (if any)
/// and the day's log (if any).
DayStatus buildDayStatus({
  required DateTime date,
  required PeriodSpan? period,
  required DayLog? dayLog,
}) {
  return DayStatus(
    periodDayNumber: period == null
        ? null
        : date.difference(period.startDate).inDays + 1,
    flow: dayLog?.flow ?? FlowLevel.none,
  );
}
