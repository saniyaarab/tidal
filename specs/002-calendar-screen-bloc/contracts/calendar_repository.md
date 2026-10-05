# Contract: CalendarRepository

Where the Calendar gets its data. The real implementation (`ServerCalendarRepository`) talks to
the server through `CalendarServerApi`; tests use `FakeCalendarRepository`. Every call is scoped
to the signed-in user by the server. Dates are UTC-midnight date keys.

```dart
abstract class CalendarRepository {
  /// Everything the screen shows for [month] with [selectedDate] selected.
  /// Issues the reads in parallel. Throws if any of them fails.
  Future<CalendarData> load(DateTime month, DateTime selectedDate);

  /// Long-press on [date]: starts, ends, moves or removes a period (rules live
  /// in PeriodEndpoint.longPress). Throws on failure.
  Future<PeriodChange> longPress(DateTime date);

  /// Reverses [change] (PeriodEndpoint.undo). Throws on failure.
  Future<void> undo(PeriodChange change);
}
```

## `load` maps to these server calls (same as today)
| Bundle field | Call |
|---|---|
| `monthDayLogs` | `log.getRange(month, monthEnd)` |
| `monthPainEntries` | `pain.getPainRange(month, monthEnd)` |
| `selectedPainEntries` | `pain.getPainRange(selectedDate, selectedDate)` |
| `prediction` | `insight.getPrediction()` |
| `periods` | `period.getPeriods(gridStart, gridEnd)` |
| `selectedBowelMovements` | `digestion.getBowelMovementRange(selectedDate, selectedDate)` |
| `units` | `insight.getUnitPreferences()` |

`monthEnd`, `gridStart`, `gridEnd` come from `CalendarGrid(month)`.

## CalendarServerApi (data layer, project-owned)
`getDayLogs`, `getPainEntries`, `getPeriods`, `getBowelMovements`, `getUnitPreferences`,
`getPrediction`, `longPress`, `undo`. `ClientCalendarServerApi` forwards each to the generated
`Client`. (Home's `HomeServerApi` is not reused: it also carries reminder calls Calendar must
not depend on, and the two features stay independent.)

## Test expectations
- `load` passes `month`/`selectedDate` ranges exactly as the table says and bundles each result into its field.
- Any single failing read makes `load` throw.
- `longPress` returns the server's `PeriodChange` untouched; `undo` forwards the same object.
