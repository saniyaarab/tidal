# Feature Specification: Home Screen State Migration

**Feature Branch**: `001-home-screen-bloc` (no branch created; work continues on the current branch)

**Created**: 2026-10-03

**Status**: Draft

**Input**: User description: "Home screen migration to bloc. The home screen has a mix of state loading and ui. Let's migrate it to use bloc for state management. Where possible we should try to mold the code into a clean architecture approach. Any existing ui tests should still pass. UI tests that focus on logic should be migrated to unit tests that can be run headless."

## Overview

The Home ("Today") screen currently loads its data, holds its state, applies its display rules, and draws the UI all in one place. This feature separates those concerns so that the Home screen's behavior can be verified without running the UI or a server, and so it becomes the reference example of the project's clean-architecture direction (constitution Principles II, III, and VII). The user-visible behavior of Home MUST NOT change.

The state-management approach is the BLoC pattern, chosen by the developer. Layering follows the constitution: presentation, domain, and data, with the data layer as the only place that talks to the server.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Home looks and behaves exactly as before (Priority: P1)

A signed-in user opens Home and sees what they saw before the migration: the cycle header, the day circle with period status, the bands for the day's log, and any due medication reminders. They can step between days, tap the circle to open the Calendar on that date, open the log menu, and pull to refresh.

**Why this priority**: The migration is only successful if users notice nothing. Any regression in Home is a regression in the app's main screen.

**Independent Test**: Run the app, and compare each Home behavior against the behavior list in the requirements below. Run the happy-path UI test for Home (see User Story 3).

**Acceptance Scenarios**:

1. **Given** a user with a logged period and pain entry today, **When** they open Home, **Then** the day circle shows the period day and flow, the bands show the pain entry, and the cycle header shows the cycle day and next-period estimate.
2. **Given** Home is showing today, **When** the user taps the previous or next arrow, **Then** the circle and bands show that day's data, while the cycle header still reflects today.
3. **Given** the user taps the day circle, **When** the Calendar opens, **Then** it has that date selected.
4. **Given** the user logs something through the log menu and returns, **When** Home reappears, **Then** it shows the updated day and reminders without a manual refresh.
5. **Given** the user pulls down on Home, **When** the refresh completes, **Then** the day's data is reloaded.

---

### User Story 2 - Home's logic is verifiable without the UI or a server (Priority: P1)

A developer can verify every rule Home applies (what the day status text says, how a day change loads data, how reminders are filtered and refreshed, what happens when a load fails) with fast tests that run headless, using fake data sources in place of the real server.

**Why this priority**: This is the reason for the migration. It delivers the testability the constitution requires and makes later changes to Home safe.

**Independent Test**: Run the Home logic tests with no device, emulator, or running server and confirm they pass in seconds.

**Acceptance Scenarios**:

1. **Given** fake data sources returning a period day with heavy flow, **When** the Home logic loads that day, **Then** its state says "period day N" with that flow level.
2. **Given** fake data sources where the day load fails, **When** the Home logic loads, **Then** its state carries an error, and the prediction and reminders (which have separate loads) are unaffected.
3. **Given** a due reminder, **When** the user logs the dose or dismisses it, **Then** the reminder list is refreshed and the data source received the matching request.
4. **Given** the user steps to another day, **When** the data finishes loading, **Then** the state reflects that day only, even if an earlier load finishes late.

---

### User Story 3 - Logic-focused UI tests become headless tests (Priority: P2)

Any existing UI test whose purpose is to check Home's logic is replaced by an equivalent headless test. A small number of happy-path UI tests remain.

**Why this priority**: It keeps the test suite fast and not fragile, per the constitution (Principle IV), but it only matters once the logic is separated.

**Independent Test**: Review the test suite: logic rules appear in headless tests, and the remaining Home UI tests are few, happy-path, and do not depend on label text or item counts.

**Acceptance Scenarios**:

1. **Given** an existing UI test that checks a Home rule (for example, the text shown for a period day), **When** the migration is complete, **Then** that rule is covered by a headless test and the UI test is removed or reduced to a happy path.
2. **Given** all remaining UI tests, **When** they are run, **Then** they pass and none depend on specific label text or item counts.

---

### Edge Cases

- A day load fails (network error): Home shows the existing "Could not load this day" message and still shows the cycle header and reminders if they loaded.
- The prediction or reminder load fails: Home continues without the header or banners, as it does today, with no error shown.
- The user steps through days quickly: only the most recently chosen day's data may be shown.
- Logging a dose or dismissing a reminder fails (for example, offline): the banner stays, nothing crashes, and the reminder list is reloaded.
- A reminder's medication is no longer in the user's list: the banner still shows, using the existing fallback name.
- The screen is closed while a load is in flight: nothing happens afterward, with no errors.
- The user's session ends (sign-out or account deletion) while Home is open: no stale data is shown to the next user.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Home MUST show the same content and behave the same as before for all of: the cycle header, the day circle (date and status text), the day's bands, due-reminder banners, the "+" button, previous/next day, tap-circle-to-open-Calendar, pull-to-refresh, loading state, and error state.
- **FR-002**: Home's state (selected day, day log, period, pain entries, bowel movements, unit preferences, prediction, due reminders, loading and error status) MUST be held and changed outside the UI widgets, and the widgets MUST only display it and report user actions.
- **FR-003**: The rules Home applies to data (for example, composing the day status text from period and flow) MUST live in plain logic that does not depend on the UI framework or the server.
- **FR-004**: All access to the server from Home's logic MUST go through project-owned interfaces, so tests can substitute fakes. No concrete server client may be needed to test Home's logic.
- **FR-005**: Home's logic MUST be tested headlessly, test-first where new behavior is touched, covering at least: loading a day, changing day, load failure, prediction load, reminder load, logging a dose from a reminder, dismissing a reminder, and refresh.
- **FR-006**: Existing UI tests MUST continue to pass. UI tests that verify logic MUST be replaced by headless tests. Remaining Home UI tests MUST be a small number of happy paths that do not depend on label text or item counts.
- **FR-007**: User-facing text on Home MUST not regress. Where the migration touches a user-facing string or date/number format, it MUST follow the constitution's localization and locale-aware formatting rules where feasible, without changing the displayed wording in the current language.
- **FR-008**: The migration MUST NOT add new data collection, third-party services, or logging of health data (constitution Principle I). Home MUST still only show the signed-in user's data.
- **FR-009**: Behavior shared with other screens (for example, `DayBands`, formatting helpers) MUST be reused rather than duplicated. Anything that must be generalized for reuse by the Home layers MUST be a small change.
- **FR-010**: The new structure MUST be documented well enough (a short note in the feature's plan or a README for the layers) that the next screen migrated can follow the same pattern.

### Key Entities

- **Home state**: Everything Home displays at one moment: the selected day, that day's log, period, pain entries, bowel movements, units, the cycle prediction, due reminders, and loading/error status.
- **Home actions**: What the user or the system can ask Home to do: load, change day, refresh, log a dose from a reminder, dismiss a reminder, and the periodic reminder check.
- **Data sources (interfaces)**: The contracts through which Home reads the day's data, prediction, and reminders and records reminder actions. The real server and test fakes both fulfill them.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A side-by-side check of every behavior listed in FR-001 shows no difference before and after the migration.
- **SC-002**: 100% of the Home logic rules listed in FR-005 are covered by headless tests, and the whole Home logic suite runs in under 10 seconds without a device or server.
- **SC-003**: The Home screen's UI code contains no server calls and no business rules; a reviewer can confirm this by inspection.
- **SC-004**: At most a few (target: 3 or fewer) UI tests remain for Home, all passing, none dependent on label text or item counts.
- **SC-005**: A different developer can migrate another screen by following the documented Home pattern, without needing to ask how the layers fit together.

## Assumptions

- The repository currently has no real UI tests (`tidal_flutter/test/widget_test.dart` is an empty placeholder). "Existing UI tests should still pass" is therefore trivially satisfied, and the "migrate logic UI tests" requirement means: do not add logic-focused UI tests, and write the logic tests headlessly from the start. If the developer has UI tests elsewhere, they should be pointed out.
- The developer chose BLoC for Home's state management. This is a project decision recorded here, not an open question. Whether the rest of the app adopts it is out of scope.
- Scope is the Home screen only: the Calendar, Insights, Journal, Me, and Log screens, and their sheets, keep their current structure. Where Home calls shared widgets (for example `DayBands`), those remain as they are.
- The server API and the generated client are unchanged. No new endpoints or models are needed.
- Server entities from the generated client may be used in the data layer. Whether domain entities are separate from them is a planning decision, with the preference being the smallest change that keeps domain logic free of server and UI dependencies.
- Pull-to-refresh and the one-minute reminder check keep their current behavior. Pull-to-refresh reloads only the day, and the cycle prediction loads once per Home visit, exactly as today.
- One intentional improvement: quickly stepping between days shows only the last day chosen (today an earlier, slower response can overwrite it).
- The localization system is not yet set up in the app. Home keeps its current strings in this feature unless localization is added first; new strings follow the constitution where feasible.
