import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../lib/screens/student/student_navigation_screen.dart';

void main() {
  group('StudentNavigationScreen Widget Tests', () {
    testWidgets('displays all four navigation destinations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StudentNavigationScreen(
            testScreens: const [
              Center(child: Text('Home Test Screen')),
              Center(child: Text('Submit Test Screen')),
              Center(child: Text('Reports Test Screen')),
              Center(child: Text('Profile Test Screen')),
            ],
          ),
        ),
      );

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
      expect(find.text('My Reports'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);

      expect(find.text('Home Test Screen'), findsOneWidget);
    });

    testWidgets('switches between navigation tabs', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: StudentNavigationScreen(
            testScreens: const [
              Center(child: Text('Home Test Screen')),
              Center(child: Text('Submit Test Screen')),
              Center(child: Text('Reports Test Screen')),
              Center(child: Text('Profile Test Screen')),
            ],
          ),
        ),
      );

      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      expect(find.text('Submit Test Screen'), findsOneWidget);

      await tester.tap(find.text('My Reports'));
      await tester.pumpAndSettle();

      expect(find.text('Reports Test Screen'), findsOneWidget);

      await tester.tap(find.text('Profile'));
      await tester.pumpAndSettle();

      expect(find.text('Profile Test Screen'), findsOneWidget);
    });
  });
}
