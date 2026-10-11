import 'package:equatable/equatable.dart';
import 'package:tidal_client/tidal_client.dart';

enum CalendarMessageKind {
  periodStarted,
  periodEnded,
  periodMoved,
  periodRemoved,
  futureDateRefused,
  updateFailed,
  doseRemoved,
  doseDeleteFailed,
  doseRestoreFailed,
}

/// A one-time message for the Calendar to show (what a long-press did, or
/// what deleting a dose did, or why they didn't). It holds values, not text: the words live in
/// `calendar_text.dart`. Every message has an [id] that grows with each new
/// message, so the screen can tell a new message from one it already showed.
class CalendarMessage extends Equatable {
  final int id;
  final CalendarMessageKind kind;

  /// Length in days of the affected period, for started/ended/moved.
  final int days;

  /// What went wrong, for the failure kinds.
  final String? error;

  /// What Undo reverses. Null for messages that offer no Undo.
  final PeriodChange? change;

  /// The deleted dose, which Undo puts back, for [doseRemoved].
  final DoseLog? dose;

  const CalendarMessage._(
    this.id,
    this.kind, {
    this.days = 0,
    this.error,
    this.change,
    this.dose,
  });

  /// The message for the server's answer to a long-press.
  factory CalendarMessage.fromChange(int id, PeriodChange change) {
    final kind = switch (change.kind) {
      PeriodChangeKind.started => CalendarMessageKind.periodStarted,
      PeriodChangeKind.ended => CalendarMessageKind.periodEnded,
      PeriodChangeKind.moved => CalendarMessageKind.periodMoved,
      PeriodChangeKind.removed => CalendarMessageKind.periodRemoved,
    };
    return CalendarMessage._(
      id,
      kind,
      days: change.lengthDays,
      change: change,
    );
  }

  const CalendarMessage.futureDateRefused(int id)
    : this._(id, CalendarMessageKind.futureDateRefused);

  const CalendarMessage.updateFailed(int id, String error)
    : this._(id, CalendarMessageKind.updateFailed, error: error);

  const CalendarMessage.doseRemoved(int id, DoseLog dose)
    : this._(id, CalendarMessageKind.doseRemoved, dose: dose);

  const CalendarMessage.doseDeleteFailed(int id, String error)
    : this._(id, CalendarMessageKind.doseDeleteFailed, error: error);

  const CalendarMessage.doseRestoreFailed(int id, String error)
    : this._(id, CalendarMessageKind.doseRestoreFailed, error: error);

  bool get canUndo => change != null || dose != null;

  @override
  List<Object?> get props => [id, kind, days, error, change, dose];
}
