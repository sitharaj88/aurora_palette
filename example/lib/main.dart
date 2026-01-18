import 'package:flutter/material.dart';
import 'package:aurora_palette/aurora_palette.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aurora Palette Demo',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        scrollbars: false,
      ),
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      home: const PickerDemoPage(),
    );
  }
}

class PickerDemoPage extends StatefulWidget {
  const PickerDemoPage({super.key});

  @override
  State<PickerDemoPage> createState() => _PickerDemoPageState();
}

class _PickerDemoPageState extends State<PickerDemoPage> {
  late CosmicColorController _controller;
  ColorHarmonyType _harmonyType = ColorHarmonyType.triadic;

  @override
  void initState() {
    super.initState();
    _controller = CosmicColorController(initialColor: Colors.cyanAccent);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWide = screenWidth > 800;

    return Scaffold(
      backgroundColor: CosmicDesign.background,
      body: Stack(
        children: [
          // Aurora Background Orbs
          _buildBackgroundOrb(-100, -100, 300, CosmicDesign.neonPurple, 0.3),
          _buildBackgroundOrb(
            null,
            -50,
            250,
            CosmicDesign.neonPink,
            0.2,
            right: -50,
          ),
          _buildBackgroundOrb(
            100,
            null,
            200,
            CosmicDesign.neonCyan,
            0.15,
            right: -80,
          ),

          // Main Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: isWide ? _buildWideLayout() : _buildCompactLayout(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left: Color Picker
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: CosmicColorPicker(
                      controller: _controller,
                      showAlpha: true,
                      showHex: true,
                      showRgb: true,
                      showRecentColors: true,
                      onColorConfirmed: _onColorConfirmed,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 32),
        // Right: Harmony & Info
        Expanded(
          child: Column(
            children: [
              _buildHarmonySelector(),
              const SizedBox(height: 24),
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  return AuroraHarmonyWheel(
                    baseColor: _controller.color,
                    harmonyType: _harmonyType,
                    onColorSelected: _controller.updateColor,
                  );
                },
              ),
              const SizedBox(height: 24),
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  return ColorInfoCard(
                    color: _controller.color,
                    onCopyHex: () => _showCopiedSnackbar(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCompactLayout() {
    return Column(
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: CosmicColorPicker(
                  controller: _controller,
                  showAlpha: true,
                  showHex: true,
                  showRgb: false,
                  showRecentColors: true,
                  onColorConfirmed: _onColorConfirmed,
                ),
              ),
              const SizedBox(height: 24),
              _buildHarmonySelector(),
              const SizedBox(height: 16),
              Center(
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, _) {
                    return AuroraHarmonyWheel(
                      baseColor: _controller.color,
                      harmonyType: _harmonyType,
                      size: 180,
                      onColorSelected: _controller.updateColor,
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              ListenableBuilder(
                listenable: _controller,
                builder: (context, _) {
                  return ColorInfoCard(
                    color: _controller.color,
                    onCopyHex: () => _showCopiedSnackbar(),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Responsive implementation: banner only on wide layout or compact top?
        // Let's keep it simple and just show the text title always, but maybe add the banner image below?
        // Wait, the user asked to "add to the demo file". Let's put it at the very top of compact layout
        // or sidebar of wide layout.
        // Actually, let's just replace the text header with the banner for a cooler look?
        // Or put it above.
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'assets/banner.png',
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [
              CosmicDesign.neonCyan,
              CosmicDesign.neonPurple,
              CosmicDesign.neonPink,
            ],
          ).createShader(bounds),
          child: const Text(
            'AURORA PALETTE',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 4,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Intelligent Color Harmony',
          style: TextStyle(
            fontSize: 14,
            letterSpacing: 2,
            color: Colors.white.withValues(alpha: 0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildHarmonySelector() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: ColorHarmonyType.values.map((type) {
          final isSelected = type == _harmonyType;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _harmonyType = type),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? CosmicDesign.neonCyan.withValues(alpha: 0.3)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? CosmicDesign.neonCyan
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  _getHarmonyLabel(type),
                  style: TextStyle(
                    color: isSelected ? CosmicDesign.neonCyan : Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBackgroundOrb(
    double? top,
    double? bottom,
    double size,
    Color color,
    double opacity, {
    double? left,
    double? right,
  }) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left ?? (right == null ? -100 : null),
      right: right,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }

  String _getHarmonyLabel(ColorHarmonyType type) {
    switch (type) {
      case ColorHarmonyType.complementary:
        return 'COMPLEMENTARY';
      case ColorHarmonyType.analogous:
        return 'ANALOGOUS';
      case ColorHarmonyType.triadic:
        return 'TRIADIC';
      case ColorHarmonyType.splitComplementary:
        return 'SPLIT';
      case ColorHarmonyType.tetradic:
        return 'TETRADIC';
      case ColorHarmonyType.monochromatic:
        return 'MONO';
    }
  }

  void _onColorConfirmed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Color confirmed: ${_controller.hexCode}'),
        backgroundColor: _controller.color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showCopiedSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Copied: ${_controller.hexCode}'),
        backgroundColor: CosmicDesign.neonCyan,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
