# Implementation Plan: Home Screen State Migration

**Branch**: `001-home-screen-bloc` (spec directory; work is on the current git branch) | **Date**: 2026-10-03 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/001-home-screen-bloc/spec.md`

## Summary

Split `HomeScreen` (today ~400 lines mixing loading, state, display rules and widgets) into a
presentation / domain / data feature folder. State moves into a `HomeBloc`; all server access
moves behind a `HomeRepository` interface with one Serverpod-backed implementation; display
rules move into pure functions. Visible behavior is unchanged. Logic is covered by headless
bloc and unit tests using a hand-written fake repository, and one or two happy-path widget
tests. This is the reference pattern for later screens (FR-010). See [research.md](research.md)
for decisions.

## Technical Context

**Language/Version**: Dart / Flutter, as already pinned in `tidal_flutter/pubspec.yaml`

**Primary Dependencies**: existing `tidal_client` and `serverpod_flutter`; new `flutter_bloc` (with `bloc`), `bloc_concurrency`, `equatable`; dev: `bloc_test`

**Storage**: N/A (no new data; the server API is unchanged)

**Testing**: `flutter test` in `tidal_flutter`; bloc and unit tests run headless; hand-written fakes of repository and clock interfaces

**Target Platform**: Existing Flutter targets (iOS, Android, web)

**Project Type**: mobile-app (Flutter client; server untouched)

**Performance Goals**: Home appears and refreshes as quickly as today (same calls, still issued in parallel); logic test suite under 10 s (SC-002)

**Constraints**: No user-visible change; no new network calls beyond today's; no new data collection

**Scale/Scope**: One screen (Home), about 16 new files (source and tests), 1 file rewritten

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] I. Privacy: no new data, endpoints, services, or logging; the repository only calls the same signed-in-user endpoints Home calls today. The bloc lives and dies with the signed-in shell, so no data survives sign-out. No new tables.
- [x] II. Tests are written first for all non-UI code (bloc, repository mapping, display rules); the tasks phase orders tests before implementation.
- [x] III. The server is reached only through `HomeRepository`; time through a clock function; the periodic reminder check through an injected tick stream. Tests use hand-written fakes of these interfaces, never of concrete classes.
- [x] IV. One or two happy-path widget tests, finding widgets by key or type, not by text or counts.
- [~] V. Home keeps its current hard-coded strings and the hand-rolled `formatDayLabel` date format because the app has no localization setup (see Complexity Tracking). The bloc state carries semantic values (day number, flow level, counts), not formatted text, so the later localization move touches only the presentation layer.
- [x] VI. `DayBands`, `formatDayLabel`, `todayAsDateKey`, and the label extensions are reused unchanged.
- [~] VII. Layers are followed, with one justified deviation (see Complexity Tracking).

**Post-design re-check**: unchanged. The design in `data-model.md` and `contracts/` keeps the same two deviations and adds none.

## Project Structure

### Documentation (this feature)

```text
specs/001-home-screen-bloc/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── home_repository.md
└── tasks.md             # created later by /speckit-tasks
```

### Source Code (repository root)

```text
tidal_flutter/
├── pubspec.yaml                          # + flutter_bloc, bloc_concurrency, equatable, bloc_test
├── lib/
│   ├── app_shell.dart                    # builds HomeBloc via a provider; otherwise unchanged
│   └── features/home/
│       ├── domain/
│       │   ├── home_repository.dart      # abstract HomeRepository (the contract)
│       │   ├── day_status.dart           # pure rule: period/flow -> DayStatus value
│       │   ├── cycle_outlook.dart        # pure rule: Prediction + today -> days until next period
│       │   ├── day_data.dart             # bundle returned by loadDay
│       │   └── due_reminder.dart         # entity for a banner
│       ├── data/
│       │   ├── server_home_repository.dart  # implements HomeRepository over HomeServerApi
│       │   └── client_home_server_api.dart  # thin adapter from HomeServerApi to the generated Client
│       └── presentation/
│           ├── bloc/
│           │   ├── home_bloc.dart
│           │   ├── home_event.dart
│           │   └── home_state.dart
│           ├── home_screen.dart          # moved from lib/screens; widgets only
│           └── widgets/                  # _DayCircle, _CycleHeader, _ReminderBanner extracted
└── test/features/home/
    ├── domain/day_status_test.dart
    ├── domain/cycle_outlook_test.dart
    ├── data/server_home_repository_test.dart  # against a fake of the narrow server surface
    ├── presentation/home_bloc_test.dart
    ├── presentation/home_screen_test.dart     # 1-2 happy paths
    └── fakes/fake_home_repository.dart
```

**Structure Decision**: feature-first folders under `lib/features/home/`, each with the three
layers. The existing `lib/screens/` and `lib/widgets/` stay as they are for unmigrated code;
`home_screen.dart` moves into the feature folder, with its import updated in `app_shell.dart`.

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Domain layer uses the generated protocol models (`DayLog`, `PainEntry`, `BowelMovement`, `UnitPreferences`, `Prediction`, `MedicationReminder`) instead of its own entities (VII) | `DayBands` and the Calendar already take these types; they are passive data classes with no transport code | Mirroring four-plus models and mapping them would duplicate code (VI) and force changes to `DayBands`, which is out of scope. Domain stays free of Flutter, and only new Home-specific concepts (`DayStatus`, `CycleOutlook`, `DueReminder`) get their own types. |
| Hard-coded strings and the hand-rolled `formatDayLabel` date format remain (V) | No localization or `intl` setup exists; adding it is a separate cross-app feature | Localizing one screen would leave the rest half-done. State carries semantic values (day numbers, flow levels, dates), so the later change is confined to presentation. |
