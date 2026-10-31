import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:facebook_task_flutter/main.dart';

void main() {
  testWidgets('renders feed and switches navigation tabs', (tester) async {
    await tester.pumpWidget(const FacebookTaskApp());
    expect(find.text('facebook'), findsOneWidget);
    expect(find.text("What's on your mind?"), findsOneWidget);
    await tester.tap(find.byTooltip('Friends'));
    await tester.pumpAndSettle();
    expect(find.text('People you may know'), findsOneWidget);
    await tester.tap(find.byTooltip('Notifications'));
    await tester.pumpAndSettle();
    expect(find.text('Mark all as read'), findsOneWidget);
  });

  testWidgets('creates a post from the composer', (tester) async {
    await tester.pumpWidget(const FacebookTaskApp());
    await tester.tap(find.text("What's on your mind?"));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField).first, 'New Flutter post');
    await tester.pump();
    await tester.tap(find.text('POST'));
    await tester.pumpAndSettle();
    expect(find.text('New Flutter post'), findsOneWidget);
  });
}
