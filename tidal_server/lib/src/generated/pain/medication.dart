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
import '../pain/medication_type.dart' as _ib85fggv;

/// An entry in the user's own medications list: anything they take, from
/// painkillers to birth control or vitamins. Remembered so it's one tap to
/// log next time (and, later, for reminders). Tidal only ever records what
/// the user says they took; it never suggests doses.
abstract class Medication
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  Medication._({
    this.id,
    required this.userId,
    required this.name,
    required this.usualDose,
    this.type,
  });

  factory Medication({
    int? id,
    required _is.UuidValue userId,
    required String name,
    required String usualDose,
    _ib85fggv.MedicationType? type,
  }) = _MedicationImpl;

  factory Medication.fromJson(Map<String, dynamic> jsonSerialization) {
    return Medication(
      id: jsonSerialization['id'] as int?,
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      usualDose: jsonSerialization['usualDose'] as String,
      type: jsonSerialization['type'] == null
          ? null
          : _ib85fggv.MedicationType.fromJson(
              (jsonSerialization['type'] as String),
            ),
    );
  }

  static final t = MedicationTable();

  static const db = MedicationRepository._();

  @override
  int? id;

  /// The user this medication belongs to.
  _is.UuidValue userId;

  /// E.g. "Ibuprofen".
  String name;

  /// Free text, e.g. "400 mg". Shown next to the name and copied onto each
  /// dose log.
  String usualDose;

  /// What kind of medication it is, if the user said.
  _ib85fggv.MedicationType? type;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [Medication]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Medication copyWith({
    int? id,
    _is.UuidValue? userId,
    String? name,
    String? usualDose,
    _ib85fggv.MedicationType? type,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Medication',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'name': name,
      'usualDose': usualDose,
      if (type != null) 'type': type?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Medication',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'name': name,
      'usualDose': usualDose,
      if (type != null) 'type': type?.toJson(),
    };
  }

  static MedicationInclude include() {
    return MedicationInclude._();
  }

  static MedicationIncludeList includeList({
    _is.WhereExpressionBuilder<MedicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    MedicationInclude? include,
  }) {
    return MedicationIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MedicationImpl extends Medication {
  _MedicationImpl({
    int? id,
    required _is.UuidValue userId,
    required String name,
    required String usualDose,
    _ib85fggv.MedicationType? type,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         usualDose: usualDose,
         type: type,
       );

  /// Returns a shallow copy of this [Medication]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Medication copyWith({
    Object? id = _Undefined,
    _is.UuidValue? userId,
    String? name,
    String? usualDose,
    Object? type = _Undefined,
  }) {
    return Medication(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      usualDose: usualDose ?? this.usualDose,
      type: type is _ib85fggv.MedicationType? ? type : this.type,
    );
  }
}

class MedicationUpdateTable extends _is.UpdateTable<MedicationTable> {
  MedicationUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.userId,
        value,
      );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> usualDose(String value) => _is.ColumnValue(
    table.usualDose,
    value,
  );

  _is.ColumnValue<_ib85fggv.MedicationType, _ib85fggv.MedicationType> type(
    _ib85fggv.MedicationType? value,
  ) => _is.ColumnValue(
    table.type,
    value,
  );
}

class MedicationTable extends _is.Table<int?> {
  MedicationTable({super.tableRelation}) : super(tableName: 'medication') {
    updateTable = MedicationUpdateTable(this);
    userId = _is.ColumnUuid(
      'userId',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    usualDose = _is.ColumnString(
      'usualDose',
      this,
    );
    type = _is.ColumnEnum(
      'type',
      this,
      _is.EnumSerialization.byName,
    );
  }

  late final MedicationUpdateTable updateTable;

  /// The user this medication belongs to.
  late final _is.ColumnUuid userId;

  /// E.g. "Ibuprofen".
  late final _is.ColumnString name;

  /// Free text, e.g. "400 mg". Shown next to the name and copied onto each
  /// dose log.
  late final _is.ColumnString usualDose;

  /// What kind of medication it is, if the user said.
  late final _is.ColumnEnum<_ib85fggv.MedicationType> type;

  @override
  List<_is.Column> get columns => [
    id,
    userId,
    name,
    usualDose,
    type,
  ];
}

class MedicationInclude extends _is.IncludeObject {
  MedicationInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => Medication.t;
}

class MedicationIncludeList extends _is.IncludeList {
  MedicationIncludeList._({
    _is.WhereExpressionBuilder<MedicationTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Medication.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => Medication.t;
}

class MedicationRepository {
  const MedicationRepository._();

  /// Returns a list of [Medication]s matching the given query parameters.
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
  Future<List<Medication>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MedicationTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Medication>(
      where: where?.call(Medication.t),
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Medication] matching the given query parameters.
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
  Future<Medication?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MedicationTable>? where,
    int? offset,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Medication>(
      where: where?.call(Medication.t),
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Medication] by its [id] or null if no such row exists.
  Future<Medication?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Medication>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Medication]s in the list and returns the inserted rows.
  ///
  /// The returned [Medication]s will have their `id` fields set.
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
  Future<List<Medication>> insert(
    _is.DatabaseSession session,
    List<Medication> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Medication>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Medication] and returns the inserted row.
  ///
  /// The returned [Medication] will have its `id` field set.
  Future<Medication> insertRow(
    _is.DatabaseSession session,
    Medication row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Medication>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Medication]s in the list and returns the resulting rows.
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
  /// The returned [Medication]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Medication>> upsert(
    _is.DatabaseSession session,
    List<Medication> rows, {
    required _is.ColumnSelections<MedicationTable> conflictColumns,
    _is.ColumnSelections<MedicationTable>? updateColumns,
    _is.WhereExpressionBuilder<MedicationTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Medication>(
      rows,
      conflictColumns: conflictColumns(Medication.t),
      updateColumns: updateColumns?.call(Medication.t),
      updateWhere: updateWhere?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Medication] and returns the resulting row.
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
  /// The returned [Medication] will have its `id` field set.
  Future<Medication?> upsertRow(
    _is.DatabaseSession session,
    Medication row, {
    required _is.ColumnSelections<MedicationTable> conflictColumns,
    _is.ColumnSelections<MedicationTable>? updateColumns,
    _is.WhereExpressionBuilder<MedicationTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Medication>(
      row,
      conflictColumns: conflictColumns(Medication.t),
      updateColumns: updateColumns?.call(Medication.t),
      updateWhere: updateWhere?.call(Medication.t),
      transaction: transaction,
    );
  }

  /// Updates all [Medication]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Medication>> update(
    _is.DatabaseSession session,
    List<Medication> rows, {
    _is.ColumnSelections<MedicationTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Medication>(
      rows,
      columns: columns?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Medication]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Medication> updateRow(
    _is.DatabaseSession session,
    Medication row, {
    _is.ColumnSelections<MedicationTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Medication>(
      row,
      columns: columns?.call(Medication.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Medication] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Medication?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MedicationUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Medication>(
      id,
      columnValues: columnValues(Medication.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Medication]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Medication>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MedicationUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MedicationTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Medication>(
      columnValues: columnValues(Medication.t.updateTable),
      where: where(Medication.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Medication]s in the list and returns the deleted rows.
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
  Future<List<Medication>> delete(
    _is.DatabaseSession session,
    List<Medication> rows, {
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Medication>(
      rows,
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Medication].
  Future<Medication> deleteRow(
    _is.DatabaseSession session,
    Medication row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Medication>(
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
  Future<List<Medication>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MedicationTable> where,
    _is.OrderByBuilder<MedicationTable>? orderBy,
    _is.OrderByListBuilder<MedicationTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Medication>(
      where: where(Medication.t),
      orderBy: orderBy?.call(Medication.t),
      orderByList: orderByList?.call(Medication.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MedicationTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Medication>(
      where: where?.call(Medication.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Medication] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MedicationTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Medication>(
      where: where(Medication.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
