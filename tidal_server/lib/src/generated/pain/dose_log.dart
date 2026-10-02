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

/// A single one-tap record of a medication dose being taken.
abstract class DoseLog
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  DoseLog._({
    this.id,
    required this.userId,
    required this.medicationId,
    required this.timestamp,
    required this.dose,
    this.painBefore,
  });

  factory DoseLog({
    int? id,
    required _is.UuidValue userId,
    required int medicationId,
    required DateTime timestamp,
    required String dose,
    int? painBefore,
  }) = _DoseLogImpl;

  factory DoseLog.fromJson(Map<String, dynamic> jsonSerialization) {
    return DoseLog(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      medicationId: jsonSerialization['medicationId'] as int,
      timestamp: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      dose: jsonSerialization['dose'] as String,
      painBefore: jsonSerialization['painBefore'] as int?,
    );
  }

  static final t = DoseLogTable();

  static const db = DoseLogRepository._();

  @override
  int? id;

  /// The user this dose log belongs to.
  _is.UuidValue userId;

  /// Which medication was taken.
  int medicationId;

  /// When the dose was taken. Always "now" at the time of logging.
  DateTime timestamp;

  /// Snapshot of the dose taken, e.g. "400 mg" (copied from the
  /// medication's usualDose at the time of logging).
  String dose;

  /// Pain level right before taking the dose, if known.
  int? painBefore;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [DoseLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DoseLog copyWith({
    int? id,
    _is.UuidValue? userId,
    int? medicationId,
    DateTime? timestamp,
    String? dose,
    int? painBefore,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DoseLog',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'medicationId': medicationId,
      'timestamp': timestamp.toJson(),
      'dose': dose,
      if (painBefore != null) 'painBefore': painBefore,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DoseLog',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'medicationId': medicationId,
      'timestamp': timestamp.toJson(),
      'dose': dose,
      if (painBefore != null) 'painBefore': painBefore,
    };
  }

  static DoseLogInclude include() {
    return DoseLogInclude._();
  }

  static DoseLogIncludeList includeList({
    _is.WhereExpressionBuilder<DoseLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoseLogTable>? orderBy,
    _is.OrderByListBuilder<DoseLogTable>? orderByList,
    DoseLogInclude? include,
  }) {
    return DoseLogIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoseLog.t),
      orderByList: orderByList?.call(DoseLog.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DoseLogImpl extends DoseLog {
  _DoseLogImpl({
    int? id,
    required _is.UuidValue userId,
    required int medicationId,
    required DateTime timestamp,
    required String dose,
    int? painBefore,
  }) : super._(
         id: id,
         userId: userId,
         medicationId: medicationId,
         timestamp: timestamp,
         dose: dose,
         painBefore: painBefore,
       );

  /// Returns a shallow copy of this [DoseLog]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DoseLog copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    int? medicationId,
    DateTime? timestamp,
    String? dose,
    Object? painBefore = _Undefined,
  }) {
    return DoseLog(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      medicationId: medicationId ?? this.medicationId,
      timestamp: timestamp ?? this.timestamp,
      dose: dose ?? this.dose,
      painBefore: painBefore is int? ? painBefore : this.painBefore,
    );
  }
}

class DoseLogUpdateTable extends _is.UpdateTable<DoseLogTable> {
  DoseLogUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<int, int> medicationId(int value) => _is.ColumnValue(
    table.medicationId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> timestamp(DateTime value) =>
      _is.ColumnValue(
        table.timestamp,
        value,
      );

  _is.ColumnValue<String, String> dose(String value) => _is.ColumnValue(
    table.dose,
    value,
  );

  _is.ColumnValue<int, int> painBefore(int? value) => _is.ColumnValue(
    table.painBefore,
    value,
  );
}

class DoseLogTable extends _is.Table<int?> {
  DoseLogTable({super.tableRelation}) : super(tableName: 'dose_log') {
    updateTable = DoseLogUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    medicationId = _is.ColumnInt(
      'medicationId',
      this,
    );
    timestamp = _is.ColumnDateTime(
      'timestamp',
      this,
    );
    dose = _is.ColumnString(
      'dose',
      this,
    );
    painBefore = _is.ColumnInt(
      'painBefore',
      this,
    );
  }

  late final DoseLogUpdateTable updateTable;

  /// The user this dose log belongs to.
  late final _is.ColumnUuid userId;

  /// Which medication was taken.
  late final _is.ColumnInt medicationId;

  /// When the dose was taken. Always "now" at the time of logging.
  late final _is.ColumnDateTime timestamp;

  /// Snapshot of the dose taken, e.g. "400 mg" (copied from the
  /// medication's usualDose at the time of logging).
  late final _is.ColumnString dose;

  /// Pain level right before taking the dose, if known.
  late final _is.ColumnInt painBefore;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    medicationId,
    timestamp,
    dose,
    painBefore,
  ];
}

class DoseLogInclude extends _is.IncludeObject {
  DoseLogInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => DoseLog.t;
}

class DoseLogIncludeList extends _is.IncludeList {
  DoseLogIncludeList._({
    _is.WhereExpressionBuilder<DoseLogTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(DoseLog.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => DoseLog.t;
}

class DoseLogRepository {
  const DoseLogRepository._();

  /// Returns a list of [DoseLog]s matching the given query parameters.
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
  Future<List<DoseLog>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoseLogTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoseLogTable>? orderBy,
    _is.OrderByListBuilder<DoseLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<DoseLog>(
      where: where?.call(DoseLog.t),
      orderBy: orderBy?.call(DoseLog.t),
      orderByList: orderByList?.call(DoseLog.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [DoseLog] matching the given query parameters.
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
  Future<DoseLog?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoseLogTable>? where,
    int? offset,
    _is.OrderByBuilder<DoseLogTable>? orderBy,
    _is.OrderByListBuilder<DoseLogTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<DoseLog>(
      where: where?.call(DoseLog.t),
      orderBy: orderBy?.call(DoseLog.t),
      orderByList: orderByList?.call(DoseLog.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [DoseLog] by its [id] or null if no such row exists.
  Future<DoseLog?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<DoseLog>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [DoseLog]s in the list and returns the inserted rows.
  ///
  /// The returned [DoseLog]s will have their `id` fields set.
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
  Future<List<DoseLog>> insert(
    _is.DatabaseSession session,
    List<DoseLog> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<DoseLog>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [DoseLog] and returns the inserted row.
  ///
  /// The returned [DoseLog] will have its `id` field set.
  Future<DoseLog> insertRow(
    _is.DatabaseSession session,
    DoseLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<DoseLog>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [DoseLog]s in the list and returns the resulting rows.
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
  /// The returned [DoseLog]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoseLog>> upsert(
    _is.DatabaseSession session,
    List<DoseLog> rows, {
    required _is.ColumnSelections<DoseLogTable> conflictColumns,
    _is.ColumnSelections<DoseLogTable>? updateColumns,
    _is.WhereExpressionBuilder<DoseLogTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<DoseLog>(
      rows,
      conflictColumns: conflictColumns(DoseLog.t),
      updateColumns: updateColumns?.call(DoseLog.t),
      updateWhere: updateWhere?.call(DoseLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [DoseLog] and returns the resulting row.
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
  /// The returned [DoseLog] will have its `id` field set.
  Future<DoseLog?> upsertRow(
    _is.DatabaseSession session,
    DoseLog row, {
    required _is.ColumnSelections<DoseLogTable> conflictColumns,
    _is.ColumnSelections<DoseLogTable>? updateColumns,
    _is.WhereExpressionBuilder<DoseLogTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<DoseLog>(
      row,
      conflictColumns: conflictColumns(DoseLog.t),
      updateColumns: updateColumns?.call(DoseLog.t),
      updateWhere: updateWhere?.call(DoseLog.t),
      transaction: transaction,
    );
  }

  /// Updates all [DoseLog]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoseLog>> update(
    _is.DatabaseSession session,
    List<DoseLog> rows, {
    _is.ColumnSelections<DoseLogTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<DoseLog>(
      rows,
      columns: columns?.call(DoseLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [DoseLog]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<DoseLog> updateRow(
    _is.DatabaseSession session,
    DoseLog row, {
    _is.ColumnSelections<DoseLogTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<DoseLog>(
      row,
      columns: columns?.call(DoseLog.t),
      transaction: transaction,
    );
  }

  /// Updates a single [DoseLog] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<DoseLog?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<DoseLogUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<DoseLog>(
      id,
      columnValues: columnValues(DoseLog.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [DoseLog]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<DoseLog>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<DoseLogUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<DoseLogTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<DoseLogTable>? orderBy,
    _is.OrderByListBuilder<DoseLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<DoseLog>(
      columnValues: columnValues(DoseLog.t.updateTable),
      where: where(DoseLog.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(DoseLog.t),
      orderByList: orderByList?.call(DoseLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [DoseLog]s in the list and returns the deleted rows.
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
  Future<List<DoseLog>> delete(
    _is.DatabaseSession session,
    List<DoseLog> rows, {
    _is.OrderByBuilder<DoseLogTable>? orderBy,
    _is.OrderByListBuilder<DoseLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<DoseLog>(
      rows,
      orderBy: orderBy?.call(DoseLog.t),
      orderByList: orderByList?.call(DoseLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [DoseLog].
  Future<DoseLog> deleteRow(
    _is.DatabaseSession session,
    DoseLog row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<DoseLog>(
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
  Future<List<DoseLog>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoseLogTable> where,
    _is.OrderByBuilder<DoseLogTable>? orderBy,
    _is.OrderByListBuilder<DoseLogTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<DoseLog>(
      where: where(DoseLog.t),
      orderBy: orderBy?.call(DoseLog.t),
      orderByList: orderByList?.call(DoseLog.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<DoseLogTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<DoseLog>(
      where: where?.call(DoseLog.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [DoseLog] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<DoseLogTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<DoseLog>(
      where: where(DoseLog.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
