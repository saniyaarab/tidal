import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../date_format.dart';
import '../../domain/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

/// Holds Home's state: the selected day, the cycle prediction and the due
/// medication reminders. Talks to the outside world only through
/// [HomeRepository], a clock and a stream of reminder ticks, so it can be
/// tested without a server or real timers.
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;
  final DateTime Function() _now;
  late final StreamSubscription<void> _ticks;

  // Set as soon as close() starts. close() waits for handlers that are still
  // running, so a late answer must not be emitted while it waits.
  bool _closing = false;

  HomeBloc({
    required this._repository,
    required DateTime Function() now,
    required Stream<void> reminderTicks,
  }) : _now = now,
       super(HomeState(selectedDate: dateKeyOf(now()))) {
    on<HomeStarted>(_onStarted);
    // restartable: a newer day choice cancels the older one's result.
    on<HomeDayChanged>(_onDayChanged, transformer: restartable());
    on<HomeRefreshed>((event, emit) => _loadDay(emit));
    on<HomeReturnedFromLog>(
      (event, emit) => Future.wait([_loadDay(emit), _loadReminders(emit)]),
    );
    on<HomeRemindersChecked>(
      (event, emit) => _loadReminders(emit),
      transformer: droppable(),
    );
    on<HomeReminderDoseLogged>(_onDoseLogged);
    on<HomeReminderDismissed>(_onDismissed);

    _ticks = reminderTicks.listen((_) => add(const HomeRemindersChecked()));
  }

  @override
  Future<void> close() async {
    _closing = true;
    await _ticks.cancel();
    return super.close();
  }

  Future<void> _onStarted(HomeStarted event, Emitter<HomeState> emit) {
    return Future.wait([
      _loadDay(emit),
      _loadPrediction(emit),
      _loadReminders(emit),
    ]);
  }

  Future<void> _onDayChanged(
    HomeDayChanged event,
    Emitter<HomeState> emit,
  ) {
    emit(
      state.copyWith(
        selectedDate: state.selectedDate.add(Duration(days: event.deltaDays)),
      ),
    );
    return _loadDay(emit);
  }

  Future<void> _loadDay(Emitter<HomeState> emit) async {
    final date = state.selectedDate;
    emit(state.copyWith(dayStatus: DayLoadStatus.loading, error: () => null));
    try {
      final day = await _repository.loadDay(date);
      // Ignore an answer for a day the user has already moved away from, or
      // that arrives while closing.
      if (_closing || state.selectedDate != date) return;
      emit(state.copyWith(dayStatus: DayLoadStatus.loaded, day: () => day));
    } catch (e) {
      if (_closing || state.selectedDate != date) return;
      emit(state.copyWith(dayStatus: DayLoadStatus.failed, error: () => '$e'));
    }
  }

  Future<void> _loadPrediction(Emitter<HomeState> emit) async {
    try {
      // Await before reading `state`: the other loads run at the same time.
      final prediction = await _repository.loadPrediction();
      if (_closing) return;
      emit(state.copyWith(prediction: prediction));
    } catch (_) {
      // A failed prediction lookup shouldn't block the rest of Home; the
      // header just won't show.
    }
  }

  Future<void> _loadReminders(Emitter<HomeState> emit) async {
    try {
      final reminders = await _repository.loadDueReminders();
      if (_closing) return;
      emit(state.copyWith(dueReminders: reminders));
    } catch (_) {
      // A failed reminder check shouldn't block the rest of Home.
    }
  }

  Future<void> _onDoseLogged(
    HomeReminderDoseLogged event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _repository.logReminderDose(event.reminder, _now());
    } catch (_) {
      // Keep the banner so the user can try again.
    }
    await _loadReminders(emit);
  }

  Future<void> _onDismissed(
    HomeReminderDismissed event,
    Emitter<HomeState> emit,
  ) async {
    try {
      await _repository.dismissReminder(event.reminder);
    } catch (_) {
      // Keep the banner so the user can try again.
    }
    await _loadReminders(emit);
  }
}
