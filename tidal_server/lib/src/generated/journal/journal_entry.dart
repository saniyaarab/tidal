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
import '../journal/self_care_activity.dart' as _ilwaelgo;

/// One day of the self-care journal: which activities the user did, and
/// their best moment of the day. At most one per user per date.
abstract class JournalEntry
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  JournalEntry._({
    this.id,
    required this.userId,
    required this.date,
    required this.activities,
    this.bestMoment,
  });

  factory JournalEntry({
    int? id,
    required _is.UuidValue userId,
    required DateTime date,
    required List<_ilwaelgo.SelfCareActivity> activities,
    String? bestMoment,
  }) = _JournalEntryImpl;

  factory JournalEntry.fromJson(Map<String, dynamic> jsonSerialization) {
    return JournalEntry(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      activities: _i79c4sn7.Protocol()
          .deserialize<List<_ilwaelgo.SelfCareActivity>>(
            jsonSerialization['activities'],
          ),
      bestMoment: jsonSerialization['bestMoment'] as String?,
    );
  }

  static final t = JournalEntryTable();

  static const db = JournalEntryRepository._();

  @override
  int? id;

  /// The user this entry belongs to.
  _is.UuidValue userId;

  /// The calendar day this entry is for, stored as midnight UTC (the same
  /// way `DayLog.date` is).
  DateTime date;

  /// The self-care activities ticked for the day.
  List<_ilwaelgo.SelfCareActivity> activities;

  /// Free text for "Best moment of the day", if the user wrote one.
  String? bestMoment;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [JournalEntry]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  JournalEntry copyWith({
    int? id,
    _is.UuidValue? userId,
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

  static JournalEntryInclude include() {
    return JournalEntryInclude._();
  }

  static JournalEntryIncludeList includeList({
    _is.WhereExpressionBuilder<JournalEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JournalEntryTable>? orderBy,
    _is.OrderByListBuilder<JournalEntryTable>? orderByList,
    JournalEntryInclude? include,
  }) {
    return JournalEntryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JournalEntry.t),
      orderByList: orderByList?.call(JournalEntry.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _JournalEntryImpl extends JournalEntry {
  _JournalEntryImpl({
    int? id,
    required _is.UuidValue userId,
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
  @_is.useResult
  @override
  JournalEntry copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
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

class JournalEntryUpdateTable extends _is.UpdateTable<JournalEntryTable> {
  JournalEntryUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> date(DateTime value) => _is.ColumnValue(
    table.date,
    value,
  );

  _is.ColumnValue<
    List<_ilwaelgo.SelfCareActivity>,
    List<_ilwaelgo.SelfCareActivity>
  >
  activities(List<_ilwaelgo.SelfCareActivity> value) => _is.ColumnValue(
    table.activities,
    value,
  );

  _is.ColumnValue<String, String> bestMoment(String? value) => _is.ColumnValue(
    table.bestMoment,
    value,
  );
}

class JournalEntryTable extends _is.Table<int?> {
  JournalEntryTable({super.tableRelation}) : super(tableName: 'journal_entry') {
    updateTable = JournalEntryUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    date = _is.ColumnDateTime(
      'date',
      this,
    );
    activities = _is.ColumnSerializable<List<_ilwaelgo.SelfCareActivity>>(
      'activities',
      this,
    );
    bestMoment = _is.ColumnString(
      'bestMoment',
      this,
    );
  }

  late final JournalEntryUpdateTable updateTable;

  /// The user this entry belongs to.
  late final _is.ColumnUuid userId;

  /// The calendar day this entry is for, stored as midnight UTC (the same
  /// way `DayLog.date` is).
  late final _is.ColumnDateTime date;

  /// The self-care activities ticked for the day.
  late final _is.ColumnSerializable<List<_ilwaelgo.SelfCareActivity>>
  activities;

  /// Free text for "Best moment of the day", if the user wrote one.
  late final _is.ColumnString bestMoment;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    date,
    activities,
    bestMoment,
  ];
}

class JournalEntryInclude extends _is.IncludeObject {
  JournalEntryInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => JournalEntry.t;
}

class JournalEntryIncludeList extends _is.IncludeList {
  JournalEntryIncludeList._({
    _is.WhereExpressionBuilder<JournalEntryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(JournalEntry.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => JournalEntry.t;
}

class JournalEntryRepository {
  const JournalEntryRepository._();

  /// Returns a list of [JournalEntry]s matching the given query parameters.
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
  Future<List<JournalEntry>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JournalEntryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JournalEntryTable>? orderBy,
    _is.OrderByListBuilder<JournalEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<JournalEntry>(
      where: where?.call(JournalEntry.t),
      orderBy: orderBy?.call(JournalEntry.t),
      orderByList: orderByList?.call(JournalEntry.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [JournalEntry] matching the given query parameters.
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
  Future<JournalEntry?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JournalEntryTable>? where,
    int? offset,
    _is.OrderByBuilder<JournalEntryTable>? orderBy,
    _is.OrderByListBuilder<JournalEntryTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<JournalEntry>(
      where: where?.call(JournalEntry.t),
      orderBy: orderBy?.call(JournalEntry.t),
      orderByList: orderByList?.call(JournalEntry.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [JournalEntry] by its [id] or null if no such row exists.
  Future<JournalEntry?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<JournalEntry>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [JournalEntry]s in the list and returns the inserted rows.
  ///
  /// The returned [JournalEntry]s will have their `id` fields set.
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
  Future<List<JournalEntry>> insert(
    _is.DatabaseSession session,
    List<JournalEntry> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<JournalEntry>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [JournalEntry] and returns the inserted row.
  ///
  /// The returned [JournalEntry] will have its `id` field set.
  Future<JournalEntry> insertRow(
    _is.DatabaseSession session,
    JournalEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<JournalEntry>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [JournalEntry]s in the list and returns the resulting rows.
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
  /// The returned [JournalEntry]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JournalEntry>> upsert(
    _is.DatabaseSession session,
    List<JournalEntry> rows, {
    required _is.ColumnSelections<JournalEntryTable> conflictColumns,
    _is.ColumnSelections<JournalEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<JournalEntryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<JournalEntry>(
      rows,
      conflictColumns: conflictColumns(JournalEntry.t),
      updateColumns: updateColumns?.call(JournalEntry.t),
      updateWhere: updateWhere?.call(JournalEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [JournalEntry] and returns the resulting row.
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
  /// The returned [JournalEntry] will have its `id` field set.
  Future<JournalEntry?> upsertRow(
    _is.DatabaseSession session,
    JournalEntry row, {
    required _is.ColumnSelections<JournalEntryTable> conflictColumns,
    _is.ColumnSelections<JournalEntryTable>? updateColumns,
    _is.WhereExpressionBuilder<JournalEntryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<JournalEntry>(
      row,
      conflictColumns: conflictColumns(JournalEntry.t),
      updateColumns: updateColumns?.call(JournalEntry.t),
      updateWhere: updateWhere?.call(JournalEntry.t),
      transaction: transaction,
    );
  }

  /// Updates all [JournalEntry]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JournalEntry>> update(
    _is.DatabaseSession session,
    List<JournalEntry> rows, {
    _is.ColumnSelections<JournalEntryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<JournalEntry>(
      rows,
      columns: columns?.call(JournalEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [JournalEntry]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<JournalEntry> updateRow(
    _is.DatabaseSession session,
    JournalEntry row, {
    _is.ColumnSelections<JournalEntryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<JournalEntry>(
      row,
      columns: columns?.call(JournalEntry.t),
      transaction: transaction,
    );
  }

  /// Updates a single [JournalEntry] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<JournalEntry?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<JournalEntryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<JournalEntry>(
      id,
      columnValues: columnValues(JournalEntry.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [JournalEntry]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<JournalEntry>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<JournalEntryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<JournalEntryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<JournalEntryTable>? orderBy,
    _is.OrderByListBuilder<JournalEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<JournalEntry>(
      columnValues: columnValues(JournalEntry.t.updateTable),
      where: where(JournalEntry.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(JournalEntry.t),
      orderByList: orderByList?.call(JournalEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [JournalEntry]s in the list and returns the deleted rows.
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
  Future<List<JournalEntry>> delete(
    _is.DatabaseSession session,
    List<JournalEntry> rows, {
    _is.OrderByBuilder<JournalEntryTable>? orderBy,
    _is.OrderByListBuilder<JournalEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<JournalEntry>(
      rows,
      orderBy: orderBy?.call(JournalEntry.t),
      orderByList: orderByList?.call(JournalEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [JournalEntry].
  Future<JournalEntry> deleteRow(
    _is.DatabaseSession session,
    JournalEntry row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<JournalEntry>(
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
  Future<List<JournalEntry>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JournalEntryTable> where,
    _is.OrderByBuilder<JournalEntryTable>? orderBy,
    _is.OrderByListBuilder<JournalEntryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<JournalEntry>(
      where: where(JournalEntry.t),
      orderBy: orderBy?.call(JournalEntry.t),
      orderByList: orderByList?.call(JournalEntry.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<JournalEntryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<JournalEntry>(
      where: where?.call(JournalEntry.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [JournalEntry] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<JournalEntryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<JournalEntry>(
      where: where(JournalEntry.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
