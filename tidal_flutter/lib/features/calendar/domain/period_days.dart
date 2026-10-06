import 'package:tidal_client/tidal_client.dart';

/// Every day from each period's start through its (confirmed or assumed)
/// end, inclusive.
Set<DateTime> expandPeriodDays(List<PeriodSpan> periods) => {
  for (final period in periods)
    for (
      var day = period.startDate;
      !day.isAfter(period.endDate);
      day = day.add(const Duration(days: 1))
    )
      day,
};
