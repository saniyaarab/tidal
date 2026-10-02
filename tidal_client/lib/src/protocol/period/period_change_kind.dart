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

/// What a long-press on the Calendar did.
enum PeriodChangeKind implements _isc.SerializableModel {
  /// A new period was started on the pressed day.
  started,

  /// The pressed day became the end of the current period.
  ended,

  /// An existing period's start was moved earlier to the pressed day.
  moved,

  /// The period starting on the pressed day was removed.
  removed;

  static PeriodChangeKind fromJson(String name) {
    switch (name) {
      case 'started':
        return PeriodChangeKind.started;
      case 'ended':
        return PeriodChangeKind.ended;
      case 'moved':
        return PeriodChangeKind.moved;
      case 'removed':
        return PeriodChangeKind.removed;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "PeriodChangeKind"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
