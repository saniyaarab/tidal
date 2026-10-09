# Feature Specification: Home Day Circle Forecast

**Feature Branch**: `003-home-day-forecast` (spec directory name only; work is on the git branch `ui_issues`)

**Created**: 2026-10-07

**Status**: Implemented (spec written after the code; see plan.md, Complexity Tracking)

**Input**: Developer's feedback: "Why does the home screen, the purple circle says no period, its obvious if the period day is not set then there is no period." Chosen direction: show something useful for the day instead (option B), and add "one more status that is of PMS": 7 days, worded "PMS possible", Home only.

## Overview

The day circle on Home shows the selected date and a status line. On an ordinary day the status line says "No period", which tells the user nothing. This feature replaces it: the circle says something only when there is something worth saying about that day, using the cycle prediction Home already loads. On an ordinary day the circle shows only the date.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - The circle says what the day is (Priority: P1)

A signed-in user steps through days on Home with the arrows. On each day the circle shows the date and, under it, what is known or predicted about that day: a logged period day, flow outside a period, the predicted period, the predicted fertile window, or the likely PMS days before the predicted period. On any other day it shows only the date.

**Why this priority**: It is the whole feature, and it removes text the developer found pointless.

**Independent Test**: With a prediction loaded, step to a day in each situation and read the circle.

**Acceptance Scenarios**:

1. **Given** the selected day is inside a logged period, **When** Home shows it, **Then** the circle says "Period · Day N" (and the flow on a second line, if logged), exactly as before.
2. **Given** the selected day is outside a period and flow was logged, **When** Home shows it, **Then** the circle says "<Flow> flow" (e.g. "Light flow"), exactly as before.
3. **Given** the selected day falls inside the predicted next period, **When** Home shows it, **Then** the circle says "Period expected".
4. **Given** the selected day falls inside the predicted fertile window, **When** Home shows it, **Then** the circle says "Fertile window".
5. **Given** the selected day is one of the 7 days before the predicted period starts, **When** Home shows it, **Then** the circle says "PMS possible".
6. **Given** none of the above apply, **When** Home shows the day, **Then** the circle shows only the date, with no status line and no empty gap.

---

### Edge Cases

- Logged data beats a prediction: a logged period day shows "Period · Day N" even if it is also in the predicted period, and logged flow outside a period shows "<Flow> flow" even if the day is in the fertile window or PMS days.
- No prediction yet (it hasn't loaded, or there is no period history): only logged information is shown; otherwise just the date.
- The prediction covers only the next cycle, so "Period expected", "Fertile window" and "PMS possible" appear only for days in the upcoming cycle. Past days that weren't period days show just the date.
- The fertile window ends about 14 days before the predicted period and the PMS days start 7 days before it, so they don't overlap in a typical cycle. If they ever did, the fertile window is shown.
- The predicted period and the PMS days never overlap: PMS days end the day before the predicted start.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The day circle MUST show, in this order of precedence: "Period · Day N" (plus flow) on a logged period day; "<Flow> flow" when flow is logged outside a period; "Period expected" inside the predicted period (from the prediction's next period start through its predicted end); "Fertile window" inside the predicted fertile window; "PMS possible" on the 7 days before the predicted period start; otherwise nothing under the date.
- **FR-002**: The text "No period" MUST NOT appear.
- **FR-003**: When there is no status, the circle MUST show the date alone, centered, with no empty line.
- **FR-004**: The rule deciding what kind of day it is MUST live in Home's domain layer as plain logic with no UI or server dependency, and the wording MUST live only in `home_text.dart` (constitution Principles II and V).
- **FR-005**: The feature MUST use the prediction Home already loads. It MUST NOT add server calls, data, endpoints or models.
- **FR-006**: The change applies to Home only. The Calendar's rings and legend are unchanged.

### Key Entities

- **Day forecast**: what the prediction says about a day that isn't a logged period day: none, expected period, fertile window, or PMS.
- **Day status**: the existing value describing a day (period day number, flow), now also carrying its day forecast.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every scenario in User Story 1 shows the stated text, checked by headless tests of the rule and the wording.
- **SC-002**: No test or code contains "No period".
- **SC-003**: The analyzer is clean and the full app test suite passes.

## Assumptions

- 7 PMS days, the developer's choice. Doctors often use the 5 days before a period to diagnose PMS, but symptoms can start earlier.
- "PMS possible", "Period expected" and "Fertile window" are worded as possibilities, since they come from a prediction.
- Home only. Showing PMS days on the Calendar would need a new ring style and legend entry, and was explicitly left out.
- This spec supersedes the day-circle wording described in `specs/001-home-screen-bloc/data-model.md`, which recorded the behavior as it was during that migration.
