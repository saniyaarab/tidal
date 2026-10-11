import 'package:tidal_client/tidal_client.dart';

/// The latest dose of each medication in [doses], earliest first. A dose
/// counts as later if it was taken later; for two taken at the same moment,
/// the one saved last (higher id) wins. Used by Home and the Calendar, which
/// show one band per medication.
List<DoseLog> latestDosePerMedication(List<DoseLog> doses) {
  final latest = <int, DoseLog>{};
  for (final dose in doses) {
    final current = latest[dose.medicationId];
    if (current == null || _isLater(dose, current)) {
      latest[dose.medicationId] = dose;
    }
  }
  return latest.values.toList()
    ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
}

bool _isLater(DoseLog a, DoseLog b) {
  final byTime = a.timestamp.compareTo(b.timestamp);
  return byTime != 0 ? byTime > 0 : (a.id ?? 0) > (b.id ?? 0);
}
