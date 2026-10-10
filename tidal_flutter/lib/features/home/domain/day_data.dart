import 'package:equatable/equatable.dart';
import 'package:tidal_client/tidal_client.dart';

/// Everything Home shows for one day, loaded together: the day log, the
/// period the day falls in (if any), pain entries, bowel movements, the
/// day's medication doses (with the user's medications by id, to name them),
/// and the user's unit preferences.
class DayData extends Equatable {
  final DayLog? dayLog;
  final PeriodSpan? period;
  final List<PainEntry> painEntries;
  final List<BowelMovement> bowelMovements;
  final List<DoseLog> doses;
  final Map<int, Medication> medicationsById;
  final UnitPreferences units;

  const DayData({
    required this.dayLog,
    required this.period,
    required this.painEntries,
    required this.bowelMovements,
    required this.units,
    this.doses = const [],
    this.medicationsById = const {},
  });

  @override
  List<Object?> get props => [
    dayLog,
    period,
    painEntries,
    bowelMovements,
    doses,
    medicationsById,
    units,
  ];
}
