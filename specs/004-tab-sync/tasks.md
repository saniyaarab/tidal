# Tasks: Keep Home and Calendar in Sync

**Input**: Design documents from `/specs/004-tab-sync/`

**Prerequisites**: plan.md, spec.md

**Tests**: Headless tests written first and run to confirm they fail (constitution Principle II: "A bug fix MUST start with a test that reproduces the bug"). No UI tests.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1)

## Phase 1: Failing tests (User Story 1)

- [ ] T001 [P] [US1] `tidal_flutter/test/app_tabs_test.dart` (new): `tabToReload(from, to)` returns Home when switching Calendar → Home, Calendar when switching Home → Calendar, Home when switching Insights/Journal/Me → Home; null for Home → Home, Calendar → Calendar, and switches to Insights, Journal or Me.
- [ ] T002 [P] [US1] In `tidal_flutter/test/features/home/presentation/home_bloc_test.dart`: after Home has loaded, `HomeTabReturned` loads the selected day and the prediction again (`loadedDays` gains the date, `predictionLoads` goes up), shows the new day's data, and never emits `DayLoadStatus.loading`; when that reload fails, the previous day's data stays and no error is shown.
- [ ] T003 [P] [US1] In `tidal_flutter/test/features/calendar/presentation/calendar_bloc_test.dart`: after the Calendar has loaded, `CalendarTabReturned` loads the same month and selected day again (`loads` gains an entry), shows the new data, and never emits `CalendarLoadStatus.loading`; when that reload fails, the previous data stays and no error is shown.
- [ ] T004 Run `flutter test` and confirm T001–T003 fail (they reference code that doesn't exist yet), which reproduces the bug at the logic level.

## Phase 2: Fix (User Story 1)

- [ ] T005 [P] [US1] Create `tidal_flutter/lib/app_tabs.dart` with `AppTab` and `tabToReload` (makes T001 pass).
- [ ] T006 [P] [US1] Add `HomeTabReturned` to `home_event.dart`; in `home_bloc.dart` handle it with `restartable()`, reloading the day quietly and calling `_loadPrediction` (makes T002 pass).
- [ ] T007 [P] [US1] Add `CalendarTabReturned` to `calendar_event.dart`; in `calendar_bloc.dart` handle it with `restartable()` through a quiet variant of `_load` (makes T003 pass).
- [ ] T008 [US1] In `tidal_flutter/lib/app_shell.dart`: keep the `HomeBloc` in a field provided with `BlocProvider.value` and close it in `dispose`; use `AppTab` for the tab indexes; in `onDestinationSelected`, send `HomeTabReturned` or `CalendarTabReturned` as `tabToReload` says.

## Phase 3: Polish

- [ ] T009 Run `dart format`, `dart analyze` and `flutter test` in `tidal_flutter`; all clean and passing.
- [ ] T010 Hot restart and check by hand: change today's weight on the Calendar, switch to Home, and see the new weight with no spinner; log mucus on Home, switch to the Calendar, and see it there.
- [ ] T011 Update `AGENTS.md` (the Home and Calendar BLoC notes) to say that switching to either tab reloads it quietly.

## Dependencies

- T001–T003 before T005–T008 (tests first). T004 confirms they fail.
- T008 needs T005–T007.
