import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:studyflow/app.dart';

void main() {
  testWidgets('Welcome screen shows the app name and actions', (tester) async {
    await tester.pumpWidget(const StudyFlowApp());

    expect(find.text('StudyFlow'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
  });

  testWidgets('Login shows inline errors for empty fields', (tester) async {
    await tester.pumpWidget(const StudyFlowApp());
    await tester.tap(find.text('Log in'));
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(ElevatedButton, 'Log in'));
    await tester.pump();

    expect(find.text('Email is required'), findsOneWidget);
    expect(find.text('Password is required'), findsOneWidget);
  });
}
