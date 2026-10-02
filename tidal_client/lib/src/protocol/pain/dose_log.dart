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

/// A single one-tap record of a medication being taken.
abstract class DoseLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DoseLog._({
    this.id,
    required this.userId,
    required this.medicationId,
    required this.date,
    required this.timestamp,
    required this.loggedAt,
    required this.dose,
  });

  factory DoseLog({
    int? id,
    required _isc.UuidValue userId,
    required int medicationId,
    required DateTime date,
    required DateTime timestamp,
    required DateTime loggedAt,
    required String dose,
  }) = _DoseLogImpl;

  factory DoseLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoseLog(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      medicationId: jsonSerialization['medicationId'] as int,
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      timestamp: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      loggedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['loggedAt'],
      ),
      dose: jsonSerialization['dose'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user this dose log belongs to.
  _isc.UuidValue userId;

  /// Which medication was taken.
  int medicationId;

  /// The calendar day this dose belongs to, stored as midnight UTC (the
  /// same way `DayLog.date` is). Doses are grouped and looked up by this.
  DateTime date;

  /// When the medication was taken, as chosen by the user (defaults to the
  /// time of logging). Never in the future.
  DateTime timestamp;

  /// The exact moment the dose was saved, set by the server. Not shown in
  /// the app.
  DateTime loggedAt;

  /// Snapshot of the dose taken, e.g. "400 mg" (copied from the
  /// medication's usualDose at the time of logging).
  String dose;

  /// Returns a shallow copy of this [DoseLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DoseLog copyWith({
    int? id,
    _isc.UuidValue? userId,
    int? medicationId,
    DateTime? date,
    DateTime? timestamp,
    DateTime? loggedAt,
    String? dose,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoseLog',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'medicationId': medicationId,
      'date': date.toJson(),
      'timestamp': timestamp.toJson(),
      'loggedAt': loggedAt.toJson(),
      'dose': dose,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoseLog',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'medicationId': medicationId,
      'date': date.toJson(),
      'timestamp': timestamp.toJson(),
      'loggedAt': loggedAt.toJson(),
      'dose': dose,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoseLogImpl extends DoseLog {
  _DoseLogImpl({
    int? id,
    required _isc.UuidValue userId,
    required int medicationId,
    required DateTime date,
    required DateTime timestamp,
    required DateTime loggedAt,
    required String dose,
  }) : super._(
         id: id,
         userId: userId,
         medicationId: medicationId,
         date: date,
         timestamp: timestamp,
         loggedAt: loggedAt,
         dose: dose,
       );

  /// Returns a shallow copy of this [DoseLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DoseLog copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    int? medicationId,
    DateTime? date,
    DateTime? timestamp,
    DateTime? loggedAt,
    String? dose,
  }) {
    return DoseLog(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      medicationId: medicationId ?? this.medicationId,
      date: date ?? this.date,
      timestamp: timestamp ?? this.timestamp,
      loggedAt: loggedAt ?? this.loggedAt,
      dose: dose ?? this.dose,
    );
  }
}
