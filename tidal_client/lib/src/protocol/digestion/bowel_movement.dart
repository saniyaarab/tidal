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

/// One bowel movement, typed on the Bristol Stool Scale. A day can have
/// several.
abstract class BowelMovement
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  BowelMovement._({
    this.id,
    required this.userId,
    required this.date,
    required this.timestamp,
    required this.loggedAt,
    required this.bristolType,
  });

  factory BowelMovement({
    int? id,
    required _isc.UuidValue userId,
    required DateTime date,
    required DateTime timestamp,
    required DateTime loggedAt,
    required int bristolType,
  }) = _BowelMovementImpl;

  factory BowelMovement.fromJson(Map<String, dynamic> jsonSerialization) {
    return BowelMovement(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      timestamp: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      loggedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['loggedAt'],
      ),
      bristolType: jsonSerialization['bristolType'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user this entry belongs to.
  _isc.UuidValue userId;

  /// The calendar day it belongs to, stored as midnight UTC.
  DateTime date;

  /// When it happened, as chosen by the user. Never in the future.
  DateTime timestamp;

  /// The exact moment the entry was saved, set by the server.
  DateTime loggedAt;

  /// Bristol Stool Scale type, 1 (hard lumps) to 7 (watery).
  int bristolType;

  /// Returns a shallow copy of this [BowelMovement]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  BowelMovement copyWith({
    int? id,
    _isc.UuidValue? userId,
    DateTime? date,
    DateTime? timestamp,
    DateTime? loggedAt,
    int? bristolType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BowelMovement',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'date': date.toJson(),
      'timestamp': timestamp.toJson(),
      'loggedAt': loggedAt.toJson(),
      'bristolType': bristolType,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BowelMovement',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'date': date.toJson(),
      'timestamp': timestamp.toJson(),
      'loggedAt': loggedAt.toJson(),
      'bristolType': bristolType,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BowelMovementImpl extends BowelMovement {
  _BowelMovementImpl({
    int? id,
    required _isc.UuidValue userId,
    required DateTime date,
    required DateTime timestamp,
    required DateTime loggedAt,
    required int bristolType,
  }) : super._(
         id: id,
         userId: userId,
         date: date,
         timestamp: timestamp,
         loggedAt: loggedAt,
         bristolType: bristolType,
       );

  /// Returns a shallow copy of this [BowelMovement]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  BowelMovement copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? date,
    DateTime? timestamp,
    DateTime? loggedAt,
    int? bristolType,
  }) {
    return BowelMovement(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      timestamp: timestamp ?? this.timestamp,
      loggedAt: loggedAt ?? this.loggedAt,
      bristolType: bristolType ?? this.bristolType,
    );
  }
}
