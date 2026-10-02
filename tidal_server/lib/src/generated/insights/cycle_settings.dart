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
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _is.UuidValue userId,
    int? typicalCycleDays,
    int? typicalPeriodDays,
    int? birthYear,
  }) = _CycleSettingsImpl;

  factory CycleSettings.fromJson(Map<String, dynamic> jsonSerialization) {
    return CycleSettings(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      typicalCycleDays: jsonSerialization['typicalCycleDays'] as int?,
      typicalPeriodDays: jsonSerialization['typicalPeriodDays'] as int?,
      birthYear: jsonSerialization['birthYear'] as int?,
    );
  }

  static final t = CycleSettingsTable();

  static const db = CycleSettingsRepository._();

  @override
  int? id;

  /// The user these settings belong to.
  _is.UuidValue userId;

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

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [CycleSettings]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CycleSettings copyWith({
    int? id,
    _is.UuidValue? userId,
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

  static CycleSettingsInclude include() {
    return CycleSettingsInclude._();
  }

  static CycleSettingsIncludeList includeList({
    _is.WhereExpressionBuilder<CycleSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CycleSettingsTable>? orderBy,
    _is.OrderByListBuilder<CycleSettingsTable>? orderByList,
    CycleSettingsInclude? include,
  }) {
    return CycleSettingsIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CycleSettings.t),
      orderByList: orderByList?.call(CycleSettings.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CycleSettingsImpl extends CycleSettings {
  _CycleSettingsImpl({
    int? id,
    required _is.UuidValue userId,
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
  @_is.useResult
  @override
  CycleSettings copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
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

class CycleSettingsUpdateTable extends _is.UpdateTable<CycleSettingsTable> {
  CycleSettingsUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<int, int> typicalCycleDays(int value) => _is.ColumnValue(
    table.typicalCycleDays,
    value,
  );

  _is.ColumnValue<int, int> typicalPeriodDays(int value) => _is.ColumnValue(
    table.typicalPeriodDays,
    value,
  );

  _is.ColumnValue<int, int> birthYear(int? value) => _is.ColumnValue(
    table.birthYear,
    value,
  );
}

class CycleSettingsTable extends _is.Table<int?> {
  CycleSettingsTable({super.tableRelation})
    : super(tableName: 'cycle_settings') {
    updateTable = CycleSettingsUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    typicalCycleDays = _is.ColumnInt(
      'typicalCycleDays',
      this,
      hasDefault: true,
    );
    typicalPeriodDays = _is.ColumnInt(
      'typicalPeriodDays',
      this,
      hasDefault: true,
    );
    birthYear = _is.ColumnInt(
      'birthYear',
      this,
    );
  }

  late final CycleSettingsUpdateTable updateTable;

  /// The user these settings belong to.
  late final _is.ColumnUuid userId;

  /// Typical days between period starts. Seeds `Prediction.nextPeriodStart`
  /// until 2+ periods have been logged, after which the real average of
  /// logged cycles is used instead. Defaults to 28.
  late final _is.ColumnInt typicalCycleDays;

  /// Typical period length in days. Defaults to 5 until the user sets it.
  late final _is.ColumnInt typicalPeriodDays;

  /// Birth year only, never a full date — the month and day aren't needed
  /// for anything the app does, so they're simply never asked for or
  /// stored. Age is always computed from this on request (see
  /// `InsightEndpoint.getAge`), never stored, so it's never stale. Age
  /// from year alone is off by at most one year.
  late final _is.ColumnInt birthYear;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    typicalCycleDays,
    typicalPeriodDays,
    birthYear,
  ];
}

class CycleSettingsInclude extends _is.IncludeObject {
  CycleSettingsInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => CycleSettings.t;
}

class CycleSettingsIncludeList extends _is.IncludeList {
  CycleSettingsIncludeList._({
    _is.WhereExpressionBuilder<CycleSettingsTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CycleSettings.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => CycleSettings.t;
}

class CycleSettingsRepository {
  const CycleSettingsRepository._();

  /// Returns a list of [CycleSettings]s matching the given query parameters.
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
  Future<List<CycleSettings>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CycleSettingsTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CycleSettingsTable>? orderBy,
    _is.OrderByListBuilder<CycleSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CycleSettings>(
      where: where?.call(CycleSettings.t),
      orderBy: orderBy?.call(CycleSettings.t),
      orderByList: orderByList?.call(CycleSettings.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [CycleSettings] matching the given query parameters.
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
  Future<CycleSettings?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CycleSettingsTable>? where,
    int? offset,
    _is.OrderByBuilder<CycleSettingsTable>? orderBy,
    _is.OrderByListBuilder<CycleSettingsTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CycleSettings>(
      where: where?.call(CycleSettings.t),
      orderBy: orderBy?.call(CycleSettings.t),
      orderByList: orderByList?.call(CycleSettings.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CycleSettings] by its [id] or null if no such row exists.
  Future<CycleSettings?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CycleSettings>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CycleSettings]s in the list and returns the inserted rows.
  ///
  /// The returned [CycleSettings]s will have their `id` fields set.
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
  Future<List<CycleSettings>> insert(
    _is.DatabaseSession session,
    List<CycleSettings> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CycleSettings>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CycleSettings] and returns the inserted row.
  ///
  /// The returned [CycleSettings] will have its `id` field set.
  Future<CycleSettings> insertRow(
    _is.DatabaseSession session,
    CycleSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CycleSettings>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CycleSettings]s in the list and returns the resulting rows.
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
  /// The returned [CycleSettings]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CycleSettings>> upsert(
    _is.DatabaseSession session,
    List<CycleSettings> rows, {
    required _is.ColumnSelections<CycleSettingsTable> conflictColumns,
    _is.ColumnSelections<CycleSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<CycleSettingsTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CycleSettings>(
      rows,
      conflictColumns: conflictColumns(CycleSettings.t),
      updateColumns: updateColumns?.call(CycleSettings.t),
      updateWhere: updateWhere?.call(CycleSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CycleSettings] and returns the resulting row.
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
  /// The returned [CycleSettings] will have its `id` field set.
  Future<CycleSettings?> upsertRow(
    _is.DatabaseSession session,
    CycleSettings row, {
    required _is.ColumnSelections<CycleSettingsTable> conflictColumns,
    _is.ColumnSelections<CycleSettingsTable>? updateColumns,
    _is.WhereExpressionBuilder<CycleSettingsTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CycleSettings>(
      row,
      conflictColumns: conflictColumns(CycleSettings.t),
      updateColumns: updateColumns?.call(CycleSettings.t),
      updateWhere: updateWhere?.call(CycleSettings.t),
      transaction: transaction,
    );
  }

  /// Updates all [CycleSettings]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CycleSettings>> update(
    _is.DatabaseSession session,
    List<CycleSettings> rows, {
    _is.ColumnSelections<CycleSettingsTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CycleSettings>(
      rows,
      columns: columns?.call(CycleSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CycleSettings]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CycleSettings> updateRow(
    _is.DatabaseSession session,
    CycleSettings row, {
    _is.ColumnSelections<CycleSettingsTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CycleSettings>(
      row,
      columns: columns?.call(CycleSettings.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CycleSettings] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CycleSettings?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<CycleSettingsUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CycleSettings>(
      id,
      columnValues: columnValues(CycleSettings.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CycleSettings]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CycleSettings>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CycleSettingsUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CycleSettingsTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CycleSettingsTable>? orderBy,
    _is.OrderByListBuilder<CycleSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CycleSettings>(
      columnValues: columnValues(CycleSettings.t.updateTable),
      where: where(CycleSettings.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CycleSettings.t),
      orderByList: orderByList?.call(CycleSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CycleSettings]s in the list and returns the deleted rows.
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
  Future<List<CycleSettings>> delete(
    _is.DatabaseSession session,
    List<CycleSettings> rows, {
    _is.OrderByBuilder<CycleSettingsTable>? orderBy,
    _is.OrderByListBuilder<CycleSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CycleSettings>(
      rows,
      orderBy: orderBy?.call(CycleSettings.t),
      orderByList: orderByList?.call(CycleSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CycleSettings].
  Future<CycleSettings> deleteRow(
    _is.DatabaseSession session,
    CycleSettings row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CycleSettings>(
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
  Future<List<CycleSettings>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CycleSettingsTable> where,
    _is.OrderByBuilder<CycleSettingsTable>? orderBy,
    _is.OrderByListBuilder<CycleSettingsTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CycleSettings>(
      where: where(CycleSettings.t),
      orderBy: orderBy?.call(CycleSettings.t),
      orderByList: orderByList?.call(CycleSettings.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CycleSettingsTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CycleSettings>(
      where: where?.call(CycleSettings.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CycleSettings] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CycleSettingsTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CycleSettings>(
      where: where(CycleSettings.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
