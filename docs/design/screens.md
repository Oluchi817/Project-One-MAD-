#Screen Annotations & Wireframes for Festival Pocket

#System Navigation Map is nav_map

#S1: Catalog/ Dashboard (Marquez J)


**Purpose**: This is the home dashboard where a user can browse saved events, filter by interest tag, and see how many total events they've attached.

**Entry**: The papp opens directly on this screen on startup, or you tap the "Catalog" tab on the bottom bar

##Primary Act**: Fill out the fields and tap "Save event" or tap "Delete event: if editing.

**Data**: Save title, date, tag, venue note, and capacity to the SQLite events table; deleting cascades to remove attendance logs too.

**States**:
- Default: Shows the cards of saved events with their tags and status badges.

- Empty: Shows "No events yet. Add your first event." or "No events match this tag. Clear filter." if a filter has zero results.

- Loading: Spinner while the app pulls events from the local database.

- Error: Error alert if reading SQLite fails.

- Success: Event list displays cleanly and the attended counter updates.


#S2: Create/ Edit Event (Marquez J)

**Purpose**: A single form where you can either add a brand-new event or fix/edit an existing one.

**Entry**: Tap "+ Add event" from the catalog (S1), or tap "Edit" while looking at an event detail (S3).

**Primary Act**: Fill out the fields and tap "Save event", or tap "Delete event" if editing.

**Data**: Saves title, date, tag, venue note, and capacity to the SQLite events table; deleting cascades to remove attendance logs too.

**States**:
- Default: Empty form for new events, or pre-filled inputs if you're editing.

- Empty: Blank input fields ready for typing.

- Loading: Save button disables briefly while writing so you can't double-tap.

- Error: Inline error text if title isn't 2 to 60 characters, or if capacity isn't a number from 1 to 500.

- Success: Returns back to S1 or S3 with the saved changes.

#S3: Event Detail/Activity (Marquez J)

**Purpose**: The main interactive screen shaped like a ticket card where you plan your event, mark it attended, and jot down notes.

**Entry**: Tapping any event card from S1 or S4.

**Primary Act**: Tap the main action button (moves through Start plan -> Mark attended -> Edit reflection), or long-press the ticket as a shortcut.

**Data**: Updates the attendance status and personal reflection note in the attendance_records SQLite table.

**States**:
- Default: Ticket card showing title, date, location note, and current status chip.

- Empty: N/A (always loads with a selected event).

- Loading: Quick pause while updating status in the database.

- Error: Pops a confirmation dialog before cancelling or deleting so you don't lose data by accident.

- Success: Shows an "ATTENDED" stamp on the ticket once completed.

#S4: History / Insights (Oluchi C)

**Purpose**: A personal attendance notebook to review past events, see filtered history logs, and get a "Pocket Pick" suggestion.

**Entry**: Tap the "History" tab on the bottom bar, or tap the history link from S3.

**Primary Act**: Filter logs by status or date range, edit/delete past records, or apply the Pocket Pick recommendation.

**Data**: Reads logs from SQLite and runs the rule-based helper (+2 for preferred tag, +1 for matching attended tags).

**States**:
- Default: Shows past logged events plus the Pocket Picks suggestion card.

- Empty: Shows "No attendance records yet" or "Not enough data yet" for the helper.

- Loading: Spinner while loading records and calculating scores.

- Error: Message if date filter produces no results.

- Success: Displays correct counts and ranks upcoming events.

#S5: Settings (Oluchi C)

**Purpose**: Saves your preferred event category tag and default group size on your device.

**Entry**: Tap the "Settings" tab on the bottom bar.

**Primary Act**: Pick your favorite tag chips, move the group size slider (1 to 20), or tap "Reset to defaults".

**Data**: Saves key-value settings directly to SharedPreferences so they persist offline and after a restart.

**States**:
- Default: Displays your saved tag choice and group size.

- Empty: Falls back to default values (All tags, group size 4) if nothing is saved.

- Loading: Quick async write to storage.

- Error: Shows "Could not save settings. Try again." if saving fails.

- Success: Shows "Saved on this device" confirmation.