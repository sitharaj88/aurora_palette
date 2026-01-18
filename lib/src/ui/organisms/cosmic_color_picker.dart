import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/cosmic_color_controller.dart';
import '../../theme/cosmic_design.dart';
import '../molecules/alpha_slider.dart';
import '../molecules/color_input_field.dart';
import '../molecules/cosmic_glass_container.dart';
import '../molecules/neon_color_area.dart';
import '../molecules/recent_colors_bar.dart';
import '../molecules/rgb_input_fields.dart';
import '../molecules/spectrum_slider.dart';

/// The main color picker widget with all features.
class CosmicColorPicker extends StatefulWidget {
  final CosmicColorController controller;
  final bool showHex;
  final bool showRgb;
  final bool showAlpha;
  final bool showRecentColors;
  final bool enableHaptics;
  final VoidCallback? onColorConfirmed;

  const CosmicColorPicker({
    super.key,
    required this.controller,
    this.showHex = true,
    this.showRgb = false,
    this.showAlpha = true,
    this.showRecentColors = true,
    this.enableHaptics = true,
    this.onColorConfirmed,
  });

  @override
  State<CosmicColorPicker> createState() => _CosmicColorPickerState();
}

class _CosmicColorPickerState extends State<CosmicColorPicker> {
  void _triggerHaptic() {
    if (widget.enableHaptics) {
      HapticFeedback.selectionClick();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final color = widget.controller.color;
        final hsv = widget.controller.hsvColor;

        return Focus(
          autofocus: true,
          onKeyEvent: (node, event) => _handleKeyEvent(event),
          child: CosmicGlassContainer(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Color Area
                Semantics(
                  label: 'Color saturation and brightness selector',
                  child: AspectRatio(
                    aspectRatio: 1.5,
                    child: NeonColorArea(
                      hsvColor: hsv,
                      onChanged: (newHsv) {
                        _triggerHaptic();
                        widget.controller.updateHSV(
                          h: newHsv.hue,
                          s: newHsv.saturation,
                          v: newHsv.value,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Hue Slider
                Semantics(
                  label: 'Hue slider, current hue ${hsv.hue.round()} degrees',
                  child: SpectrumSlider(
                    hue: hsv.hue,
                    onChanged: (hue) {
                      _triggerHaptic();
                      widget.controller.updateHSV(h: hue);
                    },
                  ),
                ),

                // Alpha Slider
                if (widget.showAlpha) ...[
                  const SizedBox(height: 16),
                  AlphaSlider(
                    alpha: widget.controller.alpha,
                    color: hsv.toColor(),
                    onChanged: (alpha) {
                      _triggerHaptic();
                      widget.controller.updateAlpha(alpha);
                    },
                  ),
                ],

                const SizedBox(height: 20),

                // Footer: Preview + Inputs
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Color Preview
                    Semantics(
                      label: 'Selected color preview',
                      child: GestureDetector(
                        onTap: () {
                          widget.controller.confirmColor();
                          widget.onColorConfirmed?.call();
                        },
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            boxShadow: CosmicDesign.neonGlow(color),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),

                    // Hex Input
                    if (widget.showHex)
                      Expanded(
                        child: ColorInputField(
                          hexCode: widget.controller.hexCode,
                          onColorChanged: (newColor) {
                            if (newColor != null) {
                              widget.controller.updateColor(newColor);
                            }
                          },
                        ),
                      ),
                  ],
                ),

                // RGB Inputs
                if (widget.showRgb) ...[
                  const SizedBox(height: 16),
                  RgbInputFields(
                    color: color,
                    onColorChanged: widget.controller.updateColor,
                  ),
                ],

                // Recent Colors
                if (widget.showRecentColors &&
                    widget.controller.recentColors.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  const Text(
                    'RECENT COLORS',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  RecentColorsBar(
                    colors: widget.controller.recentColors,
                    onColorSelected: widget.controller.updateColor,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  KeyEventResult _handleKeyEvent(KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    const double hueStep = 5.0;
    const double satValStep = 0.05;

    final hsv = widget.controller.hsvColor;

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowLeft:
        widget.controller.updateHSV(
          s: (hsv.saturation - satValStep).clamp(0.0, 1.0),
        );
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        widget.controller.updateHSV(
          s: (hsv.saturation + satValStep).clamp(0.0, 1.0),
        );
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowUp:
        widget.controller.updateHSV(
          v: (hsv.value + satValStep).clamp(0.0, 1.0),
        );
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowDown:
        widget.controller.updateHSV(
          v: (hsv.value - satValStep).clamp(0.0, 1.0),
        );
        return KeyEventResult.handled;
      case LogicalKeyboardKey.bracketLeft:
        widget.controller.updateHSV(h: (hsv.hue - hueStep) % 360);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.bracketRight:
        widget.controller.updateHSV(h: (hsv.hue + hueStep) % 360);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.enter:
        widget.controller.confirmColor();
        widget.onColorConfirmed?.call();
        return KeyEventResult.handled;
      default:
        return KeyEventResult.ignored;
    }
  }
}
