import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tidal_client/tidal_client.dart';

import '../../../../date_format.dart';
import '../../domain/calendar_repository.dart';
import '../../domain/period_days.dart';
import '../../domain/period_message.dart';
import 'calendar_event.dart';
import 'calendar_state.dart';

/// Holds the Calendar's state: the shown month, the selected day, what was
/// loaded for them, and one-time messages about period changes. Talks to the
/// outside world only through [CalendarRepository] and a clock, so it can be
/// tested without a server.
class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepository _repository;
  final DateTime Function() _now;

  // Set as soon as close() starts. close() waits for handlers that are still
  // running, so a late answer must not be emitted while it waits.
  bool _closing = false;

  int _lastMessageId = 0;

  CalendarBloc({
    required this._repository,
    required DateTime Function() now,
  }) : _now = now,
       super(
         CalendarState(
           month: firstOfMonth(dateKeyOf(now())),
           selectedDate: dateKeyOf(now()),
         ),
       ) {
    // restartable: a newer choice cancels the older one's result.
    on<CalendarStarted>((e, emit) => _load(emit), transformer: restartable());
    on<CalendarRefreshed>((e, emit) => _load(emit), transformer: restartable());
    on<CalendarReturnedFromLog>(
      (e, emit) => _load(emit),
      transformer: restartable(),
    );
    on<CalendarMonthChanged>(_onMonthChanged, transformer: restartable());
    on<CalendarDateSelected>(_onDateSelected, transformer: restartable());
    on<CalendarDateRequested>(_onDateRequested, transformer: restartable());
    // sequential: period edits run one at a time, in the order pressed.
    on<CalendarPeriodEdit>(_onPeriodEdit, transformer: sequential());
  }

  @override
  Future<void> close() {
    _closing = true;
    return super.close();
  }

  Future<void> _onMonthChanged(
    CalendarMonthChanged event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(month: addMonths(state.month, event.delta)));
    return _load(emit);
  }

  Future<void> _onDateSelected(
    CalendarDateSelected event,
    Emitter<CalendarState> emit,
  ) {
    emit(state.copyWith(selectedDate: event.date));
    return _load(emit);
  }

  Future<void> _onDateRequested(
    CalendarDateRequested event,
    Emitter<CalendarState> emit,
  ) {
    emit(
      state.copyWith(
        month: firstOfMonth(event.date),
        selectedDate: event.date,
      ),
    );
    return _load(emit);
  }

  /// Loads the shown month and selected day. An answer for a month or day
  /// the user has already moved away from is dropped.
  Future<void> _load(Emitter<CalendarState> emit) async {
    final month = state.month;
    final selectedDate = state.selectedDate;
    bool isStale() =>
        _closing || state.month != month || state.selectedDate != selectedDate;

    emit(state.copyWith(status: CalendarLoadStatus.loading, error: () => null));
    try {
      final data = await _repository.load(month, selectedDate);
      if (isStale()) return;
      emit(
        state.copyWith(
          status: CalendarLoadStatus.loaded,
          dayLogs: {for (final log in data.monthDayLogs) log.date: log},
          periodDates: expandPeriodDays(data.periods),
          painDates: {for (final entry in data.monthPainEntries) entry.date},
          selectedPainEntries: data.selectedPainEntries,
          selectedBowelMovements: data.selectedBowelMovements,
          selectedDoses: data.selectedDoses,
          medicationsById: data.medicationsById,
          units: data.units,
          prediction: data.prediction,
        ),
      );
    } catch (e) {
      if (isStale()) return;
      emit(
        state.copyWith(status: CalendarLoadStatus.failed, error: () => '$e'),
      );
    }
  }

  Future<void> _onPeriodEdit(
    CalendarPeriodEdit event,
    Emitter<CalendarState> emit,
  ) {
    return switch (event) {
      CalendarDayLongPressed() => _onLongPress(event, emit),
      CalendarUndoPressed() => _onUndo(event, emit),
      CalendarDoseDeleted() => _onDoseDeleted(event, emit),
      CalendarDoseRestored() => _onDoseRestored(event, emit),
    };
  }

  Future<void> _onLongPress(
    CalendarDayLongPressed event,
    Emitter<CalendarState> emit,
  ) async {
    if (event.date.isAfter(dateKeyOf(_now()))) {
      emit(
        state.copyWith(
          message: CalendarMessage.futureDateRefused(++_lastMessageId),
        ),
      );
      return;
    }

    final PeriodChange change;
    try {
      change = await _repository.longPress(event.date);
    } catch (e) {
      if (_closing) return;
      emit(
        state.copyWith(
          message: CalendarMessage.updateFailed(++_lastMessageId, '$e'),
        ),
      );
      return;
    }
    if (_closing) return;

    emit(state.copyWith(selectedDate: event.date));
    await _load(emit);
    if (_closing) return;
    // The period is saved even if the reload failed, so Undo stays offered.
    emit(
      state.copyWith(
        message: CalendarMessage.fromChange(++_lastMessageId, change),
      ),
    );
  }

  Future<void> _onUndo(
    CalendarUndoPressed event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      await _repository.undo(event.change);
    } catch (_) {
      // Reload anyway so the grid shows what the server actually has.
    }
    if (_closing) return;
    await _load(emit);
  }

  Future<void> _onDoseDeleted(
    CalendarDoseDeleted event,
    Emitter<CalendarState> emit,
  ) async {
    final DoseLog? deleted;
    try {
      deleted = await _repository.deleteDose(event.dose);
    } catch (e) {
      if (_closing) return;
      emit(
        state.copyWith(
          message: CalendarMessage.doseDeleteFailed(++_lastMessageId, '$e'),
        ),
      );
      return;
    }
    if (_closing) return;

    // Reload even when the dose was already gone, so the band goes away.
    await _load(emit);
    if (_closing || deleted == null) return;
    emit(
      state.copyWith(
        message: CalendarMessage.doseRemoved(++_lastMessageId, deleted),
      ),
    );
  }

  Future<void> _onDoseRestored(
    CalendarDoseRestored event,
    Emitter<CalendarState> emit,
  ) async {
    CalendarMessage? failure;
    try {
      await _repository.restoreDose(event.dose);
    } catch (e) {
      failure = CalendarMessage.doseRestoreFailed(++_lastMessageId, '$e');
    }
    if (_closing) return;

    await _load(emit);
    if (_closing || failure == null) return;
    emit(state.copyWith(message: failure));
  }
}
