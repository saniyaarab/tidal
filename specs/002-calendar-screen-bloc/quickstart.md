# Quickstart: validating the Calendar migration

## Prerequisites
- Flutter SDK; `flutter pub get` in `tidal_flutter`.
- For the manual check only: the app running via `serverpod start` with a signed-in test user.

## 1. Headless logic tests (no device, no server)
```bash
cd tidal_flutter && flutter test test/features/calendar
```
Expected: all pass in under 10 s. They cover the grid dates, period expansion across months,
ring priority, the bloc scenarios from spec User Story 2 (load, month change, select, jump to a
date, load failure, each period-change message, future-date refusal, long-press failure, Undo
success and failure, return from log, refresh, stale responses), the repository mapping, and the
message wording.

## 2. Whole client suite (Home must still pass)
```bash
cd tidal_flutter && flutter test
```

## 3. Static checks
```bash
cd tidal_flutter && dart analyze && dart format --set-exit-if-changed .
```

## 4. Side-by-side manual check (spec SC-001)
With the app running, confirm each item in spec FR-001 and User Story 1: rings and pain dots,
month arrows, day select, long-press start / end / move / remove with message and Undo,
future-date message, "+" then return refreshes, pull-to-refresh, and tapping Home's day circle
opens the Calendar on that date (also when tapped a second time for the same date; see
research D8).

## 5. Inspection checks (SC-003)
- `lib/features/calendar/presentation/` has no import of `client.dart` or `tidal_client` endpoints, and no ring or period rules.
- `lib/features/home/` imports nothing from `lib/features/calendar/`.
