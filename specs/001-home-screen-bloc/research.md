# Research: Home Screen State Migration

No NEEDS CLARIFICATION items remained after the spec. The decisions below resolve the planning
questions the spec deferred.

## D1. State holder: one `HomeBloc` with events
- **Decision**: One `Bloc<HomeEvent, HomeState>` from `flutter_bloc`, events for: started, day changed (delta), refreshed, reminders refreshed (tick), reminder dose logged, reminder dismissed.
- **Rationale**: The developer chose BLoC; events map one-to-one onto today's user actions, which makes the tests read like the spec's scenarios. A Cubit would hide the events that the tests want to assert on.
- **Alternatives**: Cubit (simpler, less traceable); one bloc per concern (day, reminders, prediction): rejected as more wiring for a screen of this size, but the three loads are independent parts of one state so a failure in one cannot affect the others.

## D2. Stale responses when stepping days quickly
- **Decision**: Handle the day-change event with `restartable()` from `bloc_concurrency`, so a newer request cancels the older one's result. Reminders and prediction use `droppable()`/sequential handlers so they do not block the day load.
- **Rationale**: The spec requires only the latest chosen day to be shown. Today's code can show a stale day (an existing latent bug); this fixes it as a side effect of the structure.
- **Alternatives**: Compare the date in the state after each await (manual and easy to forget).

## D3. Domain entities vs generated models
- **Decision**: Reuse generated protocol models for pass-through data; add domain types only for new Home concepts (`DayStatus`, `CycleOutlook`, `DueReminder`). Recorded as a justified deviation in the plan.
- **Rationale**: See the plan's Complexity Tracking. Mirroring would duplicate code and change `DayBands`.
- **Alternatives**: Full mirrored domain entities with mappers (purist, costly, breaks reuse).

## D4. Where display rules live
- **Decision**: Pure functions in the domain layer return semantic values: `DayStatus {isPeriodDay, dayNumber, flow}` and `CycleOutlook {cycleDay, daysUntilNext, confidenceDays, isOverdue}`. Presentation turns these into text ("Period · Day 2\nHeavy").
- **Rationale**: Rules are testable headless; text is a presentation concern and will be localized later without touching domain.
- **Alternatives**: Formatted strings in state (would hard-wire English into the bloc and block localization).

## D5. Time and the periodic reminder check
- **Decision**: Inject a clock (`DateTime Function()`) and a `Stream<void>` of reminder ticks into the bloc. The screen supplies `Stream.periodic(1 minute)`; tests supply a controller.
- **Rationale**: Constitution III. Removes the `Timer` from the widget, and tests need no real waiting. Closing the bloc cancels the subscription.
- **Alternatives**: Timer inside the widget (keeps logic untestable); `fake_async` against a real timer (works but couples tests to timing).

## D6. Testing the data layer
- **Decision**: `ServerHomeRepository` takes the generated `Client`'s endpoint objects through a small project-owned interface, `HomeServerApi` (the 8 calls Home makes today), so its mapping and joining (reminders + medications → `DueReminder`) can be tested with a hand-written fake rather than a mocked `Client`.
- **Rationale**: Constitution III says to mock interfaces, not concrete classes. The generated `Client` is concrete and large.
- **Alternatives**: Mocking `Client` (rejected by the constitution); skipping data-layer tests (the join logic would be untested).

## D7. Dependency injection
- **Decision**: `AppShell` builds the repository from the existing global `client` and provides the bloc with `BlocProvider` around `HomeScreen`. No DI package; the global `client` stays for unmigrated screens.
- **Rationale**: Smallest change that removes the global from Home's logic. The bloc is created inside the signed-in shell, so sign-out disposes it and no data leaks to the next user (privacy, spec edge case).
- **Alternatives**: get_it or Riverpod (new concepts for one screen).

## D8. Existing tests
- **Decision**: There are no existing UI tests (`test/widget_test.dart` is an empty stub). New tests follow the pyramid in the plan: logic in headless unit/bloc tests, one or two widget happy paths that find widgets by key/type.
- **Rationale**: Matches Principle IV and spec Assumptions.

## D9. Package versions
- **Decision**: Add the latest stable `flutter_bloc`, `bloc_concurrency`, `equatable`, and `bloc_test` with `flutter pub add` at implementation time, and let pub resolve compatible versions. They are client-side only, with no network, analytics, or storage behavior, so no privacy impact.
