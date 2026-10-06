---

description: "Tasks for Calendar Screen State Migration"
---

# Tasks: Calendar Screen State Migration

**Input**: Design documents from `/specs/002-calendar-screen-bloc/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/calendar_repository.md, quickstart.md

**Tests**: MANDATORY for non-UI code per the constitution: write each test first and see it fail before the implementation task. Use hand-written fakes of interfaces, never mocks of concrete classes. Widget tests: happy paths only (at most 3), finding widgets by key or type, never by label text or item counts.

**Organization**: User Stories 1 and 2 are both P1 and share one implementation: the logic (US2) must exist before the screen can be switched over (US1), so US2 comes first. US3 (test cleanup) comes last.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1, US2 or US3 (see spec.md)

## Path Conventions

All paths are under `tidal_flutter/` (the Flutter client). Feature code lives in `lib/features/calendar/{domain,data,presentation}`; tests mirror it in `test/features/calendar/`. The server and generated client are not touched. Reference implementation: `lib/features/home/` (see its README).

---

## Phase 1: Setup

- [X] T001 Create the empty feature folders `lib/features/calendar/domain`, `lib/features/calendar/data`, `lib/features/calendar/presentation/bloc`, `lib/features/calendar/presentation/widgets`, and `test/features/calendar/{domain,data,presentation,fakes}` (no new packages are needed; `flutter_bloc`, `bloc_concurrency`, `equatable` and `bloc_test` are already in `pubspec.yaml`)
- [X] T002 Run `flutter test` in `tidal_flutter` and note the baseline: the Home tests pass before any change

---

## Phase 2: Foundational (blocking prerequisites)

**Purpose**: The contracts and entities that tests and implementations share.

- [X] T003 [P] Define `CalendarData` (monthDayLogs, monthPainEntries, periods, selectedPainEntries, selectedBowelMovements, units, prediction) in `lib/features/calendar/domain/calendar_data.dart`, per data-model.md
- [X] T004 [P] Define `CalendarMessage` (variants periodStarted/periodEnded/periodMoved/periodRemoved/futureDateRefused/updateFailed, each with a sequence `id`; undoable ones carry the `PeriodChange`) and a pure `CalendarMessage.fromChange(id, PeriodChange)` mapping from `PeriodChangeKind`, in `lib/features/calendar/domain/period_message.dart`
- [X] T005 Define the abstract `CalendarRepository` (`load(month, selectedDate)`, `longPress(date)`, `undo(change)`) in `lib/features/calendar/domain/calendar_repository.dart`, per contracts/calendar_repository.md (depends on T003)
- [X] T006 [P] Write `FakeCalendarRepository` in `test/features/calendar/fakes/fake_calendar_repository.dart`: returns configurable `CalendarData` (or throws), records the `(month, selectedDate)` of each `load`, records `longPress`/`undo` calls, returns a configurable `PeriodChange` or throws, and lets a test delay a `load` with a `Completer` to simulate a slow response (depends on T005)
- [X] T007 [P] Add any missing builders to `test/features/home/fakes/builders.dart` (a `prediction(...)` builder and a `periodChange(kind, days)` builder; reuse the existing `dayLog`, `period`, `pain`)

**Checkpoint**: Contracts compile; the fake exists.

---

## Phase 3: User Story 2 - The Calendar's logic is verifiable without the UI or a server (Priority: P1)

**Goal**: Every rule the Calendar applies lives in plain Dart and a bloc, covered by headless tests.

**Independent Test**: `flutter test test/features/calendar` passes with no device or server, in under 10 seconds.

### Tests for User Story 2 (write first, confirm they fail)

- [X] T008 [P] [US2] Write `test/features/calendar/domain/calendar_grid_test.dart`: month starting on a Sunday has 0 leading days, on a Monday 1, on a Saturday 6; `dates` has 42 consecutive dates starting at `gridStart`; `gridEnd` is `gridStart + 41`; `monthEnd` for 28, 29, 30 and 31-day months
- [X] T009 [P] [US2] Write `test/features/calendar/domain/period_days_test.dart`: `expandPeriodDays` covers start through end inclusive; a period spanning two months includes days in both; a one-day period; overlapping spans merge; an empty list gives an empty set
- [X] T010 [P] [US2] Write `test/features/calendar/domain/day_marks_test.dart`: each ring alone (period, predicted, fertile, today); priority when several apply (period beats predicted beats fertile beats today); no ring when selected; predicted and fertile are false when their prediction fields or the prediction itself are null; range boundaries are inclusive; `inCurrentMonth`, `isToday`, `isSelected`, `hasPain`
- [X] T011 [P] [US2] Write `test/features/calendar/domain/period_message_test.dart`: each `PeriodChangeKind` maps to the matching variant with the right day count and the `PeriodChange` attached for Undo
- [X] T012 [P] [US2] Write `test/features/calendar/data/server_calendar_repository_test.dart` with a hand-written fake `CalendarServerApi`: `load` asks each read for the exact ranges in contracts/calendar_repository.md (month range, grid range, selected day) and bundles each result into its field; any one failing read makes `load` throw; a `selectedDate` outside the month still requests its own single-day range; `longPress` returns the server's `PeriodChange` unchanged; `undo` forwards the same object
- [X] T013 [US2] Write `test/features/calendar/presentation/calendar_bloc_test.dart` with `FakeCalendarRepository` and a fixed clock, using `bloc_test`, covering every scenario in spec FR-005 and User Story 2: started loads today's month and day (loading then loaded with expanded `periodDates` across months, `painDates`, day logs, units, prediction); month change (next and previous) loads that month and keeps the selected date; select a day loads its detail; date requested jumps month and selection; load failure sets failed + error and keeps previous data; stale response is dropped when the user moves month or day before an earlier load finishes (use the fake's `Completer`); long-press on a future day emits `futureDateRefused` and makes no repository call; long-press for each kind (started, ended, moved, removed) selects the day, reloads and then emits the matching message once with Undo; a second message replaces the first and has a different id; long-press failure emits `updateFailed` and leaves the data as it was; undo success reloads; undo failure still reloads and does not throw; returned-from-log and refreshed reload the same data; a refresh superseded by a month change still ends with the latest month loaded; a long-press that saves but whose follow-up reload fails leaves state `failed` with the previous grid kept and still emits the period message with Undo; a month change while a long-press reload is in flight keeps the newer month; a result arriving after `close()` emits nothing

### Implementation for User Story 2

- [X] T014 [P] [US2] Implement `CalendarGrid` in `lib/features/calendar/domain/calendar_grid.dart` (Sunday-first: `month.weekday % 7` leading days; 42 dates; `monthEnd`; `gridEnd`) to pass T008
- [X] T015 [P] [US2] Implement `expandPeriodDays` in `lib/features/calendar/domain/period_days.dart` to pass T009
- [X] T016 [P] [US2] Implement `DayRing` and `DayMarks.of(...)` in `lib/features/calendar/domain/day_marks.dart` to pass T010
- [X] T017 [US2] Finish `CalendarMessage.fromChange` in `lib/features/calendar/domain/period_message.dart` to pass T011 (depends on T004)
- [X] T018 [US2] Implement `CalendarServerApi` and `ServerCalendarRepository` in `lib/features/calendar/data/server_calendar_repository.dart` (the seven parallel reads using `CalendarGrid`, plus `longPress` and `undo`) to pass T012 (depends on T005, T014)
- [X] T019 [P] [US2] Implement `ClientCalendarServerApi` in `lib/features/calendar/data/client_calendar_server_api.dart`, forwarding each call to the generated `Client` (`client.log.getRange`, `client.pain.getPainRange`, `client.period.getPeriods`, `client.digestion.getBowelMovementRange`, `client.insight.getUnitPreferences`, `client.insight.getPrediction`, `client.period.longPress`, `client.period.undo`) (depends on T018)
- [X] T020 [P] [US2] Define the events in `lib/features/calendar/presentation/bloc/calendar_event.dart`: `CalendarStarted`, `CalendarMonthChanged(delta)`, `CalendarDateSelected(date)`, `CalendarDateRequested(date)`, `CalendarRefreshed`, `CalendarReturnedFromLog`, `CalendarDayLongPressed(date)`, `CalendarUndoPressed(change)`
- [X] T021 [P] [US2] Define `CalendarLoadStatus` and the Equatable `CalendarState` (with `copyWith` using `Function()?` for nullable fields as in `HomeState`, and a `dayLogFor(date)` helper) in `lib/features/calendar/presentation/bloc/calendar_state.dart`, per data-model.md (depends on T003, T004)
- [X] T022 [US2] Implement `CalendarBloc` in `lib/features/calendar/presentation/bloc/calendar_bloc.dart` per research D1, D2, D5, D6, D7: injected repository and clock; one `_load` used by all load events with `restartable()` and a check after each await that month and selected date still match, plus a `_closing` flag as in `HomeBloc`; await results into locals before `copyWith`; long-press and undo with `sequential()`; message ids from an incrementing counter; build `periodDates` with `expandPeriodDays` and `painDates` from the month's pain entries; ; build `dayLogs` as a map keyed by date from `monthDayLogs`, and keep it across failed loads; to pass T013 (depends on T014-T017, T020, T021)

**Checkpoint**: `flutter test test/features/calendar` is green and runs headless.

---

## Phase 4: User Story 1 - The Calendar looks and behaves exactly as before (Priority: P1)

**Goal**: The screen only draws `CalendarState` and sends events; users notice no difference.

**Independent Test**: Run the app and check each behavior in spec FR-001 against the old Calendar; run the widget happy paths (T028).

- [X] T023 [P] [US1] Write `calendar_text.dart` in `lib/features/calendar/presentation/calendar_text.dart`: turns a `CalendarMessage` into exactly today's wording ("Period started · assumed N days", "Period ended · N days", "Period start moved · N days", "Period removed", "Periods can't be logged for future dates.", "Could not update the period: $error") and carries the legend and empty/error strings ("Nothing logged for this day.", "Could not load this day: $error"); first write `test/features/calendar/presentation/calendar_text_test.dart` pinning every string, see it fail, then implement
- [X] T024 [P] [US1] Move the month header into `lib/features/calendar/presentation/widgets/month_header.dart` (takes the month and two callbacks; same look, add a `Key('calendar-previous-month')` and `Key('calendar-next-month')` to the arrows)
- [X] T025 [P] [US1] Move the day cell into `lib/features/calendar/presentation/widgets/day_cell.dart`: takes a `DayMarks` and callbacks, draws the ring from `DayRing` (rose, rose at 45%, `lavenderRing`, lavender), the selected fill, bold text, and the pain dot; no rules inside; give each cell `ValueKey` of its date so tests can find it
- [X] T026 [P] [US1] Move the legend into `lib/features/calendar/presentation/widgets/legend.dart` (same four items, same colors)
- [X] T027 [US1] Add `lib/features/calendar/presentation/widgets/month_grid.dart`: weekday header from `weekdayHeaderLabels`, 42 `DayCell`s from `CalendarGrid(state.month).dates` with `DayMarks.of(...)` per date (depends on T014, T016, T025)
- [X] T028 [US1] Write `lib/features/calendar/presentation/calendar_screen.dart`: a `StatelessWidget` over `BlocProvider`'s `CalendarBloc` using `BlocConsumer`/`BlocBuilder`. Same layout as the old screen (app bar, `RefreshIndicator` sending `CalendarRefreshed` and awaiting `bloc.stream.firstWhere((s) => s.status != CalendarLoadStatus.loading)` (completing immediately if the bloc is already closed, so a cancelled or superseded load never leaves the spinner hanging), header, grid, legend, day label via `formatDayLabel`, spinner / error / `DayBands`). A `BlocListener` with `listenWhen: previous.message?.id != current.message?.id` and a non-null message hides the current snackbar and shows the new one, with an Undo action (sending `CalendarUndoPressed(change)`) only for undoable messages. The "+" button pushes `LogScreen(date: state.selectedDate, dayLog: state.dayLogFor(state.selectedDate))` and sends `CalendarReturnedFromLog` when it returns `true`. No import of `client.dart` and no rules (depends on T022-T027)
- [X] T029 [US1] Wire it in `lib/app_shell.dart`: create the `CalendarBloc` with `ServerCalendarRepository(ClientCalendarServerApi(client))` and `DateTime.now` inside a `BlocProvider` (like Home) and `..add(const CalendarStarted())`; make `_openCalendar` add `CalendarDateRequested(date)` to that bloc (keep a reference to it, or read it from the provider's context) and switch tab; remove the `ValueNotifier<DateTime?>` `_calendarDate` and its `dispose` (depends on T028; research D8)
- [X] T030 [US1] Delete `lib/screens/calendar_screen.dart` and fix any remaining imports (`grep -rn "screens/calendar_screen" lib test`)
- [X] T031 [US1] Write `test/features/calendar/presentation/calendar_screen_test.dart` with at most three happy paths, found by key or type (never by text or counts): (1) the grid appears after load and tapping a day cell's key makes the bloc select it; (2) tapping the next-month arrow key loads the next month; (3) a long-press on a past day cell shows a snackbar with an Undo action and tapping Undo reaches the fake repository's `undo`. Unmount the widget and `unawaited(bloc.close())` in teardown as in the Home test

**Checkpoint**: The app builds and the Calendar behaves as before (manual check in T037).

---

## Phase 5: User Story 3 - Logic-focused UI tests become headless tests (Priority: P2)

**Goal**: No Calendar rule is checked only through the UI; the few UI tests left are happy paths.

**Independent Test**: Review the suite: Calendar rules appear in headless tests; at most three Calendar widget tests remain, with no dependence on text or counts.

- [X] T032 [US3] Confirm no Calendar UI tests existed before this feature (`git log --stat -- tidal_flutter/test` and `grep -rln -i calendar tidal_flutter/test` outside `features/calendar`), and record the result in the PR description (spec Assumptions: there were none)
- [X] T033 [US3] Audit `test/features/calendar/presentation/calendar_screen_test.dart` against spec SC-004: three or fewer tests, none using `find.text` or item counts, every rule it touches also covered in the headless tests from Phase 3; fix any gap by adding a headless test, not a UI test

---

## Phase 6: Polish and cross-cutting

- [X] T034 [P] Update `lib/features/home/README.md` (or add `lib/features/calendar/README.md` and link both ways) so it describes the shared pattern with both features, how Calendar receives Home's hand-off as an event (research D8), the sequence-numbered message approach (D5) and the stale-response approach (D2); add any new gotchas found while implementing (FR-012, SC-005)
- [X] T035 [P] Update `AGENTS.md` and `CLAUDE.md` "Current step" notes to say the Calendar moved to BLoC and clean architecture (date: Oct 4, 2026) and that `lib/screens/calendar_screen.dart` no longer exists; update the hand-off sentence (Calendar listens to a bloc event, not a `ValueNotifier`)
- [X] T036 Run `dart analyze` and `dart format .` in `tidal_flutter`, then `flutter test` for the whole client suite (Home tests included); fix anything they report
- [ ] T037 Run the quickstart's side-by-side manual check (quickstart.md step 4) against the running app with `serverpod start`, including long-press start, end, move and remove with Undo, a future-date long-press, "+" then return, pull-to-refresh, and Home's day circle opening the Calendar (also a second time for the same date)
- [X] T038 Verify the inspection checks in quickstart.md step 5: `presentation/` has no import of `client.dart` and no rules; `lib/features/home/` imports nothing from `lib/features/calendar/`

---

## Dependencies and execution order

- Setup (T001-T002) → Foundational (T003-T007) → US2 (T008-T022) → US1 (T023-T031) → US3 (T032-T033) → Polish (T034-T038).
- Within US2: tests T008-T013 first and failing; then T014-T016 and T019-T021 in parallel; T017, T018 and T022 follow their dependencies (T022 last).
- Within US1: T023-T026 in parallel; T027 after T025; T028 after T022-T027; T029-T031 after T028.
- US1 cannot start before US2's bloc (T022) exists. US3 needs T031.

## Parallel examples

- After Phase 2: T008, T009, T010, T011, T012 (separate test files) can be written together.
- After the tests fail: T014, T015, T016, T020, T021 (separate files) can be implemented together.
- In US1: T023, T024, T025, T026 (separate widget files).
- Polish: T034 and T035 (separate docs).

## Implementation strategy

1. Finish Phases 1-2, then US2 with tests first: this is the safest increment (nothing user-visible changes yet, and the old screen still works until T029-T030).
2. Switch the screen over (US1) in one go, as the old and new screens cannot coexist behind one tab.
3. Clean up tests (US3), then docs and the manual check (Polish).
4. MVP scope: Phases 1-4 (logic, screen and wiring) — this delivers the whole migration; US3 and Polish are verification and documentation.
