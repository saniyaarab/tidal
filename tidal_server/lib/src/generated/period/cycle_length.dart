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

/// One measured cycle: the days from one period's start to the next.
abstract class CycleLength
    implements _is.SerializableModel, _is.ProtocolSerialization {
  CycleLength._({
    required this.startDate,
    required this.days,
    required this.excludedFromAverage,
  });

  factory CycleLength({
    required DateTime startDate,
    required int days,
    required bool excludedFromAverage,
  }) = _CycleLengthImpl;

  factory CycleLength.fromJson(Map<String, dynamic> jsonSerialization) {
    return CycleLength(
      startDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      days: jsonSerialization['days'] as int,
      excludedFromAverage: _is.BoolJsonExtension.fromJson(
        jsonSerialization['excludedFromAverage'],
      ),
    );
  }

  /// Start date of the period that began this cycle.
  DateTime startDate;

  /// Days until the next period started.
  int days;

  /// True for cycles too long to be a normal cycle (e.g. a forgotten or
  /// missed period). They're still shown, with an asterisk ("53*"), but
  /// left out of the average.
  bool excludedFromAverage;

  /// Returns a shallow copy of this [CycleLength]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CycleLength copyWith({
    DateTime? startDate,
    int? days,
    bool? excludedFromAverage,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CycleLength',
      'startDate': startDate.toJson(),
      'days': days,
      'excludedFromAverage': excludedFromAverage,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CycleLength',
      'startDate': startDate.toJson(),
      'days': days,
      'excludedFromAverage': excludedFromAverage,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _CycleLengthImpl extends CycleLength {
  _CycleLengthImpl({
    required DateTime startDate,
    required int days,
    required bool excludedFromAverage,
  }) : super._(
         startDate: startDate,
         days: days,
         excludedFromAverage: excludedFromAverage,
       );

  /// Returns a shallow copy of this [CycleLength]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CycleLength copyWith({
    DateTime? startDate,
    int? days,
    bool? excludedFromAverage,
  }) {
    return CycleLength(
      startDate: startDate ?? this.startDate,
      days: days ?? this.days,
      excludedFromAverage: excludedFromAverage ?? this.excludedFromAverage,
    );
  }
}
