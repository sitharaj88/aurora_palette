import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/cosmic_color_controller.dart';
import '../../theme/cosmic_design.dart';
import '../molecules/cosmic_glass_container.dart';
import '../molecules/neon_color_area.dart';
import '../molecules/spectrum_slider.dart';
import '../molecules/alpha_slider.dart';
import '../molecules/color_input_field.dart';

/// An adaptive color picker that adjusts its layout based on screen size and platform.
class AdaptiveColorPicker extends StatelessWidget {
  /// The controller that manages the color state and history.
  final CosmicColorController controller;

  /// Whether to show the alpha/opacity slider.
  final bool showAlpha;

  /// Whether to show the hex color input field.
  final bool showHex;

  /// Callback when the user confirms the color selection.
  final VoidCallback? onColorConfirmed;

  const AdaptiveColorPicker({
    super.key,
    required this.controller,
    this.showAlpha = true,
    this.showHex = true,
    this.onColorConfirmed,
  });

  bool get _isDesktop {
    if (kIsWeb) return false;
    return Platform.isMacOS || Platform.isWindows || Platform.isLinux;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;

        return ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            final hsv = controller.hsvColor;
            final color = controller.color;

            if (isWide && _isDesktop) {
              // Desktop/Wide Layout: Side-by-side
              return CosmicGlassContainer(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: Color Area
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AspectRatio(
                            aspectRatio: 1.2,
                            child: NeonColorArea(
                              hsvColor: hsv,
                              onChanged: (newHsv) => controller.updateHSV(
                                h: newHsv.hue,
                                s: newHsv.saturation,
                                v: newHsv.value,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SpectrumSlider(
                            hue: hsv.hue,
                            onChanged: (hue) => controller.updateHSV(h: hue),
                          ),
                          if (showAlpha) ...[
                            const SizedBox(height: 12),
                            AlphaSlider(
                              alpha: controller.alpha,
                              color: hsv.toColor(),
                              onChanged: controller.updateAlpha,
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Right: Preview & Inputs
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Large Preview
                          GestureDetector(
                            onTap: () {
                              controller.confirmColor();
                              onColorConfirmed?.call();
                            },
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                boxShadow: CosmicDesign.neonGlow(color),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (showHex)
                            ColorInputField(
                              hexCode: controller.hexCode,
                              onColorChanged: (c) {
                                if (c != null) controller.updateColor(c);
                              },
                            ),
                          const SizedBox(height: 16),
                          _buildInfoRow('HUE', '${hsv.hue.round()}°'),
                          _buildInfoRow(
                            'SAT',
                            '${(hsv.saturation * 100).round()}%',
                          ),
                          _buildInfoRow('VAL', '${(hsv.value * 100).round()}%'),
                          if (showAlpha)
                            _buildInfoRow(
                              'ALPHA',
                              '${(controller.alpha * 100).round()}%',
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              // Mobile/Compact Layout: Vertical Stack
              return CosmicGlassContainer(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 180,
                      child: NeonColorArea(
                        hsvColor: hsv,
                        onChanged: (newHsv) => controller.updateHSV(
                          h: newHsv.hue,
                          s: newHsv.saturation,
                          v: newHsv.value,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SpectrumSlider(
                      hue: hsv.hue,
                      onChanged: (hue) => controller.updateHSV(h: hue),
                    ),
                    if (showAlpha) ...[
                      const SizedBox(height: 12),
                      AlphaSlider(
                        alpha: controller.alpha,
                        color: hsv.toColor(),
                        onChanged: controller.updateAlpha,
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.confirmColor();
                            onColorConfirmed?.call();
                          },
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              boxShadow: CosmicDesign.neonGlow(color),
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (showHex)
                          Expanded(
                            child: ColorInputField(
                              hexCode: controller.hexCode,
                              onColorChanged: (c) {
                                if (c != null) controller.updateColor(c);
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
