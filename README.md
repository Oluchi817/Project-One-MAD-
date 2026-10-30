# festival_pocket

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


Festival Pocket is a Flutter app for keeping track of festivals and events you want to go to. You save an event, tag it (Music, Tech, Art, Sports, Food), mark it attended once you go, and leave yourself a short note about it. There's also a "Pocket Pick" card that suggests which upcoming event fits you best.

This is our Project One for Mobile App Development. Marquez Johnson built S1, S2, S3 and the Pocket Picks scoring logic. Oluchi Chukwurah built S4, S5 and the Pocket Picks card on the History screen.

Where things stand

Right now the repo is the UI side of the app. All five screens and the bottom navigation work and are themed, but the data layer isn't hooked up yet. The design docs plan for SQLite (events and attendance) and SharedPreferences (settings), but neither sqflite nor shared_preferences is in pubspec.yaml yet, so nothing is saved between runs. A few spots are still placeholders too, like the attended counter on S1, which is a TODO.

Still to do:

add sqflite and build the events and attendance_records tables
swap the placeholder data in S1 through S4 for real database reads and writes
add shared_preferences so settings stick after a restart
write the Pocket Picks scoring in plain Dart and connect it to the S4 card
write tests for the five Pocket Picks cases
replace the default widget test (see Tests below)
What you need
Flutter SDK with Dart 3.13.4 or newer (flutter --version will tell you)
Git
VS Code or Android Studio
Chrome if you want to run it on web
Xcode if you want macOS or iOS, or an Android emulator for Android

Run flutter doctor first and fix anything it complains about for the platform you're using.

Getting it running
bash
git clone https://github.com/Oluchi817/Project-One-MAD-.git
cd Project-One-MAD-
flutter pub get

After pub get you might see a message about packages having newer versions that don't fit our constraints. That's fine, you can ignore it.

Then pick where to run it:

bash
flutter run -d chrome
flutter run -d macos
flutter devices          # to see what else is available
flutter run -d <device-id>

The first Chrome launch is slow. Ours sat on "Waiting for connection from debug service on Chrome..." for close to a minute before anything showed up. Once it prints the list of key commands it's ready, and the app opens in its own Chrome window, which can end up behind your other windows. In that terminal, r hot reloads, R hot restarts and q quits.

Using the app

The app opens on the Catalog tab. Tap Add Event to make a new one. The title has to be 2 to 60 characters and capacity has to be a number from 1 to 500, otherwise you'll get an error under the field. Tap a tag chip on the Catalog screen to filter, and tap it again to clear the filter.

Tapping an event card opens its ticket. The main button on the ticket walks the event through Start plan, then Mark attended, then Edit reflection (long-pressing the ticket does the same thing as a shortcut). Once it's attended, the ticket gets an ATTENDED stamp. You can also edit or delete from there, and delete asks you to confirm first.

The History tab shows past events and the Pocket Picks card. The Settings tab lets you choose a preferred tag and a group size from 1 to 20, or reset everything to the defaults (all tags, group size 4).

How Pocket Picks works

It's a simple scoring helper that runs entirely on the device. It isn't a prediction and there's no cloud API or trained model behind it. It only looks at events that are in the future, have a valid date, and haven't been attended yet. Each one gets points:

+2 if it matches your preferred tag
+1 for each tag it shares with events you've attended before, up to +2 total (a tag that already got the preferred-tag bonus doesn't count again)

Planned and cancelled events add nothing. An event needs at least 1 point to be suggested. If two are tied, the sooner one wins, and if the dates match too, the lower event ID wins. On the card you can Apply the pick, hit Not now, or Override, and dismissing the top pick shows the runner-up. The full spec and our five test cases are in AI_Related/AI_Feature.md.

Folder layout
lib/
  main.dart                     app entry, theme, bottom nav
  UI_screens/
    s1_catalog_dash.dart        Catalog / dashboard
    s2_create_edit_event.dart   Create and edit form
    s3_event_detail.dart        Event ticket / detail
    s4_history_insights.dart    History and Pocket Picks card
    s5_settings.dart            Settings
test/widget_test.dart
docs/design/                    wireframes (S1 to S5), nav_map.png, screens.md
AI_Related/                     AI_Feature.md and Ai_Use_Log.md
android/ ios/ macos/ web/       platform folders

Catalog, History and Settings are the three tabs on the bottom bar. S2 and S3 are pushed on top: S1 goes to S2 to add an event, S1 or S4 goes to S3 for details, and S3 goes to S2 to edit. The nav map is at docs/design/nav_map.png.

Tests
bash
flutter analyze
flutter test

Heads up that flutter test won't compile yet. test/widget_test.dart is still the default counter test from when we created the project and it points at a MyApp class that doesn't exist anymore. It needs to be rewritten to load FestivalPocketApp before the tests will run.

If something goes wrong

You see the Flutter counter demo instead of our app. On web, Chrome can hold on to an old build through a service worker. Open DevTools, go to Application, then Service Workers and click Unregister, then clear the site data under Storage and hard refresh. Another option is to run it on a new port, which gives Chrome a fresh cache:

bash
flutter clean
flutter pub get
flutter run -d chrome --web-port=5050

It's also worth checking that main() in lib/main.dart calls runApp(const FestivalPocketApp()).

Weird build errors after switching branches. flutter clean && flutter pub get usually sorts it out.

Still stuck. flutter doctor -v shows what's missing for your platform.

More docs
docs/design/screens.md has the purpose, entry point, data and states for each screen
docs/design/nav_map.png is the navigation map
AI_Related/AI_Feature.md is the Pocket Picks spec
AI_Related/Ai_Use_Log.md is where we log which AI tools we used and for what