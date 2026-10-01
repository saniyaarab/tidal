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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:tidal_client/src/protocol/log/day_log.dart' as _i91iyawq;
import 'package:tidal_client/src/protocol/pain/dose_log.dart' as _i95dlci0;
import 'package:tidal_client/src/protocol/pain/medication.dart' as _i2f8rdmx;
import 'package:tidal_client/src/protocol/pain/pain_entry.dart' as _imzr3ook;
import 'package:tidal_client/src/protocol/pain/pain_location.dart' as _ivkbsfwn;
import 'log/day_log.dart' as _ig2h1g4e;
import 'log/flow_level.dart' as _i6jt696r;
import 'log/mood.dart' as _iyv1k8fz;
import 'pain/dose_log.dart' as _ijd9wd5s;
import 'pain/medication.dart' as _ifw90bis;
import 'pain/pain_entry.dart' as _irsb51xy;
import 'pain/pain_location.dart' as _i9r8gfuz;
export 'log/day_log.dart';
export 'log/flow_level.dart';
export 'log/mood.dart';
export 'pain/dose_log.dart';
export 'pain/medication.dart';
export 'pain/pain_entry.dart';
export 'pain/pain_location.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

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
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
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
    if (t == _isc.getType<_ig2h1g4e.DayLog?>()) {
      return (data != null ? _ig2h1g4e.DayLog.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6jt696r.FlowLevel?>()) {
      return (data != null ? _i6jt696r.FlowLevel.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyv1k8fz.Mood?>()) {
      return (data != null ? _iyv1k8fz.Mood.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ijd9wd5s.DoseLog?>()) {
      return (data != null ? _ijd9wd5s.DoseLog.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifw90bis.Medication?>()) {
      return (data != null ? _ifw90bis.Medication.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_irsb51xy.PainEntry?>()) {
      return (data != null ? _irsb51xy.PainEntry.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i9r8gfuz.PainLocation?>()) {
      return (data != null ? _i9r8gfuz.PainLocation.fromJson(data) : null) as T;
    }
    if (t == List<_i9r8gfuz.PainLocation>) {
      return (data as List)
              .map((e) => deserialize<_i9r8gfuz.PainLocation>(e))
              .toList()
          as T;
    }
    if (t == List<_i91iyawq.DayLog>) {
      return (data as List)
              .map((e) => deserialize<_i91iyawq.DayLog>(e))
              .toList()
          as T;
    }
    if (t == List<_ivkbsfwn.PainLocation>) {
      return (data as List)
              .map((e) => deserialize<_ivkbsfwn.PainLocation>(e))
              .toList()
          as T;
    }
    if (t == List<_imzr3ook.PainEntry>) {
      return (data as List)
              .map((e) => deserialize<_imzr3ook.PainEntry>(e))
              .toList()
          as T;
    }
    if (t == List<_i2f8rdmx.Medication>) {
      return (data as List)
              .map((e) => deserialize<_i2f8rdmx.Medication>(e))
              .toList()
          as T;
    }
    if (t == List<_i95dlci0.DoseLog>) {
      return (data as List)
              .map((e) => deserialize<_i95dlci0.DoseLog>(e))
              .toList()
          as T;
    }
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
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
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
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
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('tidal', this);
    _iacc.Protocol().registerHostProtocol('tidal', this);
  }

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
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
