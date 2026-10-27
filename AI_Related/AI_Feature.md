# AI Feature: Pocket Picks (Smart Helper)

- **Method Label**: "Rule-based smart helper: local scoring, not a prediction or guarantee."
- **Owner**: Marquez Johnson (Pure Dart rule/heuristic calculation engine, comparison baseline, drafting, and tests)
- **UI Integration**: Oluchi Chukwurah (In-screen card on S4 History / Insights, "Apply / Not now / Override" controls)

## User Benefit
Shows which upcoming event best fits the user's interests and attendance history, and explains why. Runs 100% offline with zero cloud API or pre-trained models.

## Scoring Engine Inputs
1. Preferred interest tag (from `SharedPreferences`)
2. Event tags (`interestTagsJson` in `Event` table)
3. Event date/time (`startsAt`)
4. Event attendance history (`status` in `AttendanceLog`)

## Rules
- Only events that are in the future, have a valid date, and have NOT been attended get scored.
- **Preferred Tag Bonus**: +2 points if the event matches the user's preferred tag.
- **Attended Overlap Bonus**: +1 point for each tag it shares with past attended events (capped at +2 max). A tag that earned the preferred bonus does not count twice.
- Planned and cancelled events add 0 points.
- **Threshold**: An event needs at least 1 point to be suggested.
- **Tie-Breaker**: The sooner event wins; if dates are equal, lowest `Event.id` wins.

## Baseline Comparison
Upcoming events with the preferred tag, sorted strictly by `Event.id`.

## Evaluation Test Cases (5 Cases)
1. **Typical**: A few events in catalog; one matches preferred tag and an attended tag (Score = 3 or 4).
2. **Boundary**: Score of 1 vs 0 (event with 0 points omitted from suggestions).
3. **No Data**: Empty catalog or zero matches -> shows "Not enough data yet".
4. **Invalid**: Past events or corrupted date strings are omitted with reason logged.
5. **Override**: Tied scores; user dismisses top pick and helper displays runner-up.