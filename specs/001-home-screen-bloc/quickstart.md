# Quickstart: Validating the Home Screen Migration

## Prerequisites
- `tidal_server/config/passwords.yaml` exists and the app runs with `serverpod start`.
- From `tidal_flutter/`: `flutter pub get`.

## 1. Headless logic tests (no device, no server)
```bash
cd tidal_flutter && flutter test test/features/home
```
Expected: all domain, data, and bloc tests pass in under 10 seconds (SC-002).

## 2. Static checks
```bash
cd tidal_flutter && dart analyze && dart format --set-exit-if-changed lib test
```
Expected: no issues.

## 3. Happy-path widget tests
Included in step 1 (`presentation/home_screen_test.dart`). Expected: pass without relying on label text or item counts.

## 4. Manual parity check against the spec (SC-001)
With the app running and a user who has a period, a pain entry, and a medication reminder:
1. Home shows the cycle header, day circle with status, pain band, and a "due now" banner.
2. Previous/next arrows change the day; the cycle header stays on today.
3. Tapping the circle opens the Calendar on that date.
4. "+" → log something → back: Home shows the new data without a manual refresh.
5. Pull to refresh reloads the day.
6. Stop the server and pull to refresh: "Could not load this day" appears; start it and refresh to recover.
7. Sign out and sign in as another user: no earlier data appears.

## 5. Inspection (SC-003)
`lib/features/home/presentation/**` contains no `client.` calls and no rules beyond display.
