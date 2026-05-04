// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ✅ 'myapp' को हटाकर सीधा आपकी main.dart का पाथ दे दिया गया है
import 'package:codenetra_ai/main.dart'; 

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CodeNetraApp());

    // Verify that the app renders something.
    // This is a basic test to ensure the widget tree builds without errors.
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}