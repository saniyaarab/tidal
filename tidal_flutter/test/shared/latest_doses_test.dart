import 'package:flutter_test/flutter_test.dart';
import 'package:tidal_flutter/shared/latest_doses.dart';

import '../features/home/fakes/builders.dart';

void main() {
  DateTime at(int hour) => DateTime.utc(2026, 10, 3, hour);

  test('keeps only the latest dose of a medication', () {
    final doses = [
      doseLog(1, 10, at(8)),
      doseLog(2, 10, at(14)),
      doseLog(3, 10, at(11)),
    ];

    expect(latestDosePerMedication(doses).map((d) => d.id), [2]);
  });

  test('two medications give one dose each, earliest first', () {
    final doses = [
      doseLog(1, 10, at(14)),
      doseLog(2, 11, at(9)),
      doseLog(3, 10, at(8)),
    ];

    expect(latestDosePerMedication(doses).map((d) => d.id), [2, 1]);
  });

  test('doses taken at the same moment keep the one saved last', () {
    final doses = [doseLog(5, 10, at(8)), doseLog(4, 10, at(8))];

    expect(latestDosePerMedication(doses).map((d) => d.id), [5]);
  });

  test('no doses give none', () {
    expect(latestDosePerMedication(const []), isEmpty);
  });
}
