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

**Step 5 (check-in) was removed at the developer's request (Oct 2, 2026).** The 1-hour "did it help?" check-in (`CheckInFutureCall`, `getPendingCheckIn`/`recordRelief`/`snoozeCheckIn`, `CheckInScreen`, and `DoseLog.painAfter`/`checkInDue`) was built and then deleted; migration `20261002163251506` drops the two columns. Do not re-add it or any relief tracking. `DoseLog.painBefore` stays.

**Step 6 (calendar) is done.** The Calendar tab shows period days, pain days, and a tap-to-select day detail.

- `CalendarScreen` (`tidal_flutter/lib/screens/calendar_screen.dart`): a Sunday-first month grid (rose ring = period day, small rose dot = pain day), prev/next month navigation, and a day detail panel (reusing `DayBands`) for whichever day is selected. The "+" FAB opens `LogScreen` for the selected date. Predicted-period and fertile-window rings are deliberately not shown yet — they need the cycle-length predictions from step 7.
- `DayBands`/`Band` (`tidal_flutter/lib/widgets/day_bands.dart`): extracted out of `home_screen.dart` so Home and Calendar render a day's log identically; takes an optional `emptyMessage` so each screen's empty state reads naturally.
- `date_format.dart` gained `formatMonthYear`, `firstOfMonth`, `addMonths`, `isSameDay`, and `weekdayHeaderLabels` for the calendar grid.

**Step 7 (predictions) is done.** Home shows a "Cycle day N · Next period in Nd" header, and the Calendar's predicted-period and fertile-window rings are live.

- `Prediction` (`tidal_server/lib/src/insights/prediction.spy.yaml`): a computed, non-persisted model (no `table`) — `lastPeriodStart`, `currentCycleDay`, `nextPeriodStart`, `confidenceDays`, `predictedPeriodEnd`, `fertileWindowStart`/`End`.
- `InsightEndpoint.getPrediction` (`tidal_server/lib/src/insights/insight_endpoint.dart`): re-derives period start dates from `DayLog.flow` on every call (a day is a period start if flow isn't `none` and the day before was) — nothing is stored, so correcting a past day's flow is reflected immediately. With 2+ logged period starts, averages the last 3-6 completed cycle lengths for `nextPeriodStart`, with `confidenceDays` as half the spread between the shortest and longest of those lengths (a single completed cycle defaults to 2, since there's no spread to measure). With 0 or 1 period starts logged, there's no measured length yet, so `nextPeriodStart` is seeded from the user's `CycleSettings.typicalCycleDays` instead, with a wider `confidenceDays` of 4 (a sign-up guess is less trustworthy than even one real cycle) — this only needs one anchor date, so it kicks in from the very first logged period. `predictedPeriodEnd` is always `nextPeriodStart` plus `CycleSettings.typicalPeriodDays` (minus one day), whichever branch set it. The fertile window is estimated as the 14-days-before-next-period luteal phase, minus a 5-day lead for sperm survival. Tested in `insight_endpoint_test.dart`, including the 6-cycle cap, the seeded-vs-measured switch, and multi-user isolation.
- `CycleSettings` (`tidal_server/lib/src/insights/cycle_settings.spy.yaml`, has a `table`): `userId` (unique), `typicalCycleDays` (default 28), `typicalPeriodDays` (default 5), `birthYear` (nullable `int`, no default — there's no sensible guess; only the year is stored, never a full birth date). None of these can be derived from logged flow — a brand-new user has no cycle history at all, a light last day vs. a skipped log entry look identical, and birth year obviously isn't in `DayLog` — so the user sets them directly, at sign-up and any time after from Me. `InsightEndpoint.getCycleLength`/`saveCycleLength` (15-45 range) and `getPeriodLength`/`savePeriodLength` (1-14 range) read and write the cycle fields (both validated); `getBirthYear`/`saveBirthYear` (rejects future years and ages outside 8-100) and `getAge` (computed fresh from `birthYear` on every call, never stored; can be a year ahead until the birthday passes) handle birth year. `hasCycleSettings` reports whether sign-up is complete — which requires `birthYear` specifically, not just any saved field — and gates the sign-up step below.
- Sign-up flow: `CycleSetupGate` (`tidal_flutter/lib/screens/cycle_setup_gate.dart`) sits between `SignInScreen` and `AppShell` in `main.dart`. On every fresh sign-in it calls `hasCycleSettings`; if false, it shows `CycleSetupScreen` (`cycle_setup_screen.dart` — chips for cycle length and period length defaulting to 28/5, plus a required birth year via a year-only picker) before handing off to `AppShell`, so a new user is asked once and existing users skip straight through. `widgets/birth_year_picker.dart` shows a year-only picker limited to the 8-100-year-old range and provides `pickAndSaveBirthYear` (pick + save in one call, used by Me) alongside the pick-only `pickBirthYear` (used by sign-up, which saves all three fields together on "Continue").
- Home (`home_screen.dart`) fetches the prediction once in `initState`, independent of `_selectedDate` — it always reflects today, not whichever day the prev/next arrows are showing below it.
- Calendar (`calendar_screen.dart`) fetches the prediction alongside its other range calls. `_DayCell` now draws one of four rings, in priority order: solid rose (logged period) > faded rose (predicted period, `nextPeriodStart` through `predictedPeriodEnd`) > soft lavender (fertile window) > lavender (today). The legend lists all four alongside the pain-day dot.
- Me screen (`me_screen.dart`) has a "Profile" section with a "Birth year" row (shows the computed age, e.g. "32 yrs"; tapping it opens the year picker) and a "Cycle settings" section with "Cycle length" and "Period length" rows (shared `_SettingsRow`), each opening its own sheet (`cycle_length_sheet.dart`, `period_length_sheet.dart`) to change the value later.

**Period tracking by long-press is done (Oct 2, 2026).** Periods are now explicit start/end dates instead of being derived from flow; see "Period tracking" in CLAUDE.md for the agreed rules. This replaces the flow-based period detection described in step 7 above.

- `Period` (`tidal_server/lib/src/period/period.spy.yaml`, has a `table`): `userId`, `startDate`, `endDate` (nullable — null means the end is assumed from the default period length). Unique on `userId, startDate`. Migration `20261002184921249-periods` creates it and converts every old flow-based period start into a `Period` with no confirmed end (hand-added `INSERT` in its `migration.sql`).
- `PeriodEndpoint` (`tidal_server/lib/src/period/period_endpoint.dart`): `longPress` (remove on a start date → end within the 10th day or the assumed days of the previous period → move the next period's start earlier if within 9 days → otherwise start a new one; rejects future dates), `undo` (reverses a `PeriodChange`, ownership-checked), `getPeriods` (returns `PeriodSpan`s with assumed ends filled in), `getDefaultPeriodLength`. Tested in `period_endpoint_test.dart`.
- `period_lengths.dart`: `computeDefaultPeriodLength` (average of the last 6 confirmed period lengths, rounded up; falls back to `CycleSettings.typicalPeriodDays`) and `effectiveEndDate`, shared by `PeriodEndpoint` and `InsightEndpoint`.
- `InsightEndpoint.getPrediction` now reads cycle starts from `Period`, leaves cycles over 45 days out of the average, returns them all in `Prediction.recentCycles` (`CycleLength` with `excludedFromAverage`), and sizes `predictedPeriodEnd` with the learned default period length. `savePeriodLength` throws once sign-up is complete.
- Calendar: period rings come from `getPeriods` (not flow); long-press on a day calls `longPress` and shows a snackbar ("Period started · assumed 5 days") with Undo. Future dates show a "can't log" message.
- Home: the day circle says "Period · Day N" (plus flow if logged), "Light flow" for flow outside a period, or "No period". Tapping it switches to the Calendar tab with that date selected (`AppShell` passes a `ValueNotifier<DateTime?>` to `CalendarScreen`).
- Log screen: for future dates only Note works; Flow/Mood/Pain/Painkiller are greyed out and explain why when tapped.
- Me: "Period length" is read-only ("5 days · from your last 3 periods" / "· from sign-up"); recent cycle lengths are listed under Cycle length, with an asterisk on any left out of the average. `period_length_sheet.dart` was deleted.

**Medications, log times, and Insights MVP are done (Oct 2, 2026).** See "Pain and medication times" and "Insights" in CLAUDE.md.

- `PainEntry` and `DoseLog` gained `date` (UTC-midnight day key, indexed with `userId`) and `loggedAt` (server-set save time); `timestamp` is now the user-chosen time it happened. `DoseLog.painBefore` was removed. `Medication` gained an optional `type` (`MedicationType`: painkiller/birthControl/vitamin/other). Migration `20261002193126284-log-times-and-med-types` recreates the two tables and copies existing rows back (hand-added backup/restore in its `migration.sql`).
- `PainEndpoint.logPain(level, locations, date, timestamp)` and `logDose(medicationId, date, timestamp)` reject future dates/times (5-minute clock-skew allowance); `getPainRange`/`getDoseRange` look up by `date`; `getLastDose` was replaced by `getLastDosePerMedication`; `addMedication` takes an optional `type`.
- App: `widgets/when_picker.dart` (`WhenPicker` + `LogMoment`) is the shared "Wed 1 Oct · 14:32" row on both sheets, defaulting to the day being logged at the current time. The Pain sheet no longer has a medication section. The "Painkiller" tile/sheet is now "Medications" (`showMedicationsSheet`): type icon, "Last taken 3h ago" per medication, add-medication sheet with type chips.
- `InsightEndpoint`: cycles under 18 or over 45 days are excluded from the average; `CycleLength` gained `periodDays`; new `getCycleSummary` returns `CycleSummary` (average cycle, average period + how many confirmed periods it's from, recent cycles). `saveCycleLength` is sign-up-only like `savePeriodLength`.
- `InsightsScreen` (`screens/insights_screen.dart`, uses `fl_chart`): two stat cards and a stacked bar chart of recent cycles (rose period days, dashed average line, faded "53*" for excluded cycles). `AppShell` rebuilds it on every visit so it reloads.
- Me no longer shows cycle settings; it shows a read-only "Age" row and sign out. `saveBirthYear` is sign-up-only (throws once set); `cycle_length_sheet.dart` and `pickAndSaveBirthYear` were deleted.
- `DayBands` shows pain (with time since, e.g. "3h ago"), mood and note only — medications were removed from Home and Calendar at the developer's request (they're in the Medications sheet), so neither screen fetches doses or meds any more. The Insights "Avg period" card shows just the number, with no note.

**Step 9 (partner sharing) was cut** by the developer; its tab is now the Journal (below).

**Step 10 (privacy + delete all data) is done.**

- `PrivacyEndpoint.deleteAllMyData` (`tidal_server/lib/src/privacy/privacy_endpoint.dart`): in one transaction, deletes the user's `DayLog`, `Period`, `PainEntry`, `DoseLog`, `Medication` and `CycleSettings` rows, then the account via `const AuthUsers().delete` (cascades to the email login, profile and sessions), then broadcasts `RevokedAuthenticationUser`. Nothing is kept, not even anonymously. Tested in `privacy_endpoint_test.dart` with real auth users.
- `PrivacyScreen` (`tidal_flutter/lib/screens/privacy_screen.dart`), opened from a "Privacy" row on Me: the three agreed lines, a red "Delete all my data" button, a confirm dialog, then `client.auth.updateSignedInUser(null)` to forget the sign-in locally (the account no longer exists to sign out of) — the app returns to the sign-in screen.

**The Journal tab is done (Oct 2, 2026).** See "Journal" in CLAUDE.md.

- `JournalEntry` (`tidal_server/lib/src/journal/journal_entry.spy.yaml`, has a `table`): `userId`, `date`, `activities` (`List<SelfCareActivity>`, an enum of the 15 checklist items), `bestMoment`. Unique on `userId, date`. Migration `20261002210506235-journal`.
- `JournalEndpoint`: `getDay`, `saveDay` (replaces the whole day; rejects future dates; stores activities in checklist order; blank text becomes null). Tested in `journal_endpoint_test.dart`. `PrivacyEndpoint.deleteAllMyData` also deletes journal entries.
- `JournalScreen` (`tidal_flutter/lib/screens/journal_screen.dart`): date with prev/next arrows (next disabled on today), "Self care today" checklist with outline icons cycling rose/lavender/yellow, and a rose-bordered "Best moment of the day" box. Ticks save immediately; typing saves 800 ms after a pause and when changing day. `coming_soon_screen.dart` was deleted (no placeholders left).

**More daily logging and medication reminders are done (Oct 2, 2026).** See "More daily logging + medication reminders" in CLAUDE.md.

- `DayLog` gained `waterGlasses`/`caffeineDrinks`/`alcoholDrinks` (int, default 0), `sleepQuality` (1–5), `sleepHours`, `bloating`/`acidReflux` (`Severity`), `weightKg`, `temperatureC`, `mucus` (`MucusType`), `love` (`LoveType`). `LogEndpoint` saves each through its own method (`saveDrinkCount`, `saveSleep`, `saveDigestionDay`, `saveWeight`, `saveTemperature`, `saveMucus`, `saveLove`) via a shared `_updateDay`; passing null clears; future dates are rejected.
- `BowelMovement` table + `DigestionEndpoint` (`logBowelMovement`, `getBowelMovementRange`): Bristol type 1–7 with day, time and saved-at, several per day.
- Units: `CycleSettings.weightUnit`/`temperatureUnit` (defaults kg/celsius); `InsightEndpoint.getUnitPreferences`, `saveWeightUnit`, `saveTemperatureUnit`. Values are always stored in kg/°C; `tidal_flutter/lib/units.dart` converts for display.
- Reminders: `Medication.reminderEveryHours`; `MedicationReminder` table (one per medication: `dueAt`, `isDue`). `PainEndpoint.logDose` sets `dueAt` = dose time + interval (never moving it earlier) and schedules `MedicationReminderFutureCall.markDue` via `futureCalls.callWithDelay`; the call marks it due unless a newer dose moved `dueAt` later (1-minute leeway). Also `setReminder`, `getReminders`, `dismissReminder`; `addMedication` takes `reminderEveryHours`. Tested in `day_details_test.dart` (the future call is run directly).
- `PrivacyEndpoint.deleteAllMyData` also deletes bowel movements and reminders (reminders before medications, because of the foreign key).
- App: `widgets/day_detail_sheets.dart` has the drink counter, Sleep, Digestion, Weight/Temperature (unit switch, generic `_MeasurementSheet`) and Mucus/Love (`_ChoiceSheet`) sheets. The Log screen is a list of `_TileSpec`s (14 tiles; the old Reminder placeholder is gone). `DayBands` shows the new items (taking `bowelMovements` and `units`). Home shows a "<medication> due now" banner per due reminder with Log dose / Dismiss, re-checked every minute. The Medications sheet has a bell per medication (`showReminderSheet`) and shows "next in 2h" / "due now"; the add-medication sheet has "Remind me" chips.
- `SheetScaffold`'s close button now pops with no result (it used to return `false`, which crashed sheets whose result isn't a bool, like Add a medication).

**Home was migrated to BLoC and clean architecture (Oct 3, 2026).** See `specs/001-home-screen-bloc/` and `tidal_flutter/lib/features/home/README.md`; new Flutter screens follow this layout.

- `lib/features/home/` has `domain/` (repository interface, `DayStatus`/`CycleOutlook` rules), `data/` (`ServerHomeRepository` over a small `HomeServerApi`, adapted to the generated client by `ClientHomeServerApi`) and `presentation/` (`HomeBloc`, `HomeScreen`, widgets, `home_text.dart`). `lib/screens/home_screen.dart` no longer exists; `AppShell` provides the bloc with `BlocProvider`.
- Behavior is unchanged except that quickly stepping between days now shows only the last day chosen. Pull-to-refresh reloads the day only; returning from the log screen reloads the day and reminders; the prediction loads once.
- Tests are under `tidal_flutter/test/features/home/` (`flutter test` in `tidal_flutter`): headless domain, data and bloc tests with hand-written fakes, plus three happy-path widget tests found by key.
- New dependencies: `flutter_bloc`, `bloc_concurrency`, `equatable`, and `bloc_test` (dev).

**The Calendar was migrated to BLoC and clean architecture (Oct 4, 2026).** See `specs/002-calendar-screen-bloc/` and "Calendar differences" in `tidal_flutter/lib/features/home/README.md`.

- `lib/features/calendar/` has `domain/` (`CalendarRepository`, `CalendarGrid`, `expandPeriodDays`, `DayMarks`, `CalendarMessage`), `data/` (`ServerCalendarRepository` over `CalendarServerApi`, adapted by `ClientCalendarServerApi`) and `presentation/` (`CalendarBloc`, `CalendarScreen`, `calendar_text.dart`, widgets). `lib/screens/calendar_screen.dart` no longer exists.
- Home's day circle still calls `onOpenCalendar(date)`; `AppShell` sends `CalendarDateRequested(date)` to the `CalendarBloc` (the old `ValueNotifier` is gone). Asking for the same date twice now moves the Calendar both times.
- Period-change messages are one-time messages in bloc state; Undo that fails still reloads the grid.
- Tests are under `tidal_flutter/test/features/calendar/` (headless domain, data and bloc tests, plus three widget happy paths).

**Next**: see "Plan to the deadline" in CLAUDE.md (deploy to Serverpod Cloud, demo video).

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
