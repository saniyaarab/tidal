# Tasks: Home Day Circle Forecast

**Input**: Design documents from `/specs/003-home-day-forecast/`

**Prerequisites**: plan.md, spec.md

**Tests**: Headless unit tests for the rule (domain) and the wording (presentation); no UI tests (constitution Principle IV).

**Note on order**: these tasks were done before this file existed. The source tasks (T003–T006) were done before the test tasks (T001–T002), against Principle II; see plan.md, Complexity Tracking. They're listed here in the order the constitution expects.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (US1)

## Phase 1: Tests (User Story 1)

- [X] T001 [P] [US1] Rule tests in `tidal_flutter/test/features/home/domain/day_status_test.dart`, with a prediction (next period Oct 25–29, fertile window Oct 6–11): a day in the predicted period is `expectedPeriod`; a day in the fertile window is `fertileWindow`; Oct 24 and Oct 18 are `pms`; Oct 17 is `none`; a day outside all of them is `none`; a logged period day is period day 1 with forecast `none`.
- [X] T002 [P] [US1] Wording tests in `tidal_flutter/test/features/home/presentation/home_text_test.dart`: an ordinary day returns null (replacing the old "No period" test); "Period expected"; "Fertile window"; "PMS possible"; logged flow beats a forecast ("Light flow").

## Phase 2: Implementation (User Story 1)

- [X] T003 [US1] In `tidal_flutter/lib/features/home/domain/day_status.dart`: add `DayForecast` (none, expectedPeriod, fertileWindow, pms) and `DayStatus.forecast` (default none); `buildDayStatus` takes an optional `prediction` and sets the forecast only outside a logged period, checking the predicted period, then the fertile window, then the 7 PMS days before the predicted start (`_pmsDays = 7`).
- [X] T004 [US1] In `tidal_flutter/lib/features/home/presentation/home_text.dart`: `dayStatusText` returns `String?`; after the period and flow cases, map the forecast to "Period expected", "Fertile window", "PMS possible", or null.
- [X] T005 [US1] In `tidal_flutter/lib/features/home/presentation/home_screen.dart`: pass `state.prediction` to `buildDayStatus`.
- [X] T006 [US1] In `tidal_flutter/lib/features/home/presentation/widgets/day_circle.dart`: make `status` a `String?` and show the gap and status line only when it isn't null.

## Phase 3: Polish

- [X] T007 Search `lib` and `test` for "No period" (none left); run `dart format`, `dart analyze` and `flutter test` in `tidal_flutter` (120 tests pass).
- [X] T008 Update the Home line in `AGENTS.md` to describe the new circle texts.
- [X] T009 Note in `specs/001-home-screen-bloc/data-model.md` that the day circle's wording is superseded by this spec.

## Dependencies

- T001–T002 cover T003–T004. T005 needs T003; T006 needs T004's nullable result.
