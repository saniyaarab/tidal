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
import 'package:tidal_server/src/generated/protocol.dart' as _i79c4sn7;
import '../pain/pain_location.dart' as _inz2dpi1;

/// A single pain log: how bad it was, where, and when.
abstract class PainEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  PainEntry._({
    this.id,
    required this.userId,
    required this.date,
    required this.timestamp,
    required this.loggedAt,
    required this.level,
    required this.locations,
  });

  factory PainEntry({
    int? id,
    required _is.UuidValue userId,
    required DateTime date,
    required DateTime timestamp,
    required DateTime loggedAt,
    required int level,
    required List<_inz2dpi1.PainLocation> locations,
  }) = _PainEntryImpl;

  factory PainEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return PainEntry(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      timestamp: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      loggedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['loggedAt'],
      ),
      level: jsonSerialization['level'] as int,
      locations: _i79c4sn7.Protocol().deserialize<List<_inz2dpi1.PainLocation>>(
        jsonSerialization['locations'],
      ),
    );
  }

  static final t = PainEntryTable();

  static const db = PainEntryRepository._();

  @override
  int? id;

  /// The user this entry belongs to.
  _is.UuidValue userId;

  /// The calendar day this entry belongs to, stored as midnight UTC (the
  /// same way `DayLog.date` is). Entries are grouped and looked up by this.
  DateTime date;

  /// When the pain happened, as chosen by the user (defaults to the time
  /// of logging). Never in the future.
  DateTime timestamp;

  /// The exact moment the entry was saved, set by the server. Not shown in
  /// the app.
  DateTime loggedAt;

  /// Pain level from 0 (no pain) to 10 (worst pain).
  int level;

  /// Where the pain was felt. Can be empty if the user didn't say.
  List<_inz2dpi1.PainLocation> locations;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [PainEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PainEntry copyWith({
    int? id,
    _is.UuidValue? userId,
    DateTime? date,
    DateTime? timestamp,
    DateTime? loggedAt,
    int? level,
    List<_inz2dpi1.PainLocation>? locations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PainEntry',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'date': date.toJson(),
      'timestamp': timestamp.toJson(),
      'loggedAt': loggedAt.toJson(),
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
      'date': date.toJson(),
      'timestamp': timestamp.toJson(),
      'loggedAt': loggedAt.toJson(),
      'level': level,
      'locations': locations.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  static PainEntryInclude include() {
    return PainEntryInclude._();
  }

  static PainEntryIncludeList includeList({
    _is.WhereExpressionBuilder<PainEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PainEntryTable>? orderBy,
    _is.OrderByListBuilder<PainEntryTable>? orderByList,
    PainEntryInclude? include,
  }) {
    return PainEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PainEntry.t),
      orderByList: orderByList?.call(PainEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PainEntryImpl extends PainEntry {
  _PainEntryImpl({
    int? id,
    required _is.UuidValue userId,
    required DateTime date,
    required DateTime timestamp,
    required DateTime loggedAt,
    required int level,
    required List<_inz2dpi1.PainLocation> locations,
  }) : super._(
         id: id,
         userId: userId,
         date: date,
         timestamp: timestamp,
         loggedAt: loggedAt,
         level: level,
         locations: locations,
       );

  /// Returns a shallow copy of this [PainEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PainEntry copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    DateTime? date,
    DateTime? timestamp,
    DateTime? loggedAt,
    int? level,
    List<_inz2dpi1.PainLocation>? locations,
  }) {
    return PainEntry(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      timestamp: timestamp ?? this.timestamp,
      loggedAt: loggedAt ?? this.loggedAt,
      level: level ?? this.level,
      locations: locations ?? this.locations.map((e0) => e0).toList(),
    );
  }
}

class PainEntryUpdateTable extends _is.UpdateTable<PainEntryTable> {
  PainEntryUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> date(DateTime value) => _is.ColumnValue(
    table.date,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _is.ColumnValue(
        table.timestamp,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> loggedAt(DateTime value) =>
      _is.ColumnValue(
        table.loggedAt,
        value,
      );

  _is.ColumnValue<int, int> level(int value) => _is.ColumnValue(
    table.level,
    value,
  );

  _is.ColumnValue<List<_inz2dpi1.PainLocation>, List<_inz2dpi1.PainLocation>>
  locations(List<_inz2dpi1.PainLocation> value) => _is.ColumnValue(
    table.locations,
    value,
  );
}

class PainEntryTable extends _is.Table<int?> {
  PainEntryTable({super.tableRelation}) : super(tableName: 'pain_entry') {
    updateTable = PainEntryUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    date = _is.ColumnDateTime(
      'date',
      this,
    );
    timestamp = _is.ColumnDateTime(
      'timestamp',
      this,
    );
    loggedAt = _is.ColumnDateTime(
      'loggedAt',
      this,
    );
    level = _is.ColumnInt(
      'level',
      this,
    );
    locations = _is.ColumnSerializable<List<_inz2dpi1.PainLocation>>(
      'locations',
      this,
    );
  }

  late final PainEntryUpdateTable updateTable;

  /// The user this entry belongs to.
  late final _is.ColumnUuid userId;

  /// The calendar day this entry belongs to, stored as midnight UTC (the
  /// same way `DayLog.date` is). Entries are grouped and looked up by this.
  late final _is.ColumnDateTime date;

  /// When the pain happened, as chosen by the user (defaults to the time
  /// of logging). Never in the future.
  late final _is.ColumnDateTime timestamp;

  /// The exact moment the entry was saved, set by the server. Not shown in
  /// the app.
  late final _is.ColumnDateTime loggedAt;

  /// Pain level from 0 (no pain) to 10 (worst pain).
  late final _is.ColumnInt level;

  /// Where the pain was felt. Can be empty if the user didn't say.
  late final _is.ColumnSerializable<List<_inz2dpi1.PainLocation>> locations;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    date,
    timestamp,
    loggedAt,
    level,
    locations,
  ];
}

class PainEntryInclude extends _is.IncludeObject {
  PainEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => PainEntry.t;
}

class PainEntryIncludeList extends _is.IncludeList {
  PainEntryIncludeList._({
    _is.WhereExpressionBuilder<PainEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PainEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => PainEntry.t;
}

class PainEntryRepository {
  const PainEntryRepository._();

  /// Returns a list of [PainEntry]s matching the given query parameters.
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
  Future<List<PainEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PainEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PainEntryTable>? orderBy,
    _is.OrderByListBuilder<PainEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PainEntry>(
      where: where?.call(PainEntry.t),
      orderBy: orderBy?.call(PainEntry.t),
      orderByList: orderByList?.call(PainEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PainEntry] matching the given query parameters.
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
  Future<PainEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PainEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<PainEntryTable>? orderBy,
    _is.OrderByListBuilder<PainEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PainEntry>(
      where: where?.call(PainEntry.t),
      orderBy: orderBy?.call(PainEntry.t),
      orderByList: orderByList?.call(PainEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PainEntry] by its [id] or null if no such row exists.
  Future<PainEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PainEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PainEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [PainEntry]s will have their `id` fields set.
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
  Future<List<PainEntry>> insert(
    _is.DatabaseSession session,
    List<PainEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PainEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PainEntry] and returns the inserted row.
  ///
  /// The returned [PainEntry] will have its `id` field set.
  Future<PainEntry> insertRow(
    _is.DatabaseSession session,
    PainEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PainEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PainEntry]s in the list and returns the resulting rows.
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
  /// The returned [PainEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PainEntry>> upsert(
    _is.DatabaseSession session,
    List<PainEntry> rows, {
    required _is.ColumnSelections<PainEntryTable> conflictColumns,
    _is.ColumnSelections<PainEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<PainEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PainEntry>(
      rows,
      conflictColumns: conflictColumns(PainEntry.t),
      updateColumns: updateColumns?.call(PainEntry.t),
      updateWhere: updateWhere?.call(PainEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PainEntry] and returns the resulting row.
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
  /// The returned [PainEntry] will have its `id` field set.
  Future<PainEntry?> upsertRow(
    _is.DatabaseSession session,
    PainEntry row, {
    required _is.ColumnSelections<PainEntryTable> conflictColumns,
    _is.ColumnSelections<PainEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<PainEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PainEntry>(
      row,
      conflictColumns: conflictColumns(PainEntry.t),
      updateColumns: updateColumns?.call(PainEntry.t),
      updateWhere: updateWhere?.call(PainEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [PainEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PainEntry>> update(
    _is.DatabaseSession session,
    List<PainEntry> rows, {
    _is.ColumnSelections<PainEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PainEntry>(
      rows,
      columns: columns?.call(PainEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PainEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PainEntry> updateRow(
    _is.DatabaseSession session,
    PainEntry row, {
    _is.ColumnSelections<PainEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PainEntry>(
      row,
      columns: columns?.call(PainEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PainEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PainEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PainEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PainEntry>(
      id,
      columnValues: columnValues(PainEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PainEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PainEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PainEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PainEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PainEntryTable>? orderBy,
    _is.OrderByListBuilder<PainEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PainEntry>(
      columnValues: columnValues(PainEntry.t.updateTable),
      where: where(PainEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PainEntry.t),
      orderByList: orderByList?.call(PainEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PainEntry]s in the list and returns the deleted rows.
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
  Future<List<PainEntry>> delete(
    _is.DatabaseSession session,
    List<PainEntry> rows, {
    _is.OrderByBuilder<PainEntryTable>? orderBy,
    _is.OrderByListBuilder<PainEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PainEntry>(
      rows,
      orderBy: orderBy?.call(PainEntry.t),
      orderByList: orderByList?.call(PainEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PainEntry].
  Future<PainEntry> deleteRow(
    _is.DatabaseSession session,
    PainEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PainEntry>(
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
  Future<List<PainEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PainEntryTable> where,
    _is.OrderByBuilder<PainEntryTable>? orderBy,
    _is.OrderByListBuilder<PainEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PainEntry>(
      where: where(PainEntry.t),
      orderBy: orderBy?.call(PainEntry.t),
      orderByList: orderByList?.call(PainEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PainEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PainEntry>(
      where: where?.call(PainEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PainEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PainEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PainEntry>(
      where: where(PainEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
