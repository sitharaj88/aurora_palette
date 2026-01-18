import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurora_palette/aurora_palette.dart';

void main() {
  testWidgets('Aurora Palette example app loads', (WidgetTester tester) async {
    // Build our app with a MaterialApp wrapper
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CosmicColorPicker(
            controller: CosmicColorController(initialColor: Colors.cyan),
          ),
        ),
      ),
    );

    // Pump frames for animations
    await tester.pump();

    // Verify the color picker is rendered
    expect(find.byType(CosmicColorPicker), findsOneWidget);
  });
}
