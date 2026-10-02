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
import 'package:tidal_server/src/generated/digestion/bowel_movement.dart'
    as _ij7z5kq2;
import 'package:tidal_server/src/generated/journal/self_care_activity.dart'
    as _iq27cpnk;
import 'package:tidal_server/src/generated/log/day_log.dart' as _izjvvr32;
import 'package:tidal_server/src/generated/pain/dose_log.dart' as _ixayhju8;
import 'package:tidal_server/src/generated/pain/medication.dart' as _i1bzforx;
import 'package:tidal_server/src/generated/pain/medication_reminder.dart'
    as _iuhzinof;
import 'package:tidal_server/src/generated/pain/pain_entry.dart' as _i0ft3vou;
import 'package:tidal_server/src/generated/pain/pain_location.dart'
    as _iv8cvxsn;
import 'package:tidal_server/src/generated/period/period_span.dart'
    as _iiatq07z;
import 'digestion/bowel_movement.dart' as _i6bfb8vz;
import 'future_calls_generated_models/medication_reminder_future_call_mark_due_model.dart'
    as _i0twoea3;
import 'insights/cycle_settings.dart' as _irypdw9c;
import 'insights/cycle_summary.dart' as _itpp364r;
import 'insights/prediction.dart' as _itygu37j;
import 'insights/temperature_unit.dart' as _ik5b5xgi;
import 'insights/unit_preferences.dart' as _if2yt2rb;
import 'insights/weight_unit.dart' as _ibx9ytzf;
import 'journal/journal_entry.dart' as _iofjnpf3;
import 'journal/self_care_activity.dart' as _idiy7rnf;
import 'log/day_log.dart' as _ig2h1g4e;
import 'log/drink_type.dart' as _ivt7cba4;
import 'log/flow_level.dart' as _i6jt696r;
import 'log/love_type.dart' as _i7ihs2om;
import 'log/mood.dart' as _iyv1k8fz;
import 'log/mucus_type.dart' as _i5pmo1d8;
import 'log/severity.dart' as _ish8wihn;
import 'pain/dose_log.dart' as _ijd9wd5s;
import 'pain/medication.dart' as _ifw90bis;
import 'pain/medication_reminder.dart' as _i85kp92q;
import 'pain/medication_type.dart' as _i47q3b5q;
import 'pain/pain_entry.dart' as _irsb51xy;
import 'pain/pain_location.dart' as _i9r8gfuz;
import 'period/cycle_length.dart' as _i850u96d;
import 'period/period.dart' as _imkg8d7f;
import 'period/period_change.dart' as _i1jla7k1;
import 'period/period_change_kind.dart' as _ik4fqf6t;
import 'period/period_length_info.dart' as _iq6fzgrr;
import 'period/period_span.dart' as _i2feo9ly;
export 'digestion/bowel_movement.dart';
export 'insights/cycle_settings.dart';
export 'insights/cycle_summary.dart';
export 'insights/prediction.dart';
export 'insights/temperature_unit.dart';
export 'insights/unit_preferences.dart';
export 'insights/weight_unit.dart';
export 'journal/journal_entry.dart';
export 'journal/self_care_activity.dart';
export 'log/day_log.dart';
export 'log/drink_type.dart';
export 'log/flow_level.dart';
export 'log/love_type.dart';
export 'log/mood.dart';
export 'log/mucus_type.dart';
export 'log/severity.dart';
export 'pain/dose_log.dart';
export 'pain/medication.dart';
export 'pain/medication_reminder.dart';
export 'pain/medication_type.dart';
export 'pain/pain_entry.dart';
export 'pain/pain_location.dart';
export 'period/cycle_length.dart';
export 'period/period.dart';
export 'period/period_change.dart';
export 'period/period_change_kind.dart';
export 'period/period_length_info.dart';
export 'period/period_span.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'bowel_movement',
      dartName: 'BowelMovement',
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
          name: 'timestamp',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'loggedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'bristolType',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'bowel_movement_user_date_idx',
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
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
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
        _isp.ColumnDefinition(
          name: 'weightUnit',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:WeightUnit',
          columnDefault: '\'kg\'',
        ),
        _isp.ColumnDefinition(
          name: 'temperatureUnit',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TemperatureUnit',
          columnDefault: '\'celsius\'',
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
        _isp.ColumnDefinition(
          name: 'waterGlasses',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'caffeineDrinks',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'alcoholDrinks',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'sleepQuality',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'sleepHours',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'bloating',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:Severity?',
        ),
        _isp.ColumnDefinition(
          name: 'acidReflux',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:Severity?',
        ),
        _isp.ColumnDefinition(
          name: 'weightKg',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'temperatureC',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'mucus',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:MucusType?',
        ),
        _isp.ColumnDefinition(
          name: 'love',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:LoveType?',
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
          name: 'date',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'timestamp',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'loggedAt',
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
      indexes: [
        _isp.IndexDefinition(
          indexName: 'dose_log_user_date_idx',
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
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'journal_entry',
      dartName: 'JournalEntry',
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
          name: 'activities',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:SelfCareActivity>',
        ),
        _isp.ColumnDefinition(
          name: 'bestMoment',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'journal_entry_user_date_idx',
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
        _isp.ColumnDefinition(
          name: 'type',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:MedicationType?',
        ),
        _isp.ColumnDefinition(
          name: 'reminderEveryHours',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'medication_reminder',
      dartName: 'MedicationReminder',
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
          name: 'dueAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'isDue',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'medication_reminder_fk_0',
          columns: ['medicationId'],
          referenceTable: 'medication',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'medication_reminder_medication_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'medicationId',
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
          name: 'date',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'timestamp',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'loggedAt',
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
      indexes: [
        _isp.IndexDefinition(
          indexName: 'pain_entry_user_date_idx',
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
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'period',
      dartName: 'Period',
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
          name: 'startDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'endDate',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'period_user_start_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'userId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'startDate',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
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

    if (t == _i6bfb8vz.BowelMovement) {
      return _i6bfb8vz.BowelMovement.fromJson(data) as T;
    }
    if (t == _i0twoea3.MedicationReminderFutureCallMarkDueModel) {
      return _i0twoea3.MedicationReminderFutureCallMarkDueModel.fromJson(data)
          as T;
    }
    if (t == _irypdw9c.CycleSettings) {
      return _irypdw9c.CycleSettings.fromJson(data) as T;
    }
    if (t == _itpp364r.CycleSummary) {
      return _itpp364r.CycleSummary.fromJson(data) as T;
    }
    if (t == _itygu37j.Prediction) {
      return _itygu37j.Prediction.fromJson(data) as T;
    }
    if (t == _ik5b5xgi.TemperatureUnit) {
      return _ik5b5xgi.TemperatureUnit.fromJson(data) as T;
    }
    if (t == _if2yt2rb.UnitPreferences) {
      return _if2yt2rb.UnitPreferences.fromJson(data) as T;
    }
    if (t == _ibx9ytzf.WeightUnit) {
      return _ibx9ytzf.WeightUnit.fromJson(data) as T;
    }
    if (t == _iofjnpf3.JournalEntry) {
      return _iofjnpf3.JournalEntry.fromJson(data) as T;
    }
    if (t == _idiy7rnf.SelfCareActivity) {
      return _idiy7rnf.SelfCareActivity.fromJson(data) as T;
    }
    if (t == _ig2h1g4e.DayLog) {
      return _ig2h1g4e.DayLog.fromJson(data) as T;
    }
    if (t == _ivt7cba4.DrinkType) {
      return _ivt7cba4.DrinkType.fromJson(data) as T;
    }
    if (t == _i6jt696r.FlowLevel) {
      return _i6jt696r.FlowLevel.fromJson(data) as T;
    }
    if (t == _i7ihs2om.LoveType) {
      return _i7ihs2om.LoveType.fromJson(data) as T;
    }
    if (t == _iyv1k8fz.Mood) {
      return _iyv1k8fz.Mood.fromJson(data) as T;
    }
    if (t == _i5pmo1d8.MucusType) {
      return _i5pmo1d8.MucusType.fromJson(data) as T;
    }
    if (t == _ish8wihn.Severity) {
      return _ish8wihn.Severity.fromJson(data) as T;
    }
    if (t == _ijd9wd5s.DoseLog) {
      return _ijd9wd5s.DoseLog.fromJson(data) as T;
    }
    if (t == _ifw90bis.Medication) {
      return _ifw90bis.Medication.fromJson(data) as T;
    }
    if (t == _i85kp92q.MedicationReminder) {
      return _i85kp92q.MedicationReminder.fromJson(data) as T;
    }
    if (t == _i47q3b5q.MedicationType) {
      return _i47q3b5q.MedicationType.fromJson(data) as T;
    }
    if (t == _irsb51xy.PainEntry) {
      return _irsb51xy.PainEntry.fromJson(data) as T;
    }
    if (t == _i9r8gfuz.PainLocation) {
      return _i9r8gfuz.PainLocation.fromJson(data) as T;
    }
    if (t == _i850u96d.CycleLength) {
      return _i850u96d.CycleLength.fromJson(data) as T;
    }
    if (t == _imkg8d7f.Period) {
      return _imkg8d7f.Period.fromJson(data) as T;
    }
    if (t == _i1jla7k1.PeriodChange) {
      return _i1jla7k1.PeriodChange.fromJson(data) as T;
    }
    if (t == _ik4fqf6t.PeriodChangeKind) {
      return _ik4fqf6t.PeriodChangeKind.fromJson(data) as T;
    }
    if (t == _iq6fzgrr.PeriodLengthInfo) {
      return _iq6fzgrr.PeriodLengthInfo.fromJson(data) as T;
    }
    if (t == _i2feo9ly.PeriodSpan) {
      return _i2feo9ly.PeriodSpan.fromJson(data) as T;
    }
    if (t == _is.getType<_i6bfb8vz.BowelMovement?>()) {
      return (data != null ? _i6bfb8vz.BowelMovement.fromJson(data) : null)
          as T;
    }
    if (t ==
        _is.getType<_i0twoea3.MedicationReminderFutureCallMarkDueModel?>()) {
      return (data != null
              ? _i0twoea3.MedicationReminderFutureCallMarkDueModel.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _is.getType<_irypdw9c.CycleSettings?>()) {
      return (data != null ? _irypdw9c.CycleSettings.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itpp364r.CycleSummary?>()) {
      return (data != null ? _itpp364r.CycleSummary.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_itygu37j.Prediction?>()) {
      return (data != null ? _itygu37j.Prediction.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ik5b5xgi.TemperatureUnit?>()) {
      return (data != null ? _ik5b5xgi.TemperatureUnit.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_if2yt2rb.UnitPreferences?>()) {
      return (data != null ? _if2yt2rb.UnitPreferences.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibx9ytzf.WeightUnit?>()) {
      return (data != null ? _ibx9ytzf.WeightUnit.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iofjnpf3.JournalEntry?>()) {
      return (data != null ? _iofjnpf3.JournalEntry.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idiy7rnf.SelfCareActivity?>()) {
      return (data != null ? _idiy7rnf.SelfCareActivity.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ig2h1g4e.DayLog?>()) {
      return (data != null ? _ig2h1g4e.DayLog.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivt7cba4.DrinkType?>()) {
      return (data != null ? _ivt7cba4.DrinkType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6jt696r.FlowLevel?>()) {
      return (data != null ? _i6jt696r.FlowLevel.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7ihs2om.LoveType?>()) {
      return (data != null ? _i7ihs2om.LoveType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyv1k8fz.Mood?>()) {
      return (data != null ? _iyv1k8fz.Mood.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5pmo1d8.MucusType?>()) {
      return (data != null ? _i5pmo1d8.MucusType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ish8wihn.Severity?>()) {
      return (data != null ? _ish8wihn.Severity.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijd9wd5s.DoseLog?>()) {
      return (data != null ? _ijd9wd5s.DoseLog.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifw90bis.Medication?>()) {
      return (data != null ? _ifw90bis.Medication.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i85kp92q.MedicationReminder?>()) {
      return (data != null ? _i85kp92q.MedicationReminder.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i47q3b5q.MedicationType?>()) {
      return (data != null ? _i47q3b5q.MedicationType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irsb51xy.PainEntry?>()) {
      return (data != null ? _irsb51xy.PainEntry.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9r8gfuz.PainLocation?>()) {
      return (data != null ? _i9r8gfuz.PainLocation.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i850u96d.CycleLength?>()) {
      return (data != null ? _i850u96d.CycleLength.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_imkg8d7f.Period?>()) {
      return (data != null ? _imkg8d7f.Period.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1jla7k1.PeriodChange?>()) {
      return (data != null ? _i1jla7k1.PeriodChange.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ik4fqf6t.PeriodChangeKind?>()) {
      return (data != null ? _ik4fqf6t.PeriodChangeKind.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iq6fzgrr.PeriodLengthInfo?>()) {
      return (data != null ? _iq6fzgrr.PeriodLengthInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2feo9ly.PeriodSpan?>()) {
      return (data != null ? _i2feo9ly.PeriodSpan.fromJson(data) : null) as T;
    }
    if (t == List<_i850u96d.CycleLength>) {
      return (data as List)
              .map((e) => deserialize<_i850u96d.CycleLength>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i850u96d.CycleLength>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i850u96d.CycleLength>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_idiy7rnf.SelfCareActivity>) {
      return (data as List)
              .map((e) => deserialize<_idiy7rnf.SelfCareActivity>(e))
              .toList()
          as T;
    }
    if (t == List<_i9r8gfuz.PainLocation>) {
      return (data as List)
              .map((e) => deserialize<_i9r8gfuz.PainLocation>(e))
              .toList()
          as T;
    }
    if (t == List<_ij7z5kq2.BowelMovement>) {
      return (data as List)
              .map((e) => deserialize<_ij7z5kq2.BowelMovement>(e))
              .toList()
          as T;
    }
    if (t == List<_iq27cpnk.SelfCareActivity>) {
      return (data as List)
              .map((e) => deserialize<_iq27cpnk.SelfCareActivity>(e))
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
    if (t == List<_iuhzinof.MedicationReminder>) {
      return (data as List)
              .map((e) => deserialize<_iuhzinof.MedicationReminder>(e))
              .toList()
          as T;
    }
    if (t == List<_ixayhju8.DoseLog>) {
      return (data as List)
              .map((e) => deserialize<_ixayhju8.DoseLog>(e))
              .toList()
          as T;
    }
    if (t == List<_iiatq07z.PeriodSpan>) {
      return (data as List)
              .map((e) => deserialize<_iiatq07z.PeriodSpan>(e))
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
      _i6bfb8vz.BowelMovement => 'BowelMovement',
      _i0twoea3.MedicationReminderFutureCallMarkDueModel =>
        'MedicationReminderFutureCallMarkDueModel',
      _irypdw9c.CycleSettings => 'CycleSettings',
      _itpp364r.CycleSummary => 'CycleSummary',
      _itygu37j.Prediction => 'Prediction',
      _ik5b5xgi.TemperatureUnit => 'TemperatureUnit',
      _if2yt2rb.UnitPreferences => 'UnitPreferences',
      _ibx9ytzf.WeightUnit => 'WeightUnit',
      _iofjnpf3.JournalEntry => 'JournalEntry',
      _idiy7rnf.SelfCareActivity => 'SelfCareActivity',
      _ig2h1g4e.DayLog => 'DayLog',
      _ivt7cba4.DrinkType => 'DrinkType',
      _i6jt696r.FlowLevel => 'FlowLevel',
      _i7ihs2om.LoveType => 'LoveType',
      _iyv1k8fz.Mood => 'Mood',
      _i5pmo1d8.MucusType => 'MucusType',
      _ish8wihn.Severity => 'Severity',
      _ijd9wd5s.DoseLog => 'DoseLog',
      _ifw90bis.Medication => 'Medication',
      _i85kp92q.MedicationReminder => 'MedicationReminder',
      _i47q3b5q.MedicationType => 'MedicationType',
      _irsb51xy.PainEntry => 'PainEntry',
      _i9r8gfuz.PainLocation => 'PainLocation',
      _i850u96d.CycleLength => 'CycleLength',
      _imkg8d7f.Period => 'Period',
      _i1jla7k1.PeriodChange => 'PeriodChange',
      _ik4fqf6t.PeriodChangeKind => 'PeriodChangeKind',
      _iq6fzgrr.PeriodLengthInfo => 'PeriodLengthInfo',
      _i2feo9ly.PeriodSpan => 'PeriodSpan',
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
      case _i6bfb8vz.BowelMovement():
        return 'BowelMovement';
      case _i0twoea3.MedicationReminderFutureCallMarkDueModel():
        return 'MedicationReminderFutureCallMarkDueModel';
      case _irypdw9c.CycleSettings():
        return 'CycleSettings';
      case _itpp364r.CycleSummary():
        return 'CycleSummary';
      case _itygu37j.Prediction():
        return 'Prediction';
      case _ik5b5xgi.TemperatureUnit():
        return 'TemperatureUnit';
      case _if2yt2rb.UnitPreferences():
        return 'UnitPreferences';
      case _ibx9ytzf.WeightUnit():
        return 'WeightUnit';
      case _iofjnpf3.JournalEntry():
        return 'JournalEntry';
      case _idiy7rnf.SelfCareActivity():
        return 'SelfCareActivity';
      case _ig2h1g4e.DayLog():
        return 'DayLog';
      case _ivt7cba4.DrinkType():
        return 'DrinkType';
      case _i6jt696r.FlowLevel():
        return 'FlowLevel';
      case _i7ihs2om.LoveType():
        return 'LoveType';
      case _iyv1k8fz.Mood():
        return 'Mood';
      case _i5pmo1d8.MucusType():
        return 'MucusType';
      case _ish8wihn.Severity():
        return 'Severity';
      case _ijd9wd5s.DoseLog():
        return 'DoseLog';
      case _ifw90bis.Medication():
        return 'Medication';
      case _i85kp92q.MedicationReminder():
        return 'MedicationReminder';
      case _i47q3b5q.MedicationType():
        return 'MedicationType';
      case _irsb51xy.PainEntry():
        return 'PainEntry';
      case _i9r8gfuz.PainLocation():
        return 'PainLocation';
      case _i850u96d.CycleLength():
        return 'CycleLength';
      case _imkg8d7f.Period():
        return 'Period';
      case _i1jla7k1.PeriodChange():
        return 'PeriodChange';
      case _ik4fqf6t.PeriodChangeKind():
        return 'PeriodChangeKind';
      case _iq6fzgrr.PeriodLengthInfo():
        return 'PeriodLengthInfo';
      case _i2feo9ly.PeriodSpan():
        return 'PeriodSpan';
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
    if (dataClassName == 'BowelMovement') {
      return deserialize<_i6bfb8vz.BowelMovement>(data['data']);
    }
    if (dataClassName == 'MedicationReminderFutureCallMarkDueModel') {
      return deserialize<_i0twoea3.MedicationReminderFutureCallMarkDueModel>(
        data['data'],
      );
    }
    if (dataClassName == 'CycleSettings') {
      return deserialize<_irypdw9c.CycleSettings>(data['data']);
    }
    if (dataClassName == 'CycleSummary') {
      return deserialize<_itpp364r.CycleSummary>(data['data']);
    }
    if (dataClassName == 'Prediction') {
      return deserialize<_itygu37j.Prediction>(data['data']);
    }
    if (dataClassName == 'TemperatureUnit') {
      return deserialize<_ik5b5xgi.TemperatureUnit>(data['data']);
    }
    if (dataClassName == 'UnitPreferences') {
      return deserialize<_if2yt2rb.UnitPreferences>(data['data']);
    }
    if (dataClassName == 'WeightUnit') {
      return deserialize<_ibx9ytzf.WeightUnit>(data['data']);
    }
    if (dataClassName == 'JournalEntry') {
      return deserialize<_iofjnpf3.JournalEntry>(data['data']);
    }
    if (dataClassName == 'SelfCareActivity') {
      return deserialize<_idiy7rnf.SelfCareActivity>(data['data']);
    }
    if (dataClassName == 'DayLog') {
      return deserialize<_ig2h1g4e.DayLog>(data['data']);
    }
    if (dataClassName == 'DrinkType') {
      return deserialize<_ivt7cba4.DrinkType>(data['data']);
    }
    if (dataClassName == 'FlowLevel') {
      return deserialize<_i6jt696r.FlowLevel>(data['data']);
    }
    if (dataClassName == 'LoveType') {
      return deserialize<_i7ihs2om.LoveType>(data['data']);
    }
    if (dataClassName == 'Mood') {
      return deserialize<_iyv1k8fz.Mood>(data['data']);
    }
    if (dataClassName == 'MucusType') {
      return deserialize<_i5pmo1d8.MucusType>(data['data']);
    }
    if (dataClassName == 'Severity') {
      return deserialize<_ish8wihn.Severity>(data['data']);
    }
    if (dataClassName == 'DoseLog') {
      return deserialize<_ijd9wd5s.DoseLog>(data['data']);
    }
    if (dataClassName == 'Medication') {
      return deserialize<_ifw90bis.Medication>(data['data']);
    }
    if (dataClassName == 'MedicationReminder') {
      return deserialize<_i85kp92q.MedicationReminder>(data['data']);
    }
    if (dataClassName == 'MedicationType') {
      return deserialize<_i47q3b5q.MedicationType>(data['data']);
    }
    if (dataClassName == 'PainEntry') {
      return deserialize<_irsb51xy.PainEntry>(data['data']);
    }
    if (dataClassName == 'PainLocation') {
      return deserialize<_i9r8gfuz.PainLocation>(data['data']);
    }
    if (dataClassName == 'CycleLength') {
      return deserialize<_i850u96d.CycleLength>(data['data']);
    }
    if (dataClassName == 'Period') {
      return deserialize<_imkg8d7f.Period>(data['data']);
    }
    if (dataClassName == 'PeriodChange') {
      return deserialize<_i1jla7k1.PeriodChange>(data['data']);
    }
    if (dataClassName == 'PeriodChangeKind') {
      return deserialize<_ik4fqf6t.PeriodChangeKind>(data['data']);
    }
    if (dataClassName == 'PeriodLengthInfo') {
      return deserialize<_iq6fzgrr.PeriodLengthInfo>(data['data']);
    }
    if (dataClassName == 'PeriodSpan') {
      return deserialize<_i2feo9ly.PeriodSpan>(data['data']);
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
      case _i6bfb8vz.BowelMovement:
        return _i6bfb8vz.BowelMovement.t;
      case _irypdw9c.CycleSettings:
        return _irypdw9c.CycleSettings.t;
      case _iofjnpf3.JournalEntry:
        return _iofjnpf3.JournalEntry.t;
      case _ig2h1g4e.DayLog:
        return _ig2h1g4e.DayLog.t;
      case _ijd9wd5s.DoseLog:
        return _ijd9wd5s.DoseLog.t;
      case _ifw90bis.Medication:
        return _ifw90bis.Medication.t;
      case _i85kp92q.MedicationReminder:
        return _i85kp92q.MedicationReminder.t;
      case _irsb51xy.PainEntry:
        return _irsb51xy.PainEntry.t;
      case _imkg8d7f.Period:
        return _imkg8d7f.Period.t;
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
