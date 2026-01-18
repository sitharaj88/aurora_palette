import 'dart:ui';
import 'package:flutter/material.dart';
import '../../theme/cosmic_design.dart';

class CosmicGlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double blur;
  final BorderRadius? borderRadius;

  const CosmicGlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.blur = 10,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? CosmicDesign.radiusM,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: CosmicDesign.glassSurface,
            borderRadius: borderRadius ?? CosmicDesign.radiusM,
            border: CosmicDesign.glassBorder,
          ),
          child: child,
        ),
      ),
    );
  }
}
