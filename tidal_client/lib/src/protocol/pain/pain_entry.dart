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
import 'package:tidal_client/src/protocol/protocol.dart' as _ifh54y1n;
import '../pain/pain_location.dart' as _inz2dpi1;

/// A single pain log: how bad it was, where, and when.
abstract class PainEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PainEntry._({
    this.id,
    required this.userId,
    required this.timestamp,
    required this.level,
    required this.locations,
  });

  factory PainEntry({
    int? id,
    required _isc.UuidValue userId,
    required DateTime timestamp,
    required int level,
    required List<_inz2dpi1.PainLocation> locations,
  }) = _PainEntryImpl;

  factory PainEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return PainEntry(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      timestamp: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      level: jsonSerialization['level'] as int,
      locations: _ifh54y1n.Protocol().deserialize<List<_inz2dpi1.PainLocation>>(
        jsonSerialization['locations'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user this entry belongs to.
  _isc.UuidValue userId;

  /// When the pain was logged. Always "now" at the time of logging.
  DateTime timestamp;

  /// Pain level from 0 (no pain) to 10 (worst pain).
  int level;

  /// Where the pain was felt. Can be empty if the user didn't say.
  List<_inz2dpi1.PainLocation> locations;

  /// Returns a shallow copy of this [PainEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PainEntry copyWith({
    int? id,
    _isc.UuidValue? userId,
    DateTime? timestamp,
    int? level,
    List<_inz2dpi1.PainLocation>? locations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PainEntry',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'timestamp': timestamp.toJson(),
      'level': level,
      'locations': locations.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PainEntry',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'timestamp': timestamp.toJson(),
      'level': level,
      'locations': locations.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PainEntryImpl extends PainEntry {
  _PainEntryImpl({
    int? id,
    required _isc.UuidValue userId,
    required DateTime timestamp,
    required int level,
    required List<_inz2dpi1.PainLocation> locations,
  }) : super._(
         id: id,
         userId: userId,
         timestamp: timestamp,
         level: level,
         locations: locations,
       );

  /// Returns a shallow copy of this [PainEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PainEntry copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? timestamp,
    int? level,
    List<_inz2dpi1.PainLocation>? locations,
  }) {
    return PainEntry(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      timestamp: timestamp ?? this.timestamp,
      level: level ?? this.level,
      locations: locations ?? this.locations.map((e0) => e0).toList(),
    );
  }
}
