import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/cosmic_design.dart';
import '../../utils/color_utils.dart';

/// RGB input fields for precise color value editing.
class RgbInputFields extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const RgbInputFields({
    super.key,
    required this.color,
    required this.onColorChanged,
  });

  @override
  State<RgbInputFields> createState() => _RgbInputFieldsState();
}

class _RgbInputFieldsState extends State<RgbInputFields> {
  late TextEditingController _rController;
  late TextEditingController _gController;
  late TextEditingController _bController;

  int _getRed() => ColorUtils.getRed(widget.color);
  int _getGreen() => ColorUtils.getGreen(widget.color);
  int _getBlue() => ColorUtils.getBlue(widget.color);

  @override
  void initState() {
    super.initState();
    _rController = TextEditingController(text: _getRed().toString());
    _gController = TextEditingController(text: _getGreen().toString());
    _bController = TextEditingController(text: _getBlue().toString());
  }

  @override
  void didUpdateWidget(RgbInputFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.color != oldWidget.color) {
      _rController.text = _getRed().toString();
      _gController.text = _getGreen().toString();
      _bController.text = _getBlue().toString();
    }
  }

  @override
  void dispose() {
    _rController.dispose();
    _gController.dispose();
    _bController.dispose();
    super.dispose();
  }

  void _updateColor() {
    final r = int.tryParse(_rController.text) ?? 0;
    final g = int.tryParse(_gController.text) ?? 0;
    final b = int.tryParse(_bController.text) ?? 0;
    widget.onColorChanged(
      Color.from(
        alpha: widget.color.a,
        red: r.clamp(0, 255) / 255.0,
        green: g.clamp(0, 255) / 255.0,
        blue: b.clamp(0, 255) / 255.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildField('R', _rController, CosmicDesign.neonPink)),
        const SizedBox(width: 8),
        Expanded(child: _buildField('G', _gController, Colors.greenAccent)),
        const SizedBox(width: 8),
        Expanded(child: _buildField('B', _bController, CosmicDesign.neonCyan)),
      ],
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    Color accentColor,
  ) {
    return Semantics(
      label: '$label color value',
      textField: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: accentColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                color: accentColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: controller,
              onChanged: (_) => _updateColor(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 8),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(3),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
