Festival Pocket

A Flutter app for keeping track of festivals and events you want to go to. Save an event, tag it (Music, Tech, Art, Sports, Food), plan it, mark it attended, and leave yourself a short note.

Project One for Mobile App Development. Marquez Johnson built S1, S2, S3 and the event store. Oluchi Chukwurah built S4 and S5.

Where things stand

All five screens and the bottom navigation work. Events are kept in memory (lib/data/event_store.dart), so nothing is saved when the app closes or the page reloads.

Not built yet:

SQLite: sqflite isn't in pubspec.yaml. We could only run the app in Chrome, and sqflite doesn't run on web, so all data sits behind EventStore until we can test on an emulator or macOS.
Saved settings: shared_preferences isn't in pubspec.yaml. Settings work on screen but aren't stored or used by other screens.
Pocket Picks scoring: the History card shows sample text. The rules are in AI_Related/AI_Feature.md but aren't coded, and there is no Override button yet.
Run it

Needs Flutter with Dart 3.13.4 or newer. We have only tested on Chrome.

bash
git clone https://github.com/Oluchi817/Project-One-MAD-.git
cd Project-One-MAD-
flutter pub get
flutter run -d chrome

The first Chrome launch can take about a minute. Run flutter doctor if something is missing.

Using the app
Catalog: tap Add Event (title 2 to 60 characters, a date, capacity 1 to 500). Tap a tag chip to filter, and tap it again to clear.
Event ticket: tap a card. The main button goes Start Plan, then Mark Attended, then Edit Reflection. Long-press the ticket for the same shortcut. Edit and delete (with confirmation) are in the top bar.
History: shows attended events with a delete button, plus the Pocket Picks card.
Settings: a preferred tag and a default group size from 1 to 20. Group size is how many people you usually go with, and capacity is the size of one event.
Folder layout
lib/
  main.dart                     app entry, theme, bottom nav
  models/event.dart             Event class and tags
  data/event_store.dart         in-memory event storage
  UI_screens/                   s1 to s5 screens
test/widget_test.dart           2 widget tests
docs/design/                    wireframes, nav_map.png, screens.md
AI_Related/                     AI_Feature.md and Ai_Use_Log.md
Tests
bash
flutter test

Two widget tests: the app opens on the empty Catalog, and saving an empty form shows the validation errors.

Troubleshooting
Old app or the counter demo shows in Chrome: run flutter clean, then flutter pub get, then flutter run -d chrome --web-port=5050.
Events disappeared: expected for now, since data isn't saved yet.
Still stuck: flutter doctor -v.
