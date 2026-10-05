# Data Model: Calendar Screen State Migration

No persisted data changes. These are client-side types only. Generated server models
(`DayLog`, `PainEntry`, `BowelMovement`, `UnitPreferences`, `Prediction`, `PeriodSpan`,
`PeriodChange`, `PeriodChangeKind`) are reused unchanged.

All dates are UTC-midnight date keys (see `date_format.dart`).

## Domain (`lib/features/calendar/domain/`)

### CalendarData (bundle returned by `CalendarRepository.load`)
| Field | Type | Notes |
|---|---|---|
| `monthDayLogs` | `List<DayLog>` | the month's logs |
| `monthPainEntries` | `List<PainEntry>` | the month's pain entries |
| `periods` | `List<PeriodSpan>` | spans for the grid range, assumed ends filled in by the server |
| `selectedPainEntries` | `List<PainEntry>` | selected day only |
| `selectedBowelMovements` | `List<BowelMovement>` | selected day only |
| `units` | `UnitPreferences` | |
| `prediction` | `Prediction` | |

The repository returns raw lists. The bloc turns them into the state's maps and sets with the
pure functions below, so the rules are tested without the data layer.

### CalendarGrid (pure rule)
- `CalendarGrid(month)`: `monthEnd` (last day), `gridStart` (`month - (month.weekday % 7)` days), `gridEnd` (`gridStart + 41`), `dates` (42 consecutive dates from `gridStart`).

### expandPeriodDays (pure rule)
`Set<DateTime> expandPeriodDays(List<PeriodSpan>)`: every date from each span's `startDate` through `endDate`, inclusive; overlapping spans merge; spans outside the grid range are still expanded.

### DayMarks (pure rule)
`DayMarks.of(date, month, selectedDate, today, periodDates, painDates, prediction)` →
- `inCurrentMonth`, `isSelected`, `isToday`, `hasPain`
- `ring`: `DayRing { none, period, predicted, fertile, today }`; priority period > predicted > fertile > today; `none` when selected.
- predicted = `nextPeriodStart <= date <= predictedPeriodEnd` (both non-null); fertile = `fertileWindowStart <= date <= fertileWindowEnd` (both non-null).

### CalendarMessage (one-time message, no text)
| Variant | Fields | Undo? |
|---|---|---|
| `periodStarted` | `days` | yes |
| `periodEnded` | `days` | yes |
| `periodMoved` | `days` | yes |
| `periodRemoved` | — | yes |
| `futureDateRefused` | — | no |
| `updateFailed` | `error` (String) | no |

Each carries a sequence `id`; undoable ones also carry the `PeriodChange` to pass to `undo`.
Mapping from `PeriodChangeKind` (started/ended/moved/removed) is a pure function.

### CalendarRepository
See [contracts/calendar_repository.md](contracts/calendar_repository.md).

## Presentation state (`CalendarState`, Equatable)
| Field | Type | Notes |
|---|---|---|
| `month` | `DateTime` | first of month; starts as today's month |
| `selectedDate` | `DateTime` | starts as today |
| `status` | `CalendarLoadStatus` | `loading` / `loaded` / `failed`; starts `loading` |
| `error` | `String?` | set only when `failed` |
| `dayLogs` | `Map<DateTime, DayLog>` | kept across failed loads |
| `periodDates`, `painDates` | `Set<DateTime>` | kept across failed loads |
| `selectedPainEntries`, `selectedBowelMovements` | lists | |
| `units` | `UnitPreferences?` | null until first load |
| `prediction` | `Prediction?` | null until first load |
| `message` | `CalendarMessage?` | latest one-time message (see research D5) |

### State transitions
- Started / Refreshed / ReturnedFromLog / MonthChanged / DateSelected / DateRequested → `loading` (error cleared) → `loaded` with new data, or `failed` with the error and the previous data kept. A result for a month or date no longer in state is dropped (D2).
- MonthChanged: `month = addMonths(month, delta)`; selected date unchanged.
- DateRequested: `month = firstOfMonth(date)`, `selectedDate = date`.
- DayLongPressed: future → message `futureDateRefused`; else server call, then `selectedDate = date`, reload, message with Undo; on error message `updateFailed`.
- UndoPressed: server undo then reload; on error still reload.
- Sign-out: the bloc is closed with `AppShell`; nothing persists.
