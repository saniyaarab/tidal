# Research: Calendar Screen State Migration

No NEEDS CLARIFICATION items remained after the spec. The decisions below resolve the planning
questions the spec deferred. Decisions already made for Home (D1 BLoC, D3 generated models,
D5 injected clock, D6 narrow server interface, D7 `BlocProvider` in `AppShell`) apply unchanged;
see `specs/001-home-screen-bloc/research.md`.

## D1. One `CalendarBloc` with events
- **Decision**: One `Bloc<CalendarEvent, CalendarState>`. Events: `CalendarStarted`, `CalendarMonthChanged(delta)`, `CalendarDateSelected(date)`, `CalendarDateRequested(date)` (from Home), `CalendarRefreshed`, `CalendarReturnedFromLog`, `CalendarDayLongPressed(date)`, `CalendarUndoPressed(change)`.
- **Rationale**: Events map one-to-one onto user actions and the spec's scenarios, so tests read like the spec.
- **Alternatives**: Cubit (hides the events the tests assert on); separate blocs for grid and day detail (more wiring, and the data loads together today).

## D2. Stale responses
- **Decision**: Month change, date select, date request, refresh, started and returned-from-log all go through one `_load` and use `restartable()`, so a newer request cancels an older one's result. After each await the handler also checks that `state.month`/`state.selectedDate` still match the request.
- **Rationale**: Spec requires only the last choice to be shown (today an earlier, slower response can overwrite it). Same approach as Home D2.
- **Alternatives**: Manual comparison only (easy to forget).

## D3. One repository call for the whole screen
- **Decision**: `CalendarRepository.load(month, selectedDate)` returns a `CalendarData` bundle (month day logs, month pain entries, period spans for the grid range, selected-day pain entries and bowel movements, units, prediction), issuing the same seven server calls in parallel as today. `longPress(date)` and `undo(change)` are separate methods.
- **Rationale**: Spec assumes every change reloads the same data as today; partial loading is out of scope. One bundle keeps the state update atomic, so the grid and the day detail never disagree.
- **Alternatives**: Separate `loadMonth` / `loadDay` / `loadPrediction` (finer control, but invites partial loading and half-updated states, and is not requested).

## D4. Where the rules live
- **Decision**: Pure domain functions return semantic values:
  - `CalendarGrid` — `gridStart` (Sunday-first, `month.weekday % 7` leading days), 42 `dates`, `monthEnd`, `gridEnd`.
  - `expandPeriodDays(spans)` — every day from `startDate` through `endDate`, inclusive.
  - `DayMarks.of(date, ...)` — `inCurrentMonth`, `isSelected`, `isToday`, `hasPain`, and `ring` (`DayRing.period | predicted | fertile | today | none`). Priority is period > predicted > fertile > today, and no ring is drawn on the selected day.
  - `CalendarMessage` — `periodStarted(days) | periodEnded(days) | periodMoved(days) | periodRemoved | futureDateRefused | updateFailed(error)`, mapped from `PeriodChange.kind` in the bloc.
- **Rationale**: Rules are headless-testable; text is presentation and gets localized later (as Home D4).
- **Alternatives**: Rules left in widgets (untestable); formatted strings in state (hard-wires English).

## D5. One-time messages
- **Decision**: `CalendarState.message` holds a `CalendarMessage` with a sequence `id` (an increasing counter in the bloc), plus the `PeriodChange` to undo when the message offers Undo. The screen uses `BlocListener` with `listenWhen: previous.message?.id != current.message?.id` and a non-null message; it hides the current snackbar and shows the new one. The message stays in state (harmless: a listener only fires on a change, so a rebuilt widget does not replay it).
- **Rationale**: Meets FR-007 (exactly once, replaced by the next) with no extra acknowledge event and testable with `bloc_test` by asserting the emitted states. A rebuilt screen's new `BlocListener` does not fire for the state it starts with.
- **Alternatives**: A separate effects stream (not replayable in `bloc_test` as simply, and risks lost events); clearing the message with an acknowledge event (extra event and a race when two messages arrive quickly).

## D6. Long-press and Undo flow
- **Decision**:
  1. A date after today (injected clock, UTC date key) emits `futureDateRefused` and calls nothing.
  2. Otherwise `repository.longPress(date)`; on success set `selectedDate = date`, reload, then emit the message with Undo (same order as today, so the message appears after the grid updates). If the reload fails, still emit the message: the period was saved, so Undo must stay available.
  3. On failure emit `updateFailed(error)` and leave the grid as it was.
  4. Undo calls `repository.undo(change)` then reloads. If undo fails, the grid is reloaded anyway so it shows what the server has, and no crash (spec edge case; today the exception is unhandled).
  Long-press and undo use `sequential()` so two quick presses cannot interleave their server writes.
- **Rationale**: Preserves today's order and wording; fixes the unhandled Undo error.
- **Alternatives**: `droppable()` (would silently ignore a second press, a visible change).

## D7. Failure display and data kept on screen
- **Decision**: A failed load sets `status = failed` and `error`, but keeps the previous grid data in state; the screen shows "Could not load this day: …" in place of the day's log and keeps the grid. `loading` shows the spinner in place of the log, as today.
- **Rationale**: Matches the spec edge cases and today's behavior (the old code never cleared its sets on error).

## D8. Hand-off from Home
- **Decision**: Remove the `ValueNotifier<DateTime?>`. `AppShell` already receives Home's `onOpenCalendar(date)` callback; it now calls `calendarBloc.add(CalendarDateRequested(date))` and switches tab. `AppShell` owns the `CalendarBloc` through a `BlocProvider` (same as Home), so the Home feature depends on nothing Calendar-specific (FR-011).
- **Consequence**: The kept quirk in the spec (Home asking for the same date twice does not move the Calendar if the user changed the selection since) disappears, because an event always fires, unlike a `ValueNotifier` assigned an equal value. Preserving the quirk would need deliberate dedup code that makes the app worse. **Flag for the developer**: this is a deviation from the spec's Assumptions; reinstate the dedup in `AppShell` if exact parity is wanted.
- **Alternatives**: Keep the notifier and have the screen forward it to the bloc (leaves a UI-level channel and the quirk, but is a smaller diff); a shared app-level navigation bloc (new concept for one hand-off).

## D9. Log screen navigation
- **Decision**: The screen pushes `LogScreen(date: state.selectedDate, dayLog: state.dayLogFor(selectedDate))` itself (navigation is presentation) and adds `CalendarReturnedFromLog` when it returns `true`. `LogScreen` is not touched.
- **Rationale**: Scope; navigation is a UI concern.

## D10. Testing the data layer
- **Decision**: `ServerCalendarRepository` takes a small project-owned `CalendarServerApi` (the nine calls the Calendar makes: seven reads, `longPress`, `undo`), implemented over the generated `Client` by `ClientCalendarServerApi`. Its mapping (bundling the results, the grid-range arguments) is tested with a hand-written fake.
- **Rationale**: Constitution III; same as Home D6.

## D11. Existing tests
- **Decision**: There are no existing Calendar UI tests (`test/widget_test.dart` is an empty stub; Home tests must keep passing). Calendar logic gets headless tests from the start; up to 3 widget happy paths find widgets by `Key`/type: month grid renders and a day tap selects it; the next-month arrow changes the shown month; a long-press shows a message with an Undo button.
- **Rationale**: Principle IV and spec Assumptions.

## D12. Dependencies
- **Decision**: None added; `flutter_bloc`, `bloc_concurrency`, `equatable` and `bloc_test` are already in `pubspec.yaml` from the Home migration.
