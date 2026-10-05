import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_client/tidal_client.dart';
import 'package:tidal_flutter/features/calendar/domain/period_message.dart';

import '../../home/fakes/builders.dart';

void main() {
  const expectedKinds = {
    PeriodChangeKind.started: CalendarMessageKind.periodStarted,
    PeriodChangeKind.ended: CalendarMessageKind.periodEnded,
    PeriodChangeKind.moved: CalendarMessageKind.periodMoved,
    PeriodChangeKind.removed: CalendarMessageKind.periodRemoved,
  };

  for (final entry in expectedKinds.entries) {
    test('${entry.key.name} maps to ${entry.value.name}', () {
      final change = periodChange(entry.key, 4);
      final message = CalendarMessage.fromChange(7, change);
      expect(message.kind, entry.value);
      expect(message.days, 4);
      expect(message.id, 7);
      expect(message.change, same(change));
      expect(message.canUndo, isTrue);
    });
  }

  test('refusal and failure messages offer no Undo', () {
    expect(const CalendarMessage.futureDateRefused(1).canUndo, isFalse);
    final failed = const CalendarMessage.updateFailed(2, 'offline');
    expect(failed.canUndo, isFalse);
    expect(failed.error, 'offline');
  });
}
