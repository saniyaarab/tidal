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
import '../log/flow_level.dart' as _iewtcc21;
import '../log/mood.dart' as _i64v955q;

/// One user's log for a single calendar day: period flow, mood, and a note.
/// There is at most one DayLog per user per date (see the unique index below).
abstract class DayLog
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DayLog._({
    this.id,
    required this.userId,
    required this.date,
    _iewtcc21.FlowLevel? flow,
    this.mood,
    this.note,
  }) : flow = flow ?? _iewtcc21.FlowLevel.none;

  factory DayLog({
    int? id,
    required _isc.UuidValue userId,
    required DateTime date,
    _iewtcc21.FlowLevel? flow,
    _i64v955q.Mood? mood,
    String? note,
  }) = _DayLogImpl;

  factory DayLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DayLog(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      flow: jsonSerialization['flow'] == null
          ? null
          : _iewtcc21.FlowLevel.fromJson((jsonSerialization['flow'] as String)),
      mood: jsonSerialization['mood'] == null
          ? null
          : _i64v955q.Mood.fromJson((jsonSerialization['mood'] as String)),
      note: jsonSerialization['note'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user this log belongs to.
  _isc.UuidValue userId;

  /// The calendar day this log is for, stored as midnight UTC of that day.
  DateTime date;

  /// Period flow for the day. Defaults to `none` (no period logged).
  _iewtcc21.FlowLevel flow;

  /// Mood for the day, if logged.
  _i64v955q.Mood? mood;

  /// Freeform note, if the user wrote one.
  String? note;

  /// Returns a shallow copy of this [DayLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DayLog copyWith({
    int? id,
    _isc.UuidValue? userId,
    DateTime? date,
    _iewtcc21.FlowLevel? flow,
    _i64v955q.Mood? mood,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DayLog',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'date': date.toJson(),
      'flow': flow.toJson(),
      if (mood != null) 'mood': mood?.toJson(),
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DayLog',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'date': date.toJson(),
      'flow': flow.toJson(),
      if (mood != null) 'mood': mood?.toJson(),
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DayLogImpl extends DayLog {
  _DayLogImpl({
    int? id,
    required _isc.UuidValue userId,
    required DateTime date,
    _iewtcc21.FlowLevel? flow,
    _i64v955q.Mood? mood,
    String? note,
  }) : super._(
         id: id,
         userId: userId,
         date: date,
         flow: flow,
         mood: mood,
         note: note,
       );

  /// Returns a shallow copy of this [DayLog]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DayLog copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? date,
    _iewtcc21.FlowLevel? flow,
    Object? mood = _Undefined,
    Object? note = _Undefined,
  }) {
    return DayLog(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      flow: flow ?? this.flow,
      mood: mood is _i64v955q.Mood? ? mood : this.mood,
      note: note is String? ? note : this.note,
    );
  }
}
