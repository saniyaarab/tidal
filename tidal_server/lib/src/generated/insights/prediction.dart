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

/// A snapshot of where the signed-in user is in their cycle, and where
/// their next period is predicted to start. Not persisted — recomputed from
/// the user's `Period` rows on every request, so changes are always
/// reflected immediately.
abstract class Prediction
    implements _is.SerializableModel, _is.ProtocolSerialization {
  Prediction._({
    this.lastPeriodStart,
    this.currentCycleDay,
    this.nextPeriodStart,
    int? confidenceDays,
    this.predictedPeriodEnd,
    this.fertileWindowStart,
    this.fertileWindowEnd,
    this.recentCycles,
  }) : confidenceDays = confidenceDays ?? 0;

  factory Prediction({
    DateTime? lastPeriodStart,
    int? currentCycleDay,
    DateTime? nextPeriodStart,
    int? confidenceDays,
    DateTime? predictedPeriodEnd,
    DateTime? fertileWindowStart,
    DateTime? fertileWindowEnd,
    List<_ingj5vp3.CycleLength>? recentCycles,
  }) = _PredictionImpl;

  factory Prediction.fromJson(Map<String, dynamic> jsonSerialization) {
    return Prediction(
      lastPeriodStart: jsonSerialization['lastPeriodStart'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPeriodStart'],
            ),
      currentCycleDay: jsonSerialization['currentCycleDay'] as int?,
      nextPeriodStart: jsonSerialization['nextPeriodStart'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextPeriodStart'],
            ),
      confidenceDays: jsonSerialization['confidenceDays'] as int?,
      predictedPeriodEnd: jsonSerialization['predictedPeriodEnd'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['predictedPeriodEnd'],
            ),
      fertileWindowStart: jsonSerialization['fertileWindowStart'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['fertileWindowStart'],
            ),
      fertileWindowEnd: jsonSerialization['fertileWindowEnd'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['fertileWindowEnd'],
            ),
      recentCycles: jsonSerialization['recentCycles'] == null
          ? null
          : _i79c4sn7.Protocol().deserialize<List<_ingj5vp3.CycleLength>>(
              jsonSerialization['recentCycles'],
            ),
    );
  }

  /// Start date of the most recent period. Null if no period has ever
  /// been logged.
  DateTime? lastPeriodStart;

  /// 1-based day count since lastPeriodStart. Null if lastPeriodStart is null.
  int? currentCycleDay;

  /// Predicted start of the next period, from the average of the last 3-6
  /// completed cycle lengths. Null until at least one full cycle (two
  /// period starts) has been logged.
  DateTime? nextPeriodStart;

  /// "± this many days" around nextPeriodStart, from the spread of recent
  /// cycle lengths. 0 whenever nextPeriodStart is null.
  int confidenceDays;

  /// Last day of the predicted period, from the user's default period
  /// length (learned from confirmed periods, else the sign-up value). Null whenever nextPeriodStart is null.
  DateTime? predictedPeriodEnd;

  /// Estimated fertile window (ovulation around 14 days before the next
  /// period, plus the days sperm can survive before it). Null whenever
  /// nextPeriodStart is null.
  DateTime? fertileWindowStart;

  DateTime? fertileWindowEnd;

  /// The most recent completed cycles (up to 6), oldest first, including
  /// any left out of the average for being over 45 days long.
  List<_ingj5vp3.CycleLength>? recentCycles;

  /// Returns a shallow copy of this [Prediction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Prediction copyWith({
    DateTime? lastPeriodStart,
    int? currentCycleDay,
    DateTime? nextPeriodStart,
    int? confidenceDays,
    DateTime? predictedPeriodEnd,
    DateTime? fertileWindowStart,
    DateTime? fertileWindowEnd,
    List<_ingj5vp3.CycleLength>? recentCycles,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Prediction',
      if (lastPeriodStart != null) 'lastPeriodStart': lastPeriodStart?.toJson(),
      if (currentCycleDay != null) 'currentCycleDay': currentCycleDay,
      if (nextPeriodStart != null) 'nextPeriodStart': nextPeriodStart?.toJson(),
      'confidenceDays': confidenceDays,
      if (predictedPeriodEnd != null)
        'predictedPeriodEnd': predictedPeriodEnd?.toJson(),
      if (fertileWindowStart != null)
        'fertileWindowStart': fertileWindowStart?.toJson(),
      if (fertileWindowEnd != null)
        'fertileWindowEnd': fertileWindowEnd?.toJson(),
      if (recentCycles != null)
        'recentCycles': recentCycles?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Prediction',
      if (lastPeriodStart != null) 'lastPeriodStart': lastPeriodStart?.toJson(),
      if (currentCycleDay != null) 'currentCycleDay': currentCycleDay,
      if (nextPeriodStart != null) 'nextPeriodStart': nextPeriodStart?.toJson(),
      'confidenceDays': confidenceDays,
      if (predictedPeriodEnd != null)
        'predictedPeriodEnd': predictedPeriodEnd?.toJson(),
      if (fertileWindowStart != null)
        'fertileWindowStart': fertileWindowStart?.toJson(),
      if (fertileWindowEnd != null)
        'fertileWindowEnd': fertileWindowEnd?.toJson(),
      if (recentCycles != null)
        'recentCycles': recentCycles?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PredictionImpl extends Prediction {
  _PredictionImpl({
    DateTime? lastPeriodStart,
    int? currentCycleDay,
    DateTime? nextPeriodStart,
    int? confidenceDays,
    DateTime? predictedPeriodEnd,
    DateTime? fertileWindowStart,
    DateTime? fertileWindowEnd,
    List<_ingj5vp3.CycleLength>? recentCycles,
  }) : super._(
         lastPeriodStart: lastPeriodStart,
         currentCycleDay: currentCycleDay,
         nextPeriodStart: nextPeriodStart,
         confidenceDays: confidenceDays,
         predictedPeriodEnd: predictedPeriodEnd,
         fertileWindowStart: fertileWindowStart,
         fertileWindowEnd: fertileWindowEnd,
         recentCycles: recentCycles,
       );

  /// Returns a shallow copy of this [Prediction]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Prediction copyWith({
    Object? lastPeriodStart = _Undefined,
    Object? currentCycleDay = _Undefined,
    Object? nextPeriodStart = _Undefined,
    int? confidenceDays,
    Object? predictedPeriodEnd = _Undefined,
    Object? fertileWindowStart = _Undefined,
    Object? fertileWindowEnd = _Undefined,
    Object? recentCycles = _Undefined,
  }) {
    return Prediction(
      lastPeriodStart: lastPeriodStart is DateTime?
          ? lastPeriodStart
          : this.lastPeriodStart,
      currentCycleDay: currentCycleDay is int?
          ? currentCycleDay
          : this.currentCycleDay,
      nextPeriodStart: nextPeriodStart is DateTime?
          ? nextPeriodStart
          : this.nextPeriodStart,
      confidenceDays: confidenceDays ?? this.confidenceDays,
      predictedPeriodEnd: predictedPeriodEnd is DateTime?
          ? predictedPeriodEnd
          : this.predictedPeriodEnd,
      fertileWindowStart: fertileWindowStart is DateTime?
          ? fertileWindowStart
          : this.fertileWindowStart,
      fertileWindowEnd: fertileWindowEnd is DateTime?
          ? fertileWindowEnd
          : this.fertileWindowEnd,
      recentCycles: recentCycles is List<_ingj5vp3.CycleLength>?
          ? recentCycles
          : this.recentCycles?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
