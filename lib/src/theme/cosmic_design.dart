import 'package:flutter/material.dart';

/// Design tokens and styling constants for the Cosmic theme.
class CosmicDesign {
  /// Base background color for the picker.
  static const Color background = Color(0xFF0F0F1A);

  /// Surface color for interior components.
  static const Color surface = Color(0xFF1A1A2E);

  /// Translucent white surface for glassmorphism effects.
  static const Color glassSurface = Color(0x33FFFFFF);

  /// Bright cyan neon accent.
  static const Color neonCyan = Color(0xFF00F2FF);

  /// Deep purple neon accent.
  static const Color neonPurple = Color(0xFFBD00FF);

  /// Intense pink neon accent.
  static const Color neonPink = Color(0xFFFF00D6);

  /// Generates a neon-style glow shadow using the provided color.
  static List<BoxShadow> neonGlow(Color color) => [
    BoxShadow(
      color: color.withValues(alpha: 0.5),
      blurRadius: 12,
      spreadRadius: 2,
    ),
    BoxShadow(
      color: color.withValues(alpha: 0.2),
      blurRadius: 20,
      spreadRadius: 5,
    ),
  ];

  static const List<BoxShadow> glassShadow = [
    BoxShadow(color: Color(0x66000000), blurRadius: 16, offset: Offset(0, 8)),
  ];

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [neonPurple, neonPink],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Borders
  static final Border glassBorder = Border.all(
    color: Colors.white.withValues(alpha: 0.2),
    width: 1.5,
  );

  // Border Radius
  static const BorderRadius radiusM = BorderRadius.all(Radius.circular(16));
  static const BorderRadius radiusL = BorderRadius.all(Radius.circular(24));
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(999));
}
