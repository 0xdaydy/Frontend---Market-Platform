// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:market_connect/src/app.dart';
import 'package:market_connect/src/shared/wrappers/state_wrapper.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StateWrapper(child: App()));

    // Verify that the app starts.
    // In a real app, we would check for specific widgets like the login screen.
    expect(find.byType(App), findsOneWidget);
  });
}
