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
import 'package:tidal_server/src/generated/protocol.dart' as _i79c4sn7;
import '../period/cycle_length.dart' as _ingj5vp3;

/// What the Insights tab shows: average cycle and period length, and the
/// recent cycles behind them. Computed on request, never stored.
abstract class CycleSummary
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CycleSummary._({
    required this.averageCycleDays,
    required this.averagePeriodDays,
    required this.periodFromPeriods,
    required this.cycles,
  });

  factory CycleSummary({
    required int averageCycleDays,
    required int averagePeriodDays,
    required int periodFromPeriods,
    required List<_ingj5vp3.CycleLength> cycles,
  }) = _CycleSummaryImpl;

  factory CycleSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return CycleSummary(
      averageCycleDays: jsonSerialization['averageCycleDays'] as int,
      averagePeriodDays: jsonSerialization['averagePeriodDays'] as int,
      periodFromPeriods: jsonSerialization['periodFromPeriods'] as int,
      cycles: _i79c4sn7.Protocol().deserialize<List<_ingj5vp3.CycleLength>>(
        jsonSerialization['cycles'],
      ),
    );
  }

  /// Average days between period starts, from the recent cycles that
  /// count — or the sign-up estimate until there's at least one such cycle.
  int averageCycleDays;

  /// Average period length in days (rounded up), from confirmed periods —
  /// or the sign-up estimate until any period has a confirmed end.
  int averagePeriodDays;

  /// How many confirmed periods averagePeriodDays came from (0 = sign-up
  /// estimate).
  int periodFromPeriods;

  /// The most recent completed cycles (up to 6), oldest first.
  List<_ingj5vp3.CycleLength> cycles;

  /// Returns a shallow copy of this [CycleSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CycleSummary copyWith({
    int? averageCycleDays,
    int? averagePeriodDays,
    int? periodFromPeriods,
    List<_ingj5vp3.CycleLength>? cycles,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CycleSummary',
      'averageCycleDays': averageCycleDays,
      'averagePeriodDays': averagePeriodDays,
      'periodFromPeriods': periodFromPeriods,
      'cycles': cycles.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CycleSummary',
      'averageCycleDays': averageCycleDays,
      'averagePeriodDays': averagePeriodDays,
      'periodFromPeriods': periodFromPeriods,
      'cycles': cycles.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CycleSummaryImpl extends CycleSummary {
  _CycleSummaryImpl({
    required int averageCycleDays,
    required int averagePeriodDays,
    required int periodFromPeriods,
    required List<_ingj5vp3.CycleLength> cycles,
  }) : super._(
         averageCycleDays: averageCycleDays,
         averagePeriodDays: averagePeriodDays,
         periodFromPeriods: periodFromPeriods,
         cycles: cycles,
       );

  /// Returns a shallow copy of this [CycleSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CycleSummary copyWith({
    int? averageCycleDays,
    int? averagePeriodDays,
    int? periodFromPeriods,
    List<_ingj5vp3.CycleLength>? cycles,
  }) {
    return CycleSummary(
      averageCycleDays: averageCycleDays ?? this.averageCycleDays,
      averagePeriodDays: averagePeriodDays ?? this.averagePeriodDays,
      periodFromPeriods: periodFromPeriods ?? this.periodFromPeriods,
      cycles: cycles ?? this.cycles.map((e0) => e0.copyWith()).toList(),
    );
  }
}
