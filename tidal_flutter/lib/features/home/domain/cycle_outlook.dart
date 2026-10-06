import 'package:tidal_client/tidal_client.dart';

/// Where the user is in their cycle today, from the latest [Prediction]:
/// the cycle day and how long until the next period is expected.
class CycleOutlook {
  final int cycleDay;

  /// Days from today to the predicted next period; null if unknown. Zero or
  /// negative means it is due now (or overdue).
  final int? daysUntilNextPeriod;
  final int confidenceDays;

  const CycleOutlook({
    required this.cycleDay,
    required this.daysUntilNextPeriod,
    required this.confidenceDays,
  });

  bool get isDueNow => daysUntilNextPeriod != null && daysUntilNextPeriod! <= 0;
}

/// Builds the [CycleOutlook] for [today], or null when the prediction has no
/// cycle day yet (nothing to show).
CycleOutlook? buildCycleOutlook(Prediction prediction, DateTime today) {
  final cycleDay = prediction.currentCycleDay;
  if (cycleDay == null) return null;
  return CycleOutlook(
    cycleDay: cycleDay,
    daysUntilNextPeriod: prediction.nextPeriodStart?.difference(today).inDays,
    confidenceDays: prediction.confidenceDays,
  );
}
