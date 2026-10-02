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
import '../log/love_type.dart' as _i32gka0x;
import '../log/mood.dart' as _i64v955q;
import '../log/mucus_type.dart' as _irc759lm;
import '../log/severity.dart' as _iqyt4ohq;

/// One user's log for a single calendar day: flow, mood, note, and the
/// other once-a-day details (drinks, sleep, digestion, body, love).
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
    int? waterGlasses,
    int? caffeineDrinks,
    int? alcoholDrinks,
    this.sleepQuality,
    this.sleepHours,
    this.bloating,
    this.acidReflux,
    this.weightKg,
    this.temperatureC,
    this.mucus,
    this.love,
  }) : flow = flow ?? _iewtcc21.FlowLevel.none,
       waterGlasses = waterGlasses ?? 0,
       caffeineDrinks = caffeineDrinks ?? 0,
       alcoholDrinks = alcoholDrinks ?? 0;

  factory DayLog({
    int? id,
    required _isc.UuidValue userId,
    required DateTime date,
    _iewtcc21.FlowLevel? flow,
    _i64v955q.Mood? mood,
    String? note,
    int? waterGlasses,
    int? caffeineDrinks,
    int? alcoholDrinks,
    int? sleepQuality,
    double? sleepHours,
    _iqyt4ohq.Severity? bloating,
    _iqyt4ohq.Severity? acidReflux,
    double? weightKg,
    double? temperatureC,
    _irc759lm.MucusType? mucus,
    _i32gka0x.LoveType? love,
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
      waterGlasses: jsonSerialization['waterGlasses'] as int?,
      caffeineDrinks: jsonSerialization['caffeineDrinks'] as int?,
      alcoholDrinks: jsonSerialization['alcoholDrinks'] as int?,
      sleepQuality: jsonSerialization['sleepQuality'] as int?,
      sleepHours: (jsonSerialization['sleepHours'] as num?)?.toDouble(),
      bloating: jsonSerialization['bloating'] == null
          ? null
          : _iqyt4ohq.Severity.fromJson(
              (jsonSerialization['bloating'] as String),
            ),
      acidReflux: jsonSerialization['acidReflux'] == null
          ? null
          : _iqyt4ohq.Severity.fromJson(
              (jsonSerialization['acidReflux'] as String),
            ),
      weightKg: (jsonSerialization['weightKg'] as num?)?.toDouble(),
      temperatureC: (jsonSerialization['temperatureC'] as num?)?.toDouble(),
      mucus: jsonSerialization['mucus'] == null
          ? null
          : _irc759lm.MucusType.fromJson(
              (jsonSerialization['mucus'] as String),
            ),
      love: jsonSerialization['love'] == null
          ? null
          : _i32gka0x.LoveType.fromJson((jsonSerialization['love'] as String)),
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

  /// Glasses of water (250 ml each). 0 when not logged.
  int waterGlasses;

  /// Caffeinated drinks (coffee, tea, energy drinks). 0 when not logged.
  int caffeineDrinks;

  /// Alcoholic drinks. 0 when not logged.
  int alcoholDrinks;

  /// Sleep quality for the night before, 1 (poor) to 5 (great), if logged.
  int? sleepQuality;

  /// Hours slept the night before, if logged.
  double? sleepHours;

  /// How bloated the user felt, if logged.
  _iqyt4ohq.Severity? bloating;

  /// How bad acid reflux was, if logged.
  _iqyt4ohq.Severity? acidReflux;

  /// Weight in kilograms, if logged (shown in the user's chosen unit).
  double? weightKg;

  /// Basal body temperature in °C, if logged (shown in the user's unit).
  double? temperatureC;

  /// Cervical mucus, if logged.
  _irc759lm.MucusType? mucus;

  /// Sex, if logged.
  _i32gka0x.LoveType? love;

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
    int? waterGlasses,
    int? caffeineDrinks,
    int? alcoholDrinks,
    int? sleepQuality,
    double? sleepHours,
    _iqyt4ohq.Severity? bloating,
    _iqyt4ohq.Severity? acidReflux,
    double? weightKg,
    double? temperatureC,
    _irc759lm.MucusType? mucus,
    _i32gka0x.LoveType? love,
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
      'waterGlasses': waterGlasses,
      'caffeineDrinks': caffeineDrinks,
      'alcoholDrinks': alcoholDrinks,
      if (sleepQuality != null) 'sleepQuality': sleepQuality,
      if (sleepHours != null) 'sleepHours': sleepHours,
      if (bloating != null) 'bloating': bloating?.toJson(),
      if (acidReflux != null) 'acidReflux': acidReflux?.toJson(),
      if (weightKg != null) 'weightKg': weightKg,
      if (temperatureC != null) 'temperatureC': temperatureC,
      if (mucus != null) 'mucus': mucus?.toJson(),
      if (love != null) 'love': love?.toJson(),
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
      'waterGlasses': waterGlasses,
      'caffeineDrinks': caffeineDrinks,
      'alcoholDrinks': alcoholDrinks,
      if (sleepQuality != null) 'sleepQuality': sleepQuality,
      if (sleepHours != null) 'sleepHours': sleepHours,
      if (bloating != null) 'bloating': bloating?.toJson(),
      if (acidReflux != null) 'acidReflux': acidReflux?.toJson(),
      if (weightKg != null) 'weightKg': weightKg,
      if (temperatureC != null) 'temperatureC': temperatureC,
      if (mucus != null) 'mucus': mucus?.toJson(),
      if (love != null) 'love': love?.toJson(),
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
    int? waterGlasses,
    int? caffeineDrinks,
    int? alcoholDrinks,
    int? sleepQuality,
    double? sleepHours,
    _iqyt4ohq.Severity? bloating,
    _iqyt4ohq.Severity? acidReflux,
    double? weightKg,
    double? temperatureC,
    _irc759lm.MucusType? mucus,
    _i32gka0x.LoveType? love,
  }) : super._(
         id: id,
         userId: userId,
         date: date,
         flow: flow,
         mood: mood,
         note: note,
         waterGlasses: waterGlasses,
         caffeineDrinks: caffeineDrinks,
         alcoholDrinks: alcoholDrinks,
         sleepQuality: sleepQuality,
         sleepHours: sleepHours,
         bloating: bloating,
         acidReflux: acidReflux,
         weightKg: weightKg,
         temperatureC: temperatureC,
         mucus: mucus,
         love: love,
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
    int? waterGlasses,
    int? caffeineDrinks,
    int? alcoholDrinks,
    Object? sleepQuality = _Undefined,
    Object? sleepHours = _Undefined,
    Object? bloating = _Undefined,
    Object? acidReflux = _Undefined,
    Object? weightKg = _Undefined,
    Object? temperatureC = _Undefined,
    Object? mucus = _Undefined,
    Object? love = _Undefined,
  }) {
    return DayLog(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      flow: flow ?? this.flow,
      mood: mood is _i64v955q.Mood? ? mood : this.mood,
      note: note is String? ? note : this.note,
      waterGlasses: waterGlasses ?? this.waterGlasses,
      caffeineDrinks: caffeineDrinks ?? this.caffeineDrinks,
      alcoholDrinks: alcoholDrinks ?? this.alcoholDrinks,
      sleepQuality: sleepQuality is int? ? sleepQuality : this.sleepQuality,
      sleepHours: sleepHours is double? ? sleepHours : this.sleepHours,
      bloating: bloating is _iqyt4ohq.Severity? ? bloating : this.bloating,
      acidReflux: acidReflux is _iqyt4ohq.Severity?
          ? acidReflux
          : this.acidReflux,
      weightKg: weightKg is double? ? weightKg : this.weightKg,
      temperatureC: temperatureC is double? ? temperatureC : this.temperatureC,
      mucus: mucus is _irc759lm.MucusType? ? mucus : this.mucus,
      love: love is _i32gka0x.LoveType? ? love : this.love,
    );
  }
}
