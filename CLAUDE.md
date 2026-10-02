@AGENTS.md

# Tidal: project context for Claude

Tidal is a period **and pain** tracker built for the Serverpod hackathon (Serverpod 4 + Flutter).
Submit on BuilderBase by **Oct 12, 2026** (hard deadline Oct 14). Submission: working app, demo video ≤ 3 min, project description, GitHub repo.

The developer is a data engineer (Python, Java, cloud) who is new to Flutter/Dart. Keep the code simple and well commented, build one feature at a time, and explain how to test each step.
Serverpod App Studio runs the project locally (full-stack hot reload, embedded Postgres).

## The hook
Popular trackers (Flo, Clue, Maya, Tide) don't track pain properly. Tidal logs pain and the medications taken alongside the cycle, so patterns can be found later.
Demo story: "My periods are painful and I take painkillers. My tracker couldn't log any of that, so I built Tidal."

## MVP scope (build in this order)
1. Email auth (Serverpod built-in auth).
2. Day log: flow, mood, note.
3. Pain log: level 0–10, locations (cramps, lower back, head, legs, stomach). Pain only — no medication on the pain sheet.
4. Medications: the user's list of anything they take (name, usual dose, optional type: painkiller, birth control, vitamin/supplement, other), one-tap "taken" logging, "last taken" per medication. Remembered for future reminders. Record only. Never suggest doses.
5. Removed: the "did it help?" check-in after a dose was cut at the developer's request (Oct 2, 2026). Do not re-add it or any relief/painAfter tracking.
6. Calendar: period, predicted, and fertile days as rings, with a dot on pain days. Periods are started and ended by long-press (see "Period tracking" below).
7. Predictions: average of the last 3–6 cycle lengths, ± spread. Period length learned from recorded periods (see "Period tracking").
8. Insights (MVP): average cycle length and average period length, with a bar chart of recent cycles (see "Insights" below).
9. Cut (Oct 2, 2026, developer's decision): partner sharing. Not part of the MVP.
10. Privacy screen + "delete all my data" (agreed Oct 2, 2026): a "Privacy" row on Me opens a Privacy screen with exactly these three lines — "Only you can see your data.", "Tidal never shares or sells it.", "You can delete everything at any time." — and a red "Delete all my data" button. It asks "Delete all your data? This can't be undone." (Cancel / red Delete), then deletes everything tied to the user — day logs, periods, pain entries, medications, doses, sign-up answers, and the account itself — and signs them out. Nothing is kept.

Stretch only if ahead: doctor summary PDF export, "pack your painkillers" reminder, offline sync.
Future (not MVP, developer's ideas): log more of what affects symptoms — bowel movements/IBS (pain relief after a bowel movement), caffeine and water (breast pain), foods (bloating), sugar cravings — and find patterns in why some cycles hurt more than others, with healthier swaps for cravings; medication schedules and reminders; anonymous research data to learn patterns across users (e.g. IBS and period pain) — consent model still to be decided by the developer (opt-in recommended for legal reasons: GDPR, Washington's My Health My Data Act); until then, delete removes everything; flag periods longer than 8 days as a possible menorrhagia anomaly and warn/track it; flag missed or unusually long cycles as anomalies; ask the user whether they're regular, irregular, or have PCOS/endometriosis and handle each case; reminders and events on future dates.
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

**Default period length:** the average of the user's confirmed period lengths, **always rounded up** (e.g. 4, 5, 4 → 4.33 → 5). Before any period has a confirmed end, use the period length entered at sign-up (`CycleSettings.typicalPeriodDays`, default 5). Assumed (unconfirmed) periods never count toward the average. Cycle length, period length and birth year can only be entered at sign-up (period/cycle length as the user's first estimate). Me shows only the age computed from birth year, read-only, labelled "Age". Afterwards they don't appear on Me at all; the learned averages are shown on Insights.

**Cycle length** (start of one period to the start of the next) works as before: the average of the last 3–6 cycles, now measured from `Period.startDate` instead of being derived from flow. Cycles shorter than 18 days or longer than 45 days (e.g. a forgotten or missed period; same rule as Maya) are still recorded and shown with an asterisk (e.g. "53*") but left out of the average, with no warning for now.

**Flow** (light/medium/heavy) is optional and recorded per day. It never creates, ends or splits a period.

**Future dates:** only Note can be logged. Flow, Mood, Pain and Painkiller are disabled with a message saying they can't be logged for future dates.

**Home:** tapping the day circle opens the Calendar tab with that date selected. No long-press on Home.

**Existing data:** every period start found by the old flow-based rule (a flow day whose previous day has no flow) becomes a `Period` starting on that date with no confirmed end, so it shows with the default length.

## Pain and medication times (agreed Oct 2, 2026)
Pain entries and medications taken store the day they belong to, the time they happened, and (server-only) the exact moment they were saved. The Pain and Medications sheets show "<day> · <time>", defaulting to the day being logged and the current time; the user can change both, but not to the future. The app groups entries by day. Wherever a logged pain entry or medication is shown (pain bands on Home/Calendar, the Medications sheet), it shows time since, not the clock time — e.g. "3h ago", "Last taken 3h ago" — so the user can tell when a dose is due (e.g. every 4 hours).

## Insights (MVP, agreed Oct 2, 2026)
The Insights tab shows "Avg cycle: N days" and "Avg period: N days", then a bar chart with one bar per recent cycle (up to 6): bar height is the cycle length, the bottom part shaded rose for its period days, a dashed line at the average cycle length. Cycles left out of the average are drawn faded and labelled with an asterisk ("53*"). Chart library: fl_chart.

## Data models (.spy.yaml)
- DayLog: userId, date, flow (none/light/medium/heavy), mood, note
- PainEntry: userId, date, timestamp, loggedAt, level, locations
- Medication: userId, name, usualDose, type (optional)
- DoseLog: userId, medicationId, date, timestamp, loggedAt, dose
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
- Home ("Today"): cycle day + next period at the top; a large lavender day circle (date, "Day 1", "Period · heavy") with prev/next arrows; below it, full-width pastel bands per logged item (pain = rose, mood = yellow, note = lavender; medications are not shown on Home or Calendar, only in the Medications sheet); a "your pattern" tip row.
- Log menu (+): two big tiles, Pain (rose) and Painkiller (lavender), then round pastel buttons: Flow, Mood, Symptoms, Note, Share, Reminder.
- Log pain sheet: 0–10 circles (rose ramp), location chips, one-tap "my meds" list, "Save".
- Calendar, Insights (Pain/Cycle/History tabs), Partner view as described in the MVP.

## Current step
Step 1 (foundation) is done: auth, DayLog + LogEndpoint, app shell with bottom nav and "+", Home screen with day circle and bands, Log sheet for Flow/Mood/Note.
Steps 3-4 (pain + medication logging) are done: PainEntry/Medication/DoseLog + PainEndpoint, Pain and Painkiller log sheets, Home bands for pain and doses (ordered by time).
Step 5 (check-in) was built and then removed at the developer's request. Step 6 (calendar) is done: CalendarScreen with a month grid (period rings, pain dots, tap-to-select day detail).
Step 7 (predictions) is done: InsightEndpoint.getPrediction derives cycle starts from DayLog flow and averages the last 3-6 cycle lengths; Home shows "Cycle day N · Next period in Nd" and Calendar shows predicted-period and fertile-window rings. See AGENTS.md for what's built and where.
Period tracking by long-press (see the section above) is done: `Period` table + PeriodEndpoint, predictions from periods, Calendar long-press with Undo, Home circle opens Calendar, notes-only future dates, read-only period length on Me.
Medications (step 4 redesign), editable pain/medication times, and Insights MVP (step 8) are done. Me shows only Age (read-only) and sign out.
Step 10 (privacy + delete all data) is done. Step 9 (partner sharing) was cut; the Partner tab will become a self-care Journal (design pending from the developer).
Next: Journal tab, then the demo video.
