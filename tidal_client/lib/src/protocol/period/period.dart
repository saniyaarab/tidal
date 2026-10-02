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

/// One period: the days from its start date through its end date.
/// The user sets both by long-pressing days on the Calendar (see
/// `PeriodEndpoint.longPress`). Flow level is recorded separately on
/// `DayLog` and never decides where a period starts or ends.
abstract class Period
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Period._({
    this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
  });

  factory Period({
    int? id,
    required _isc.UuidValue userId,
    required DateTime startDate,
    DateTime? endDate,
  }) = _PeriodImpl;

  factory Period.fromJson(Map<String, dynamic> jsonSerialization) {
    return Period(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      startDate: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user this period belongs to.
  _isc.UuidValue userId;

  /// First day of the period, stored as midnight UTC of that day.
  DateTime startDate;

  /// Last day of the period, once the user has confirmed it by
  /// long-pressing it. Null means "not confirmed yet": the period is then
  /// assumed to last the user's default period length (see
  /// `computeDefaultPeriodLength`).
  DateTime? endDate;

  /// Returns a shallow copy of this [Period]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Period copyWith({
    int? id,
    _isc.UuidValue? userId,
    DateTime? startDate,
    DateTime? endDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Period',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Period',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PeriodImpl extends Period {
  _PeriodImpl({
    int? id,
    required _isc.UuidValue userId,
    required DateTime startDate,
    DateTime? endDate,
  }) : super._(
         id: id,
         userId: userId,
         startDate: startDate,
         endDate: endDate,
       );

  /// Returns a shallow copy of this [Period]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Period copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? startDate,
    Object? endDate = _Undefined,
  }) {
    return Period(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
    );
  }
}
