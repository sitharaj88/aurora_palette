import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/cosmic_design.dart';
import '../../utils/color_harmony.dart';
import '../../utils/color_utils.dart';
import 'cosmic_glass_container.dart';

/// A beautiful card showing detailed color information.
class ColorInfoCard extends StatelessWidget {
  /// The color to analyze and display information for.
  final Color color;

  /// Callback when the hex code is successfully copied to the clipboard.
  final VoidCallback? onCopyHex;

  const ColorInfoCard({super.key, required this.color, this.onCopyHex});

  @override
  Widget build(BuildContext context) {
    final hexCode = ColorUtils.colorToHex(color);
    final colorName = ColorTemperature.getColorName(color);
    final temperature = ColorTemperature.getTemperatureLabel(color);
    final brightness = ColorTemperature.getBrightnessLabel(color);
    final textColor = ColorTemperature.getContrastingTextColor(color);

    return CosmicGlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Color name and preview
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: CosmicDesign.neonGlow(color),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Center(
                  child: Icon(
                    ColorTemperature.isWarm(color)
                        ? Icons.wb_sunny
                        : Icons.ac_unit,
                    color: textColor,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      colorName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        _buildTag(
                          temperature,
                          ColorTemperature.isWarm(color)
                              ? Colors.orange
                              : Colors.lightBlue,
                        ),
                        _buildTag(
                          brightness,
                          Colors.white.withValues(alpha: 0.3),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Hex code with copy button
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: hexCode));
              onCopyHex?.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    hexCode,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'monospace',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const Icon(Icons.copy, color: Colors.white54, size: 18),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // RGB values
          LayoutBuilder(
            builder: (context, constraints) {
              // If space is tight, use smaller font or stacking?
              // For now, Expanded widgets in a Row should distribute space.
              return Row(
                children: [
                  Expanded(
                    child: _buildColorValue(
                      'R',
                      ColorUtils.getRed(color),
                      CosmicDesign.neonPink,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildColorValue(
                      'G',
                      ColorUtils.getGreen(color),
                      Colors.greenAccent,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildColorValue(
                      'B',
                      ColorUtils.getBlue(color),
                      CosmicDesign.neonCyan,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildColorValue(String label, int value, Color accent) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: accent,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
