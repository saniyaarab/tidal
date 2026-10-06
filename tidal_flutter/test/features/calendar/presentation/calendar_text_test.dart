import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/calendar/domain/period_message.dart';
import 'package:tidal_flutter/features/calendar/presentation/calendar_text.dart';

import '../../home/fakes/builders.dart';

// Pins the wording users see, so a change to it is deliberate.
void main() {
  String textFor(PeriodChangeKind kind, int days) => messageText(
    CalendarMessage.fromChange(1, periodChange(kind, days)),
  );

  test('period change messages', () {
    expect(
      textFor(PeriodChangeKind.started, 5),
      'Period started · assumed 5 days',
    );
    expect(textFor(PeriodChangeKind.ended, 4), 'Period ended · 4 days');
    expect(
      textFor(PeriodChangeKind.moved, 6),
      'Period start moved · 6 days',
    );
    expect(textFor(PeriodChangeKind.removed, 0), 'Period removed');
  });

  test('refusal and failure messages', () {
    expect(
      messageText(const CalendarMessage.futureDateRefused(1)),
      "Periods can't be logged for future dates.",
    );
    expect(
      messageText(const CalendarMessage.updateFailed(2, 'offline')),
      'Could not update the period: offline',
    );
  });

  test('day area strings', () {
    expect(loadErrorText('offline'), 'Could not load this day: offline');
    expect(emptyDayText, 'Nothing logged for this day.');
  });
}
