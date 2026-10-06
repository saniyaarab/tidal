import 'package:tidal_client/tidal_client.dart';

import '../../../log_labels.dart';
import '../domain/cycle_outlook.dart';
import '../domain/day_status.dart';

// The wording Home shows. The domain rules produce values; turning them into
// text happens only here, so this is the one place to localize later.

/// The text inside the day circle, e.g. "Period · Day 2\nHeavy",
/// "Light flow" (flow logged outside a period), or "No period".
String dayStatusText(DayStatus status) {
  final flowLogged = status.flow != FlowLevel.none;
  final day = status.periodDayNumber;
  if (day != null) {
    return flowLogged
        ? 'Period · Day $day\n${status.flow.label}'
        : 'Period · Day $day';
  }
  return flowLogged ? '${status.flow.label} flow' : 'No period';
}

/// "Cycle day 5".
String cycleTitleText(CycleOutlook outlook) => 'Cycle day ${outlook.cycleDay}';

/// "Next period in 23 days (±3)", or null when there is no estimate.
String? cycleSubtitleText(CycleOutlook outlook) {
  final days = outlook.daysUntilNextPeriod;
  if (days == null) return null;
  return outlook.isDueNow
      ? 'Next period expected any day now'
      : 'Next period in $days days (±${outlook.confidenceDays})';
}
