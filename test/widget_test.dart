// This is a basic Flutter widget test for FinEXTracker.
//
// The current test is a default counter example and does not reflect the actual
// functionality of FinEXTracker, which starts with a login screen (see main.dart).
// To test FinEXTracker, use the WidgetTester utility from flutter_test to interact
// with widgets like the login form. For example, you can simulate entering a
// username and password, tap the login button, and verify navigation to the
// Dashboard. Update this test to match the app's current behavior.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:js/main.dart';

void main() {
  testWidgets('Counter increments smoke test (outdated for FinEXTracker)', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0 (not applicable to FinEXTracker).
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame (not present in FinEXTracker).
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented (not applicable).
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}