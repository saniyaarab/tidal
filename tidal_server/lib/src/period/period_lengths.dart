import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// How many of the most recent confirmed periods are averaged for the
/// default period length (the same window predictions use for cycles).
const _maxPeriodsToAverage = 6;

/// The user's default period length: the average of their confirmed period
/// lengths (start through confirmed end), always rounded up — e.g. 4, 5, 4
/// averages 4.33, so the default is 5. Until any period has a confirmed
/// end, it's the period length entered at sign-up (5 if never set).
///
/// Assumed periods (no confirmed end) never count, since their length is
/// this default to begin with.
Future<PeriodLengthInfo> computeDefaultPeriodLength(
  Session session,
  UuidValue userId,
) async {
  final confirmed = await Period.db.find(
    session,
    where: (t) => t.userId.equals(userId) & t.endDate.notEquals(null),
    orderBy: (t) => t.startDate.desc(),
    limit: _maxPeriodsToAverage,
  );

  if (confirmed.isEmpty) {
    final settings = await CycleSettings.db.findFirstRow(
      session,
      where: (t) => t.userId.equals(userId),
    );
    return PeriodLengthInfo(
      days: settings?.typicalPeriodDays ?? 5,
      fromPeriods: 0,
    );
  }

  final lengths = [
    for (final period in confirmed)
      period.endDate!.difference(period.startDate).inDays + 1,
  ];
  final average = lengths.reduce((a, b) => a + b) / lengths.length;
  return PeriodLengthInfo(days: average.ceil(), fromPeriods: lengths.length);
}

/// The last day of [period]: its confirmed end date, or, if it has none
/// yet, the day [defaultLength] days after its start (counting the start).
DateTime effectiveEndDate(Period period, int defaultLength) =>
    period.endDate ?? period.startDate.add(Duration(days: defaultLength - 1));
