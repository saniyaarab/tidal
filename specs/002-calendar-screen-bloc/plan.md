# Implementation Plan: Calendar Screen State Migration

**Branch**: `002-calendar-screen-bloc` (spec directory; work is on the current git branch `feature/bloc`) | **Date**: 2026-10-04 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/002-calendar-screen-bloc/spec.md`

## Summary

Split `CalendarScreen` (531 lines mixing loading, state, display rules and widgets) into a
presentation / domain / data feature folder, following the Home layout
(`tidal_flutter/lib/features/home/README.md`). State moves into a `CalendarBloc`; all server
access moves behind a `CalendarRepository` interface with one Serverpod-backed implementation;
the display rules (grid dates, period expansion, ring priority, period-change wording inputs)
become pure functions. One-time messages (period started, ended, moved, removed, future date
refused, update failed, Undo) are carried in bloc state with a sequence number and shown by a
`BlocListener`. Home's hand-off changes from a shared `ValueNotifier` to an event sent to the
`CalendarBloc` by `AppShell`. Visible behavior is unchanged, apart from the improvements listed
in [research.md](research.md) (D2, D8). See [research.md](research.md) for all decisions.

## Technical Context

**Language/Version**: Dart / Flutter, as already pinned in `tidal_flutter/pubspec.yaml`

**Primary Dependencies**: existing `tidal_client`, `flutter_bloc`, `bloc_concurrency`, `equatable`; dev: `bloc_test`. No new packages.

**Storage**: N/A (no new data; the server API, models and period rules are unchanged)

**Testing**: `flutter test` in `tidal_flutter`; domain, data and bloc tests run headless with hand-written fakes; at most 3 widget happy paths found by key or type

**Target Platform**: Existing Flutter targets (iOS, Android, web)

**Project Type**: mobile-app (Flutter client; server untouched)

**Performance Goals**: Same calls as today, still issued in parallel; the Calendar logic suite runs in under 10 s (SC-002)

**Constraints**: No user-visible change except D2/D8; no new network calls; no new data collection

**Scale/Scope**: One screen (Calendar), about 20 new files (source and tests), 1 file rewritten (`lib/screens/calendar_screen.dart` moves), `app_shell.dart` lightly edited

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

- [x] I. Privacy: no new data, endpoints, services or logging; the repository calls only the signed-in-user endpoints the Calendar calls today. The bloc is created inside the signed-in `AppShell` and closed with it, so no data survives sign-out. No new tables, so "delete all my data" is unaffected.
- [x] II. Tests are written first for all non-UI code (grid and ring rules, period expansion, bloc, repository mapping); the tasks phase orders tests before implementation.
- [x] III. The server is reached only through `CalendarRepository` (and, inside the data layer, `CalendarServerApi`); time through an injected clock. Tests use hand-written fakes of these interfaces, never of concrete classes.
- [x] IV. At most 3 widget happy paths, finding widgets by key or type, not by text or counts.
- [~] V. Hard-coded strings and the hand-rolled date helpers stay (see Complexity Tracking). State carries semantic values (dates, kinds, day counts), not text; wording lives in `calendar_text.dart` so localization later touches only presentation.
- [x] VI. `DayBands`, `date_format.dart` helpers, Home's test builders and the bloc conventions are reused. The one generalization is moving the shared fake/builders location only if needed (see Structure Decision).
- [~] VII. Layers followed, with the same justified deviation as Home (see Complexity Tracking).

**Post-design re-check**: unchanged. `data-model.md` and `contracts/` add no new deviations.

## Project Structure

### Documentation (this feature)

```text
specs/002-calendar-screen-bloc/
├── plan.md
├── research.md
├── data-model.md
├── quickstart.md
├── contracts/
│   └── calendar_repository.md
└── tasks.md             # created later by /speckit-tasks
```

### Source Code (repository root)

```text
tidal_flutter/
├── lib/
│   ├── app_shell.dart                       # builds CalendarBloc with BlocProvider; Home hand-off sends an event; ValueNotifier removed
│   ├── screens/calendar_screen.dart         # deleted (moved)
│   └── features/calendar/
│       ├── domain/
│       │   ├── calendar_repository.dart     # abstract CalendarRepository (the contract)
│       │   ├── calendar_data.dart           # bundle returned by load
│       │   ├── calendar_grid.dart           # pure rule: month -> 42 grid dates, month end, range
│       │   ├── period_days.dart             # pure rule: PeriodSpans -> set of period dates
│       │   ├── day_marks.dart               # pure rule: date + data -> ring/pain/selected/today flags
│       │   └── period_message.dart          # CalendarMessage values (kind + days), no text
│       ├── data/
│       │   ├── server_calendar_repository.dart  # implements CalendarRepository over CalendarServerApi
│       │   └── client_calendar_server_api.dart  # thin adapter to the generated Client
│       └── presentation/
│           ├── bloc/
│           │   ├── calendar_bloc.dart
│           │   ├── calendar_event.dart
│           │   └── calendar_state.dart
│           ├── calendar_text.dart           # domain values -> words on screen
│           ├── calendar_screen.dart         # draws state, sends events, shows messages
│           └── widgets/                     # month_header, month_grid, day_cell, legend
└── test/features/calendar/
    ├── domain/{calendar_grid,period_days,day_marks}_test.dart
    ├── data/server_calendar_repository_test.dart
    ├── presentation/calendar_bloc_test.dart
    ├── presentation/calendar_text_test.dart
    ├── presentation/calendar_screen_test.dart   # up to 3 happy paths
    └── fakes/fake_calendar_repository.dart      # builders reused from test/features/home/fakes/builders.dart
```

**Structure Decision**: feature-first folders under `lib/features/calendar/`, same three layers as Home. `calendar_screen.dart` moves into the feature and its import in `app_shell.dart` is updated. Home's `builders.dart` is imported as-is by Calendar tests (`prediction` and `periodChange` builders are added there if missing; a small addition, not a move).

## Complexity Tracking

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| Domain layer uses generated protocol models (`DayLog`, `PainEntry`, `BowelMovement`, `UnitPreferences`, `Prediction`, `PeriodSpan`, `PeriodChange`) instead of its own entities (VII) | `DayBands` and the server API already use these passive data classes; `PeriodChange` must round-trip unchanged to `PeriodEndpoint.undo` | Mirroring them would duplicate code (VI) and force changes to `DayBands` (out of scope). Same deviation as Home. New Calendar concepts (`CalendarData`, `DayMarks`, `CalendarMessage`) get their own types. |
| Hard-coded strings and hand-rolled `formatMonthYear` / `formatDayLabel` / `weekdayHeaderLabels` remain (V) | No localization or `intl` setup exists; adding it is a separate cross-app feature | Localizing one screen would leave the rest half-done. State holds semantic values, so the later change is confined to presentation. |
