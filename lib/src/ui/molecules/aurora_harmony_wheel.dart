import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../theme/cosmic_design.dart';
import '../../utils/color_harmony.dart';

/// A beautiful aurora-animated color harmony display that adapts to available space.
class AuroraHarmonyWheel extends StatefulWidget {
  final Color baseColor;
  final ColorHarmonyType harmonyType;
  final ValueChanged<Color>? onColorSelected;

  /// Optional fixed size. If null, adapts to parent constraints.
  final double? size;

  const AuroraHarmonyWheel({
    super.key,
    required this.baseColor,
    this.harmonyType = ColorHarmonyType.triadic,
    this.onColorSelected,
    this.size,
  });

  @override
  State<AuroraHarmonyWheel> createState() => _AuroraHarmonyWheelState();
}

class _AuroraHarmonyWheelState extends State<AuroraHarmonyWheel>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = ColorHarmony.getPalette(
      widget.baseColor,
      widget.harmonyType,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use provided size, or calculate from constraints
        final availableSize = math.min(
          constraints.maxWidth,
          constraints.maxHeight,
        );
        final size =
            widget.size ?? (availableSize.isFinite ? availableSize : 200.0);

        // Scale dot sizes based on wheel size
        final dotSize = (size * 0.16).clamp(24.0, 40.0);
        final centerSize = (size * 0.3).clamp(40.0, 80.0);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              size: Size(size, size),
              painter: _AuroraWheelPainter(
                palette: palette,
                rotation: _controller.value * 2 * math.pi,
                baseColor: widget.baseColor,
              ),
              child: SizedBox(
                width: size,
                height: size,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Center color preview
                    Container(
                      width: centerSize,
                      height: centerSize,
                      decoration: BoxDecoration(
                        color: widget.baseColor,
                        shape: BoxShape.circle,
                        boxShadow: CosmicDesign.neonGlow(widget.baseColor),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                    // Harmony color dots
                    ...List.generate(palette.length, (index) {
                      final angle =
                          (index / palette.length) * 2 * math.pi - math.pi / 2;
                      final radius = size * 0.35;
                      final x = math.cos(angle) * radius;
                      final y = math.sin(angle) * radius;
                      final halfDot = dotSize / 2;

                      return Positioned(
                        left: size / 2 + x - halfDot,
                        top: size / 2 + y - halfDot,
                        child: GestureDetector(
                          onTap: () =>
                              widget.onColorSelected?.call(palette[index]),
                          child: TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 300 + index * 100),
                            curve: Curves.elasticOut,
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: child,
                              );
                            },
                            child: Container(
                              width: dotSize,
                              height: dotSize,
                              decoration: BoxDecoration(
                                color: palette[index],
                                shape: BoxShape.circle,
                                boxShadow: CosmicDesign.neonGlow(
                                  palette[index],
                                ),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class _AuroraWheelPainter extends CustomPainter {
  final List<Color> palette;
  final double rotation;
  final Color baseColor;

  _AuroraWheelPainter({
    required this.palette,
    required this.rotation,
    required this.baseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw aurora gradient rings
    for (int i = 0; i < 3; i++) {
      final ringRadius = radius * (0.7 + i * 0.1);
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..shader = SweepGradient(
          startAngle: rotation + i * 0.5,
          endAngle: rotation + i * 0.5 + math.pi * 2,
          colors: [
            ...palette.map((c) => c.withValues(alpha: 0.3)),
            palette.first.withValues(alpha: 0.3),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: ringRadius));

      canvas.drawCircle(center, ringRadius, paint);
    }

    // Draw connecting lines between harmony colors
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < palette.length; i++) {
      final angle1 = (i / palette.length) * 2 * math.pi - math.pi / 2;
      final angle2 =
          ((i + 1) % palette.length / palette.length) * 2 * math.pi -
          math.pi / 2;
      final r = size.width * 0.35;

      final p1 = Offset(
        center.dx + math.cos(angle1) * r,
        center.dy + math.sin(angle1) * r,
      );
      final p2 = Offset(
        center.dx + math.cos(angle2) * r,
        center.dy + math.sin(angle2) * r,
      );

      canvas.drawLine(p1, p2, linePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _AuroraWheelPainter oldDelegate) {
    return rotation != oldDelegate.rotation ||
        baseColor != oldDelegate.baseColor;
  }
}
