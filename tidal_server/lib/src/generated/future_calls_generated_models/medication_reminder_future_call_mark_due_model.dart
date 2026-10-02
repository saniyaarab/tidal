/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;

abstract class MedicationReminderFutureCallMarkDueModel
    implements _is.SerializableModel, _is.ProtocolSerialization {
  MedicationReminderFutureCallMarkDueModel._({required this.reminderId});

  factory MedicationReminderFutureCallMarkDueModel({required int reminderId}) =
      _MedicationReminderFutureCallMarkDueModelImpl;

  factory MedicationReminderFutureCallMarkDueModel.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return MedicationReminderFutureCallMarkDueModel(
      reminderId: jsonSerialization['reminderId'] as int,
    );
  }

  int reminderId;

  /// Returns a shallow copy of this [MedicationReminderFutureCallMarkDueModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MedicationReminderFutureCallMarkDueModel copyWith({int? reminderId});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MedicationReminderFutureCallMarkDueModel',
      'reminderId': reminderId,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _MedicationReminderFutureCallMarkDueModelImpl
    extends MedicationReminderFutureCallMarkDueModel {
  _MedicationReminderFutureCallMarkDueModelImpl({required int reminderId})
    : super._(reminderId: reminderId);

  /// Returns a shallow copy of this [MedicationReminderFutureCallMarkDueModel]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  MedicationReminderFutureCallMarkDueModel copyWith({int? reminderId}) {
    return MedicationReminderFutureCallMarkDueModel(
      reminderId: reminderId ?? this.reminderId,
    );
  }
}
