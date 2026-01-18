import 'package:flutter/material.dart';
import '../../theme/cosmic_design.dart';

class NeonHandle extends StatefulWidget {
  final Color color;
  final double size;

  const NeonHandle({super.key, required this.color, this.size = 24});

  @override
  State<NeonHandle> createState() => _NeonHandleState();
}

class _NeonHandleState extends State<NeonHandle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: widget.color, width: 2),
          boxShadow: CosmicDesign.neonGlow(widget.color),
        ),
        child: Center(
          child: Container(
            width: widget.size * 0.4,
            height: widget.size * 0.4,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ),
    );
  }
}
