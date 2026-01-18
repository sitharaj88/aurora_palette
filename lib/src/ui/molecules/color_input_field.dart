import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/cosmic_design.dart';
import '../../utils/color_utils.dart';

/// A glassmorphic input field for hex color codes with real-time validation.
class ColorInputField extends StatefulWidget {
  final String hexCode;
  final ValueChanged<Color?> onColorChanged;

  const ColorInputField({
    super.key,
    required this.hexCode,
    required this.onColorChanged,
  });

  @override
  State<ColorInputField> createState() => _ColorInputFieldState();
}

class _ColorInputFieldState extends State<ColorInputField> {
  late TextEditingController _controller;
  bool _isValid = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.hexCode);
  }

  @override
  void didUpdateWidget(ColorInputField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.hexCode != oldWidget.hexCode &&
        widget.hexCode != _controller.text) {
      _controller.text = widget.hexCode;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final color = ColorUtils.hexToColor(value);
    setState(() => _isValid = color != null);
    widget.onColorChanged(color);
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Hex color input field',
      textField: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isValid
                ? Colors.white.withValues(alpha: 0.1)
                : CosmicDesign.neonPink,
            width: _isValid ? 1 : 2,
          ),
        ),
        child: TextField(
          controller: _controller,
          onChanged: _onChanged,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'monospace',
            fontWeight: FontWeight.bold,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: '#FFFFFF',
            hintStyle: TextStyle(color: Colors.white30),
            prefixIcon: Icon(Icons.tag, color: Colors.white54, size: 18),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9a-fA-F#]')),
            LengthLimitingTextInputFormatter(9),
          ],
        ),
      ),
    );
  }
}
