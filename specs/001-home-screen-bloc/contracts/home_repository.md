# Contract: HomeRepository and its collaborators

The interfaces Home's logic depends on. Real implementations call the server; tests use fakes.

## HomeRepository (domain)

| Method | Returns | Behavior |
|--------|---------|----------|
| `loadDay(DateTime date)` | `DayData` | Day log, period, pain entries, bowel movements, unit preferences for that date, fetched in parallel. Throws on failure. |
| `loadPrediction()` | `Prediction` | Cycle prediction for today, independent of the selected day. |
| `loadDueReminders()` | `List<DueReminder>` | Only reminders that are due, each joined with its medication's name. |
| `logReminderDose(DueReminder r, DateTime now)` | `void` | Logs the medication as taken now; the server then sets the next reminder. |
| `dismissReminder(DueReminder r)` | `void` | Dismisses the reminder. |

## HomeServerApi (data)
The narrow surface `ServerHomeRepository` needs from the generated `Client`: `getRange`, `getPainRange`, `getPeriods`, `getBowelMovementRange`, `getUnitPreferences`, `getPrediction`, `getReminders`, `myMeds`, `logDose`, `dismissReminder`. A thin adapter wraps the generated client in the app; tests supply a fake.

## Other injected collaborators (bloc constructor)
- `DateTime Function() now`: the clock.
- `Stream<void> reminderTicks`: emits once a minute in the app.

## Guarantees
- Every call is scoped to the signed-in user by the server (unchanged); the repository adds no caching or persistence.
- `logReminderDose` and `dismissReminder` may throw. The bloc catches the error, keeps the banner, and reloads reminders.
- Errors from `loadDay` reach the bloc as exceptions and become a `failed` state. Errors from `loadPrediction` and `loadDueReminders` are swallowed by the bloc and leave the previous value.
