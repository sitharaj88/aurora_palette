import 'package:flutter/material.dart';
import '../atoms/neon_handle.dart';

class SpectrumSlider extends StatelessWidget {
  final double hue;
  final ValueChanged<double> onChanged;
  final double handleSize;

  const SpectrumSlider({
    super.key,
    required this.hue,
    required this.onChanged,
    this.handleSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final double handleRadius = handleSize / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double effectiveWidth = width - handleSize;

        // Calculate handle position with edge padding
        final double handleX = (hue / 360) * effectiveWidth + handleRadius;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) => _handleTouch(details.localPosition, width),
          onPanUpdate: (details) => _handleTouch(details.localPosition, width),
          onPanDown: (details) => _handleTouch(details.localPosition, width),
          child: SizedBox(
            height: 48,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                // Track with padding for handle
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: handleRadius),
                  child: Container(
                    height: 12,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFF0000),
                          Color(0xFFFFFF00),
                          Color(0xFF00FF00),
                          Color(0xFF00FFFF),
                          Color(0xFF0000FF),
                          Color(0xFFFF00FF),
                          Color(0xFFFF0000),
                        ],
                      ),
                    ),
                  ),
                ),
                // Handle
                Positioned(
                  left: handleX - handleRadius,
                  child: NeonHandle(
                    color: HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor(),
                    size: handleSize,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleTouch(Offset localPosition, double totalWidth) {
    final double handleRadius = handleSize / 2;
    final double effectiveWidth = totalWidth - handleSize;
    final double h =
        ((localPosition.dx - handleRadius) / effectiveWidth).clamp(0.0, 1.0) *
        360;
    onChanged(h);
  }
}
