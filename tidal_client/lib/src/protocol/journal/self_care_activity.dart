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

/// The self-care activities on the Journal's "Self care today" checklist.
enum SelfCareActivity implements _isc.SerializableModel {
  meditated,
  calledFriend,
  hitSnooze,
  listenedToMusic,
  snackedHealthy,
  wentOutside,
  readBook,
  tookBath,
  drewOrPainted,
  cookedMeal,
  plannedTrip,
  huggedSomeone,
  madeTea,
  complimentedMe,
  tookNap;

  static SelfCareActivity fromJson(String name) {
    switch (name) {
      case 'meditated':
        return SelfCareActivity.meditated;
      case 'calledFriend':
        return SelfCareActivity.calledFriend;
      case 'hitSnooze':
        return SelfCareActivity.hitSnooze;
      case 'listenedToMusic':
        return SelfCareActivity.listenedToMusic;
      case 'snackedHealthy':
        return SelfCareActivity.snackedHealthy;
      case 'wentOutside':
        return SelfCareActivity.wentOutside;
      case 'readBook':
        return SelfCareActivity.readBook;
      case 'tookBath':
        return SelfCareActivity.tookBath;
      case 'drewOrPainted':
        return SelfCareActivity.drewOrPainted;
      case 'cookedMeal':
        return SelfCareActivity.cookedMeal;
      case 'plannedTrip':
        return SelfCareActivity.plannedTrip;
      case 'huggedSomeone':
        return SelfCareActivity.huggedSomeone;
      case 'madeTea':
        return SelfCareActivity.madeTea;
      case 'complimentedMe':
        return SelfCareActivity.complimentedMe;
      case 'tookNap':
        return SelfCareActivity.tookNap;
      default:
        throw ArgumentError(
          'Value "$name" cannot be converted to "SelfCareActivity"',
        );
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
