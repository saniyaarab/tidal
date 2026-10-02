/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'package:tidal_server/src/generated/log/day_log.dart' as _izjvvr32;
import 'package:tidal_server/src/generated/pain/dose_log.dart' as _ixayhju8;
import 'package:tidal_server/src/generated/pain/medication.dart' as _i1bzforx;
import 'package:tidal_server/src/generated/pain/pain_entry.dart' as _i0ft3vou;
import 'package:tidal_server/src/generated/pain/pain_location.dart'
    as _iv8cvxsn;
import 'future_calls_generated_models/check_in_future_call_check_model.dart'
    as _iy7j8eve;
import 'insights/cycle_settings.dart' as _irypdw9c;
import 'insights/prediction.dart' as _itygu37j;
import 'log/day_log.dart' as _ig2h1g4e;
import 'log/flow_level.dart' as _i6jt696r;
import 'log/mood.dart' as _iyv1k8fz;
import 'pain/dose_log.dart' as _ijd9wd5s;
import 'pain/medication.dart' as _ifw90bis;
import 'pain/pain_entry.dart' as _irsb51xy;
import 'pain/pain_location.dart' as _i9r8gfuz;
export 'insights/cycle_settings.dart';
export 'insights/prediction.dart';
export 'log/day_log.dart';
export 'log/flow_level.dart';
export 'log/mood.dart';
export 'pain/dose_log.dart';
export 'pain/medication.dart';
export 'pain/pain_entry.dart';
export 'pain/pain_location.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'cycle_settings',
      dartName: 'CycleSettings',
      schema: 'public',
      module: 'tidal',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'typicalCycleDays',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '28',
        ),
        _isp.ColumnDefinition(
          name: 'typicalPeriodDays',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '5',
        ),
        _isp.ColumnDefinition(
          name: 'birthYear',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'cycle_settings_user_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'day_log',
      dartName: 'DayLog',
      schema: 'public',
      module: 'tidal',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'date',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'flow',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:FlowLevel',
          columnDefault: '\'none\'',
        ),
        _isp.ColumnDefinition(
          name: 'mood',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:Mood?',
        ),
        _isp.ColumnDefinition(
          name: 'note',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'day_log_user_date_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'date',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'dose_log',
      dartName: 'DoseLog',
      schema: 'public',
      module: 'tidal',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'medicationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'timestamp',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'dose',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'painBefore',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'painAfter',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'checkInDue',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'dose_log_fk_0',
          columns: ['medicationId'],
          referenceTable: 'medication',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'medication',
      dartName: 'Medication',
      schema: 'public',
      module: 'tidal',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'usualDose',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'pain_entry',
      dartName: 'PainEntry',
      schema: 'public',
      module: 'tidal',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'timestamp',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'level',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'locations',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:PainLocation>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iy7j8eve.CheckInFutureCallCheckModel) {
      return _iy7j8eve.CheckInFutureCallCheckModel.fromJson(data) as T;
    }
    if (t == _irypdw9c.CycleSettings) {
      return _irypdw9c.CycleSettings.fromJson(data) as T;
    }
    if (t == _itygu37j.Prediction) {
      return _itygu37j.Prediction.fromJson(data) as T;
    }
    if (t == _ig2h1g4e.DayLog) {
      return _ig2h1g4e.DayLog.fromJson(data) as T;
    }
    if (t == _i6jt696r.FlowLevel) {
      return _i6jt696r.FlowLevel.fromJson(data) as T;
    }
    if (t == _iyv1k8fz.Mood) {
      return _iyv1k8fz.Mood.fromJson(data) as T;
    }
    if (t == _ijd9wd5s.DoseLog) {
      return _ijd9wd5s.DoseLog.fromJson(data) as T;
    }
    if (t == _ifw90bis.Medication) {
      return _ifw90bis.Medication.fromJson(data) as T;
    }
    if (t == _irsb51xy.PainEntry) {
      return _irsb51xy.PainEntry.fromJson(data) as T;
    }
    if (t == _i9r8gfuz.PainLocation) {
      return _i9r8gfuz.PainLocation.fromJson(data) as T;
    }
    if (t == _is.getType<_iy7j8eve.CheckInFutureCallCheckModel?>()) {
      return (data != null
              ? _iy7j8eve.CheckInFutureCallCheckModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_irypdw9c.CycleSettings?>()) {
      return (data != null ? _irypdw9c.CycleSettings.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itygu37j.Prediction?>()) {
      return (data != null ? _itygu37j.Prediction.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ig2h1g4e.DayLog?>()) {
      return (data != null ? _ig2h1g4e.DayLog.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6jt696r.FlowLevel?>()) {
      return (data != null ? _i6jt696r.FlowLevel.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyv1k8fz.Mood?>()) {
      return (data != null ? _iyv1k8fz.Mood.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijd9wd5s.DoseLog?>()) {
      return (data != null ? _ijd9wd5s.DoseLog.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifw90bis.Medication?>()) {
      return (data != null ? _ifw90bis.Medication.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irsb51xy.PainEntry?>()) {
      return (data != null ? _irsb51xy.PainEntry.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9r8gfuz.PainLocation?>()) {
      return (data != null ? _i9r8gfuz.PainLocation.fromJson(data) : null) as T;
    }
    if (t == List<_i9r8gfuz.PainLocation>) {
      return (data as List)
              .map((e) => deserialize<_i9r8gfuz.PainLocation>(e))
              .toList()
          as T;
    }
    if (t == List<_izjvvr32.DayLog>) {
      return (data as List)
              .map((e) => deserialize<_izjvvr32.DayLog>(e))
              .toList()
          as T;
    }
    if (t == List<_iv8cvxsn.PainLocation>) {
      return (data as List)
              .map((e) => deserialize<_iv8cvxsn.PainLocation>(e))
              .toList()
          as T;
    }
    if (t == List<_i0ft3vou.PainEntry>) {
      return (data as List)
              .map((e) => deserialize<_i0ft3vou.PainEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i1bzforx.Medication>) {
      return (data as List)
              .map((e) => deserialize<_i1bzforx.Medication>(e))
              .toList()
          as T;
    }
    if (t == List<_ixayhju8.DoseLog>) {
      return (data as List)
              .map((e) => deserialize<_ixayhju8.DoseLog>(e))
              .toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iy7j8eve.CheckInFutureCallCheckModel => 'CheckInFutureCallCheckModel',
      _irypdw9c.CycleSettings => 'CycleSettings',
      _itygu37j.Prediction => 'Prediction',
      _ig2h1g4e.DayLog => 'DayLog',
      _i6jt696r.FlowLevel => 'FlowLevel',
      _iyv1k8fz.Mood => 'Mood',
      _ijd9wd5s.DoseLog => 'DoseLog',
      _ifw90bis.Medication => 'Medication',
      _irsb51xy.PainEntry => 'PainEntry',
      _i9r8gfuz.PainLocation => 'PainLocation',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('tidal.', '');
    }

    switch (data) {
      case _iy7j8eve.CheckInFutureCallCheckModel():
        return 'CheckInFutureCallCheckModel';
      case _irypdw9c.CycleSettings():
        return 'CycleSettings';
      case _itygu37j.Prediction():
        return 'Prediction';
      case _ig2h1g4e.DayLog():
        return 'DayLog';
      case _i6jt696r.FlowLevel():
        return 'FlowLevel';
      case _iyv1k8fz.Mood():
        return 'Mood';
      case _ijd9wd5s.DoseLog():
        return 'DoseLog';
      case _ifw90bis.Medication():
        return 'Medication';
      case _irsb51xy.PainEntry():
        return 'PainEntry';
      case _i9r8gfuz.PainLocation():
        return 'PainLocation';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CheckInFutureCallCheckModel') {
      return deserialize<_iy7j8eve.CheckInFutureCallCheckModel>(data['data']);
    }
    if (dataClassName == 'CycleSettings') {
      return deserialize<_irypdw9c.CycleSettings>(data['data']);
    }
    if (dataClassName == 'Prediction') {
      return deserialize<_itygu37j.Prediction>(data['data']);
    }
    if (dataClassName == 'DayLog') {
      return deserialize<_ig2h1g4e.DayLog>(data['data']);
    }
    if (dataClassName == 'FlowLevel') {
      return deserialize<_i6jt696r.FlowLevel>(data['data']);
    }
    if (dataClassName == 'Mood') {
      return deserialize<_iyv1k8fz.Mood>(data['data']);
    }
    if (dataClassName == 'DoseLog') {
      return deserialize<_ijd9wd5s.DoseLog>(data['data']);
    }
    if (dataClassName == 'Medication') {
      return deserialize<_ifw90bis.Medication>(data['data']);
    }
    if (dataClassName == 'PainEntry') {
      return deserialize<_irsb51xy.PainEntry>(data['data']);
    }
    if (dataClassName == 'PainLocation') {
      return deserialize<_i9r8gfuz.PainLocation>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('tidal', this);
    _iacs.Protocol().registerHostProtocol('tidal', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _irypdw9c.CycleSettings:
        return _irypdw9c.CycleSettings.t;
      case _ig2h1g4e.DayLog:
        return _ig2h1g4e.DayLog.t;
      case _ijd9wd5s.DoseLog:
        return _ijd9wd5s.DoseLog.t;
      case _ifw90bis.Medication:
        return _ifw90bis.Medication.t;
      case _irsb51xy.PainEntry:
        return _irsb51xy.PainEntry.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'tidal';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
