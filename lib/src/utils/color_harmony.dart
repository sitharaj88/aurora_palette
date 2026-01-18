import 'package:flutter/material.dart';

/// Types of color harmony relationships.
enum ColorHarmonyType {
  complementary,
  analogous,
  triadic,
  splitComplementary,
  tetradic,
  monochromatic,
}

/// Generates harmonious color palettes from a base color.
class ColorHarmony {
  /// Gets the complementary color (opposite on the color wheel).
  static Color complementary(Color color) {
    final hsv = HSVColor.fromColor(color);
    return HSVColor.fromAHSV(
      hsv.alpha,
      (hsv.hue + 180) % 360,
      hsv.saturation,
      hsv.value,
    ).toColor();
  }

  /// Gets analogous colors (adjacent on the color wheel).
  static List<Color> analogous(Color color, {double angle = 30}) {
    final hsv = HSVColor.fromColor(color);
    return [
      HSVColor.fromAHSV(
        hsv.alpha,
        (hsv.hue - angle) % 360,
        hsv.saturation,
        hsv.value,
      ).toColor(),
      color,
      HSVColor.fromAHSV(
        hsv.alpha,
        (hsv.hue + angle) % 360,
        hsv.saturation,
        hsv.value,
      ).toColor(),
    ];
  }

  /// Gets triadic colors (three evenly spaced colors).
  static List<Color> triadic(Color color) {
    final hsv = HSVColor.fromColor(color);
    return [
      color,
      HSVColor.fromAHSV(
        hsv.alpha,
        (hsv.hue + 120) % 360,
        hsv.saturation,
        hsv.value,
      ).toColor(),
      HSVColor.fromAHSV(
        hsv.alpha,
        (hsv.hue + 240) % 360,
        hsv.saturation,
        hsv.value,
      ).toColor(),
    ];
  }

  /// Gets split-complementary colors.
  static List<Color> splitComplementary(Color color, {double angle = 30}) {
    final hsv = HSVColor.fromColor(color);
    final complementHue = (hsv.hue + 180) % 360;
    return [
      color,
      HSVColor.fromAHSV(
        hsv.alpha,
        (complementHue - angle) % 360,
        hsv.saturation,
        hsv.value,
      ).toColor(),
      HSVColor.fromAHSV(
        hsv.alpha,
        (complementHue + angle) % 360,
        hsv.saturation,
        hsv.value,
      ).toColor(),
    ];
  }

  /// Gets tetradic colors (four colors forming a rectangle).
  static List<Color> tetradic(Color color) {
    final hsv = HSVColor.fromColor(color);
    return [
      color,
      HSVColor.fromAHSV(
        hsv.alpha,
        (hsv.hue + 90) % 360,
        hsv.saturation,
        hsv.value,
      ).toColor(),
      HSVColor.fromAHSV(
        hsv.alpha,
        (hsv.hue + 180) % 360,
        hsv.saturation,
        hsv.value,
      ).toColor(),
      HSVColor.fromAHSV(
        hsv.alpha,
        (hsv.hue + 270) % 360,
        hsv.saturation,
        hsv.value,
      ).toColor(),
    ];
  }

  /// Gets monochromatic variations (same hue, different saturation/value).
  static List<Color> monochromatic(Color color, {int count = 5}) {
    final hsv = HSVColor.fromColor(color);
    final List<Color> colors = [];
    for (int i = 0; i < count; i++) {
      final factor = (i + 1) / (count + 1);
      colors.add(
        HSVColor.fromAHSV(
          hsv.alpha,
          hsv.hue,
          hsv.saturation * factor + 0.2,
          0.3 + (0.7 * factor),
        ).toColor(),
      );
    }
    return colors;
  }

  /// Gets a full palette based on harmony type.
  static List<Color> getPalette(Color color, ColorHarmonyType type) {
    switch (type) {
      case ColorHarmonyType.complementary:
        return [color, complementary(color)];
      case ColorHarmonyType.analogous:
        return analogous(color);
      case ColorHarmonyType.triadic:
        return triadic(color);
      case ColorHarmonyType.splitComplementary:
        return splitComplementary(color);
      case ColorHarmonyType.tetradic:
        return tetradic(color);
      case ColorHarmonyType.monochromatic:
        return monochromatic(color);
    }
  }
}

/// Analyzes color temperature and characteristics.
class ColorTemperature {
  /// Determines if a color is warm (reds, oranges, yellows).
  static bool isWarm(Color color) {
    final hsv = HSVColor.fromColor(color);
    // Warm colors: 0-60° and 300-360° (reds, oranges, yellows, magentas)
    return hsv.hue <= 60 || hsv.hue >= 300;
  }

  /// Determines if a color is cool (blues, greens, purples).
  static bool isCool(Color color) => !isWarm(color);

  /// Gets the temperature description.
  static String getTemperatureLabel(Color color) {
    return isWarm(color) ? 'Warm' : 'Cool';
  }

  /// Calculates relative luminance (0-1).
  static double getLuminance(Color color) {
    return color.computeLuminance();
  }

  /// Gets a description of the color's brightness.
  static String getBrightnessLabel(Color color) {
    final luminance = getLuminance(color);
    if (luminance > 0.7) return 'Very Light';
    if (luminance > 0.5) return 'Light';
    if (luminance > 0.3) return 'Medium';
    if (luminance > 0.1) return 'Dark';
    return 'Very Dark';
  }

  /// Suggests whether to use dark or light text on this background.
  static Color getContrastingTextColor(Color background) {
    return getLuminance(background) > 0.5 ? Colors.black : Colors.white;
  }

  /// Gets the approximate color name.
  static String getColorName(Color color) {
    final hsv = HSVColor.fromColor(color);
    final hue = hsv.hue;
    final sat = hsv.saturation;
    final val = hsv.value;

    // Handle achromatic colors
    if (sat < 0.1) {
      if (val > 0.9) return 'White';
      if (val > 0.6) return 'Light Gray';
      if (val > 0.3) return 'Gray';
      if (val > 0.1) return 'Dark Gray';
      return 'Black';
    }

    // Chromatic colors
    if (hue < 15) return 'Red';
    if (hue < 45) return 'Orange';
    if (hue < 75) return 'Yellow';
    if (hue < 105) return 'Lime';
    if (hue < 135) return 'Green';
    if (hue < 165) return 'Teal';
    if (hue < 195) return 'Cyan';
    if (hue < 225) return 'Sky Blue';
    if (hue < 255) return 'Blue';
    if (hue < 285) return 'Purple';
    if (hue < 315) return 'Magenta';
    if (hue < 345) return 'Pink';
    return 'Red';
  }
}
