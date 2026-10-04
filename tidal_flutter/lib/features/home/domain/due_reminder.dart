import 'package:equatable/equatable.dart';

/// A medication reminder that is due now, ready to show as a banner
/// ("Ibuprofen due now"). Pairs the reminder with its medication's name.
class DueReminder extends Equatable {
  /// Shown when the medication is no longer in the user's list.
  static const unknownMedicationName = 'Medication';

  final int reminderId;
  final int medicationId;
  final String medicationName;

  const DueReminder({
    required this.reminderId,
    required this.medicationId,
    required this.medicationName,
  });

  @override
  List<Object?> get props => [reminderId, medicationId, medicationName];
}
