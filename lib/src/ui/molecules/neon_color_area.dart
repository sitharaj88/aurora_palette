import 'package:flutter/material.dart';
import '../atoms/neon_handle.dart';

class NeonColorArea extends StatelessWidget {
  final HSVColor hsvColor;
  final ValueChanged<HSVColor> onChanged;
  final double handleSize;

  const NeonColorArea({
    super.key,
    required this.hsvColor,
    required this.onChanged,
    this.handleSize = 24,
  });

  @override
  Widget build(BuildContext context) {
    final double handleRadius = handleSize / 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final double height = constraints.maxHeight > 0
            ? constraints.maxHeight
            : 200;

        // Calculate handle position with edge padding
        final double handleX =
            (hsvColor.saturation * (width - handleSize)) + handleRadius;
        final double handleY =
            ((1 - hsvColor.value) * (height - handleSize)) + handleRadius;

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onPanStart: (details) =>
              _handleTouch(details.localPosition, Size(width, height)),
          onPanUpdate: (details) =>
              _handleTouch(details.localPosition, Size(width, height)),
          onPanDown: (details) =>
              _handleTouch(details.localPosition, Size(width, height)),
          child: Container(
            height: height,
            width: width,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Saturation/Value Gradient Area
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: HSVColor.fromAHSV(
                              1.0,
                              hsvColor.hue,
                              1.0,
                              1.0,
                            ).toColor(),
                          ),
                        ),
                        const Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.white, Colors.transparent],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ),
                        const Positioned.fill(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.transparent, Colors.black],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // The Handle - positioned from center
                Positioned(
                  left: handleX - handleRadius,
                  top: handleY - handleRadius,
                  child: NeonHandle(
                    color: hsvColor.toColor(),
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

  void _handleTouch(Offset localPosition, Size size) {
    final double handleRadius = handleSize / 2;
    // Adjust for handle padding
    final double effectiveWidth = size.width - handleSize;
    final double effectiveHeight = size.height - handleSize;

    final double s = ((localPosition.dx - handleRadius) / effectiveWidth).clamp(
      0.0,
      1.0,
    );
    final double v = (1 - ((localPosition.dy - handleRadius) / effectiveHeight))
        .clamp(0.0, 1.0);
    onChanged(hsvColor.withSaturation(s).withValue(v));
  }
}
