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

/// A period as the Calendar draws it: always has an end date, even when
/// the user hasn't confirmed one yet (then it's the assumed end). Computed
/// on request, never stored.
abstract class PeriodSpan
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PeriodSpan._({
    required this.periodId,
    required this.startDate,
    required this.endDate,
    required this.endConfirmed,
  });

  factory PeriodSpan({
    required int periodId,
    required DateTime startDate,
    required DateTime endDate,
    required bool endConfirmed,
  }) = _PeriodSpanImpl;

  factory PeriodSpan.fromJson(Map<String, dynamic> jsonSerialization) {
    return PeriodSpan(
      periodId: jsonSerialization['periodId'] as int,
      startDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: _is.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
      endConfirmed: _is.BoolJsonExtension.fromJson(
        jsonSerialization['endConfirmed'],
      ),
    );
  }

  /// Id of the underlying `Period` row.
  int periodId;

  /// First day of the period.
  DateTime startDate;

  /// Last day of the period: the confirmed end date, or the assumed one.
  DateTime endDate;

  /// True when the user set endDate by long-press; false when it's assumed
  /// from the default period length.
  bool endConfirmed;

  /// Returns a shallow copy of this [PeriodSpan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PeriodSpan copyWith({
    int? periodId,
    DateTime? startDate,
    DateTime? endDate,
    bool? endConfirmed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PeriodSpan',
      'periodId': periodId,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'endConfirmed': endConfirmed,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PeriodSpan',
      'periodId': periodId,
      'startDate': startDate.toJson(),
      'endDate': endDate.toJson(),
      'endConfirmed': endConfirmed,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PeriodSpanImpl extends PeriodSpan {
  _PeriodSpanImpl({
    required int periodId,
    required DateTime startDate,
    required DateTime endDate,
    required bool endConfirmed,
  }) : super._(
         periodId: periodId,
         startDate: startDate,
         endDate: endDate,
         endConfirmed: endConfirmed,
       );

  /// Returns a shallow copy of this [PeriodSpan]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PeriodSpan copyWith({
    int? periodId,
    DateTime? startDate,
    DateTime? endDate,
    bool? endConfirmed,
  }) {
    return PeriodSpan(
      periodId: periodId ?? this.periodId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      endConfirmed: endConfirmed ?? this.endConfirmed,
    );
  }
}
