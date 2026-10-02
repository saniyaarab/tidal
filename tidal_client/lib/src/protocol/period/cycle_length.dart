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

/// One measured cycle: the days from one period's start to the next.
abstract class CycleLength
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CycleLength._({
    required this.startDate,
    required this.days,
    required this.periodDays,
    required this.excludedFromAverage,
  });

  factory CycleLength({
    required DateTime startDate,
    required int days,
    required int periodDays,
    required bool excludedFromAverage,
  }) = _CycleLengthImpl;

  factory CycleLength.fromJson(Map<String, dynamic> jsonSerialization) {
    return CycleLength(
      startDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      days: jsonSerialization['days'] as int,
      periodDays: jsonSerialization['periodDays'] as int,
      excludedFromAverage: _isc.BoolJsonExtension.fromJson(
        jsonSerialization['excludedFromAverage'],
      ),
    );
  }

  /// Start date of the period that began this cycle.
  DateTime startDate;

  /// Days until the next period started.
  int days;

  /// How many days that period lasted (its confirmed length, or the
  /// default period length if its end was never confirmed).
  int periodDays;

  /// True for cycles shorter than 18 or longer than 45 days (e.g. a
  /// forgotten or missed period). They're still shown, with an asterisk
  /// ("53*"), but left out of the average.
  bool excludedFromAverage;

  /// Returns a shallow copy of this [CycleLength]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CycleLength copyWith({
    DateTime? startDate,
    int? days,
    int? periodDays,
    bool? excludedFromAverage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CycleLength',
      'startDate': startDate.toJson(),
      'days': days,
      'periodDays': periodDays,
      'excludedFromAverage': excludedFromAverage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CycleLength',
      'startDate': startDate.toJson(),
      'days': days,
      'periodDays': periodDays,
      'excludedFromAverage': excludedFromAverage,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CycleLengthImpl extends CycleLength {
  _CycleLengthImpl({
    required DateTime startDate,
    required int days,
    required int periodDays,
    required bool excludedFromAverage,
  }) : super._(
         startDate: startDate,
         days: days,
         periodDays: periodDays,
         excludedFromAverage: excludedFromAverage,
       );

  /// Returns a shallow copy of this [CycleLength]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CycleLength copyWith({
    DateTime? startDate,
    int? days,
    int? periodDays,
    bool? excludedFromAverage,
  }) {
    return CycleLength(
      startDate: startDate ?? this.startDate,
      days: days ?? this.days,
      periodDays: periodDays ?? this.periodDays,
      excludedFromAverage: excludedFromAverage ?? this.excludedFromAverage,
    );
  }
}
