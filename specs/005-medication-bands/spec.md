# Feature Specification: Medication Bands on Home and Calendar

**Feature Branch**: `005-medication-bands` (spec directory name only; work is on the git branch `feature/medication-bands`)

**Created**: 2026-10-09

**Status**: Clarified (Q1: Undo message; Q2: per medication)

**Input**: GitHub issue #7, "Show medications taken on Home and the Calendar" (priority: high), and the developer's answers: show on Home and the Calendar's day view; "Tylenol 800 mg · taken 2h ago"; lavender with the medication's type icon; ordered by time with the other timed entries; "only show the last dose taken"; "one can slide left and see the option to delete". Full dose history is a separate issue (#8).

## Overview

Marking a medication as taken saves a dose, but the dose doesn't appear on Home or in the Calendar's day view, so there's no way to see what was taken on a day. This feature shows the last dose of each medication taken that day as a band, and lets the user delete a dose logged by mistake by swiping its band left.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - See what I took today (Priority: P1)

A signed-in user marks a medication as taken, then sees it on Home for that day, and in the Calendar when that day is selected.

**Why this priority**: Knowing what was taken and how long ago is the core of the medication feature, and it's what the developer's own routine (alternating painkillers) depends on.

**Independent Test**: Mark Tylenol as taken, then open Home and the Calendar on that day.

**Acceptance Scenarios**:

1. **Given** the user took Tylenol (usual dose 800 mg) 2 hours ago, **When** Home shows today, **Then** it shows a lavender band with the painkiller icon reading "Tylenol 800 mg · taken 2h ago".
2. **Given** the same dose, **When** the Calendar has today selected, **Then** its day view shows the same band.
3. **Given** the user took Tylenol at 08:00 and again at 14:00 today, **When** Home shows today, **Then** only one Tylenol band appears, for the 14:00 dose.
4. **Given** the user took Tylenol and Ibuprofen today, **When** Home shows today, **Then** one band appears for each medication.
5. **Given** a pain entry at 09:00, a Tylenol dose at 10:00 and a bowel movement at 11:00, **When** Home shows the day, **Then** the bands appear in that time order, followed by the once-a-day items (mood, drinks, sleep and so on) and the note, as today.
6. **Given** a dose was taken on an earlier day, **When** that day is shown, **Then** its band shows time since as elsewhere (e.g. "taken 2 days ago").

---

### User Story 2 - Remove a dose logged by mistake (Priority: P1)

A user who marked the wrong medication, or marked it twice, swipes its band left, sees a Delete option, and removes the dose.

**Why this priority**: Without it, a mistaken dose stays forever and makes the "time since last dose" wrong, which matters for avoiding overdoses.

**Independent Test**: Log a dose, swipe its band left, tap Delete, and check the band and the Medications sheet.

**Acceptance Scenarios**:

1. **Given** a medication band, **When** the user swipes it left, **Then** a red Delete option appears; nothing is deleted yet.
2. **Given** the Delete option is showing, **When** the user taps it, **Then** that dose is deleted on the server, its band goes away, and "Dose removed · Undo" shows for 4 seconds.
3. **Given** the user took Tylenol at 08:00 and 14:00 and deletes the 14:00 band, **When** the day reloads, **Then** a Tylenol band for 08:00 appears (it's now the last dose).
4. **Given** the user swipes a band but doesn't tap Delete, **When** they swipe it back or tap elsewhere, **Then** the band returns to normal and nothing is deleted.
5. **Given** the deleted dose was the latest one for a medication with a reminder, **When** it's deleted, **Then** the reminder is based on the medication's latest remaining dose, or removed if none is left (so "due now" never refers to a dose that no longer exists).
6. **Given** a dose is deleted, **When** the Medications sheet is opened, **Then** "Last taken" reflects the latest remaining dose.
7. **Given** "Dose removed · Undo" is showing, **When** the user taps Undo, **Then** the dose comes back and its band reappears.

---

### Edge Cases

- Deleting fails (offline, server error): the band stays and a message says it couldn't be deleted.
- The dose was already deleted (a double tap, or another device): nothing happens on the server, the band disappears when the day reloads, and no failure message or Undo is shown.
- Undo fails (offline, server error): the day reloads as it is, and a message says the dose couldn't be restored.
- The day's doses or medications can't be loaded: the day shows the same error state as any other failed load, with the existing retry. The bands are never silently missing.
- A user can only ever see or delete their own doses.
- A medication with no dose on the shown day has no band.
- The Calendar and Home don't refresh each other when switching tabs (issue #6), so a dose logged or deleted on one tab appears on the other after a pull-to-refresh, until #6 is fixed.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Home and the Calendar's day view MUST show one band per medication taken on the shown day, for that medication's latest dose that day.
- **FR-002**: A band MUST read "<name> <dose> · taken <time since>" (e.g. "Tylenol 800 mg · taken 2h ago"), using the dose saved with the log and the same time-since wording as pain bands.
- **FR-003**: A band MUST be lavender and use the medication's type icon (the same icons as the Medications sheet).
- **FR-004**: Medication bands MUST be ordered by time among the other timed bands (pain, bowel movements), before the once-a-day items and the note.
- **FR-005**: Swiping a medication band left MUST reveal a Delete option; tapping it MUST delete that dose. Other bands don't swipe.
- **FR-006**: The server MUST offer deleting a dose, only for the signed-in user's own doses, and MUST update or remove that medication's reminder so it reflects the latest remaining dose. Deleting a dose that isn't the medication's latest MUST leave its reminder, including a dismissed one, unchanged.
- **FR-007**: The rule choosing the last dose per medication per day MUST be plain logic, tested headlessly; the server's delete MUST be covered by integration tests (constitution Principle II).
- **FR-008**: "Delete all my data" continues to delete all doses (unchanged).
- **FR-009**: CLAUDE.md and AGENTS.md MUST be updated: they currently say medications aren't shown on Home or the Calendar.
- **FR-010**: After a delete, a "Dose removed · Undo" message MUST show for 4 seconds and then disappear by itself; tapping Undo MUST restore the same dose (medication, day, time and dose) and recalculate that medication's reminder.

### Key Entities

- **Dose**: one medication taken at a time on a day (existing `DoseLog`).
- **Medication band**: what a day shows for one medication: its latest dose that day, with name, dose, type icon and time since.

## Clarifications

- **Q1 (answered 2026-10-09)**: After tapping Delete, is there an Undo? → **Yes**: a "Dose removed · Undo" message shows for 4 seconds, like the period messages; Undo puts the same dose back (same medication, day, time and dose), and its reminder is recalculated again (FR-010).
- **Q2 (answered 2026-10-09)**: "Only show the last dose": per medication or one band in total? → **Per medication** (FR-001): one Tylenol band and one Ibuprofen band, so alternating painkillers shows both.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every scenario in User Stories 1 and 2 holds.
- **SC-002**: The last-dose rule and the delete flow are covered by tests written before the code; the analyzer is clean and the app and server test suites pass.

## Assumptions

- Full dose history (every dose, editing past doses) is out of scope: issue #8.
- Swipe-to-delete applies to medication bands only.
- Home and the Calendar load doses and medications through their existing repositories (`HomeRepository`, `CalendarRepository`), extended as needed.
