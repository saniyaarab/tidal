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

/// One period: the days from its start date through its end date.
/// The user sets both by long-pressing days on the Calendar (see
/// `PeriodEndpoint.longPress`). Flow level is recorded separately on
/// `DayLog` and never decides where a period starts or ends.
abstract class Period implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Period._({
    this.id,
    required this.userId,
    required this.startDate,
    this.endDate,
  });

  factory Period({
    int? id,
    required _is.UuidValue userId,
    required DateTime startDate,
    DateTime? endDate,
  }) = _PeriodImpl;

  factory Period.fromJson(Map<String, dynamic> jsonSerialization) {
    return Period(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      startDate: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['startDate'],
      ),
      endDate: jsonSerialization['endDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endDate']),
    );
  }

  static final t = PeriodTable();

  static const db = PeriodRepository._();

  @override
  int? id;

  /// The user this period belongs to.
  _is.UuidValue userId;

  /// First day of the period, stored as midnight UTC of that day.
  DateTime startDate;

  /// Last day of the period, once the user has confirmed it by
  /// long-pressing it. Null means "not confirmed yet": the period is then
  /// assumed to last the user's default period length (see
  /// `computeDefaultPeriodLength`).
  DateTime? endDate;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Period]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Period copyWith({
    int? id,
    _is.UuidValue? userId,
    DateTime? startDate,
    DateTime? endDate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Period',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Period',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'startDate': startDate.toJson(),
      if (endDate != null) 'endDate': endDate?.toJson(),
    };
  }

  static PeriodInclude include() {
    return PeriodInclude._();
  }

  static PeriodIncludeList includeList({
    _is.WhereExpressionBuilder<PeriodTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PeriodTable>? orderBy,
    _is.OrderByListBuilder<PeriodTable>? orderByList,
    PeriodInclude? include,
  }) {
    return PeriodIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Period.t),
      orderByList: orderByList?.call(Period.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PeriodImpl extends Period {
  _PeriodImpl({
    int? id,
    required _is.UuidValue userId,
    required DateTime startDate,
    DateTime? endDate,
  }) : super._(
         id: id,
         userId: userId,
         startDate: startDate,
         endDate: endDate,
       );

  /// Returns a shallow copy of this [Period]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Period copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    DateTime? startDate,
    Object? endDate = _Undefined,
  }) {
    return Period(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      startDate: startDate ?? this.startDate,
      endDate: endDate is DateTime? ? endDate : this.endDate,
    );
  }
}

class PeriodUpdateTable extends _is.UpdateTable<PeriodTable> {
  PeriodUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> startDate(DateTime value) =>
      _is.ColumnValue(
        table.startDate,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> endDate(DateTime? value) =>
      _is.ColumnValue(
        table.endDate,
        value,
      );
}

class PeriodTable extends _is.Table<int?> {
  PeriodTable({super.tableRelation}) : super(tableName: 'period') {
    updateTable = PeriodUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    startDate = _is.ColumnDateTime(
      'startDate',
      this,
    );
    endDate = _is.ColumnDateTime(
      'endDate',
      this,
    );
  }

  late final PeriodUpdateTable updateTable;

  /// The user this period belongs to.
  late final _is.ColumnUuid userId;

  /// First day of the period, stored as midnight UTC of that day.
  late final _is.ColumnDateTime startDate;

  /// Last day of the period, once the user has confirmed it by
  /// long-pressing it. Null means "not confirmed yet": the period is then
  /// assumed to last the user's default period length (see
  /// `computeDefaultPeriodLength`).
  late final _is.ColumnDateTime endDate;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    startDate,
    endDate,
  ];
}

class PeriodInclude extends _is.IncludeObject {
  PeriodInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Period.t;
}

class PeriodIncludeList extends _is.IncludeList {
  PeriodIncludeList._({
    _is.WhereExpressionBuilder<PeriodTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Period.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Period.t;
}

class PeriodRepository {
  const PeriodRepository._();

  /// Returns a list of [Period]s matching the given query parameters.
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
  Future<List<Period>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PeriodTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PeriodTable>? orderBy,
    _is.OrderByListBuilder<PeriodTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Period>(
      where: where?.call(Period.t),
      orderBy: orderBy?.call(Period.t),
      orderByList: orderByList?.call(Period.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Period] matching the given query parameters.
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
  Future<Period?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PeriodTable>? where,
    int? offset,
    _is.OrderByBuilder<PeriodTable>? orderBy,
    _is.OrderByListBuilder<PeriodTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Period>(
      where: where?.call(Period.t),
      orderBy: orderBy?.call(Period.t),
      orderByList: orderByList?.call(Period.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Period] by its [id] or null if no such row exists.
  Future<Period?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Period>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Period]s in the list and returns the inserted rows.
  ///
  /// The returned [Period]s will have their `id` fields set.
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
  Future<List<Period>> insert(
    _is.DatabaseSession session,
    List<Period> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Period>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Period] and returns the inserted row.
  ///
  /// The returned [Period] will have its `id` field set.
  Future<Period> insertRow(
    _is.DatabaseSession session,
    Period row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Period>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Period]s in the list and returns the resulting rows.
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
  /// The returned [Period]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Period>> upsert(
    _is.DatabaseSession session,
    List<Period> rows, {
    required _is.ColumnSelections<PeriodTable> conflictColumns,
    _is.ColumnSelections<PeriodTable>? updateColumns,
    _is.WhereExpressionBuilder<PeriodTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Period>(
      rows,
      conflictColumns: conflictColumns(Period.t),
      updateColumns: updateColumns?.call(Period.t),
      updateWhere: updateWhere?.call(Period.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Period] and returns the resulting row.
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
  /// The returned [Period] will have its `id` field set.
  Future<Period?> upsertRow(
    _is.DatabaseSession session,
    Period row, {
    required _is.ColumnSelections<PeriodTable> conflictColumns,
    _is.ColumnSelections<PeriodTable>? updateColumns,
    _is.WhereExpressionBuilder<PeriodTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Period>(
      row,
      conflictColumns: conflictColumns(Period.t),
      updateColumns: updateColumns?.call(Period.t),
      updateWhere: updateWhere?.call(Period.t),
      transaction: transaction,
    );
  }

  /// Updates all [Period]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Period>> update(
    _is.DatabaseSession session,
    List<Period> rows, {
    _is.ColumnSelections<PeriodTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Period>(
      rows,
      columns: columns?.call(Period.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Period]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Period> updateRow(
    _is.DatabaseSession session,
    Period row, {
    _is.ColumnSelections<PeriodTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Period>(
      row,
      columns: columns?.call(Period.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Period] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Period?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<PeriodUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Period>(
      id,
      columnValues: columnValues(Period.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Period]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Period>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PeriodUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PeriodTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PeriodTable>? orderBy,
    _is.OrderByListBuilder<PeriodTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Period>(
      columnValues: columnValues(Period.t.updateTable),
      where: where(Period.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Period.t),
      orderByList: orderByList?.call(Period.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Period]s in the list and returns the deleted rows.
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
  Future<List<Period>> delete(
    _is.DatabaseSession session,
    List<Period> rows, {
    _is.OrderByBuilder<PeriodTable>? orderBy,
    _is.OrderByListBuilder<PeriodTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Period>(
      rows,
      orderBy: orderBy?.call(Period.t),
      orderByList: orderByList?.call(Period.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Period].
  Future<Period> deleteRow(
    _is.DatabaseSession session,
    Period row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Period>(
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
  Future<List<Period>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PeriodTable> where,
    _is.OrderByBuilder<PeriodTable>? orderBy,
    _is.OrderByListBuilder<PeriodTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Period>(
      where: where(Period.t),
      orderBy: orderBy?.call(Period.t),
      orderByList: orderByList?.call(Period.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PeriodTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Period>(
      where: where?.call(Period.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Period] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PeriodTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Period>(
      where: where(Period.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
