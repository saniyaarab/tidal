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
import 'package:serverpod/serverpod.dart' as _is;
import '../log/flow_level.dart' as _iewtcc21;
import '../log/love_type.dart' as _i32gka0x;
import '../log/mood.dart' as _i64v955q;
import '../log/mucus_type.dart' as _irc759lm;
import '../log/severity.dart' as _iqyt4ohq;

/// One user's log for a single calendar day: flow, mood, note, and the
/// other once-a-day details (drinks, sleep, digestion, body, love).
/// There is at most one DayLog per user per date (see the unique index below).
abstract class DayLog implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue userId,
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
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
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

  static final t = DayLogTable();

  static const db = DayLogRepository._();

  @override
  int? id;

  /// The user this log belongs to.
  _is.UuidValue userId;

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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DayLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DayLog copyWith({
    int? id,
    _is.UuidValue? userId,
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

  static DayLogInclude include() {
    return DayLogInclude._();
  }

  static DayLogIncludeList includeList({
    _is.WhereExpressionBuilder<DayLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DayLogTable>? orderBy,
    _is.OrderByListBuilder<DayLogTable>? orderByList,
    DayLogInclude? include,
  }) {
    return DayLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DayLog.t),
      orderByList: orderByList?.call(DayLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DayLogImpl extends DayLog {
  _DayLogImpl({
    int? id,
    required _is.UuidValue userId,
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
  @_is.useResult
  @override
  DayLog copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
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

class DayLogUpdateTable extends _is.UpdateTable<DayLogTable> {
  DayLogUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> date(DateTime value) => _is.ColumnValue(
    table.date,
    value,
  );

  _is.ColumnValue<_iewtcc21.FlowLevel, _iewtcc21.FlowLevel> flow(
    _iewtcc21.FlowLevel value,
  ) => _is.ColumnValue(
    table.flow,
    value,
  );

  _is.ColumnValue<_i64v955q.Mood, _i64v955q.Mood> mood(_i64v955q.Mood? value) =>
      _is.ColumnValue(
        table.mood,
        value,
      );

  _is.ColumnValue<String, String> note(String? value) => _is.ColumnValue(
    table.note,
    value,
  );

  _is.ColumnValue<int, int> waterGlasses(int value) => _is.ColumnValue(
    table.waterGlasses,
    value,
  );

  _is.ColumnValue<int, int> caffeineDrinks(int value) => _is.ColumnValue(
    table.caffeineDrinks,
    value,
  );

  _is.ColumnValue<int, int> alcoholDrinks(int value) => _is.ColumnValue(
    table.alcoholDrinks,
    value,
  );

  _is.ColumnValue<int, int> sleepQuality(int? value) => _is.ColumnValue(
    table.sleepQuality,
    value,
  );

  _is.ColumnValue<double, double> sleepHours(double? value) => _is.ColumnValue(
    table.sleepHours,
    value,
  );

  _is.ColumnValue<_iqyt4ohq.Severity, _iqyt4ohq.Severity> bloating(
    _iqyt4ohq.Severity? value,
  ) => _is.ColumnValue(
    table.bloating,
    value,
  );

  _is.ColumnValue<_iqyt4ohq.Severity, _iqyt4ohq.Severity> acidReflux(
    _iqyt4ohq.Severity? value,
  ) => _is.ColumnValue(
    table.acidReflux,
    value,
  );

  _is.ColumnValue<double, double> weightKg(double? value) => _is.ColumnValue(
    table.weightKg,
    value,
  );

  _is.ColumnValue<double, double> temperatureC(double? value) =>
      _is.ColumnValue(
        table.temperatureC,
        value,
      );

  _is.ColumnValue<_irc759lm.MucusType, _irc759lm.MucusType> mucus(
    _irc759lm.MucusType? value,
  ) => _is.ColumnValue(
    table.mucus,
    value,
  );

  _is.ColumnValue<_i32gka0x.LoveType, _i32gka0x.LoveType> love(
    _i32gka0x.LoveType? value,
  ) => _is.ColumnValue(
    table.love,
    value,
  );
}

class DayLogTable extends _is.Table<int?> {
  DayLogTable({super.tableRelation}) : super(tableName: 'day_log') {
    updateTable = DayLogUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    date = _is.ColumnDateTime(
      'date',
      this,
    );
    flow = _is.ColumnEnum(
      'flow',
      this,
      _is.EnumSerialization.byName,
      hasDefault: true,
    );
    mood = _is.ColumnEnum(
      'mood',
      this,
      _is.EnumSerialization.byName,
    );
    note = _is.ColumnString(
      'note',
      this,
    );
    waterGlasses = _is.ColumnInt(
      'waterGlasses',
      this,
      hasDefault: true,
    );
    caffeineDrinks = _is.ColumnInt(
      'caffeineDrinks',
      this,
      hasDefault: true,
    );
    alcoholDrinks = _is.ColumnInt(
      'alcoholDrinks',
      this,
      hasDefault: true,
    );
    sleepQuality = _is.ColumnInt(
      'sleepQuality',
      this,
    );
    sleepHours = _is.ColumnDouble(
      'sleepHours',
      this,
    );
    bloating = _is.ColumnEnum(
      'bloating',
      this,
      _is.EnumSerialization.byName,
    );
    acidReflux = _is.ColumnEnum(
      'acidReflux',
      this,
      _is.EnumSerialization.byName,
    );
    weightKg = _is.ColumnDouble(
      'weightKg',
      this,
    );
    temperatureC = _is.ColumnDouble(
      'temperatureC',
      this,
    );
    mucus = _is.ColumnEnum(
      'mucus',
      this,
      _is.EnumSerialization.byName,
    );
    love = _is.ColumnEnum(
      'love',
      this,
      _is.EnumSerialization.byName,
    );
  }

  late final DayLogUpdateTable updateTable;

  /// The user this log belongs to.
  late final _is.ColumnUuid userId;

  /// The calendar day this log is for, stored as midnight UTC of that day.
  late final _is.ColumnDateTime date;

  /// Period flow for the day. Defaults to `none` (no period logged).
  late final _is.ColumnEnum<_iewtcc21.FlowLevel> flow;

  /// Mood for the day, if logged.
  late final _is.ColumnEnum<_i64v955q.Mood> mood;

  /// Freeform note, if the user wrote one.
  late final _is.ColumnString note;

  /// Glasses of water (250 ml each). 0 when not logged.
  late final _is.ColumnInt waterGlasses;

  /// Caffeinated drinks (coffee, tea, energy drinks). 0 when not logged.
  late final _is.ColumnInt caffeineDrinks;

  /// Alcoholic drinks. 0 when not logged.
  late final _is.ColumnInt alcoholDrinks;

  /// Sleep quality for the night before, 1 (poor) to 5 (great), if logged.
  late final _is.ColumnInt sleepQuality;

  /// Hours slept the night before, if logged.
  late final _is.ColumnDouble sleepHours;

  /// How bloated the user felt, if logged.
  late final _is.ColumnEnum<_iqyt4ohq.Severity> bloating;

  /// How bad acid reflux was, if logged.
  late final _is.ColumnEnum<_iqyt4ohq.Severity> acidReflux;

  /// Weight in kilograms, if logged (shown in the user's chosen unit).
  late final _is.ColumnDouble weightKg;

  /// Basal body temperature in °C, if logged (shown in the user's unit).
  late final _is.ColumnDouble temperatureC;

  /// Cervical mucus, if logged.
  late final _is.ColumnEnum<_irc759lm.MucusType> mucus;

  /// Sex, if logged.
  late final _is.ColumnEnum<_i32gka0x.LoveType> love;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    date,
    flow,
    mood,
    note,
    waterGlasses,
    caffeineDrinks,
    alcoholDrinks,
    sleepQuality,
    sleepHours,
    bloating,
    acidReflux,
    weightKg,
    temperatureC,
    mucus,
    love,
  ];
}

class DayLogInclude extends _is.IncludeObject {
  DayLogInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DayLog.t;
}

class DayLogIncludeList extends _is.IncludeList {
  DayLogIncludeList._({
    _is.WhereExpressionBuilder<DayLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DayLog.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DayLog.t;
}

class DayLogRepository {
  const DayLogRepository._();

  /// Returns a list of [DayLog]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<DayLog>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DayLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DayLogTable>? orderBy,
    _is.OrderByListBuilder<DayLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DayLog>(
      where: where?.call(DayLog.t),
      orderBy: orderBy?.call(DayLog.t),
      orderByList: orderByList?.call(DayLog.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DayLog] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<DayLog?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DayLogTable>? where,
    int? offset,
    _is.OrderByBuilder<DayLogTable>? orderBy,
    _is.OrderByListBuilder<DayLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DayLog>(
      where: where?.call(DayLog.t),
      orderBy: orderBy?.call(DayLog.t),
      orderByList: orderByList?.call(DayLog.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DayLog] by its [id] or null if no such row exists.
  Future<DayLog?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DayLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DayLog]s in the list and returns the inserted rows.
  ///
  /// The returned [DayLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayLog>> insert(
    _is.DatabaseSession session,
    List<DayLog> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DayLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DayLog] and returns the inserted row.
  ///
  /// The returned [DayLog] will have its `id` field set.
  Future<DayLog> insertRow(
    _is.DatabaseSession session,
    DayLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DayLog>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DayLog]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [DayLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayLog>> upsert(
    _is.DatabaseSession session,
    List<DayLog> rows, {
    required _is.ColumnSelections<DayLogTable> conflictColumns,
    _is.ColumnSelections<DayLogTable>? updateColumns,
    _is.WhereExpressionBuilder<DayLogTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DayLog>(
      rows,
      conflictColumns: conflictColumns(DayLog.t),
      updateColumns: updateColumns?.call(DayLog.t),
      updateWhere: updateWhere?.call(DayLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DayLog] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [DayLog] will have its `id` field set.
  Future<DayLog?> upsertRow(
    _is.DatabaseSession session,
    DayLog row, {
    required _is.ColumnSelections<DayLogTable> conflictColumns,
    _is.ColumnSelections<DayLogTable>? updateColumns,
    _is.WhereExpressionBuilder<DayLogTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DayLog>(
      row,
      conflictColumns: conflictColumns(DayLog.t),
      updateColumns: updateColumns?.call(DayLog.t),
      updateWhere: updateWhere?.call(DayLog.t),
      transaction: transaction,
    );
  }

  /// Updates all [DayLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayLog>> update(
    _is.DatabaseSession session,
    List<DayLog> rows, {
    _is.ColumnSelections<DayLogTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DayLog>(
      rows,
      columns: columns?.call(DayLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DayLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DayLog> updateRow(
    _is.DatabaseSession session,
    DayLog row, {
    _is.ColumnSelections<DayLogTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DayLog>(
      row,
      columns: columns?.call(DayLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DayLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DayLog?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DayLogUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DayLog>(
      id,
      columnValues: columnValues(DayLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DayLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayLog>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DayLogUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DayLogTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DayLogTable>? orderBy,
    _is.OrderByListBuilder<DayLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DayLog>(
      columnValues: columnValues(DayLog.t.updateTable),
      where: where(DayLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DayLog.t),
      orderByList: orderByList?.call(DayLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DayLog]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayLog>> delete(
    _is.DatabaseSession session,
    List<DayLog> rows, {
    _is.OrderByBuilder<DayLogTable>? orderBy,
    _is.OrderByListBuilder<DayLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DayLog>(
      rows,
      orderBy: orderBy?.call(DayLog.t),
      orderByList: orderByList?.call(DayLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DayLog].
  Future<DayLog> deleteRow(
    _is.DatabaseSession session,
    DayLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DayLog>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DayLog>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DayLogTable> where,
    _is.OrderByBuilder<DayLogTable>? orderBy,
    _is.OrderByListBuilder<DayLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DayLog>(
      where: where(DayLog.t),
      orderBy: orderBy?.call(DayLog.t),
      orderByList: orderByList?.call(DayLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DayLogTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DayLog>(
      where: where?.call(DayLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DayLog] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DayLogTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DayLog>(
      where: where(DayLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
