import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:aurora_palette/aurora_palette.dart';

void main() {
  group('ColorUtils Tests', () {
    test('colorToHex converts color correctly', () {
      const color = Color(0xFFFF0000); // Red
      expect(ColorUtils.colorToHex(color), '#FF0000');
    });

    test('hexToColor parses hex correctly', () {
      final red = ColorUtils.hexToColor('#FF0000');
      final green = ColorUtils.hexToColor('00FF00');

      expect(red, isNotNull);
      expect(ColorUtils.getRed(red!), 255);
      expect(ColorUtils.getGreen(red), 0);
      expect(ColorUtils.getBlue(red), 0);

      expect(green, isNotNull);
      expect(ColorUtils.getRed(green!), 0);
      expect(ColorUtils.getGreen(green), 255);
      expect(ColorUtils.getBlue(green), 0);
    });

    test('rgbToHsv and hsvToColor are inverse', () {
      const color = Colors.blue;
      final hsv = ColorUtils.rgbToHsv(color);
      final resultColor = ColorUtils.hsvToColor(hsv[0], hsv[1], hsv[2]);

      expect(ColorUtils.getRed(resultColor), ColorUtils.getRed(color));
      expect(ColorUtils.getGreen(resultColor), ColorUtils.getGreen(color));
      expect(ColorUtils.getBlue(resultColor), ColorUtils.getBlue(color));
    });

    test('getRed, getGreen, getBlue return correct values', () {
      const color = Color(0xFFAABBCC);
      expect(ColorUtils.getRed(color), 0xAA);
      expect(ColorUtils.getGreen(color), 0xBB);
      expect(ColorUtils.getBlue(color), 0xCC);
    });
  });

  group('CosmicColorController Tests', () {
    test('initializes with default color', () {
      final controller = CosmicColorController();
      expect(controller.color, isNotNull);
    });

    test('initializes with custom color', () {
      final controller = CosmicColorController(initialColor: Colors.red);
      expect(ColorUtils.getRed(controller.color), closeTo(255, 15));
    });

    test('updateHSV updates hue', () {
      final controller = CosmicColorController(initialColor: Colors.blue);
      controller.updateHSV(h: 0); // Set to red hue
      expect(controller.hsvColor.hue, 0);
    });

    test('updateAlpha updates alpha', () {
      final controller = CosmicColorController();
      controller.updateAlpha(0.5);
      expect(controller.alpha, 0.5);
    });

    test('confirmColor adds to recent colors', () {
      final controller = CosmicColorController(initialColor: Colors.blue);
      expect(controller.recentColors.isEmpty, true);
      controller.confirmColor();
      expect(controller.recentColors.length, 1);
    });
  });

  group('ColorHarmony Tests', () {
    test('complementary returns opposite color', () {
      const red = Color(0xFFFF0000);
      final complement = ColorHarmony.complementary(red);
      final hsv = HSVColor.fromColor(complement);
      // Complement of red (hue 0) should be cyan (hue 180)
      expect(hsv.hue, closeTo(180, 5));
    });

    test('triadic returns 3 colors', () {
      const blue = Colors.blue;
      final triadic = ColorHarmony.triadic(blue);
      expect(triadic.length, 3);
    });

    test('analogous returns 3 colors', () {
      const green = Colors.green;
      final analogous = ColorHarmony.analogous(green);
      expect(analogous.length, 3);
    });
  });

  group('ColorTemperature Tests', () {
    test('isWarm detects warm colors', () {
      expect(ColorTemperature.isWarm(Colors.red), true);
      expect(ColorTemperature.isWarm(Colors.orange), true);
      expect(ColorTemperature.isWarm(Colors.yellow), true);
    });

    test('isCool detects cool colors', () {
      expect(ColorTemperature.isCool(Colors.blue), true);
      expect(ColorTemperature.isCool(Colors.green), true);
      expect(ColorTemperature.isCool(Colors.cyan), true);
    });

    test('getColorName returns approximate name', () {
      expect(ColorTemperature.getColorName(Colors.red), 'Red');
      // Colors.blue has a hue around 218°, which is Sky Blue in our algorithm
      expect(ColorTemperature.getColorName(const Color(0xFF0000FF)), 'Blue');
      expect(ColorTemperature.getColorName(Colors.green), 'Green');
    });

    test('getContrastingTextColor works correctly', () {
      expect(
        ColorTemperature.getContrastingTextColor(Colors.white),
        Colors.black,
      );
      expect(
        ColorTemperature.getContrastingTextColor(Colors.black),
        Colors.white,
      );
    });
  });
}
