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

/// A snapshot of where the signed-in user is in their cycle, and where
/// their next period is predicted to start. Not persisted — recomputed from
/// `DayLog` flow entries on every request, so edits to past days are always
/// reflected immediately.
abstract class Prediction
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Prediction._({
    this.lastPeriodStart,
    this.currentCycleDay,
    this.nextPeriodStart,
    int? confidenceDays,
    this.predictedPeriodEnd,
    this.fertileWindowStart,
    this.fertileWindowEnd,
  }) : confidenceDays = confidenceDays ?? 0;

  factory Prediction({
    DateTime? lastPeriodStart,
    int? currentCycleDay,
    DateTime? nextPeriodStart,
    int? confidenceDays,
    DateTime? predictedPeriodEnd,
    DateTime? fertileWindowStart,
    DateTime? fertileWindowEnd,
  }) = _PredictionImpl;

  factory Prediction.fromJson(Map<String, dynamic> jsonSerialization) {
    return Prediction(
      lastPeriodStart: jsonSerialization['lastPeriodStart'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastPeriodStart'],
            ),
      currentCycleDay: jsonSerialization['currentCycleDay'] as int?,
      nextPeriodStart: jsonSerialization['nextPeriodStart'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['nextPeriodStart'],
            ),
      confidenceDays: jsonSerialization['confidenceDays'] as int?,
      predictedPeriodEnd: jsonSerialization['predictedPeriodEnd'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['predictedPeriodEnd'],
            ),
      fertileWindowStart: jsonSerialization['fertileWindowStart'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['fertileWindowStart'],
            ),
      fertileWindowEnd: jsonSerialization['fertileWindowEnd'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['fertileWindowEnd'],
            ),
    );
  }

  /// The most recent day flow changed from none to light/medium/heavy.
  /// Null if no period has ever been logged.
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

  /// Last day of the predicted period, from the user's CycleSettings
  /// (defaults to 5 days). Null whenever nextPeriodStart is null.
  DateTime? predictedPeriodEnd;

  /// Estimated fertile window (ovulation around 14 days before the next
  /// period, plus the days sperm can survive before it). Null whenever
  /// nextPeriodStart is null.
  DateTime? fertileWindowStart;

  DateTime? fertileWindowEnd;

  /// Returns a shallow copy of this [Prediction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Prediction copyWith({
    DateTime? lastPeriodStart,
    int? currentCycleDay,
    DateTime? nextPeriodStart,
    int? confidenceDays,
    DateTime? predictedPeriodEnd,
    DateTime? fertileWindowStart,
    DateTime? fertileWindowEnd,
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
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  }) : super._(
         lastPeriodStart: lastPeriodStart,
         currentCycleDay: currentCycleDay,
         nextPeriodStart: nextPeriodStart,
         confidenceDays: confidenceDays,
         predictedPeriodEnd: predictedPeriodEnd,
         fertileWindowStart: fertileWindowStart,
         fertileWindowEnd: fertileWindowEnd,
       );

  /// Returns a shallow copy of this [Prediction]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Prediction copyWith({
    Object? lastPeriodStart = _Undefined,
    Object? currentCycleDay = _Undefined,
    Object? nextPeriodStart = _Undefined,
    int? confidenceDays,
    Object? predictedPeriodEnd = _Undefined,
    Object? fertileWindowStart = _Undefined,
    Object? fertileWindowEnd = _Undefined,
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
    );
  }
}
