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

/// An entry in the user's own "my meds" list. Tidal only ever records what
/// the user says they took; it never suggests doses.
abstract class Medication
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Medication._({
    this.id,
    required this.userId,
    required this.name,
    required this.usualDose,
  });

  factory Medication({
    int? id,
    required _isc.UuidValue userId,
    required String name,
    required String usualDose,
  }) = _MedicationImpl;

  factory Medication.fromJson(Map<String, dynamic> jsonSerialization) {
    return Medication(
      id: jsonSerialization['id'] as int?,
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      usualDose: jsonSerialization['usualDose'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The user this medication belongs to.
  _isc.UuidValue userId;

  /// E.g. "Ibuprofen".
  String name;

  /// Free text, e.g. "400 mg". Shown next to the name and copied onto each
  /// dose log unless the user says otherwise.
  String usualDose;

  /// Returns a shallow copy of this [Medication]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Medication copyWith({
    int? id,
    _isc.UuidValue? userId,
    String? name,
    String? usualDose,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Medication',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      'name': name,
      'usualDose': usualDose,
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
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MedicationImpl extends Medication {
  _MedicationImpl({
    int? id,
    required _isc.UuidValue userId,
    required String name,
    required String usualDose,
  }) : super._(
         id: id,
         userId: userId,
         name: name,
         usualDose: usualDose,
       );

  /// Returns a shallow copy of this [Medication]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Medication copyWith({
    Object? id = _Undefined,
    _isc.UuidValue? userId,
    String? name,
    String? usualDose,
  }) {
    return Medication(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      usualDose: usualDose ?? this.usualDose,
    );
  }
}
