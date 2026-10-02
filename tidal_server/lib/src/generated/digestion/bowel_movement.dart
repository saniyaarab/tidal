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

/// One bowel movement, typed on the Bristol Stool Scale. A day can have
/// several.
abstract class BowelMovement
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  BowelMovement._({
    this.id,
    required this.userId,
    required this.date,
    required this.timestamp,
    required this.loggedAt,
    required this.bristolType,
  });

  factory BowelMovement({
    int? id,
    required _is.UuidValue userId,
    required DateTime date,
    required DateTime timestamp,
    required DateTime loggedAt,
    required int bristolType,
  }) = _BowelMovementImpl;

  factory BowelMovement.fromJson(Map<String, dynamic> jsonSerialization) {
    return BowelMovement(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      date: _is.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      timestamp: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['timestamp'],
      ),
      loggedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['loggedAt'],
      ),
      bristolType: jsonSerialization['bristolType'] as int,
    );
  }

  static final t = BowelMovementTable();

  static const db = BowelMovementRepository._();

  @override
  int? id;

  /// The user this entry belongs to.
  _is.UuidValue userId;

  /// The calendar day it belongs to, stored as midnight UTC.
  DateTime date;

  /// When it happened, as chosen by the user. Never in the future.
  DateTime timestamp;

  /// The exact moment the entry was saved, set by the server.
  DateTime loggedAt;

  /// Bristol Stool Scale type, 1 (hard lumps) to 7 (watery).
  int bristolType;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [BowelMovement]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BowelMovement copyWith({
    int? id,
    _is.UuidValue? userId,
    DateTime? date,
    DateTime? timestamp,
    DateTime? loggedAt,
    int? bristolType,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BowelMovement',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'date': date.toJson(),
      'timestamp': timestamp.toJson(),
      'loggedAt': loggedAt.toJson(),
      'bristolType': bristolType,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BowelMovement',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'date': date.toJson(),
      'timestamp': timestamp.toJson(),
      'loggedAt': loggedAt.toJson(),
      'bristolType': bristolType,
    };
  }

  static BowelMovementInclude include() {
    return BowelMovementInclude._();
  }

  static BowelMovementIncludeList includeList({
    _is.WhereExpressionBuilder<BowelMovementTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BowelMovementTable>? orderBy,
    _is.OrderByListBuilder<BowelMovementTable>? orderByList,
    BowelMovementInclude? include,
  }) {
    return BowelMovementIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BowelMovement.t),
      orderByList: orderByList?.call(BowelMovement.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BowelMovementImpl extends BowelMovement {
  _BowelMovementImpl({
    int? id,
    required _is.UuidValue userId,
    required DateTime date,
    required DateTime timestamp,
    required DateTime loggedAt,
    required int bristolType,
  }) : super._(
         id: id,
         userId: userId,
         date: date,
         timestamp: timestamp,
         loggedAt: loggedAt,
         bristolType: bristolType,
       );

  /// Returns a shallow copy of this [BowelMovement]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BowelMovement copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    DateTime? date,
    DateTime? timestamp,
    DateTime? loggedAt,
    int? bristolType,
  }) {
    return BowelMovement(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      timestamp: timestamp ?? this.timestamp,
      loggedAt: loggedAt ?? this.loggedAt,
      bristolType: bristolType ?? this.bristolType,
    );
  }
}

class BowelMovementUpdateTable extends _is.UpdateTable<BowelMovementTable> {
  BowelMovementUpdateTable(super.table);

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

  _is.ColumnValue<int, int> bristolType(int value) => _is.ColumnValue(
    table.bristolType,
    value,
  );
}

class BowelMovementTable extends _is.Table<int?> {
  BowelMovementTable({super.tableRelation})
    : super(tableName: 'bowel_movement') {
    updateTable = BowelMovementUpdateTable(this);
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
    bristolType = _is.ColumnInt(
      'bristolType',
      this,
    );
  }

  late final BowelMovementUpdateTable updateTable;

  /// The user this entry belongs to.
  late final _is.ColumnUuid userId;

  /// The calendar day it belongs to, stored as midnight UTC.
  late final _is.ColumnDateTime date;

  /// When it happened, as chosen by the user. Never in the future.
  late final _is.ColumnDateTime timestamp;

  /// The exact moment the entry was saved, set by the server.
  late final _is.ColumnDateTime loggedAt;

  /// Bristol Stool Scale type, 1 (hard lumps) to 7 (watery).
  late final _is.ColumnInt bristolType;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    date,
    timestamp,
    loggedAt,
    bristolType,
  ];
}

class BowelMovementInclude extends _is.IncludeObject {
  BowelMovementInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => BowelMovement.t;
}

class BowelMovementIncludeList extends _is.IncludeList {
  BowelMovementIncludeList._({
    _is.WhereExpressionBuilder<BowelMovementTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(BowelMovement.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => BowelMovement.t;
}

class BowelMovementRepository {
  const BowelMovementRepository._();

  /// Returns a list of [BowelMovement]s matching the given query parameters.
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
  Future<List<BowelMovement>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BowelMovementTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BowelMovementTable>? orderBy,
    _is.OrderByListBuilder<BowelMovementTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<BowelMovement>(
      where: where?.call(BowelMovement.t),
      orderBy: orderBy?.call(BowelMovement.t),
      orderByList: orderByList?.call(BowelMovement.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [BowelMovement] matching the given query parameters.
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
  Future<BowelMovement?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BowelMovementTable>? where,
    int? offset,
    _is.OrderByBuilder<BowelMovementTable>? orderBy,
    _is.OrderByListBuilder<BowelMovementTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<BowelMovement>(
      where: where?.call(BowelMovement.t),
      orderBy: orderBy?.call(BowelMovement.t),
      orderByList: orderByList?.call(BowelMovement.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [BowelMovement] by its [id] or null if no such row exists.
  Future<BowelMovement?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<BowelMovement>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [BowelMovement]s in the list and returns the inserted rows.
  ///
  /// The returned [BowelMovement]s will have their `id` fields set.
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
  Future<List<BowelMovement>> insert(
    _is.DatabaseSession session,
    List<BowelMovement> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<BowelMovement>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [BowelMovement] and returns the inserted row.
  ///
  /// The returned [BowelMovement] will have its `id` field set.
  Future<BowelMovement> insertRow(
    _is.DatabaseSession session,
    BowelMovement row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<BowelMovement>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [BowelMovement]s in the list and returns the resulting rows.
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
  /// The returned [BowelMovement]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BowelMovement>> upsert(
    _is.DatabaseSession session,
    List<BowelMovement> rows, {
    required _is.ColumnSelections<BowelMovementTable> conflictColumns,
    _is.ColumnSelections<BowelMovementTable>? updateColumns,
    _is.WhereExpressionBuilder<BowelMovementTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<BowelMovement>(
      rows,
      conflictColumns: conflictColumns(BowelMovement.t),
      updateColumns: updateColumns?.call(BowelMovement.t),
      updateWhere: updateWhere?.call(BowelMovement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [BowelMovement] and returns the resulting row.
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
  /// The returned [BowelMovement] will have its `id` field set.
  Future<BowelMovement?> upsertRow(
    _is.DatabaseSession session,
    BowelMovement row, {
    required _is.ColumnSelections<BowelMovementTable> conflictColumns,
    _is.ColumnSelections<BowelMovementTable>? updateColumns,
    _is.WhereExpressionBuilder<BowelMovementTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<BowelMovement>(
      row,
      conflictColumns: conflictColumns(BowelMovement.t),
      updateColumns: updateColumns?.call(BowelMovement.t),
      updateWhere: updateWhere?.call(BowelMovement.t),
      transaction: transaction,
    );
  }

  /// Updates all [BowelMovement]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BowelMovement>> update(
    _is.DatabaseSession session,
    List<BowelMovement> rows, {
    _is.ColumnSelections<BowelMovementTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<BowelMovement>(
      rows,
      columns: columns?.call(BowelMovement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [BowelMovement]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<BowelMovement> updateRow(
    _is.DatabaseSession session,
    BowelMovement row, {
    _is.ColumnSelections<BowelMovementTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<BowelMovement>(
      row,
      columns: columns?.call(BowelMovement.t),
      transaction: transaction,
    );
  }

  /// Updates a single [BowelMovement] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<BowelMovement?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<BowelMovementUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<BowelMovement>(
      id,
      columnValues: columnValues(BowelMovement.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [BowelMovement]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<BowelMovement>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<BowelMovementUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<BowelMovementTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<BowelMovementTable>? orderBy,
    _is.OrderByListBuilder<BowelMovementTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<BowelMovement>(
      columnValues: columnValues(BowelMovement.t.updateTable),
      where: where(BowelMovement.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(BowelMovement.t),
      orderByList: orderByList?.call(BowelMovement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [BowelMovement]s in the list and returns the deleted rows.
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
  Future<List<BowelMovement>> delete(
    _is.DatabaseSession session,
    List<BowelMovement> rows, {
    _is.OrderByBuilder<BowelMovementTable>? orderBy,
    _is.OrderByListBuilder<BowelMovementTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<BowelMovement>(
      rows,
      orderBy: orderBy?.call(BowelMovement.t),
      orderByList: orderByList?.call(BowelMovement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [BowelMovement].
  Future<BowelMovement> deleteRow(
    _is.DatabaseSession session,
    BowelMovement row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<BowelMovement>(
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
  Future<List<BowelMovement>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BowelMovementTable> where,
    _is.OrderByBuilder<BowelMovementTable>? orderBy,
    _is.OrderByListBuilder<BowelMovementTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<BowelMovement>(
      where: where(BowelMovement.t),
      orderBy: orderBy?.call(BowelMovement.t),
      orderByList: orderByList?.call(BowelMovement.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<BowelMovementTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<BowelMovement>(
      where: where?.call(BowelMovement.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [BowelMovement] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<BowelMovementTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<BowelMovement>(
      where: where(BowelMovement.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
