<!--
Sync Impact Report
- Version change: 1.0.0 → 1.1.0
- Modified principles: none
- Added sections: Principle VII (Clean Architecture in the Flutter Client)
- Removed sections: none
- Templates:
  - ✅ .specify/templates/plan-template.md (added Constitution Check gate for VII)
  - ✅ .specify/templates/tasks-template.md (no change needed)
  - ✅ .specify/templates/spec-template.md (no change needed)
- Follow-up TODOs:
  - The Flutter app does not yet use localization (no l10n.yaml, no intl). Existing screens
    use hard-coded strings and date_format.dart; migrate opportunistically (Principle V).
  - Existing screens (for example HomeScreen, CalendarScreen) mix loading, state, and UI and
    call the global `client` directly; migrate opportunistically (Principle VII).
  - CLAUDE.md "Future" ideas include anonymous cross-user research data; this needs
    explicit review against Principle I before any work starts.
-->
# Tidal Constitution

## Core Principles

### I. Privacy First (NON-NEGOTIABLE)
Privacy is Tidal's primary selling point and outranks every other principle, feature, and
deadline. Health data about cycles, pain, and medication is among the most sensitive data
a person has.

- Every endpoint MUST return and modify only the signed-in user's own data.
- Users MUST be able to delete everything tied to them at any time, and deletion MUST remove
  data from every table, including any added later.
- Code MUST NOT send user data to third parties, add advertising or analytics SDKs, or sell
  or share data. Logs and error reports MUST NOT contain health data or personal identifiers.
- Features that would weaken these guarantees (data sharing, social or community features,
  cross-user data collection, third-party health integrations) MUST NOT be proposed or
  implemented. Anything that needs user data to leave the user's control requires explicit,
  informed opt-in and a constitutional amendment first.
- Collect the minimum data needed. Prefer storing less (for example, birth year, not birth
  date) and computing derived values on demand.

Rationale: the product's promise to users is "Only you can see your data." Breaking it once
destroys the reason to use the app.

### II. Test-First for Non-UI Code
Business logic, server endpoints, data transformations, and client-side services MUST be
developed test-first: write a failing test, make it pass, then refactor. Tests MUST be
reviewed against the spec before implementation starts. Server logic is tested with
`serverpod_test` integration tests (`dart test` in `tidal_server`); pure Dart logic gets
plain unit tests. A bug fix MUST start with a test that reproduces the bug.

### III. Isolate External Services Behind Interfaces
Anything outside the app's own process or logic (the Serverpod client, clock, notifications,
storage, email, platform APIs) MUST be accessed through an interface owned by this project,
so tests can substitute it. In tests, mock or fake the interface, not a concrete class.
Prefer hand-written fakes for simple interfaces. Global singletons that block substitution
(such as the global `client`) SHOULD be wrapped or injected when code that uses them needs
tests.

### IV. Minimal, Resilient UI Tests
UI-driven tests are fragile, so keep them few: a small number of happy-path journeys that
prove the main flows work. UI tests MUST NOT depend on specific label text or on item
counts; find widgets by keys, types, or semantics instead. Logic that can be tested without
the UI MUST be moved out of widgets and tested there (Principle II).

### V. Localized and Locale-Aware
User-facing strings MUST go through Flutter's localization system (`flutter_localizations`,
`intl`, ARB files) whenever feasible; new hard-coded user-facing strings need a stated
reason. Dates, times, numbers, and units shown to users MUST use locale-aware formatters
(for example `DateFormat`/`NumberFormat` with the current locale), never hand-built strings
or fixed formats. Stored and transmitted values stay in canonical forms (UTC date keys,
kg, °C) and are converted only for display.

### VI. Reuse Over Duplication
Before writing new code, look for existing code that does the job or nearly does. Prefer a
small change that generalizes an existing class, widget, or function over copying it. Shared
sheets, widgets, and helpers (such as `SheetScaffold`, `DayBands`, `WhenPicker`) are the
model. Generalize only as far as the current need; do not build speculative abstractions.

### VII. Clean Architecture in the Flutter Client
New features in `tidal_flutter` SHOULD be built with clean architecture: separate layers
with dependencies pointing inward.

- **Presentation** (widgets, screens, and their state holders): renders state and forwards
  user actions. It contains no networking and no business rules.
- **Domain** (entities, use cases, repository interfaces): plain Dart with no Flutter or
  Serverpod imports. It holds the business rules.
- **Data** (repository implementations): the only layer that talks to the Serverpod client
  or other external services, behind the interfaces from Principle III.

This is what makes Principles II and III practical: domain logic is tested without the UI
or a server, and data sources are swapped for fakes. A feature that departs from this
layering needs a justification in the plan's complexity table. Existing code is NOT
required to change at once; it MUST be migrated when practical, for example when a feature
touches it. Do not rewrite working code only to reorganize it.

## Technical Constraints

- Stack: Flutter app (`tidal_flutter`), Serverpod 4 server (`tidal_server`), generated shared
  client (`tidal_client`). Generated code MUST NOT be edited by hand.
- Authentication uses Serverpod's built-in auth. Secrets live in `config/passwords.yaml`,
  which MUST NOT be committed.
- Tidal records and visualizes data only. It never suggests medication doses or gives
  medical advice.
- Scope follows `CLAUDE.md`; items it lists as cut or removed MUST NOT be re-added without
  the developer's explicit decision.

## Development Workflow

- Before merging: `dart analyze` and `dart format` are clean and `dart test` passes in the
  server package.
- Every spec, plan, and pull request MUST be checked against this constitution. The plan's
  Constitution Check MUST answer, at minimum: Does it keep data private to the user? Is
  deletion still complete? Are tests written first for non-UI code? Are external services
  behind interfaces? Are strings localized and formats locale-aware? Is existing code reused? Does new Flutter code follow the clean architecture layers?
- Deviations MUST be recorded with a justification in the plan's complexity table.

## Governance

This constitution supersedes other practices and style preferences. Amendments require a
written change to this file, a version bump, and an update to affected templates and
guidance (`CLAUDE.md`, `AGENTS.md`). Versioning follows semantic versioning: MAJOR for
removing or redefining a principle, MINOR for adding a principle or materially expanding
guidance, PATCH for clarifications. Principle I may only be weakened by a MAJOR amendment
with an explicit user-facing privacy rationale. Compliance is reviewed on every plan and
pull request.

**Version**: 1.1.0 | **Ratified**: 2026-10-03 | **Last Amended**: 2026-10-03
