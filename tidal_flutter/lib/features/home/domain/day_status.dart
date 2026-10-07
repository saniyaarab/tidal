import 'package:tidal_client/tidal_client.dart';

/// What the cycle prediction says about a day that isn't a logged period day.
enum DayForecast {
  /// Nothing predicted for this day.
  none,

  /// Inside the predicted next period.
  expectedPeriod,

  /// Inside the predicted fertile window.
  fertileWindow,

  /// In the days just before the predicted next period, when PMS is likely.
  pms,
}

/// What kind of day it is, in terms of the period and flow: whether it falls
/// in a period (and which day of it), the flow logged, and what the
/// prediction says about it. Holds values, not text, so wording can change
/// (or be localized) without touching the rule.
class DayStatus {
  /// 1-based day within the period, or null when the day is outside one.
  final int? periodDayNumber;
  final FlowLevel flow;

  /// What the prediction says about the day. Always [DayForecast.none] on a
  /// logged period day: what happened beats what was predicted.
  final DayForecast forecast;

  const DayStatus({
    required this.periodDayNumber,
    required this.flow,
    this.forecast = DayForecast.none,
  });

  bool get isPeriodDay => periodDayNumber != null;
}

/// Works out the [DayStatus] of [date] from the period it falls in (if any),
/// the day's log (if any) and the cycle prediction (if loaded).
DayStatus buildDayStatus({
  required DateTime date,
  required PeriodSpan? period,
  required DayLog? dayLog,
  Prediction? prediction,
}) {
  return DayStatus(
    periodDayNumber: period == null
        ? null
        : date.difference(period.startDate).inDays + 1,
    flow: dayLog?.flow ?? FlowLevel.none,
    forecast: period == null
        ? _forecastFor(date, prediction)
        : DayForecast.none,
  );
}

// PMS symptoms usually show up in the week before a period.
const _pmsDays = 7;

/// Whether [date] falls in the predicted period, the fertile window, or the
/// PMS days just before the predicted period.
DayForecast _forecastFor(DateTime date, Prediction? prediction) {
  if (prediction == null) return DayForecast.none;
  if (_isBetween(
    date,
    prediction.nextPeriodStart,
    prediction.predictedPeriodEnd,
  )) {
    return DayForecast.expectedPeriod;
  }
  if (_isBetween(
    date,
    prediction.fertileWindowStart,
    prediction.fertileWindowEnd,
  )) {
    return DayForecast.fertileWindow;
  }
  final nextStart = prediction.nextPeriodStart;
  if (nextStart != null &&
      _isBetween(
        date,
        nextStart.subtract(const Duration(days: _pmsDays)),
        nextStart.subtract(const Duration(days: 1)),
      )) {
    return DayForecast.pms;
  }
  return DayForecast.none;
}

/// Whether [date] is on or between [start] and [end] (false if either is
/// unknown).
bool _isBetween(DateTime date, DateTime? start, DateTime? end) =>
    start != null && end != null && !date.isBefore(start) && !date.isAfter(end);
