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

/// The next reminder for one medication: set when a dose is logged (if the
/// medication has `reminderEveryHours`), and marked due by
/// `MedicationReminderFutureCall` when that time comes. Home shows due
/// reminders as a banner. One per medication.
abstract class MedicationReminder
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  MedicationReminder._({
    this.id,
    required this.userId,
    required this.medicationId,
    required this.dueAt,
    bool? isDue,
  }) : isDue = isDue ?? false;

  factory MedicationReminder({
    int? id,
    required _is.UuidValue userId,
    required int medicationId,
    required DateTime dueAt,
    bool? isDue,
  }) = _MedicationReminderImpl;

  factory MedicationReminder.fromJson(Map<String, dynamic> jsonSerialization) {
    return MedicationReminder(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      medicationId: jsonSerialization['medicationId'] as int,
      dueAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      isDue: jsonSerialization['isDue'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isDue']),
    );
  }

  static final t = MedicationReminderTable();

  static const db = MedicationReminderRepository._();

  @override
  int? id;

  /// The user this reminder belongs to.
  _is.UuidValue userId;

  /// Which medication it's for.
  int medicationId;

  /// When the next dose is due.
  DateTime dueAt;

  /// True once dueAt has passed (set by the future call), until the user
  /// logs a dose or dismisses it.
  bool isDue;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MedicationReminder]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  MedicationReminder copyWith({
    int? id,
    _is.UuidValue? userId,
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

  static MedicationReminderInclude include() {
    return MedicationReminderInclude._();
  }

  static MedicationReminderIncludeList includeList({
    _is.WhereExpressionBuilder<MedicationReminderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MedicationReminderTable>? orderBy,
    _is.OrderByListBuilder<MedicationReminderTable>? orderByList,
    MedicationReminderInclude? include,
  }) {
    return MedicationReminderIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MedicationReminder.t),
      orderByList: orderByList?.call(MedicationReminder.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MedicationReminderImpl extends MedicationReminder {
  _MedicationReminderImpl({
    int? id,
    required _is.UuidValue userId,
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
  @_is.useResult
  @override
  MedicationReminder copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
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

class MedicationReminderUpdateTable
    extends _is.UpdateTable<MedicationReminderTable> {
  MedicationReminderUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<int, int> medicationId(int value) => _is.ColumnValue(
    table.medicationId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> dueAt(DateTime value) => _is.ColumnValue(
    table.dueAt,
    value,
  );

  _is.ColumnValue<bool, bool> isDue(bool value) => _is.ColumnValue(
    table.isDue,
    value,
  );
}

class MedicationReminderTable extends _is.Table<int?> {
  MedicationReminderTable({super.tableRelation})
    : super(tableName: 'medication_reminder') {
    updateTable = MedicationReminderUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    medicationId = _is.ColumnInt(
      'medicationId',
      this,
    );
    dueAt = _is.ColumnDateTime(
      'dueAt',
      this,
    );
    isDue = _is.ColumnBool(
      'isDue',
      this,
      hasDefault: true,
    );
  }

  late final MedicationReminderUpdateTable updateTable;

  /// The user this reminder belongs to.
  late final _is.ColumnUuid userId;

  /// Which medication it's for.
  late final _is.ColumnInt medicationId;

  /// When the next dose is due.
  late final _is.ColumnDateTime dueAt;

  /// True once dueAt has passed (set by the future call), until the user
  /// logs a dose or dismisses it.
  late final _is.ColumnBool isDue;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    medicationId,
    dueAt,
    isDue,
  ];
}

class MedicationReminderInclude extends _is.IncludeObject {
  MedicationReminderInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => MedicationReminder.t;
}

class MedicationReminderIncludeList extends _is.IncludeList {
  MedicationReminderIncludeList._({
    _is.WhereExpressionBuilder<MedicationReminderTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MedicationReminder.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MedicationReminder.t;
}

class MedicationReminderRepository {
  const MedicationReminderRepository._();

  /// Returns a list of [MedicationReminder]s matching the given query parameters.
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
  Future<List<MedicationReminder>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MedicationReminderTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MedicationReminderTable>? orderBy,
    _is.OrderByListBuilder<MedicationReminderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MedicationReminder>(
      where: where?.call(MedicationReminder.t),
      orderBy: orderBy?.call(MedicationReminder.t),
      orderByList: orderByList?.call(MedicationReminder.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MedicationReminder] matching the given query parameters.
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
  Future<MedicationReminder?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MedicationReminderTable>? where,
    int? offset,
    _is.OrderByBuilder<MedicationReminderTable>? orderBy,
    _is.OrderByListBuilder<MedicationReminderTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MedicationReminder>(
      where: where?.call(MedicationReminder.t),
      orderBy: orderBy?.call(MedicationReminder.t),
      orderByList: orderByList?.call(MedicationReminder.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MedicationReminder] by its [id] or null if no such row exists.
  Future<MedicationReminder?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MedicationReminder>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MedicationReminder]s in the list and returns the inserted rows.
  ///
  /// The returned [MedicationReminder]s will have their `id` fields set.
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
  Future<List<MedicationReminder>> insert(
    _is.DatabaseSession session,
    List<MedicationReminder> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MedicationReminder>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MedicationReminder] and returns the inserted row.
  ///
  /// The returned [MedicationReminder] will have its `id` field set.
  Future<MedicationReminder> insertRow(
    _is.DatabaseSession session,
    MedicationReminder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MedicationReminder>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [MedicationReminder]s in the list and returns the resulting rows.
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
  /// The returned [MedicationReminder]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MedicationReminder>> upsert(
    _is.DatabaseSession session,
    List<MedicationReminder> rows, {
    required _is.ColumnSelections<MedicationReminderTable> conflictColumns,
    _is.ColumnSelections<MedicationReminderTable>? updateColumns,
    _is.WhereExpressionBuilder<MedicationReminderTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MedicationReminder>(
      rows,
      conflictColumns: conflictColumns(MedicationReminder.t),
      updateColumns: updateColumns?.call(MedicationReminder.t),
      updateWhere: updateWhere?.call(MedicationReminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MedicationReminder] and returns the resulting row.
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
  /// The returned [MedicationReminder] will have its `id` field set.
  Future<MedicationReminder?> upsertRow(
    _is.DatabaseSession session,
    MedicationReminder row, {
    required _is.ColumnSelections<MedicationReminderTable> conflictColumns,
    _is.ColumnSelections<MedicationReminderTable>? updateColumns,
    _is.WhereExpressionBuilder<MedicationReminderTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MedicationReminder>(
      row,
      conflictColumns: conflictColumns(MedicationReminder.t),
      updateColumns: updateColumns?.call(MedicationReminder.t),
      updateWhere: updateWhere?.call(MedicationReminder.t),
      transaction: transaction,
    );
  }

  /// Updates all [MedicationReminder]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MedicationReminder>> update(
    _is.DatabaseSession session,
    List<MedicationReminder> rows, {
    _is.ColumnSelections<MedicationReminderTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MedicationReminder>(
      rows,
      columns: columns?.call(MedicationReminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MedicationReminder]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MedicationReminder> updateRow(
    _is.DatabaseSession session,
    MedicationReminder row, {
    _is.ColumnSelections<MedicationReminderTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MedicationReminder>(
      row,
      columns: columns?.call(MedicationReminder.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MedicationReminder] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MedicationReminder?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MedicationReminderUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MedicationReminder>(
      id,
      columnValues: columnValues(MedicationReminder.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MedicationReminder]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MedicationReminder>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MedicationReminderUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<MedicationReminderTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MedicationReminderTable>? orderBy,
    _is.OrderByListBuilder<MedicationReminderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MedicationReminder>(
      columnValues: columnValues(MedicationReminder.t.updateTable),
      where: where(MedicationReminder.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MedicationReminder.t),
      orderByList: orderByList?.call(MedicationReminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MedicationReminder]s in the list and returns the deleted rows.
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
  Future<List<MedicationReminder>> delete(
    _is.DatabaseSession session,
    List<MedicationReminder> rows, {
    _is.OrderByBuilder<MedicationReminderTable>? orderBy,
    _is.OrderByListBuilder<MedicationReminderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MedicationReminder>(
      rows,
      orderBy: orderBy?.call(MedicationReminder.t),
      orderByList: orderByList?.call(MedicationReminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MedicationReminder].
  Future<MedicationReminder> deleteRow(
    _is.DatabaseSession session,
    MedicationReminder row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MedicationReminder>(
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
  Future<List<MedicationReminder>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MedicationReminderTable> where,
    _is.OrderByBuilder<MedicationReminderTable>? orderBy,
    _is.OrderByListBuilder<MedicationReminderTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MedicationReminder>(
      where: where(MedicationReminder.t),
      orderBy: orderBy?.call(MedicationReminder.t),
      orderByList: orderByList?.call(MedicationReminder.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MedicationReminderTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MedicationReminder>(
      where: where?.call(MedicationReminder.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MedicationReminder] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MedicationReminderTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MedicationReminder>(
      where: where(MedicationReminder.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
