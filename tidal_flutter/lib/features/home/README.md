# Home feature: the reference layout for clean architecture + BLoC

Home was the first screen migrated (spec: `specs/001-home-screen-bloc/`). Copy this
layout for the next screen.

```
features/home/
├── domain/          plain Dart; the rules and the contracts
│   ├── home_repository.dart   what Home needs from the outside (interface)
│   ├── day_status.dart        pure rule: period/flow -> DayStatus (values, not text)
│   ├── cycle_outlook.dart     pure rule: Prediction + today -> CycleOutlook
│   ├── day_data.dart, due_reminder.dart   data the rules and screen share
├── data/            the only layer that talks to the server
│   ├── server_home_repository.dart  HomeRepository over HomeServerApi (+ the join logic)
│   └── client_home_server_api.dart  forwards HomeServerApi calls to the generated Client
└── presentation/
    ├── bloc/        HomeBloc, HomeEvent, HomeState (loading, ordering, failures)
    ├── home_text.dart   turns domain values into the words on screen (localize here)
    ├── home_screen.dart draws HomeState, reports user actions as events
    └── widgets/     small widgets that take plain values
```

Dependencies point inward: presentation -> domain <- data. Domain imports no Flutter and
no server client calls (it reuses the generated model classes, a deviation recorded in
the plan).

## How it is wired
`AppShell` builds `HomeBloc` with `ServerHomeRepository(ClientHomeServerApi(client))`, the
clock (`DateTime.now`) and a once-a-minute tick stream, and provides it with
`BlocProvider`. The provider closes the bloc when the shell goes away, so signing out
drops all of Home's state.

## How it is tested (all under `test/features/home/`, no server or device)
- `domain/*_test.dart`: the pure rules.
- `data/server_home_repository_test.dart`: mapping and joins, with a hand-written `HomeServerApi` fake.
- `presentation/home_bloc_test.dart`: state handling with `FakeHomeRepository`, a fixed clock and a tick `StreamController`.
- `presentation/home_text_test.dart`: pins the wording shown to the user.
- `presentation/home_screen_test.dart`: three happy paths, found by key or type (never by text or counts).

## Recipe for the next screen
1. Write the repository interface and entities in `domain/` (reuse generated models where the rest of the app already does).
2. Write tests for the pure rules and the bloc against a hand-written fake; see them fail.
3. Implement the rules, the data layer and the bloc.
4. Move the screen into `presentation/`, make it draw state and send events, and give widgets keys for the happy-path test.
5. Provide the bloc where the screen is created.

## Gotchas
- In a bloc handler, `emit(state.copyWith(x: await y))` reads `state` *before* the await; await into a local first, because other loads may have changed `state` meanwhile.
- Don't `await bloc.close()` in a widget test; it never finishes on the fake clock. Unmount the widget and `unawaited(bloc.close())`, as `BlocProvider` does.
