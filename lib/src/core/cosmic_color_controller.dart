import 'package:flutter/material.dart';
import '../utils/color_utils.dart';

/// Main controller for managing the color state in the picker.
/// Supports HSV color model with alpha channel.
class CosmicColorController extends ChangeNotifier {
  late HSVColor _hsvColor;
  double _alpha = 1.0;
  final List<Color> _recentColors = [];
  static const int _maxRecentColors = 10;

  CosmicColorController({Color initialColor = Colors.blue}) {
    _hsvColor = HSVColor.fromColor(initialColor);
    _alpha = initialColor.a;
  }

  HSVColor get hsvColor => _hsvColor;
  Color get color => _hsvColor.toColor().withValues(alpha: _alpha);
  double get alpha => _alpha;
  List<Color> get recentColors => List.unmodifiable(_recentColors);

  void updateHSV({double? h, double? s, double? v}) {
    _hsvColor = HSVColor.fromAHSV(
      1.0,
      h ?? _hsvColor.hue,
      s ?? _hsvColor.saturation,
      v ?? _hsvColor.value,
    );
    notifyListeners();
  }

  void updateAlpha(double alpha) {
    _alpha = alpha.clamp(0.0, 1.0);
    notifyListeners();
  }

  void updateColor(Color newColor) {
    _hsvColor = HSVColor.fromColor(newColor);
    _alpha = newColor.a;
    notifyListeners();
  }

  /// Call this when the user confirms/selects the current color.
  void confirmColor() {
    final currentColor = color;
    // Remove if already exists to avoid duplicates
    _recentColors.remove(currentColor);
    // Add to the front
    _recentColors.insert(0, currentColor);
    // Trim to max size
    if (_recentColors.length > _maxRecentColors) {
      _recentColors.removeLast();
    }
    notifyListeners();
  }

  String get hexCode =>
      ColorUtils.colorToHex(color, includeAlpha: _alpha < 1.0);

  int get red => ColorUtils.getRed(color);
  int get green => ColorUtils.getGreen(color);
  int get blue => ColorUtils.getBlue(color);
}
