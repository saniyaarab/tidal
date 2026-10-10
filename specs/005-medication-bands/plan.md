# Implementation Plan: Medication Bands on Home and Calendar

**Branch**: `005-medication-bands` (spec directory; work is on the git branch `feature/medication-bands`) | **Date**: 2026-10-09 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/005-medication-bands/spec.md`

## Summary

Home and the Calendar load the shown day's doses and the user's medications through their repositories, and `DayBands` shows one band per medication for its latest dose that day, chosen by a shared pure function. Each medication band can be swiped left to reveal Delete. The server gains `deleteDose` and `restoreDose` (for Undo), both of which recalculate that medication's reminder from its latest remaining dose. Each bloc handles delete and undo and shows a one-time "Dose removed · Undo" message (4 seconds).

## Technical Context

**Language/Version**: Dart / Flutter and Serverpod 4.0.0, as pinned

**Primary Dependencies**: existing `tidal_client`, `flutter_bloc`, `bloc_concurrency`, `equatable`; **new: `flutter_slidable`** (swipe-to-reveal actions on a list row; widely used, MIT licence)

**Storage**: No schema change and no migration: doses are deleted from and restored into the existing `dose_log` table; reminders use the existing `medication_reminder` table

**Testing**: server: `serverpod_test` integration tests (`dart test` in `tidal_server`); app: headless tests (`flutter test` in `tidal_flutter`) for the latest-dose rule, repositories and both blocs, with the existing hand-written fakes

**Target Platform**: Existing Flutter targets (iOS, Android, web)

**Project Type**: mobile-app + Serverpod server

**Constraints**: Home and Calendar each make two more calls when loading a day (the day's doses and the medication list); bands show "time since", never the clock time

**Scale/Scope**: server: 1 endpoint file + tests; app: shared rule + `DayBands`, Home and Calendar data, domain and bloc layers + tests; docs

## Design

### Server (`tidal_server/lib/src/pain/pain_endpoint.dart`)
1. **`deleteDose(int doseLogId) → DoseLog?`**: finds the dose; if it doesn't exist or isn't the signed-in user's, deletes nothing and returns `null` (the same answer either way, so it doesn't reveal that someone else's dose exists). Otherwise deletes it, recalculates that medication's reminder (see 3), and returns the deleted dose (the app keeps it for Undo).
2. **`restoreDose(DoseLog dose) → DoseLog`**: refuses unless `dose.medicationId` is one of the signed-in user's medications; runs the same `_checkNotFuture(dose.date, dose.timestamp)` as `logDose`, so Undo can't be used to save a future dose; inserts the dose again with its original day, time, dose text and saved-at time (a new id, always the signed-in user's `userId`, whatever `userId` the client sent); recalculates the reminder (see 3). The dose text comes from the client's copy, which is acceptable because it only ever lands in the user's own data.
3. **`_recalculateReminder(session, medication, changedDose)`** (private): runs only if the medication has `reminderEveryHours` **and** `changedDose` was (delete) or is now (restore) the medication's latest dose. Otherwise it does nothing, so a reminder the user already dismissed isn't brought back by removing or restoring an older dose. When it does run, it sets the reminder to the latest remaining dose + interval (`isDue` if that's in the past, otherwise scheduled with `MedicationReminderFutureCall`), or deletes the reminder if no dose is left. Unlike `logDose`, this may move the due time earlier, because the latest dose may have gone. A future call scheduled for the old time finds the reminder already moved, deleted or due and does nothing (`markDue` already checks this).

### App: shared rule and bands
4. **`tidal_flutter/lib/shared/latest_doses.dart`** (new): `List<DoseLog> latestDosePerMedication(List<DoseLog> doses)`, one per medication, the latest by `timestamp`. Shared by Home and the Calendar (see Complexity Tracking).
5. **`tidal_flutter/lib/widgets/day_bands.dart`**: new optional inputs `doses`, `medicationsById` and `onDeleteDose`. Medication bands (lavender, the medication's type icon via the existing `medicationIcon`, "<name> <dose> · taken <time since>") join the time-ordered list with pain and bowel movements. When `onDeleteDose` is given, each medication band is wrapped in a `Slidable` with one red Delete action.

### App: Home
6. **Data**: `DayData` gains `doses` and `medicationsById`; `HomeServerApi` gains `getDoses(from, to)` and `deleteDose`/`restoreDose`; `ServerHomeRepository.loadDay` loads the day's doses and medications alongside the rest; `HomeRepository` gains `deleteDose(DoseLog) → DoseLog?` and `restoreDose(DoseLog)`.
7. **Bloc**: new events `HomeDoseDeleted(dose)` and `HomeDoseRestored(dose)`, handled one at a time (`sequential()`); each calls the repository, reloads the day and the reminders, and on delete sets a one-time `HomeMessage` ("Dose removed", with the deleted dose for Undo). A failed delete sets a "couldn't delete" message and leaves the day as it was. A delete that returns `null` (the dose was already gone) reloads the day and sets no message. A failed restore sets a "couldn't restore" message and reloads the day. The message kinds are therefore: dose removed (carries the dose), couldn't delete, couldn't restore. If loading the day's doses or medications fails, the whole day load fails like any other part of it (the existing error state and retry). Home has no one-time messages today; `HomeMessage` follows the Calendar's `CalendarMessage` pattern (an id so each is shown once).
8. **Screen**: `HomeScreen` passes `onDeleteDose` to `DayBands` and shows `HomeMessage`s with a `BlocListener` as a SnackBar (`persist: false`, Undo action).

### App: Calendar
9. **Data**: `CalendarData` gains the selected day's `doses` and `medicationsById`; `CalendarServerApi` and `ServerCalendarRepository` as for Home; `CalendarRepository` gains `deleteDose` (returning `DoseLog?`) and `restoreDose`.
10. **Bloc and screen**: `CalendarDoseDeleted(dose)` and `CalendarDoseRestored(dose)` join the existing sequential edit events; `CalendarMessage` gains a "dose removed" kind; the screen passes `onDeleteDose` to `DayBands`.

### Docs
11. CLAUDE.md ("More daily logging", "Screens") and AGENTS.md: medications show on Home and the Calendar again, as the latest dose per medication, with swipe-to-delete and Undo.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] I. Privacy: no new data or tables. `deleteDose` and `restoreDose` only act on the signed-in user's own doses and medications (integration tests cover another user's attempt). "Delete all my data" is unchanged and still deletes every dose and reminder.
- [x] II. Test-first: tasks put failing tests first for the server endpoints, the latest-dose rule, both repositories and both blocs.
- [x] III. All server access stays behind `HomeServerApi`/`HomeRepository` and `CalendarServerApi`/`CalendarRepository`; tests use the hand-written fakes.
- [x] IV. No new UI tests; the swipe is a library widget, and the logic it triggers is tested in the blocs.
- [~] V. New strings ("taken", "Delete", "Dose removed", "Undo", the failure message) go in the existing wording files; localization is still not set up (existing deviation).
- [x] VI. Reuses `DayBands`, `medicationIcon`, `formatRelativeTime`, the period-message pattern, `persist: false`, and the existing reminder scheduling.
- [~] VII. Layers followed in each feature; the latest-dose rule is shared at app level (see Complexity Tracking).

## Project Structure

```text
specs/005-medication-bands/
├── spec.md
├── plan.md        # this file
└── tasks.md

tidal_server/
├── lib/src/pain/pain_endpoint.dart          # deleteDose, restoreDose, _recalculateReminder
└── test/integration/day_details_test.dart   # delete/restore/reminder tests

tidal_flutter/lib/
├── shared/latest_doses.dart                 # NEW: latestDosePerMedication
├── widgets/day_bands.dart                   # medication bands + Slidable delete
├── features/home/
│   ├── domain/day_data.dart, home_repository.dart, home_message.dart (NEW)
│   ├── data/server_home_repository.dart, client_home_server_api.dart
│   └── presentation/bloc/*, home_screen.dart, home_text.dart
└── features/calendar/
    ├── domain/calendar_data.dart, calendar_repository.dart, period_message.dart
    ├── data/server_calendar_repository.dart, client_calendar_server_api.dart
    └── presentation/bloc/*, calendar_screen.dart, calendar_text.dart

tidal_flutter/test/
├── shared/latest_doses_test.dart            # NEW
├── features/home/...                         # repository + bloc tests, fake updates
└── features/calendar/...                     # repository + bloc tests, fake updates
```

## Complexity Tracking

| Deviation | Why | Simpler alternative rejected because |
|-----------|-----|--------------------------------------|
| VII: `lib/shared/latest_doses.dart` outside the feature folders | Home and the Calendar both need the same rule; spec 002 keeps the two features independent, so neither should import the other | Duplicating the rule in both features would let them drift apart |
| New dependency `flutter_slidable` | The spec asks for swipe-to-**reveal** a Delete option; Flutter's built-in `Dismissible` only removes on swipe | Building swipe-to-reveal by hand is more code and more bugs than a well-used package |
| Home gains a one-time message mechanism (`HomeMessage`) | Undo needs a message, and Home had none | Showing the SnackBar straight from the widget would put the delete flow's logic in the UI (Principles II and IV) |
