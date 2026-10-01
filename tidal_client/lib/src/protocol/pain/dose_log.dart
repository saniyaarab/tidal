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

/// A single one-tap record of a medication dose being taken.
abstract class DoseLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DoseLog._({
    this.id,
    required this.userId,
    required this.medicationId,
    required this.timestamp,
    required this.dose,
    this.painBefore,
    this.painAfter,
    bool? checkInDue,
  }) : checkInDue = checkInDue ?? false;

  factory DoseLog({
    int? id,
    required _isc.UuidValue userId,
    required int medicationId,
    required DateTime timestamp,
    required String dose,
    int? painBefore,
    int? painAfter,
    bool? checkInDue,
  }) = _DoseLogImpl;

  factory DoseLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoseLog(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      medicationId: jsonSerialization['medicationId'] as int,
      timestamp: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      dose: jsonSerialization['dose'] as String,
      painBefore: jsonSerialization['painBefore'] as int?,
      painAfter: jsonSerialization['painAfter'] as int?,
      checkInDue: jsonSerialization['checkInDue'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['checkInDue']),
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

  /// When the dose was taken. Always "now" at the time of logging.
  DateTime timestamp;

  /// Snapshot of the dose taken, e.g. "400 mg" (copied from the
  /// medication's usualDose at the time of logging).
  String dose;

  /// Pain level right before taking the dose, if known.
  int? painBefore;

  /// Pain level at the "did it help?" check-in, once answered.
  int? painAfter;

  /// Set by CheckInFutureCall, 1 hour after the dose (or 30 minutes after
  /// a snooze). True means the check-in is ready to show the user.
  bool checkInDue;

  /// Returns a shallow copy of this [DoseLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DoseLog copyWith({
    int? id,
    _isc.UuidValue? userId,
    int? medicationId,
    DateTime? timestamp,
    String? dose,
    int? painBefore,
    int? painAfter,
    bool? checkInDue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoseLog',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'medicationId': medicationId,
      'timestamp': timestamp.toJson(),
      'dose': dose,
      if (painBefore != null) 'painBefore': painBefore,
      if (painAfter != null) 'painAfter': painAfter,
      'checkInDue': checkInDue,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoseLog',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'medicationId': medicationId,
      'timestamp': timestamp.toJson(),
      'dose': dose,
      if (painBefore != null) 'painBefore': painBefore,
      if (painAfter != null) 'painAfter': painAfter,
      'checkInDue': checkInDue,
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
    required DateTime timestamp,
    required String dose,
    int? painBefore,
    int? painAfter,
    bool? checkInDue,
  }) : super._(
         id: id,
         userId: userId,
         medicationId: medicationId,
         timestamp: timestamp,
         dose: dose,
         painBefore: painBefore,
         painAfter: painAfter,
         checkInDue: checkInDue,
       );

  /// Returns a shallow copy of this [DoseLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DoseLog copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    int? medicationId,
    DateTime? timestamp,
    String? dose,
    Object? painBefore = _Undefined,
    Object? painAfter = _Undefined,
    bool? checkInDue,
  }) {
    return DoseLog(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      medicationId: medicationId ?? this.medicationId,
      timestamp: timestamp ?? this.timestamp,
      dose: dose ?? this.dose,
      painBefore: painBefore is int? ? painBefore : this.painBefore,
      painAfter: painAfter is int? ? painAfter : this.painAfter,
      checkInDue: checkInDue ?? this.checkInDue,
    );
  }
}
