import 'package:auto_tech/widgets/stateless/Loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget testableWidget(Widget child) => MaterialApp(home: child);

  testWidgets('Loading widget - Expects one Text and one Loading', (WidgetTester tester) async {

    final widget = testableWidget(Loading(text: 'Your car helper'));

    await tester.pumpWidget(widget);

    final finder = find.text('Your car helper');
    final widgetFinder = find.byWidget(widget);

    expect(finder, findsOneWidget);
    expect(widgetFinder, findsOneWidget);
  });
}
