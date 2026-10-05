# Feature Specification: Calendar Screen State Migration

**Feature Branch**: `002-calendar-screen-bloc` (spec directory name only; work continues on the current git branch)

**Created**: 2026-10-04

**Status**: Draft

**Input**: User description: "Calendar screen migration to bloc. The calendar screen has a mix of state loading and ui. Let's migrate it to use bloc for state management. Where possible we should try to mold the code into a clean architecture approach. Any existing ui tests should still pass. UI tests that focus on logic should be migrated to unit tests that can be run headless."

## Overview

The Calendar screen loads its data, holds its state, applies its display rules (which days get which ring, which dates are shown in the grid, what each period change says), and draws the UI all in one place. This feature separates those concerns, following the pattern set by the Home screen migration (`specs/001-home-screen-bloc/` and `tidal_flutter/lib/features/home/README.md`), so the Calendar's behavior can be verified without running the UI or a server (constitution Principles II, III and VII). The user-visible behavior of the Calendar MUST NOT change, except for the two improvements noted in Assumptions.

The state-management approach is the BLoC pattern, chosen by the developer, with the same layering as Home: presentation, domain and data, with the data layer as the only place that talks to the server.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The Calendar looks and behaves exactly as before (Priority: P1)

A signed-in user opens the Calendar and sees the month grid with period rings, predicted-period and fertile-window rings, today's ring, and pain dots, with the selected day's log below. They can move between months, select a day, long-press a day to start, end, move or remove a period (with a message and Undo), open the log menu with "+", pull to refresh, and arrive from Home with a date already selected.

**Why this priority**: The migration is only successful if users notice nothing. The Calendar is where periods are recorded, so a regression here damages the app's core data.

**Independent Test**: Run the app and compare each behavior in the requirements against what the Calendar did before; run the Calendar's happy-path UI tests (User Story 3).

**Acceptance Scenarios**:

1. **Given** a user with a logged period, a predicted period, a fertile window and a pain entry in the visible month, **When** they open the Calendar, **Then** each day shows the right ring (logged beats predicted beats fertile beats today) and pain days show a dot.
2. **Given** the Calendar shows October, **When** the user taps the next arrow, **Then** November's grid is shown with its data, and the selected day stays selected.
3. **Given** the user taps a day, **When** the data loads, **Then** that day is highlighted and its log appears below the grid.
4. **Given** the user long-presses a past day that is not near a period, **When** the change is saved, **Then** a period starts there, that day becomes selected, the grid updates, and a message such as "Period started · assumed 5 days" appears with an Undo button.
5. **Given** a period change message is showing, **When** the user taps Undo, **Then** the change is reversed and the grid updates.
6. **Given** the user long-presses a future day, **When** nothing is saved, **Then** a message says periods can't be logged for future dates.
7. **Given** the user taps the day circle on Home, **When** the Calendar opens, **Then** it shows that date's month with the date selected.
8. **Given** the user logs something through the "+" button and returns, **When** the Calendar reappears, **Then** it shows the updated data without a manual refresh.

---

### User Story 2 - The Calendar's logic is verifiable without the UI or a server (Priority: P1)

A developer can verify every rule the Calendar applies (which dates fall in the grid, which ring each day gets, how a period's days are expanded, what each period change message says, how month and day changes load data, and what happens when a load or a long-press fails) with fast tests that run headless, using fake data sources in place of the real server.

**Why this priority**: This is the reason for the migration. The Calendar has the most rules of any screen, and they are the part users depend on most.

**Independent Test**: Run the Calendar logic tests with no device, emulator or running server and confirm they pass in seconds.

**Acceptance Scenarios**:

1. **Given** fake data sources returning a period that spans two months, **When** the Calendar logic loads a month, **Then** its state marks every day from the period's start through its end, including days in the grid's neighbouring months.
2. **Given** a day that is both a logged period day and a fertile day, **When** its ring is worked out, **Then** the logged period wins.
3. **Given** the user moves to another month, **When** the data finishes loading, **Then** the state reflects that month only, even if an earlier load finishes late.
4. **Given** fake data sources where a load fails, **When** the Calendar logic loads, **Then** its state carries an error that can be shown without affecting the grid already on screen.
5. **Given** a long-press on a past day, **When** the fake server reports each kind of period change (started, ended, moved, removed), **Then** the state asks the screen to show the matching message with an Undo action, once.
6. **Given** a long-press on a future day, **When** it is handled, **Then** no request reaches the data source and the "can't log future dates" message is requested.

---

### User Story 3 - Logic-focused UI tests become headless tests (Priority: P2)

Any existing UI test whose purpose is to check Calendar logic is replaced by an equivalent headless test. A small number of happy-path UI tests remain for the Calendar.

**Why this priority**: It keeps the test suite fast and not fragile, per the constitution (Principle IV), but it only matters once the logic is separated.

**Independent Test**: Review the test suite: Calendar logic appears in headless tests, and the remaining Calendar UI tests are few, happy-path, and do not depend on label text or item counts.

**Acceptance Scenarios**:

1. **Given** any existing UI test that checks a Calendar rule, **When** the migration is complete, **Then** that rule is covered by a headless test and the UI test is removed or reduced to a happy path.
2. **Given** all remaining Calendar UI tests, **When** they are run, **Then** they pass and none depend on specific label text or item counts.

---

### Edge Cases

- A month or day load fails (network error): the Calendar shows the existing "Could not load this day" message in place of the day's log, and keeps showing the grid.
- A long-press fails (offline, server error): the existing "Could not update the period" message appears, and the grid is left as it was.
- Undo fails: nothing crashes, and the grid is reloaded so it shows what the server actually has.
- The user taps through months or days quickly: only the most recently chosen month and day are shown.
- Home sends the same date twice in a row: the Calendar behaves as it does today (see Assumptions).
- A period spans several months, or starts before the visible grid: its days still show on every grid cell they cover.
- The message for a period change is replaced by the next one (a new long-press hides the old message), as today. Taps on days do not hide it.
- The screen is closed or the tab is rebuilt while a load or save is in flight: nothing happens afterward, with no errors.
- The user's session ends (sign-out or account deletion) while the Calendar is open: no stale data is shown to the next user.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The Calendar MUST show the same content and behave the same as before for all of: the month header and arrows, the Sunday-first 6-week grid including neighbouring-month days, the ring priority (logged period, predicted period, fertile window, today), pain dots, the legend, day selection and highlight, the selected day's log (with its loading and error states), the "+" button, pull-to-refresh, arriving from Home with a date selected, and long-press period changes with their messages and Undo.
- **FR-002**: The Calendar's state (shown month, selected date, day logs, period dates, pain dates, the selected day's pain entries and bowel movements, unit preferences, prediction, loading and error status) MUST be held and changed outside the UI widgets, and the widgets MUST only display it and report user actions.
- **FR-003**: The rules the Calendar applies to data MUST live in plain logic that does not depend on the UI framework or the server: the grid's date range, expanding periods into their days, whether a day is a logged/predicted/fertile/today/pain day and which ring wins, and the wording of each period-change message.
- **FR-004**: All access to the server from the Calendar's logic MUST go through project-owned interfaces, so tests can substitute fakes. No concrete server client may be needed to test the Calendar's logic.
- **FR-005**: The Calendar's logic MUST be tested headlessly, test-first for new behavior, covering at least: loading a month, changing month, selecting a day, jumping to a requested date, load failure, each ring and its priority, period expansion across months, each kind of long-press result and message, the future-date refusal, long-press failure, Undo (success and failure), returning from the log screen, and refresh.
- **FR-006**: Existing UI tests MUST continue to pass. UI tests that verify logic MUST be replaced by headless tests. Remaining Calendar UI tests MUST be a small number of happy paths that do not depend on label text or item counts.
- **FR-007**: One-time messages (period started, ended, moved, removed, future date refused, update failed, with Undo) MUST be shown exactly once each, even if the screen is rebuilt, and a new message MUST replace the previous one.
- **FR-008**: User-facing text on the Calendar MUST not regress. Where the migration touches a user-facing string or date/number format, it MUST follow the constitution's localization and locale-aware formatting rules where feasible, without changing the displayed wording in the current language.
- **FR-009**: The migration MUST NOT add new data collection, third-party services, or logging of health data (constitution Principle I). The Calendar MUST still only show the signed-in user's data, and no data may survive sign-out.
- **FR-010**: Behavior and code shared with other screens (`DayBands`, the date helpers, and the structure and test helpers from the Home feature) MUST be reused rather than duplicated. Anything that must be generalized for reuse MUST be a small change.
- **FR-011**: The "Home asks the Calendar to show a date" hand-off MUST keep working from the user's point of view. How the two screens communicate is a planning decision, and it MUST NOT leave the Home feature depending on the Calendar's internals.
- **FR-012**: The feature's documentation (the Home feature README or a Calendar one) MUST be updated so the next screen migrated can follow the same pattern.

### Key Entities

- **Calendar state**: Everything the Calendar displays at one moment: the shown month, the selected date, which days are period days, pain days, and day logs for the month, the selected day's detail, the prediction, units, and loading/error status.
- **Calendar actions**: What the user or the system can ask the Calendar to do: load, change month, select a day, long-press a day, undo a period change, jump to a date requested by Home, refresh, and return from the log screen.
- **Day marks**: What the grid shows for one date: whether it is a logged period day, a predicted period day, a fertile day, today, selected, in the current month, and has pain.
- **Period change message**: The one-time message describing the result of a long-press (what happened and how many days) together with what Undo reverses.
- **Data sources (interfaces)**: The contracts through which the Calendar reads the month's and day's data and prediction, and performs and undoes period changes. The real server and test fakes both fulfill them.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A side-by-side check of every behavior listed in FR-001 shows no difference before and after the migration, apart from the improvement noted in Assumptions.
- **SC-002**: 100% of the Calendar logic rules listed in FR-005 are covered by headless tests, and the whole Calendar logic suite runs in under 10 seconds without a device or server.
- **SC-003**: The Calendar screen's UI code contains no server calls and no business rules; a reviewer can confirm this by inspection.
- **SC-004**: At most a few (target: 3 or fewer) UI tests remain for the Calendar, all passing, none dependent on label text or item counts.
- **SC-005**: After the migration, Home and Calendar share one documented structure, and a developer can migrate a third screen by following it without needing to ask how the layers fit together.
- **SC-006**: A period started, ended, moved, removed or undone from the Calendar produces the same server result as before for every case in the agreed period-tracking rules (the server rules themselves are not touched).

## Assumptions

- The repository has no existing Calendar UI tests, so "existing UI tests should still pass" is satisfied by not breaking the Home tests and the full client suite, and "migrate logic UI tests" means writing the Calendar logic tests headlessly from the start. If the developer has Calendar UI tests elsewhere, they should be pointed out.
- The developer chose BLoC for the Calendar, matching Home. This is recorded as a project decision, not an open question.
- Scope is the Calendar screen only. Home (already migrated) keeps its structure except for the small change needed for FR-011; the Log screen and its sheets, Insights, Journal and Me keep their current structure. Calendar still opens `LogScreen`, and `DayBands` stays as it is.
- The server API, the period-tracking rules (`PeriodEndpoint.longPress` and `undo`) and the generated client are unchanged. No new endpoints or models are needed.
- Generated server models may be used in the Calendar's domain layer, as in Home (the justified deviation recorded in the Home plan). Whether the Calendar needs any model of its own is a planning decision, with the preference being the smallest change that keeps domain logic free of server and UI dependencies.
- Every month change, day selection, refresh and return from the log screen reloads the same data as today. Smarter partial loading is out of scope unless it falls out naturally and changes nothing the user sees.
- One intentional improvement, as with Home: quickly moving between months or days shows only the last choice (today an earlier, slower response can overwrite it).
- Intentional change: because Home's hand-off becomes an event, tapping Home's day circle always moves the Calendar to that date, including when it is the same date as last time and the user has since changed the selection. (Before, an unchanged value was ignored.)
- The one-minute reminder timer, the prediction and other Home behavior are not part of this feature.
- The localization system is not yet set up in the app. The Calendar keeps its current strings and the hand-rolled date helpers (`formatDayLabel`, `formatMonthYear`, `weekdayHeaderLabels`) in this feature, as Home did, with the deviation recorded in the plan. New strings follow the constitution where feasible.
