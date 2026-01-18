import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Internal utility functions for color conversion and component extraction.
class ColorUtils {
  /// Helper to get red component (0-255) from Color.
  static int getRed(Color color) => (color.r * 255.0).round().clamp(0, 255);

  /// Helper to get green component (0-255) from Color.
  static int getGreen(Color color) => (color.g * 255.0).round().clamp(0, 255);

  /// Helper to get blue component (0-255) from Color.
  static int getBlue(Color color) => (color.b * 255.0).round().clamp(0, 255);

  /// Helper to get alpha component (0-255) from Color.
  static int getAlpha(Color color) => (color.a * 255.0).round().clamp(0, 255);

  /// Converts a [Color] to a hex string (e.g., "#RRGGBB" or "#AARRGGBB").
  static String colorToHex(Color color, {bool includeAlpha = false}) {
    final r = getRed(color).toRadixString(16).padLeft(2, '0');
    final g = getGreen(color).toRadixString(16).padLeft(2, '0');
    final b = getBlue(color).toRadixString(16).padLeft(2, '0');
    if (includeAlpha) {
      final a = getAlpha(color).toRadixString(16).padLeft(2, '0');
      return '#$a$r$g$b'.toUpperCase();
    } else {
      return '#$r$g$b'.toUpperCase();
    }
  }

  /// Parses a hex string to a [Color].
  static Color? hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    if (hex.length != 8) return null;
    try {
      final a = int.parse(hex.substring(0, 2), radix: 16) / 255.0;
      final r = int.parse(hex.substring(2, 4), radix: 16) / 255.0;
      final g = int.parse(hex.substring(4, 6), radix: 16) / 255.0;
      final b = int.parse(hex.substring(6, 8), radix: 16) / 255.0;
      return Color.from(alpha: a, red: r, green: g, blue: b);
    } catch (_) {
      return null;
    }
  }

  /// Converts RGB to HSV values.
  /// Result is a list of [h (0-360), s (0-1), v (0-1)].
  static List<double> rgbToHsv(Color color) {
    final double r = color.r;
    final double g = color.g;
    final double b = color.b;

    final double max = math.max(r, math.max(g, b));
    final double min = math.min(r, math.min(g, b));
    final double delta = max - min;

    double h = 0.0;
    if (delta != 0) {
      if (max == r) {
        h = (g - b) / delta + (g < b ? 6 : 0);
      } else if (max == g) {
        h = (b - r) / delta + 2;
      } else {
        h = (r - g) / delta + 4;
      }
      h /= 6;
    }

    final double s = max == 0 ? 0 : delta / max;
    final double v = max;

    return [h * 360, s, v];
  }

  /// Converts HSV values to a [Color].
  static Color hsvToColor(double h, double s, double v, [double a = 1.0]) {
    return HSVColor.fromAHSV(
      a,
      h.clamp(0.0, 360.0),
      s.clamp(0.0, 1.0),
      v.clamp(0.0, 1.0),
    ).toColor();
  }
}
