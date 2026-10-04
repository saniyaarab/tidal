---

description: "Tasks for Home Screen State Migration"
---

# Tasks: Home Screen State Migration

**Input**: Design documents from `/specs/001-home-screen-bloc/`

**Prerequisites**: plan.md, spec.md, research.md, data-model.md, contracts/home_repository.md, quickstart.md

**Tests**: MANDATORY for non-UI code per the constitution: write each test first and see it fail before the implementation task. Use hand-written fakes of interfaces, never mocks of concrete classes. Widget tests: happy paths only, finding widgets by key or type, never by label text or item counts.

**Organization**: User Stories 1 and 2 are both P1 and share one implementation: the logic (US2) must exist before the screen can be switched over (US1), so US2 comes first. US3 (test cleanup) comes last.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1, US2 or US3 (see spec.md)

## Path Conventions

All paths are under `tidal_flutter/` (the Flutter client). Feature code lives in `lib/features/home/{domain,data,presentation}`; tests mirror it in `test/features/home/`. The server and generated client are not touched.

---

## Phase 1: Setup

- [X] T001 Add `flutter_bloc`, `bloc_concurrency`, `equatable` to dependencies and `bloc_test` to dev_dependencies in `tidal_flutter/pubspec.yaml` (use `flutter pub add`), then run `flutter pub get`
- [X] T002 Create the empty feature folders `lib/features/home/domain`, `lib/features/home/data`, `lib/features/home/presentation/bloc`, `lib/features/home/presentation/widgets`, and `test/features/home/{domain,data,presentation,fakes}`

---

## Phase 2: Foundational (blocking prerequisites)

**Purpose**: The contracts and entities that tests and implementations share.

- [X] T003 [P] Define `DueReminder` (reminderId, medicationId, medicationName) in `lib/features/home/domain/due_reminder.dart`
- [X] T004 [P] Define `DayData` (DayLog?, PeriodSpan?, pain entries, bowel movements, UnitPreferences) in `lib/features/home/domain/day_data.dart`, per data-model.md
- [X] T005 Define the abstract `HomeRepository` (`loadDay`, `loadPrediction`, `loadDueReminders`, `logReminderDose`, `dismissReminder`) in `lib/features/home/domain/home_repository.dart`, per contracts/home_repository.md (depends on T003, T004)
- [X] T005a [P] Define `HomeEvent` types (`HomeStarted`, `HomeDayChanged`, `HomeRefreshed`, `HomeReturnedFromLog`, `HomeRemindersChecked`, `HomeReminderDoseLogged`, `HomeReminderDismissed`) in `lib/features/home/presentation/bloc/home_event.dart`
- [X] T005b [P] Define `HomeState` (Equatable; selected date, day section with loading/loaded/failed, prediction, due reminders) in `lib/features/home/presentation/bloc/home_state.dart`
- [X] T006 Write `FakeHomeRepository` in `test/features/home/fakes/fake_home_repository.dart`: a hand-written implementation with settable results, settable failures (including for log dose and dismiss), optional completers for delayed responses, and recorded calls (depends on T005)
- [X] T006a Add compiling stubs (signatures only, throwing `UnimplementedError`) for `DayStatus` and its builder in `lib/features/home/domain/day_status.dart`, `CycleOutlook` and its builder in `.../cycle_outlook.dart`, `ServerHomeRepository` and `HomeServerApi` in `.../data/server_home_repository.dart`, and `HomeBloc` in `.../presentation/bloc/home_bloc.dart`, so the test tasks compile and then fail (depends on T005a, T005b, T006)

**Checkpoint**: Interfaces, events, state, fake and stubs exist; tests compile and fail.

---

## Phase 3: User Story 2 - Home's logic is verifiable without the UI or a server (Priority: P1)

**Goal**: All of Home's rules and state handling live in headless-testable code.

**Independent Test**: `flutter test test/features/home/domain test/features/home/data test/features/home/presentation/home_bloc_test.dart` passes with no device or server, in under 10 seconds.

### Tests (write first; they must fail)

- [X] T007 [P] [US2] Tests for `DayStatus` in `test/features/home/domain/day_status_test.dart`: period day N from the start date, flow inside a period, flow outside a period, no period, flow `none` inside a period
- [X] T008 [P] [US2] Tests for `CycleOutlook` in `test/features/home/domain/cycle_outlook_test.dart`: no cycle day, days until next period, overdue (≤ 0 days), no next start, confidence passthrough
- [X] T009 [P] [US2] Tests for `ServerHomeRepository` in `test/features/home/data/server_home_repository_test.dart` using a fake `HomeServerApi`: `loadDay` bundles the five results, empty lists give null day log and period, `loadDueReminders` keeps only due reminders and joins medication names (falling back to "Medication"), `logReminderDose` and `dismissReminder` pass the right ids and date key
- [X] T010 [US2] Tests for `HomeBloc` in `test/features/home/presentation/home_bloc_test.dart` using `bloc_test`, `FakeHomeRepository`, a fixed clock and a `StreamController` for reminder ticks. Cover: start loads day, prediction and reminders in parallel; day change loads the new date and leaves prediction alone; two quick day changes show only the last (late first response ignored); day load failure gives a failed state while prediction and reminders stay; prediction and reminder failures are silent; pull-to-refresh (`HomeRefreshed`) reloads the day only; returning from the log screen (`HomeReturnedFromLog`) reloads the day and reminders but not the prediction; tick reloads reminders; log dose and dismiss call the repository then reload reminders; a failing log dose or dismiss keeps the banner, reloads reminders and does not throw; a day load that completes after the bloc is closed emits nothing and throws nothing; closing the bloc cancels the tick subscription

### Implementation

- [X] T011 [P] [US2] Implement `DayStatus` and its builder function in `lib/features/home/domain/day_status.dart` (replace the stub; pure Dart; makes T007 pass)
- [X] T012 [P] [US2] Implement `CycleOutlook` and its builder in `lib/features/home/domain/cycle_outlook.dart` (replace the stub; pure Dart; makes T008 pass)
- [X] T013 [US2] Define the `HomeServerApi` interface (the calls listed in contracts/home_repository.md) and implement `ServerHomeRepository` in `lib/features/home/data/server_home_repository.dart`, plus a thin adapter `ClientHomeServerApi` over the generated `Client` in `lib/features/home/data/client_home_server_api.dart` (replace the stub; makes T009 pass)
- [X] T016 [US2] Implement `HomeBloc` in `lib/features/home/presentation/bloc/home_bloc.dart`: injected repository, clock and tick stream; `restartable()` for day loads; silent failures for prediction and reminders (replace the stub; makes T010 pass; depends on T011-T013)

**Checkpoint**: All headless tests pass. The old screen still works untouched.

---

## Phase 4: User Story 1 - Home looks and behaves exactly as before (Priority: P1) 🎯 MVP

**Goal**: The Home screen is driven by the bloc and looks and behaves identically.

**Independent Test**: quickstart.md steps 3 and 4 (happy-path widget test plus manual parity check).

### Tests (write first)

- [X] T017 [US1] Widget happy-path test in `test/features/home/presentation/home_screen_test.dart`: pump `HomeScreen` with a `FakeHomeRepository` and a manual tick stream; it shows the day circle, a band for a logged item and a due-reminder banner, and tapping the circle calls the open-calendar callback with the selected date. Find widgets by `Key` or type, not by text or counts. Add the needed `Key`s to the widgets in T019

### Implementation

- [X] T018 [US1] Move `lib/screens/home_screen.dart` to `lib/features/home/presentation/home_screen.dart` (use `git mv`). Replace its state and `_load*` methods with a `BlocBuilder`/`BlocListener` on `HomeBloc`; keep `onOpenCalendar` and the navigation to `LogScreen`; after `LogScreen` returns changed, add `HomeReturnedFromLog`; pull-to-refresh adds `HomeRefreshed`
- [X] T019 [US1] Extract `_DayCircle`, `_ArrowButton`, `_CycleHeader` and `_ReminderBanner` into `lib/features/home/presentation/widgets/` as public widgets that take plain values (reusing `DayBands`, `formatDayLabel` and the label extensions unchanged); render status text from `DayStatus` and header text from `CycleOutlook` with the exact current wording, and add a unit test in `test/features/home/presentation/home_text_test.dart` that the status and header text match today's wording; add `Key`s for T017 (depends on T011, T012)
- [X] T020 [US1] Update `lib/app_shell.dart`: build `ServerHomeRepository(ClientHomeServerApi(client))` and provide `HomeBloc` (clock `DateTime.now`, `Stream.periodic(1 minute)` ticks) with `BlocProvider` around `HomeScreen`; update the `HomeScreen` import
- [X] T021 [US1] Run `dart analyze` and `dart format` in `tidal_flutter` and fix findings
- [ ] T022 [US1] Manual parity check: run quickstart.md step 4 (all seven checks) against the running app and fix any difference

**Checkpoint**: Home is fully migrated and behaves as before; the old inline loading code is gone.

---

## Phase 5: User Story 3 - Logic-focused UI tests become headless tests (Priority: P2)

**Goal**: The test suite follows the constitution's test pyramid.

**Independent Test**: Review test files; run `flutter test` for the whole client.

- [X] T023 [US3] Audit the client's tests (`tidal_flutter/test/`, including `widget_test.dart`) for UI tests that check Home logic; migrate any found into the headless tests above, or record in the plan that none exist (the placeholder `widget_test.dart` is empty)
- [X] T024 [US3] Confirm every Home widget test finds widgets by key or type, not label text or item counts, and that at most three Home UI tests exist (SC-004)
- [X] T025 [US3] Run the whole client suite with `flutter test` and confirm it passes

---

## Phase 6: Polish and cross-cutting

- [X] T026 [P] Write `lib/features/home/README.md` documenting the layers, the test strategy and a short "how to migrate the next screen" recipe (FR-010)
- [X] T027 [P] Update `AGENTS.md` and `CLAUDE.md` (Flutter section): Home now lives in `lib/features/home` using BLoC; new screens follow it
- [X] T028 Constitution check: confirm no `client.` call remains in `lib/features/home/presentation`, no new data collected or logged (Principle I), and the two documented deviations are unchanged
- [ ] T029 Run quickstart.md end to end and tick SC-001 to SC-005

---

## Dependencies and Order

- Setup (T001-T002) → Foundational (T003-T006a) → US2 (T007-T016) → US1 (T017-T022) → US3 (T023-T025) → Polish (T026-T029).
- US1 depends on US2 (the bloc). US3 depends on US1 and US2 (it audits their tests).
- T007-T010 depend on T006a (compiling stubs), so they fail for the right reason before the implementation. Within a phase, tests come before the code they cover (T007-T010 before T011-T016; T017 before T018-T020).
- T011 and T012 depend on the tests only. T016 depends on T011-T013. T019 depends on T011-T012. T020 depends on T013, T016 and T018.

## Parallel Opportunities

- T003 and T004 together.
- T007, T008, T009 and T010 together (different files, all after T006a).
- T005a and T005b together; T011 and T012 together.
- T026 and T027 together.

## Implementation Strategy

**MVP**: Phases 1-4. At the end of Phase 4 the migration is complete and Home is unchanged for users. Phase 5 is cleanup, and Phase 6 documents the pattern. Commit after each phase, and keep the app runnable after every task: the old screen stays in place until T018 switches it over.
