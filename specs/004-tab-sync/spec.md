# Feature Specification: Keep Home and Calendar in Sync

**Feature Branch**: `004-tab-sync` (spec directory name only; work is on the git branch `ui_issues`)

**Created**: 2026-10-07

**Status**: Clarified (Q1 answered: option A)

**Input**: Bug report from the developer: "if i add weight on home and then change the weight on calendar tab it doesnt sync the log on home page, this problem happens with mucus also."

## Overview

Home and the Calendar both show a day's log. The app keeps every tab alive in the background so switching tabs is instant, but each tab loads its data only once and then reloads only after its own actions (its own "+" button, pull-to-refresh, changing day or month). Switching tabs doesn't reload anything. So a change made on one tab doesn't show on the other until the user pulls to refresh. This affects every logged item (weight, mucus, pain, mood, note, drinks, sleep, digestion, temperature, love), in both directions, and periods started or ended on the Calendar too. It existed before the Bloc migration.

## User Scenarios & Testing *(mandatory)*

### User Story 1 - A change on one tab shows on the other (Priority: P1)

A signed-in user logs or changes something on the Calendar, then switches to Home (or the other way round), and sees the change without pulling to refresh.

**Why this priority**: Showing an old value after the user changed it makes the app look broken and erodes trust in the data, which is the core of a health tracker.

**Independent Test**: Change a day's weight on the Calendar, switch to Home on that day, and read the weight band.

**Acceptance Scenarios**:

1. **Given** Home shows today with weight 60 kg, **When** the user changes today's weight to 62 kg on the Calendar and switches to Home, **Then** Home shows 62 kg.
2. **Given** the Calendar has today selected, **When** the user logs mucus on Home and switches to the Calendar, **Then** the Calendar's day detail shows the mucus.
3. **Given** the user starts or ends a period on the Calendar, **When** they switch to Home, **Then** Home's day circle and cycle header reflect it ("Period · Day N", the updated next-period estimate and forecast).
4. **Given** the user is on Home, **When** they tap the Home tab again, **Then** nothing reloads.

---

### Edge Cases

- Switching tabs quickly back and forth: only the latest reload's result is shown (the existing Bloc rules already ignore stale answers).
- A reload after a tab switch fails (offline): the tab keeps showing what it had, with no error message; nothing crashes.
- Switching to a tab while it's already reloading: no duplicate visible effect.
- Insights already rebuilds on each visit; Journal and Me are out of scope (they don't show data the other tabs change, except Journal days, which only Journal edits).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: Switching **to** Home from another tab MUST reload Home's selected day (its day log, pain entries, bowel movements, period and units) **and the cycle prediction**, so changes made elsewhere show, including period edits that move the prediction (cycle header and day-circle forecast).
- **FR-002**: Switching **to** the Calendar from another tab MUST reload the Calendar's shown month and selected day.
- **FR-003**: Re-selecting the tab that's already shown MUST NOT reload it.
- **FR-004**: The decision of which tab to reload on a switch MUST be plain logic outside the widgets, tested headlessly (constitution Principles II and VII).
- **FR-005**: No new server calls beyond the ones each tab already makes when it loads; no new data or endpoints.
- **FR-006**: While a tab reloads after a switch, it MUST keep showing what it already has (no spinner, no blank log) and swap in the new data when it arrives. If that reload fails, it MUST keep showing what it had, without an error message (the user can still pull to refresh). Pull-to-refresh keeps its current behavior.

### Key Entities

- **Tab switch**: moving from one bottom-navigation tab to another; decides whether the destination reloads.

## Clarifications

- **Q1 (answered 2026-10-07)**: While a tab reloads after a switch, should the day's log stay on screen until the new data arrives, or blank briefly with a spinner? → **Option A**: keep showing the current log and swap in the new data when it arrives, so switching tabs never flickers (FR-006). Option B (reuse the existing refresh, which flashes a spinner) was rejected.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Every scenario in User Story 1 holds; the reload decision and (for option A) the quiet reload are covered by headless tests written before the fix.
- **SC-002**: The analyzer is clean and the full app test suite passes.

## Assumptions

- Reloading on every switch to Home or Calendar costs the same calls each tab makes when it loads today; that's acceptable for a personal-data app with small payloads.
- Home's medication reminders aren't reloaded on a tab switch; they're already re-checked every minute.
