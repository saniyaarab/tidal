@AGENTS.md

# Tidal: project context for Claude

Tidal is a period **and pain** tracker built for the Serverpod hackathon (Serverpod 4 + Flutter).
Submit on BuilderBase by **Oct 12, 2026** (hard deadline Oct 14). Submission: working app, demo video ≤ 3 min, project description, GitHub repo.

The developer is a data engineer (Python, Java, cloud) who is new to Flutter/Dart. Keep the code simple and well commented, build one feature at a time, and explain how to test each step.
Serverpod App Studio runs the project locally (full-stack hot reload, embedded Postgres).

## The hook
Popular trackers (Flo, Clue, Maya, Tide) don't track pain properly. Tidal logs pain level and the painkiller taken, then shows how pain follows the cycle.
Demo story: "My periods are painful and I take painkillers. My tracker couldn't log any of that, so I built Tidal."

## MVP scope (build in this order)
1. Email auth (Serverpod built-in auth).
2. Day log: flow, mood, note.
3. Pain log: level 0–10, locations (cramps, lower back, head, legs, stomach), time.
4. Medication log: user's "my meds" list (name + usual dose), one-tap dose logging, "time since last dose". Record only. Never suggest doses.
5. Removed: the "did it help?" check-in after a dose was cut at the developer's request (Oct 2, 2026). Do not re-add it or any relief/painAfter tracking.
6. Calendar: period, predicted, and fertile days as rings, with a dot on pain days. Periods are started and ended by long-press (see "Period tracking" below).
7. Predictions: average of the last 3–6 cycle lengths, ± spread. Period length learned from recorded periods (see "Period tracking").
8. Pain insights: average pain by cycle day.
9. Partner sharing: invite code; partner sees phase + a live "bad pain day" status via a Serverpod streaming endpoint; care nudges.
10. Privacy screen + "delete all my data".

Stretch only if ahead: doctor summary PDF export, "pack your painkillers" reminder, offline sync.
Future (not MVP, developer's ideas): flag periods longer than 8 days as a possible menorrhagia anomaly and warn/track it; flag missed or unusually long cycles as anomalies; ask the user whether they're regular, irregular, or have PCOS/endometriosis and handle each case; reminders and events on future dates.
Cut: pregnancy mode, community, wearables, ML.

## Period tracking (agreed with the developer, Oct 2, 2026)
A period is defined by its start and end dates, which the user sets by long-pressing days on the Calendar. Flow level is separate.

**Long-press on a Calendar day** (today or past days only):
- **On a period's start date:** removes that period right away. A message shows "Period removed · Undo" and disappears by itself.
- **1–9 days after the start of the latest period that began before it** (i.e. up to the period's 10th day): sets that period's end date. This works for days inside the assumed length too (shortening it) and for days after it (lengthening it). The end is now confirmed.
- **Up to 9 days before an existing period's start** (and not inside another period): moves that period's start earlier to this date ("Period start moved · Undo") instead of creating an overlapping period.
- **Anywhere else:** starts a new period on that date. Until an end is set, the period is assumed to last the user's default period length (e.g. start + 4 more days for a 5-day default), and those days show as period days like any other.
- **On a future date:** does nothing except show a message that periods can't be logged for future dates.
- After every long-press, show a short message that disappears by itself, with Undo, e.g. "Period started · assumed 5 days · Undo" or "Period ended · 4 days · Undo".
- One-line hint under the calendar: "Long-press a day to start or end a period".

**Default period length:** the average of the user's confirmed period lengths, **always rounded up** (e.g. 4, 5, 4 → 4.33 → 5). Before any period has a confirmed end, use the period length entered at sign-up (`CycleSettings.typicalPeriodDays`, default 5). Assumed (unconfirmed) periods never count toward the average. Period length can only be entered at sign-up; afterwards Me shows the current default (learned or from sign-up) read-only, e.g. "5 days · from your last 3 periods".

**Cycle length** (start of one period to the start of the next) works as before: the average of the last 3–6 cycles, now measured from `Period.startDate` instead of being derived from flow. Cycles longer than 45 days (e.g. a forgotten or missed period) are still recorded and shown with an asterisk (e.g. "53*") but left out of the average, with no warning for now.

**Flow** (light/medium/heavy) is optional and recorded per day. It never creates, ends or splits a period.

**Future dates:** only Note can be logged. Flow, Mood, Pain and Painkiller are disabled with a message saying they can't be logged for future dates.

**Home:** tapping the day circle opens the Calendar tab with that date selected. No long-press on Home.

**Existing data:** every period start found by the old flow-based rule (a flow day whose previous day has no flow) becomes a `Period` starting on that date with no confirmed end, so it shows with the default length.

## Data models (.spy.yaml)
- DayLog: userId, date, flow (none/light/medium/heavy), mood, note
- PainEntry: userId, timestamp, level, locations
- Medication: userId, name, usualDose
- DoseLog: userId, medicationId, timestamp, dose, painBefore
- Period: userId, startDate, endDate (nullable; null = not confirmed yet, so the end is assumed from the default period length)
- Prediction: userId, nextStart, confidenceDays
- PartnerLink: ownerId, partnerId, inviteCode, sharesPhase, sharesPainStatus

## Endpoints
- LogEndpoint: saveDay, getRange, deleteAll
- PainEndpoint: logPain, logDose, myMeds
- InsightEndpoint: getPrediction, getPainInsights
- PartnerEndpoint: createInvite, acceptInvite, watchPartner (stream)
Every endpoint only returns the signed-in user's own data.

## Design system (pastel, soft, feminine)
- Background #FAF7FD · cards #FFFFFF · borders #E7E0F0
- Text #2E2640 · secondary text #655D78
- Lavender (primary): buttons/titles/active tab #6B4FA0, day circle #7A5CB8, circle ring #DCD0F3, soft band #EDE6F9
- Yellow (secondary): "+" button #FFD95E with plum icon, soft band #FFF4CC, icons #8A6500
- Rose (period & pain only): #B04A68, soft band #FCE8EE
- Fonts (google_fonts): Fraunces for titles and big numbers, Nunito Sans for everything else
- Rounded corners 14–20 px, outline icons, touch targets ≥ 44 px
- All tokens live in one theme file

## Screens (wireframes exist; layout inspired by the Maya app, look is Tidal's own)
- Bottom nav: Home, Calendar, Insights, Partner, Me. Yellow round "+" button on Home and Calendar.
- Home ("Today"): cycle day + next period at the top; a large lavender day circle (date, "Day 1", "Period · heavy") with prev/next arrows; below it, full-width pastel bands per logged item (pain = rose, painkiller = lavender, mood = yellow); a "your pattern" tip row.
- Log menu (+): two big tiles, Pain (rose) and Painkiller (lavender), then round pastel buttons: Flow, Mood, Symptoms, Note, Share, Reminder.
- Log pain sheet: 0–10 circles (rose ramp), location chips, one-tap "my meds" list, "Save".
- Calendar, Insights (Pain/Cycle/History tabs), Partner view as described in the MVP.

## Current step
Step 1 (foundation) is done: auth, DayLog + LogEndpoint, app shell with bottom nav and "+", Home screen with day circle and bands, Log sheet for Flow/Mood/Note.
Steps 3-4 (pain + medication logging) are done: PainEntry/Medication/DoseLog + PainEndpoint, Pain and Painkiller log sheets, Home bands for pain and doses (ordered by time).
Step 5 (check-in) was built and then removed at the developer's request. Step 6 (calendar) is done: CalendarScreen with a month grid (period rings, pain dots, tap-to-select day detail).
Step 7 (predictions) is done: InsightEndpoint.getPrediction derives cycle starts from DayLog flow and averages the last 3-6 cycle lengths; Home shows "Cycle day N · Next period in Nd" and Calendar shows predicted-period and fertile-window rings. See AGENTS.md for what's built and where.
Period tracking by long-press (see the section above) is done: `Period` table + PeriodEndpoint, predictions from periods, Calendar long-press with Undo, Home circle opens Calendar, notes-only future dates, read-only period length on Me.
Next: pain insights (step 8).
