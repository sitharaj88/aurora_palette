import 'package:flutter/material.dart';
import '../atoms/neon_handle.dart';

/// A slider for selecting alpha/opacity values with a checkered background.
class AlphaSlider extends StatelessWidget {
  final double alpha;
  final Color color;
  final ValueChanged<double> onChanged;
  final double handleSize;

  const AlphaSlider({
    super.key,
    required this.alpha,
    required this.color,
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
        final double handleX = alpha * effectiveWidth + handleRadius;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) => _handleTouch(details.localPosition, width),
          onPanUpdate: (details) => _handleTouch(details.localPosition, width),
          onPanDown: (details) => _handleTouch(details.localPosition, width),
          child: Semantics(
            label:
                'Alpha slider, current value ${(alpha * 100).round()} percent',
            slider: true,
            value: '${(alpha * 100).round()}%',
            child: SizedBox(
              height: 48,
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  // Checkered background with padding for handle
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: handleRadius),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: SizedBox(
                        height: 12,
                        child: CustomPaint(
                          painter: _CheckeredPainter(),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              gradient: LinearGradient(
                                colors: [
                                  color.withValues(alpha: 0),
                                  color.withValues(alpha: 1),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Handle
                  Positioned(
                    left: handleX - handleRadius,
                    child: NeonHandle(color: color, size: handleSize),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleTouch(Offset localPosition, double totalWidth) {
    final double handleRadius = handleSize / 2;
    final double effectiveWidth = totalWidth - handleSize;
    final double a = ((localPosition.dx - handleRadius) / effectiveWidth).clamp(
      0.0,
      1.0,
    );
    onChanged(a);
  }
}

class _CheckeredPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const int gridSize = 6;
    final paint1 = Paint()..color = Colors.grey.shade300;
    final paint2 = Paint()..color = Colors.grey.shade100;

    for (int x = 0; x < size.width / gridSize; x++) {
      for (int y = 0; y < size.height / gridSize; y++) {
        final paint = (x + y) % 2 == 0 ? paint1 : paint2;
        canvas.drawRect(
          Rect.fromLTWH(
            x * gridSize.toDouble(),
            y * gridSize.toDouble(),
            gridSize.toDouble(),
            gridSize.toDouble(),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
