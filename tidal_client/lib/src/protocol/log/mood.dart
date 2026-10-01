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

/// The user's overall mood for a day.
enum Mood implements _isc.SerializableModel {
  happy,
  calm,
  tired,
  irritated,
  sad,
  anxious;

  static Mood fromJson(String name) {
    switch (name) {
      case 'happy':
        return Mood.happy;
      case 'calm':
        return Mood.calm;
      case 'tired':
        return Mood.tired;
      case 'irritated':
        return Mood.irritated;
      case 'sad':
        return Mood.sad;
      case 'anxious':
        return Mood.anxious;
      default:
        throw ArgumentError('Value "$name" cannot be converted to "Mood"');
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
