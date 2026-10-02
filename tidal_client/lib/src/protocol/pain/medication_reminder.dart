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

/// The next reminder for one medication: set when a dose is logged (if the
/// medication has `reminderEveryHours`), and marked due by
/// `MedicationReminderFutureCall` when that time comes. Home shows due
/// reminders as a banner. One per medication.
abstract class MedicationReminder
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MedicationReminder._({
    this.id,
    required this.userId,
    required this.medicationId,
    required this.dueAt,
    bool? isDue,
  }) : isDue = isDue ?? false;

  factory MedicationReminder({
    int? id,
    required _isc.UuidValue userId,
    required int medicationId,
    required DateTime dueAt,
    bool? isDue,
  }) = _MedicationReminderImpl;

  factory MedicationReminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return MedicationReminder(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      medicationId: jsonSerialization['medicationId'] as int,
      dueAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      isDue: jsonSerialization['isDue'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isDue']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user this reminder belongs to.
  _isc.UuidValue userId;

  /// Which medication it's for.
  int medicationId;

  /// When the next dose is due.
  DateTime dueAt;

  /// True once dueAt has passed (set by the future call), until the user
  /// logs a dose or dismisses it.
  bool isDue;

  /// Returns a shallow copy of this [MedicationReminder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MedicationReminder copyWith({
    int? id,
    _isc.UuidValue? userId,
    int? medicationId,
    DateTime? dueAt,
    bool? isDue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MedicationReminder',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'medicationId': medicationId,
      'dueAt': dueAt.toJson(),
      'isDue': isDue,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MedicationReminder',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'medicationId': medicationId,
      'dueAt': dueAt.toJson(),
      'isDue': isDue,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MedicationReminderImpl extends MedicationReminder {
  _MedicationReminderImpl({
    int? id,
    required _isc.UuidValue userId,
    required int medicationId,
    required DateTime dueAt,
    bool? isDue,
  }) : super._(
         id: id,
         userId: userId,
         medicationId: medicationId,
         dueAt: dueAt,
         isDue: isDue,
       );

  /// Returns a shallow copy of this [MedicationReminder]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MedicationReminder copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    int? medicationId,
    DateTime? dueAt,
    bool? isDue,
  }) {
    return MedicationReminder(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      medicationId: medicationId ?? this.medicationId,
      dueAt: dueAt ?? this.dueAt,
      isDue: isDue ?? this.isDue,
    );
  }
}
