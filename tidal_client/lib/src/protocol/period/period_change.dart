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
import 'package:tidal_client/src/protocol/protocol.dart' as _ifh54y1n;
import '../period/period.dart' as _ixmp88ti;
import '../period/period_change_kind.dart' as _ih3v2vv1;

/// The result of a long-press, so the app can show what happened
/// ("Period started · assumed 5 days") and offer Undo. Pass it back to
/// `PeriodEndpoint.undo` to reverse the change.
abstract class PeriodChange
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PeriodChange._({
    required this.kind,
    required this.lengthDays,
    this.before,
    this.after,
  });

  factory PeriodChange({
    required _ih3v2vv1.PeriodChangeKind kind,
    required int lengthDays,
    _ixmp88ti.Period? before,
    _ixmp88ti.Period? after,
  }) = _PeriodChangeImpl;

  factory PeriodChange.fromJson(Map<String, dynamic> jsonSerialization) {
    return PeriodChange(
      kind: _ih3v2vv1.PeriodChangeKind.fromJson(
        (jsonSerialization['kind'] as String),
      ),
      lengthDays: jsonSerialization['lengthDays'] as int,
      before: jsonSerialization['before'] == null
          ? null
          : _ifh54y1n.Protocol().deserialize<_ixmp88ti.Period>(
              jsonSerialization['before'],
            ),
      after: jsonSerialization['after'] == null
          ? null
          : _ifh54y1n.Protocol().deserialize<_ixmp88ti.Period>(
              jsonSerialization['after'],
            ),
    );
  }

  /// What the long-press did.
  _ih3v2vv1.PeriodChangeKind kind;

  /// Length in days of the affected period after the change (0 when it
  /// was removed).
  int lengthDays;

  /// The period as it was before the change. Null when a new one started.
  _ixmp88ti.Period? before;

  /// The period as it is after the change. Null when it was removed.
  _ixmp88ti.Period? after;

  /// Returns a shallow copy of this [PeriodChange]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PeriodChange copyWith({
    _ih3v2vv1.PeriodChangeKind? kind,
    int? lengthDays,
    _ixmp88ti.Period? before,
    _ixmp88ti.Period? after,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PeriodChange',
      'kind': kind.toJson(),
      'lengthDays': lengthDays,
      if (before != null) 'before': before?.toJson(),
      if (after != null) 'after': after?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PeriodChange',
      'kind': kind.toJson(),
      'lengthDays': lengthDays,
      if (before != null) 'before': before?.toJsonForProtocol(),
      if (after != null) 'after': after?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PeriodChangeImpl extends PeriodChange {
  _PeriodChangeImpl({
    required _ih3v2vv1.PeriodChangeKind kind,
    required int lengthDays,
    _ixmp88ti.Period? before,
    _ixmp88ti.Period? after,
  }) : super._(
         kind: kind,
         lengthDays: lengthDays,
         before: before,
         after: after,
       );

  /// Returns a shallow copy of this [PeriodChange]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PeriodChange copyWith({
    _ih3v2vv1.PeriodChangeKind? kind,
    int? lengthDays,
    Object? before = _Undefined,
    Object? after = _Undefined,
  }) {
    return PeriodChange(
      kind: kind ?? this.kind,
      lengthDays: lengthDays ?? this.lengthDays,
      before: before is _ixmp88ti.Period? ? before : this.before?.copyWith(),
      after: after is _ixmp88ti.Period? ? after : this.after?.copyWith(),
    );
  }
}
