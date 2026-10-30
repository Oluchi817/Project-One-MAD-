import 'package:flutter_test/flutter_test.dart';

import 'package:festival_pocket/main.dart';

void main() {
  testWidgets('App opens on the empty catalog', (WidgetTester tester) async {
    await tester.pumpWidget(const FestivalPocketApp());

    expect(find.text('Festival Pocket'), findsOneWidget);
    expect(find.text('No events yet. Add your first event.'), findsOneWidget);
    expect(find.text('Add Event'), findsOneWidget);
  });

  testWidgets('Saving an empty event form shows validation errors',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FestivalPocketApp());

    await tester.tap(find.text('Add Event'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Save Event'));
    await tester.pump();

    expect(find.text('Title must be 2 to 60 characters'), findsOneWidget);
    expect(find.text('Pick a date'), findsOneWidget);
    expect(find.text('Capacity must be a number from 1 to 500'), findsOneWidget);
  });
}