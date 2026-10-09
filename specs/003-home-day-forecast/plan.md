# Implementation Plan: Home Day Circle Forecast

**Branch**: `003-home-day-forecast` (spec directory; work is on the git branch `ui_issues`) | **Date**: 2026-10-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/003-home-day-forecast/spec.md`

## Summary

Add a `DayForecast` value (none, expected period, fertile window, PMS) to Home's existing `DayStatus`, worked out in `buildDayStatus` from the prediction Home already holds in its state. `dayStatusText` turns it into "Period expected", "Fertile window" or "PMS possible", and returns null on an ordinary day instead of "No period"; `DayCircle` hides its status line when the text is null. No bloc, data-layer, server or Calendar changes.

## Technical Context

**Language/Version**: Dart / Flutter, as pinned in `tidal_flutter/pubspec.yaml`

**Primary Dependencies**: existing `tidal_client` (`Prediction`, `PeriodSpan`, `DayLog`); no new packages

**Storage**: N/A (no new data)

**Testing**: `flutter test` in `tidal_flutter`; headless unit tests for the rule and the wording

**Target Platform**: Existing Flutter targets (iOS, Android, web)

**Project Type**: mobile-app (Flutter client; server untouched)

**Constraints**: Uses only `HomeState.prediction`, which Home already loads once; no new network calls

**Scale/Scope**: 4 source files and 2 test files in `tidal_flutter/lib/features/home/` and its tests

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] I. Privacy: display only. No new data, endpoints, services or logging; "delete all my data" is unaffected.
- [~] II. Test-first: the rule and wording are fully covered by headless tests, but the tests were written **after** the code (see Complexity Tracking).
- [x] III. No new external access: the prediction comes through the existing `HomeRepository` into bloc state.
- [x] IV. No UI tests added; the rule and wording are tested headlessly.
- [~] V. Strings stay hard-coded in `home_text.dart`, the single wording file, as for the rest of Home (existing deviation recorded in the Home plan). The domain carries values (`DayForecast`), not text.
- [x] VI. Reuses `DayStatus`, `buildDayStatus`, the prediction already in `HomeState`, and the existing test builders.
- [x] VII. Layers followed: the rule is in `domain/day_status.dart`, wording in `presentation/home_text.dart`, display in `presentation/widgets/day_circle.dart`.

## Project Structure

### Documentation (this feature)

```text
specs/003-home-day-forecast/
├── spec.md
├── plan.md     # this file
└── tasks.md
```

### Source Code (repository root)

```text
tidal_flutter/lib/features/home/
├── domain/day_status.dart               # DayForecast + the rule (_forecastFor, _pmsDays = 7)
└── presentation/
    ├── home_text.dart                   # wording; returns null on an ordinary day
    ├── home_screen.dart                 # passes state.prediction into buildDayStatus
    └── widgets/day_circle.dart          # status is optional; no line when null

tidal_flutter/test/features/home/
├── domain/day_status_test.dart          # forecast rule, PMS edges, logged beats predicted
└── presentation/home_text_test.dart     # each wording, null on an ordinary day
```

**Structure Decision**: Extend the existing `DayStatus` rather than add a new type, so the circle still takes one value and one text function. Precedence (logged period → flow → expected period → fertile window → PMS → nothing) is decided in two places by design: logged-versus-predicted in the domain (`forecast` is `none` on a logged period day) and flow-versus-forecast in the wording (flow is checked first).

## Complexity Tracking

| Deviation | Why | Simpler alternative rejected because |
|-----------|-----|--------------------------------------|
| II: code written before its tests, and this spec written after both | The change was agreed in conversation and implemented directly; the spec workflow wasn't followed at the time | Redoing the code test-first would produce the same code and tests. The tests now cover every rule, and future features follow spec → plan → tasks → tests → code |
| V: hard-coded English strings | Localization isn't set up in the app yet (same as all of Home) | Setting up localization for three strings is out of scope; `home_text.dart` keeps all wording in one place for later |
