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
import '../journal/self_care_activity.dart' as _ilwaelgo;

/// One day of the self-care journal: which activities the user did, and
/// their best moment of the day. At most one per user per date.
abstract class JournalEntry
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  JournalEntry._({
    this.id,
    required this.userId,
    required this.date,
    required this.activities,
    this.bestMoment,
  });

  factory JournalEntry({
    int? id,
    required _isc.UuidValue userId,
    required DateTime date,
    required List<_ilwaelgo.SelfCareActivity> activities,
    String? bestMoment,
  }) = _JournalEntryImpl;

  factory JournalEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return JournalEntry(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      date: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      activities: _ifh54y1n.Protocol()
          .deserialize<List<_ilwaelgo.SelfCareActivity>>(
            jsonSerialization['activities'],
          ),
      bestMoment: jsonSerialization['bestMoment'] as String?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user this entry belongs to.
  _isc.UuidValue userId;

  /// The calendar day this entry is for, stored as midnight UTC (the same
  /// way `DayLog.date` is).
  DateTime date;

  /// The self-care activities ticked for the day.
  List<_ilwaelgo.SelfCareActivity> activities;

  /// Free text for "Best moment of the day", if the user wrote one.
  String? bestMoment;

  /// Returns a shallow copy of this [JournalEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  JournalEntry copyWith({
    int? id,
    _isc.UuidValue? userId,
    DateTime? date,
    List<_ilwaelgo.SelfCareActivity>? activities,
    String? bestMoment,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'JournalEntry',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'date': date.toJson(),
      'activities': activities.toJson(valueToJson: (v) => v.toJson()),
      if (bestMoment != null) 'bestMoment': bestMoment,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'JournalEntry',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'date': date.toJson(),
      'activities': activities.toJson(valueToJson: (v) => v.toJson()),
      if (bestMoment != null) 'bestMoment': bestMoment,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JournalEntryImpl extends JournalEntry {
  _JournalEntryImpl({
    int? id,
    required _isc.UuidValue userId,
    required DateTime date,
    required List<_ilwaelgo.SelfCareActivity> activities,
    String? bestMoment,
  }) : super._(
         id: id,
         userId: userId,
         date: date,
         activities: activities,
         bestMoment: bestMoment,
       );

  /// Returns a shallow copy of this [JournalEntry]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  JournalEntry copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    DateTime? date,
    List<_ilwaelgo.SelfCareActivity>? activities,
    Object? bestMoment = _Undefined,
  }) {
    return JournalEntry(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      activities: activities ?? this.activities.map((e0) => e0).toList(),
      bestMoment: bestMoment is String? ? bestMoment : this.bestMoment,
    );
  }
}
