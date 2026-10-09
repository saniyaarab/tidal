# Implementation Plan: Keep Home and Calendar in Sync

**Branch**: `004-tab-sync` (spec directory; work is on the git branch `ui_issues`) | **Date**: 2026-10-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/004-tab-sync/spec.md`

## Summary

When the user switches to Home or the Calendar from another tab, the shell sends that tab's bloc a new "tab returned" event. Each bloc handles it with a **quiet reload**: the same calls its normal load makes, but without emitting the loading state, and keeping the current data if the reload fails (FR-006, option A). Which tab to reload is decided by a small pure function, tested headlessly. The shell keeps a handle on the Home bloc (as it already does for the Calendar's) so it can send the event.

## Technical Context

**Language/Version**: Dart / Flutter, as pinned in `tidal_flutter/pubspec.yaml`

**Primary Dependencies**: existing `flutter_bloc`, `bloc_concurrency`; dev: `bloc_test`. No new packages.

**Storage**: N/A

**Testing**: `flutter test` in `tidal_flutter`; headless tests for the tab decision and both blocs, using the existing `FakeHomeRepository` (`loadedDays`, `predictionLoads`) and `FakeCalendarRepository` (`loads`). No widget tests: `AppShell` builds every tab, including ones that use the global server client, so it isn't testable headlessly; its wiring stays a few lines.

**Target Platform**: Existing Flutter targets (iOS, Android, web)

**Project Type**: mobile-app (Flutter client; server untouched)

**Constraints**: No new server calls beyond each tab's existing load; no visible loading state on a tab switch

**Scale/Scope**: 1 new source file, 5 edited source files, 3 test files (1 new)

## Design

1. **Tab decision** — new `tidal_flutter/lib/app_tabs.dart`:
   - `enum AppTab { home, calendar, insights, journal, me }` in bottom-bar order (replacing the shell's `_calendarTab`/`_insightsTab` index constants).
   - `AppTab? tabToReload(AppTab from, AppTab to)`: `to` when it's Home or Calendar and differs from `from`; otherwise null (re-selecting the shown tab, or switching to Insights, Journal or Me).
2. **Home** — `features/home/presentation/bloc/home_event.dart` gains `HomeTabReturned`; `home_bloc.dart` handles it with `restartable()`, reloading the selected day quietly and the prediction:
   - A quiet day reload calls `loadDay(date)` without emitting `DayLoadStatus.loading`, emits the new day when it arrives (same stale-answer checks as today), and on failure emits nothing.
   - The prediction reload reuses `_loadPrediction` (already quiet: it never shows a loading state, and keeps the old prediction on failure).
   - Reminders aren't reloaded (they're re-checked every minute).
3. **Calendar** — `features/calendar/presentation/bloc/calendar_event.dart` gains `CalendarTabReturned`; `calendar_bloc.dart` handles it with `restartable()` via a quiet variant of `_load` that skips emitting `CalendarLoadStatus.loading` and keeps the current data on failure.
4. **Shell** — `app_shell.dart`:
   - Keep the `HomeBloc` in a field and provide it with `BlocProvider.value` (like `_calendarBloc`); close both in `dispose`.
   - In `onDestinationSelected`, call `tabToReload(current, chosen)` and add `HomeTabReturned` or `CalendarTabReturned` accordingly.
   - Use `AppTab` for the index constants.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] I. Privacy: no new data, endpoints, services or logging; the quiet reloads call the same signed-in-user endpoints the tabs already call. The shell still closes both blocs on sign-out.
- [x] II. Test-first: tasks put the failing tests (tab decision, Home quiet reload, Calendar quiet reload) before any source change; they're run and seen failing before the fix.
- [x] III. Server access stays behind `HomeRepository` and `CalendarRepository`; tests use the existing hand-written fakes.
- [x] IV. No new UI tests.
- [x] V. No new user-facing strings.
- [x] VI. Reuses each bloc's existing load paths, stale-answer checks and `_loadPrediction`, and the existing fakes.
- [~] VII. The tab decision lives at the app level (`lib/app_tabs.dart`), not inside a feature folder, because it's about navigation between features. See Complexity Tracking.

## Project Structure

```text
specs/004-tab-sync/
├── spec.md
├── plan.md     # this file
└── tasks.md

tidal_flutter/lib/
├── app_tabs.dart                                     # NEW: AppTab + tabToReload
├── app_shell.dart                                    # holds HomeBloc; sends the events
└── features/
    ├── home/presentation/bloc/home_event.dart        # + HomeTabReturned
    ├── home/presentation/bloc/home_bloc.dart         # quiet day reload + prediction
    ├── calendar/presentation/bloc/calendar_event.dart # + CalendarTabReturned
    └── calendar/presentation/bloc/calendar_bloc.dart  # quiet load

tidal_flutter/test/
├── app_tabs_test.dart                                # NEW
├── features/home/presentation/home_bloc_test.dart    # + HomeTabReturned tests
└── features/calendar/presentation/calendar_bloc_test.dart # + CalendarTabReturned tests
```

## Complexity Tracking

| Deviation | Why | Simpler alternative rejected because |
|-----------|-----|--------------------------------------|
| VII: app-level `lib/app_tabs.dart` outside the feature folders | Tab switching coordinates two features; putting it inside either would make one feature know about the other | Inlining the decision in `AppShell` would leave it untestable (the shell can't be built headlessly) |
| `AppShell` itself isn't tested | Building it constructs every tab, including screens that call the global server client (constitution III notes this singleton) | Wrapping the global client for every tab is a larger refactor than this bug fix; the shell's added wiring is three lines calling tested code |
