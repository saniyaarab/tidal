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
6. Calendar: period, predicted, and fertile days as rings, with a dot on pain days.
7. Predictions: average of the last 3–6 cycle lengths, ± spread.
8. Pain insights: average pain by cycle day.
9. Partner sharing: invite code; partner sees phase + a live "bad pain day" status via a Serverpod streaming endpoint; care nudges.
10. Privacy screen + "delete all my data".

Stretch only if ahead: doctor summary PDF export, "pack your painkillers" reminder, offline sync.
Cut: pregnancy mode, community, wearables, ML.

## Data models (.spy.yaml)
- DayLog: userId, date, flow (none/light/medium/heavy), mood, note
- PainEntry: userId, timestamp, level, locations
- Medication: userId, name, usualDose
- DoseLog: userId, medicationId, timestamp, dose, painBefore
- Cycle: userId, startDate, endDate, length
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
Next: pain insights (step 8).
