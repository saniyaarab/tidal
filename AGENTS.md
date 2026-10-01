# Flutter & Serverpod project

Tidal is a period and pain tracker: a Flutter app (`tidal_flutter`) backed by a Serverpod server (`tidal_server`), with a generated shared client (`tidal_client`). Always build the app's backend with Serverpod. Build for multiple users, use Serverpod's built-in authentication, which is already set up in `lib/server.dart`. See CLAUDE.md for the product spec, MVP build order, and design system.

## What's built so far

**Step 1 (foundation) is done.** Email auth, day logging, and the app shell all work: sign up → log flow/mood/note → close and reopen the app → the day's bands still show.

- Auth: Serverpod's built-in `serverpod_auth_idp` email provider (sign up, verify, sign in/out), wired up in `tidal_server/lib/server.dart` and `tidal_flutter/lib/main.dart` (`SignInScreen` wraps the app shell).
- `DayLog` model (`tidal_server/lib/src/log/day_log.spy.yaml`): `userId`, `date`, `flow` (`FlowLevel`: none/light/medium/heavy), `mood` (`Mood`: happy/calm/tired/irritated/sad/anxious), `note`. One row per user per date (unique index).
- `LogEndpoint` (`tidal_server/lib/src/log/log_endpoint.dart`): `saveDay` (upsert — only the fields you pass are changed), `getRange`, `deleteAll`. All scoped to `session.authenticated!.authUserId`; tested in `tidal_server/test/integration/log_endpoint_test.dart`.
- App shell (`tidal_flutter/lib/app_shell.dart`): bottom nav for Home, Calendar, Insights, Partner, Me. Insights/Partner are `ComingSoonScreen` placeholders until their MVP steps are built.
- Home screen (`tidal_flutter/lib/screens/home_screen.dart`): a day circle (date + flow, prev/next arrows) with pastel bands below for mood and note.
- Log screen (`tidal_flutter/lib/screens/log_screen.dart`), opened from the "+" FAB: Flow/Mood/Note tiles open bottom sheets (`tidal_flutter/lib/widgets/log_sheets.dart`); Pain/Painkiller/Reminder tiles show a "coming soon" snackbar until their steps are built.
- Design tokens in `tidal_flutter/lib/theme.dart` (`TidalColors`, `TidalRadius`, `buildTidalTheme()`) matching CLAUDE.md's pastel design system (Fraunces for titles/big numbers, Nunito Sans otherwise).
- `tidal_flutter/lib/screens/me_screen.dart` shows the signed-in email and a sign-out button (the privacy/"delete all my data" screen is a later step).

**Steps 3-4 (pain + medication logging) are done.** Logging pain and a painkiller dose both show up on Home as time-ordered bands.

- `PainEntry`, `Medication`, `DoseLog` models (`tidal_server/lib/src/pain/*.spy.yaml`). `PainEntry.locations` is a `List<PainLocation>` (cramps/lowerBack/head/legs/stomach). `DoseLog.medicationId` relates to `Medication`; `DoseLog.dose` snapshots the medication's `usualDose` at log time; `painBefore` is optional context.
- `PainEndpoint` (`tidal_server/lib/src/pain/pain_endpoint.dart`): `logPain`, `getPainRange`, `myMeds`, `addMedication`, `logDose`, `getDoseRange`, `getLastDose`. Timestamps are always server-generated ("now"), never client-supplied. Tested in `tidal_server/test/integration/pain_endpoint_test.dart`.
- Pain sheet and Painkiller sheet (`tidal_flutter/lib/widgets/pain_sheets.dart`), wired to the Pain/Painkiller tiles in the Log screen. The Pain sheet combines a 0-10 level, location chips, and an optional one-tap "took something" (logs a dose with `painBefore` set to that level). The Painkiller sheet shows "time since last dose" and a one-tap medication list that logs a dose immediately; "Add a medication" opens a small add-medication sheet.
- Shared sheet chrome (`SheetScaffold`, `OptionChip`, `showTidalSheet`, `showSheetError`) lives in `tidal_flutter/lib/widgets/sheet_common.dart` so Flow/Mood/Note and Pain/Painkiller sheets stay visually consistent.
- Home screen now also fetches the day's pain entries and dose logs (alongside the day log and meds list) and renders one band per entry, sorted by time, before the mood/note bands.

**Steps 5-6 (check-in + calendar) are done.** An hour after a dose is logged, a "did it help?" check-in appears automatically; the Calendar tab shows period days, pain days, and a tap-to-select day detail.

- `DoseLog` gained `painAfter` (nullable `int`) and `checkInDue` (`bool`, default `false`) (`tidal_server/lib/src/pain/dose_log.spy.yaml`).
- `CheckInFutureCall` (`tidal_server/lib/src/pain/check_in_future_call.dart`): a Serverpod future call that flips `checkInDue` to `true` on a dose log, unless it's already been answered. `PainEndpoint.logDose` schedules it 1 hour after the dose (identifier `check-in-<doseLogId>`, so it can't double-schedule); `PainEndpoint.snoozeCheckIn` reschedules it 30 minutes out.
- `PainEndpoint` gained `getPendingCheckIn` (the signed-in user's one due check-in, if any), `recordRelief` (saves `painAfter`, clears `checkInDue`), and `snoozeCheckIn`. All tested in `pain_endpoint_test.dart`, including simulating the future call firing directly (its real delay can't be awaited in tests).
- `CheckInScreen` (`tidal_flutter/lib/screens/check_in_screen.dart`): before/now pain comparison, one-tap 0/2/4/6/8/10 buttons, "Save relief" / "Ask me again in 30 min". `HomeScreen` checks for a pending check-in on load and pushes this screen automatically.
- `CalendarScreen` (`tidal_flutter/lib/screens/calendar_screen.dart`): a Sunday-first month grid (rose ring = period day, small rose dot = pain day), prev/next month navigation, and a day detail panel (reusing `DayBands`) for whichever day is selected. The "+" FAB opens `LogScreen` for the selected date. Predicted-period and fertile-window rings are deliberately not shown yet — they need the cycle-length predictions from step 7.
- `DayBands`/`Band` (`tidal_flutter/lib/widgets/day_bands.dart`): extracted out of `home_screen.dart` so Home and Calendar render a day's log identically; takes an optional `emptyMessage` so each screen's empty state reads naturally.
- `date_format.dart` gained `formatMonthYear`, `firstOfMonth`, `addMonths`, `isSameDay`, and `weekdayHeaderLabels` for the calendar grid.

**Next**: predictions (step 7) — `Cycle`/`Prediction` models and an average of the last 3-6 cycle lengths, which the Calendar's predicted/fertile rings and Home's "next period" depend on.

The user starts the server and Flutter app with `serverpod start`. There is no need to check if the server is running: make the changes and call the `serverpod` MCP tools as needed. If the server is not running, an informative error message will be received from the MCP server. Then STOP and ask the user to start it. NEVER start the server yourself. The Flutter app is started along with it, or can be launched from the MCP tool `spawn_flutter_app`.

While running, `serverpod start` watches for file changes to run incremental code generation and hot reload both the server and the Flutter app.

Calling `serverpod generate` directly is not needed, but might be useful to troubleshoot when an incremental generation fails.

ALWAYS use the MCP server instead of the command line. Use the MCP server to:

- `create_migration` and `apply_migrations` for database (after you change data models).
- `create_repair_migration` if the database has drifted out of sync with the migrations.
- `tail_server_logs` to read logs from the server.
- `tail_flutter_logs` to read the raw stdout/stderr of the Flutter app.
- `hot_reload` / `hot_restart` to reload or restart the server and the Flutter app. ALWAYS call `hot_restart` after doing changes in the Flutter app that may not work with normal hot reload (which is automatically applied).
- `spawn_flutter_app` to start a Flutter app declared under `serverpod: flutter_apps:` in the server `pubspec.yaml`.
- `get_flutter_app_dtd` (Dart tooling daemon) for connecting to the app through the `dart` MCP.

NEVER edit generated code. The server's `lib/src/generated/` directory and the whole `tidal_client` package are rewritten by the code generator. Change the `.spy.yaml` models, the endpoints, or `lib/server.dart` instead.

Migrations are a narrow exception: the `migration.sql` of a generated migration MAY be edited by hand when the generated SQL would lose data — to add a data transformation, or to reach a destructive change through non-destructive steps. Never touch the other files in the migration directory, and keep the schema the SQL ends up with identical to `definition.sql` — new databases are created from that file and never run `migration.sql`.

Only when the server cannot be started at all, fall back to the CLI in the server package:

- `serverpod generate` to regenerate the client and the generated server code.
- `serverpod create-migration` after changing a model with a `table` (add `--force` for destructive changes). It only writes the migration; `serverpod start` applies pending migrations when it boots the server.

Tests need no Docker. `config/test.yaml` sets `database.dataPath`, so Serverpod starts and manages the test database (an embedded PostgreSQL) itself, and the project's `docker-compose.yaml` is not used for it. Just run `dart test` in the server package.

Checklist after doing changes, in this order:

- `dart analyze` (CLI)
- `dart format` (CLI)
- `create_migration` and `apply_migrations` (MCP - only if necessary)
- Do `serverpod` MCP `hot_restart` if required (hot reload is done automatically). Will also hot restart Flutter app
- Run tests, if applicable (`dart test` in the server package)
- Check `serverpod` MCP `tail_server_logs` and `tail_flutter_logs` for any issues.

If the user asks you to test the app:

1. Use `get_flutter_app_dtd` (`serverpod` MCP) to get the Flutter app's DTD
2. Pass the DTD to `connect_dart_tooling_daemon` (`dart` MCP) to connect to the app
3. Use `flutter_driver` (`dart` MCP) to navigate through the app

The app is launched from `tidal_flutter/lib/driver.dart`, which starts the Flutter driver extension with text entry emulation turned off so the app stays usable by hand. To let the driver type, set `enableTextEntryEmulation: true` there and `hot_restart` the app.
