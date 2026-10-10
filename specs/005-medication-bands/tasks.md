# Tasks: Medication Bands on Home and Calendar

**Input**: Design documents from `/specs/005-medication-bands/`

**Prerequisites**: plan.md, spec.md

**Tests**: Written first and run to confirm they fail (constitution Principle II). Server: `serverpod_test` integration tests. App: headless tests with the existing fakes. No new UI tests.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: US1 (see what I took) or US2 (remove a dose)

## Phase 1: Setup

- [X] T001 Add `flutter_slidable` to `tidal_flutter/pubspec.yaml` and run `flutter pub get`.

## Phase 2: Server, test first (US2)

- [X] T002 [US2] In `tidal_server/test/integration/day_details_test.dart`, add failing tests: `deleteDose` removes the signed-in user's dose and returns it; another user's `deleteDose`, and `deleteDose` for an id that doesn't exist, return null and delete nothing (a second delete of the same dose also returns null); deleting the latest dose of a medication with a reminder recalculates it from the previous dose; deleting its only dose removes the reminder; deleting an older (not latest) dose leaves the reminder untouched, including `isDue: false` after a dismiss; `restoreDose` brings the dose back with the same day, time and dose text and recalculates the reminder; restoring an older dose leaves the reminder untouched; `restoreDose` for another user's medication throws; `restoreDose` with a future date or time throws and inserts nothing; `restoreDose` ignores a different `userId` on the passed dose and saves it under the signed-in user.
- [X] T003 [US2] Run `dart test` in `tidal_server` (after `serverpod generate` with the project's 4.0.0 CLI) and confirm T002's tests fail.
- [ ] T004 (code written and analyzer-clean, tests not yet run: see Notes) [US2] Implement `deleteDose`, `restoreDose` and `_recalculateReminder` in `tidal_server/lib/src/pain/pain_endpoint.dart`; regenerate the client; T002's tests pass.

## Phase 3: App, test first (US1 and US2)

- [X] T005 [P] [US1] `tidal_flutter/test/shared/latest_doses_test.dart` (new): one dose per medication, the latest by time; two medications give two doses; no doses give none.
- [X] T006 [P] [US1] Home repository test: `loadDay` includes the day's doses and the medications, and fails as a whole if loading either fails, like any other part of the day; `deleteDose`/`restoreDose` call the API. Update `FakeHomeRepository` with doses, medications and delete/restore records.
- [X] T007 [P] [US2] Home bloc tests: `HomeDoseDeleted` calls the repository, reloads the day and reminders, and sets a one-time "dose removed" message carrying the dose; `HomeDoseRestored` restores it and reloads; a failing delete sets a failure message and keeps the day; a repository that returns null from `deleteDose` makes the bloc reload the day and set no message; a failing `restoreDose` sets a "couldn't restore" message and reloads the day.
- [X] T008 [P] [US1] Calendar repository test: `load` includes the selected day's doses and the medications, and fails as a whole if loading either fails; `deleteDose`/`restoreDose` call the API. Update `FakeCalendarRepository`.
- [X] T009 [P] [US2] Calendar bloc tests: `CalendarDoseDeleted`/`CalendarDoseRestored` as for Home, run in order with period edits; the message kind is "dose removed"; a null from `deleteDose` reloads with no message; a failing `restoreDose` sets a "couldn't restore" message and reloads.
- [X] T010 Run `flutter test` and confirm T005–T009 fail.

## Phase 4: App implementation

- [X] T011 [US1] Create `tidal_flutter/lib/shared/latest_doses.dart` (T005 passes).
- [X] T012 [US1] Home data and domain: `DayData` + `HomeServerApi`/`ClientHomeServerApi` + `ServerHomeRepository` + `HomeRepository` (T006 passes).
- [X] T013 [US2] Home bloc: `HomeMessage`, events, handlers (T007 passes).
- [X] T014 [US1] Calendar data and domain: `CalendarData` + API + repository (T008 passes).
- [X] T015 [US2] Calendar bloc and `CalendarMessage` "dose removed" kind (T009 passes).
- [X] T016 [US1][US2] `DayBands`: medication bands in time order with the type icon and "taken <time since>"; `Slidable` Delete when `onDeleteDose` is given.
- [X] T017 [US1][US2] `HomeScreen` and `CalendarScreen`: pass doses, medications and `onDeleteDose` to `DayBands`; show "Dose removed · Undo" with `persist: false`. Wording in `home_text.dart` and `calendar_text.dart`, including "couldn't delete" and "couldn't restore".

## Phase 5: Polish

- [ ] T018 (done except `dart test` in `tidal_server`: see Notes) Run `dart format` and `dart analyze` (server and app), `dart test` (server) and `flutter test` (app); all clean and passing.
- [ ] T019 (not done: needs the running app) Hot restart and check by hand: mark Tylenol taken twice and see one band for the latest; swipe it left, tap Delete, see the earlier dose's band and "Dose removed · Undo"; tap Undo and see it return; check the Medications sheet's "Last taken".
- [X] T020 Update CLAUDE.md and AGENTS.md (FR-009).

## Dependencies

- T002–T003 before T004 (server test first). T004 before the app's API changes (T012, T014) need the regenerated client.
- T005–T010 before T011–T017 (app tests first).
- T016 before T017.

## Notes (implementation, 2026-10-10)

- T003: confirmed failing as a compile error (`deleteDose`/`restoreDose` undefined on the test endpoint).
- T004 / T018: the server integration tests could not be run here. Every `withServerpod` test, including existing ones, exits silently while loading, and `.serverpod/test` is never created. On a clean checkout of the branch head the same test fails with `No named parameter 'ephemeralDatabase'` in `test/integration/test_tools/serverpod_test_tools.dart`: that file was generated by the 4.0.3 CLI (Serverpod App Studio) but `serverpod_test` is pinned to 4.0.0. The generated test tools in this change were regenerated with `serverpod_cli` 4.0.0 (`dart pub global activate serverpod_cli 4.0.0`), which drops `ephemeralDatabase`. Running `dart test` in `tidal_server` from the developer's terminal, and aligning the CLI and `serverpod_test` versions, is still needed.
- The app side is complete: `flutter analyze` is clean and `flutter test` passes (148 tests).
