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

/// The user's own cycle estimates and birth year, collected at sign-up.
/// Cycle/period length seed predictions before enough history has been
/// logged to measure them directly, and size the predicted-period window
/// on the Calendar — neither can be derived from logged flow alone (a
/// light last day and a skipped log day look the same; a brand-new user
/// has no cycle history at all), so the user sets them directly. Birth
/// year lives here too since it's collected on the same sign-up screen,
/// even though it isn't cycle-specific — there's no separate profile
/// table yet.
abstract class CycleSettings
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CycleSettings._({
    this.id,
    required this.userId,
    int? typicalCycleDays,
    int? typicalPeriodDays,
    this.birthYear,
  }) : typicalCycleDays = typicalCycleDays ?? 28,
       typicalPeriodDays = typicalPeriodDays ?? 5;

  factory CycleSettings({
    int? id,
    required _isc.UuidValue userId,
    int? typicalCycleDays,
    int? typicalPeriodDays,
    int? birthYear,
  }) = _CycleSettingsImpl;

  factory CycleSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return CycleSettings(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      typicalCycleDays: jsonSerialization['typicalCycleDays'] as int?,
      typicalPeriodDays: jsonSerialization['typicalPeriodDays'] as int?,
      birthYear: jsonSerialization['birthYear'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user these settings belong to.
  _isc.UuidValue userId;

  /// Typical days between period starts. Seeds `Prediction.nextPeriodStart`
  /// until 2+ periods have been logged, after which the real average of
  /// logged cycles is used instead. Defaults to 28.
  int typicalCycleDays;

  /// Typical period length in days. Defaults to 5 until the user sets it.
  int typicalPeriodDays;

  /// Birth year only, never a full date — the month and day aren't needed
  /// for anything the app does, so they're simply never asked for or
  /// stored. Age is always computed from this on request (see
  /// `InsightEndpoint.getAge`), never stored, so it's never stale. Age
  /// from year alone is off by at most one year.
  int? birthYear;

  /// Returns a shallow copy of this [CycleSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CycleSettings copyWith({
    int? id,
    _isc.UuidValue? userId,
    int? typicalCycleDays,
    int? typicalPeriodDays,
    int? birthYear,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CycleSettings',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'typicalCycleDays': typicalCycleDays,
      'typicalPeriodDays': typicalPeriodDays,
      if (birthYear != null) 'birthYear': birthYear,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CycleSettings',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'typicalCycleDays': typicalCycleDays,
      'typicalPeriodDays': typicalPeriodDays,
      if (birthYear != null) 'birthYear': birthYear,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CycleSettingsImpl extends CycleSettings {
  _CycleSettingsImpl({
    int? id,
    required _isc.UuidValue userId,
    int? typicalCycleDays,
    int? typicalPeriodDays,
    int? birthYear,
  }) : super._(
         id: id,
         userId: userId,
         typicalCycleDays: typicalCycleDays,
         typicalPeriodDays: typicalPeriodDays,
         birthYear: birthYear,
       );

  /// Returns a shallow copy of this [CycleSettings]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CycleSettings copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    int? typicalCycleDays,
    int? typicalPeriodDays,
    Object? birthYear = _Undefined,
  }) {
    return CycleSettings(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      typicalCycleDays: typicalCycleDays ?? this.typicalCycleDays,
      typicalPeriodDays: typicalPeriodDays ?? this.typicalPeriodDays,
      birthYear: birthYear is int? ? birthYear : this.birthYear,
    );
  }
}
