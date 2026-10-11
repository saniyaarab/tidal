import 'package:equatable/equatable.dart';
import 'package:tidal_client/tidal_client.dart';

enum HomeMessageKind { doseRemoved, doseDeleteFailed, doseRestoreFailed }

/// A one-time message for Home to show (what deleting a dose did, or why it
/// didn't). It holds values, not text: the words live in `home_text.dart`.
/// Every message has an [id] that grows with each new message, so the screen
/// can tell a new message from one it already showed.
class HomeMessage extends Equatable {
  final int id;
  final HomeMessageKind kind;

  /// The deleted dose, which Undo puts back. Null for messages with no Undo.
  final DoseLog? dose;

  /// What went wrong, for the failure kinds.
  final String? error;

  const HomeMessage._(this.id, this.kind, {this.dose, this.error});

  const HomeMessage.doseRemoved(int id, DoseLog dose)
    : this._(id, HomeMessageKind.doseRemoved, dose: dose);

  const HomeMessage.deleteFailed(int id, String error)
    : this._(id, HomeMessageKind.doseDeleteFailed, error: error);

  const HomeMessage.restoreFailed(int id, String error)
    : this._(id, HomeMessageKind.doseRestoreFailed, error: error);

  bool get canUndo => dose != null;

  @override
  List<Object?> get props => [id, kind, dose, error];
}
