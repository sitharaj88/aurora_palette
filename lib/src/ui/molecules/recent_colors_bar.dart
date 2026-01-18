import 'package:flutter/material.dart';
import '../../theme/cosmic_design.dart';

/// A bar displaying recently selected colors with animated entry.
class RecentColorsBar extends StatelessWidget {
  final List<Color> colors;
  final ValueChanged<Color> onColorSelected;
  final int maxColors;

  const RecentColorsBar({
    super.key,
    required this.colors,
    required this.onColorSelected,
    this.maxColors = 8,
  });

  @override
  Widget build(BuildContext context) {
    final displayColors = colors.take(maxColors).toList();

    return Semantics(
      label: 'Recent colors, ${displayColors.length} colors available',
      child: SizedBox(
        height: 40,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: displayColors.length,
          separatorBuilder: (context, index) => const SizedBox(width: 8),
          itemBuilder: (context, index) {
            final color = displayColors[index];
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 200 + (index * 50)),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(scale: value, child: child);
              },
              child: Semantics(
                label: 'Select color',
                button: true,
                child: GestureDetector(
                  onTap: () => onColorSelected(color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: CosmicDesign.neonGlow(color),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
