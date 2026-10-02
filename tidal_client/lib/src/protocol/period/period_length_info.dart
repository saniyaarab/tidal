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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

/// The user's current default period length, and where it comes from.
abstract class PeriodLengthInfo
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PeriodLengthInfo._({
    required this.days,
    required this.fromPeriods,
  });

  factory PeriodLengthInfo({
    required int days,
    required int fromPeriods,
  }) = _PeriodLengthInfoImpl;

  factory PeriodLengthInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return PeriodLengthInfo(
      days: jsonSerialization['days'] as int,
      fromPeriods: jsonSerialization['fromPeriods'] as int,
    );
  }

  /// Default period length in days.
  int days;

  /// How many confirmed periods it was averaged from. 0 means none have
  /// a confirmed end yet, so it's the length entered at sign-up.
  int fromPeriods;

  /// Returns a shallow copy of this [PeriodLengthInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PeriodLengthInfo copyWith({
    int? days,
    int? fromPeriods,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PeriodLengthInfo',
      'days': days,
      'fromPeriods': fromPeriods,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PeriodLengthInfo',
      'days': days,
      'fromPeriods': fromPeriods,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _PeriodLengthInfoImpl extends PeriodLengthInfo {
  _PeriodLengthInfoImpl({
    required int days,
    required int fromPeriods,
  }) : super._(
         days: days,
         fromPeriods: fromPeriods,
       );

  /// Returns a shallow copy of this [PeriodLengthInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PeriodLengthInfo copyWith({
    int? days,
    int? fromPeriods,
  }) {
    return PeriodLengthInfo(
      days: days ?? this.days,
      fromPeriods: fromPeriods ?? this.fromPeriods,
    );
  }
}
