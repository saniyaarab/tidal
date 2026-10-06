# Data Model: Home Screen State Migration

No server models, tables, or migrations change. This lists the client-side types Home uses.

## HomeState (presentation/bloc)
Immutable, value-comparable (`Equatable`). Three sections load independently.

| Field | Type | Notes |
|-------|------|-------|
| `selectedDate` | `DateTime` (UTC date key) | Starts at today (from the injected clock) |
| `day` | `DayData?` + `dayStatus` (`loading` / `loaded` / `failed`) | `failed` carries an error message |
| `prediction` | `Prediction?` | Null until loaded or if the load fails (silent) |
| `dueReminders` | `List<DueReminder>` | Empty until loaded or if the load fails (silent) |

`DayData` (domain) bundles what the day load returns: `DayLog?`, `PeriodSpan?`, `List<PainEntry>`, `List<BowelMovement>`, `UnitPreferences`, all generated models.

## HomeEvent
`HomeStarted`, `HomeDayChanged(deltaDays)`, `HomeRefreshed`, `HomeReturnedFromLog`, `HomeRemindersChecked` (from the tick stream), `HomeReminderDoseLogged(reminder)`, `HomeReminderDismissed(reminder)`.

State transitions:
- `HomeStarted` → day loading; prediction and reminders load in parallel.
- `HomeDayChanged` → selected date moves; day loading; a newer change supersedes an older one (D2). Prediction is unaffected.
- `HomeRefreshed` (pull-to-refresh) → reload the day only, as today.
- `HomeReturnedFromLog` (back from the log screen) → reload the day and reminders, as today.
- The prediction loads once at start and is not reloaded by either, as today.
- Reminder actions → call the repository, then reload reminders.

## DayStatus (domain, pure)
`isPeriodDay`, `periodDayNumber` (1-based, null outside a period), `flow` (`FlowLevel`). Built from `(selectedDate, PeriodSpan?, DayLog?)`. Presentation renders "Period · Day N" / "Period · Day N\n<Flow>" / "<Flow> flow" / "No period" from it, exactly as today.

## CycleOutlook (domain, pure)
`cycleDay` (null → nothing shown), `daysUntilNextPeriod` (null if unknown), `confidenceDays`, `isDueNow` (days until ≤ 0). Built from `(Prediction, today)`.

## DueReminder (domain)
`reminderId`, `medicationId`, `medicationName` (falls back to "Medication" when the medication is unknown, as today).
