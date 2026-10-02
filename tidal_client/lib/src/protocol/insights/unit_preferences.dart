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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../insights/temperature_unit.dart' as _ic708v43;
import '../insights/weight_unit.dart' as _iq9jtd14;

/// The units the user has chosen in the Weight and Temperature sheets.
abstract class UnitPreferences
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UnitPreferences._({
    required this.weightUnit,
    required this.temperatureUnit,
  });

  factory UnitPreferences({
    required _iq9jtd14.WeightUnit weightUnit,
    required _ic708v43.TemperatureUnit temperatureUnit,
  }) = _UnitPreferencesImpl;

  factory UnitPreferences.fromJson(Map<String, dynamic> jsonSerialization) {
    return UnitPreferences(
      weightUnit: _iq9jtd14.WeightUnit.fromJson(
        (jsonSerialization['weightUnit'] as String),
      ),
      temperatureUnit: _ic708v43.TemperatureUnit.fromJson(
        (jsonSerialization['temperatureUnit'] as String),
      ),
    );
  }

  _iq9jtd14.WeightUnit weightUnit;

  _ic708v43.TemperatureUnit temperatureUnit;

  /// Returns a shallow copy of this [UnitPreferences]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UnitPreferences copyWith({
    _iq9jtd14.WeightUnit? weightUnit,
    _ic708v43.TemperatureUnit? temperatureUnit,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UnitPreferences',
      'weightUnit': weightUnit.toJson(),
      'temperatureUnit': temperatureUnit.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UnitPreferences',
      'weightUnit': weightUnit.toJson(),
      'temperatureUnit': temperatureUnit.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _UnitPreferencesImpl extends UnitPreferences {
  _UnitPreferencesImpl({
    required _iq9jtd14.WeightUnit weightUnit,
    required _ic708v43.TemperatureUnit temperatureUnit,
  }) : super._(
         weightUnit: weightUnit,
         temperatureUnit: temperatureUnit,
       );

  /// Returns a shallow copy of this [UnitPreferences]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UnitPreferences copyWith({
    _iq9jtd14.WeightUnit? weightUnit,
    _ic708v43.TemperatureUnit? temperatureUnit,
  }) {
    return UnitPreferences(
      weightUnit: weightUnit ?? this.weightUnit,
      temperatureUnit: temperatureUnit ?? this.temperatureUnit,
    );
  }
}
