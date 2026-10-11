import 'package:flutter/material.dart';
import '../models/futo_theme.dart';
import '../services/dynamic_color_service.dart';

class ThemeSettingsScreen extends StatefulWidget {
  final FutoTheme theme;
  final Function(FutoTheme) onApply;
  const ThemeSettingsScreen({super.key, required this.theme, required this.onApply});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  late FutoTheme _theme;
  Color _selectedColor = const Color(0xFF6C63FF);
  String? _selectedBackground;
  int _autoMode = 0;

  final List<Color> _colors = [
    Colors.white, const Color(0xFF1A1A2E), Colors.grey[200]!,
    Colors.green, Colors.red, Colors.grey[800]!,
    Colors.cyan[200]!, Colors.blue, Colors.teal,
    Colors.pink[200]!, Colors.pink[800]!, Colors.purple[800]!,
    Colors.blueGrey[800]!, Colors.brown, Colors.grey[300]!,
    Colors.black, Colors.black87, Colors.black,
  ];

  final List<Map<String, String>> _backgrounds = [
    {'name': 'جبال', 'path': 'assets/backgrounds/mountain.jpg'},
    {'name': 'غروب', 'path': 'assets/backgrounds/sunset.jpg'},
    {'name': 'محيط', 'path': 'assets/backgrounds/ocean.jpg'},
    {'name': 'غابة', 'path': 'assets/backgrounds/forest.jpg'},
    {'name': 'فضاء', 'path': 'assets/backgrounds/space.jpg'},
    {'name': 'صحراء', 'path': 'assets/backgrounds/desert.jpg'},
    {'name': 'شتاء', 'path': 'assets/backgrounds/winter.jpg'},
    {'name': 'مدينة', 'path': 'assets/backgrounds/city.jpg'},
    {'name': 'نيون', 'path': 'assets/backgrounds/neon.jpg'},
  ];

  @override
  void initState() {
    super.initState();
    _theme = widget.theme;
    _selectedColor = _theme.primary;
    _selectedBackground = _theme.backgroundImage;
  }

  void _applyColor(Color color) {
    setState(() {
      _selectedColor = color;
      final palette = DynamicColorService.generatePalette(color);
      _theme.primary = palette['primary']!;
      _theme.onPrimary = palette['onPrimary']!;
      _theme.primaryContainer = palette['primaryContainer']!;
      _theme.secondary = palette['secondary']!;
      _theme.tertiary = palette['tertiary']!;
      _theme.background = palette['background']!;
      _theme.surface = palette['surface']!;
      _theme.keyboardSurface = palette['keyboardSurface']!;
      _theme.keyboardContainer = palette['keyboardContainer']!;
      _theme.keyboardPrimary = palette['keyboardPrimary']!;
      _theme.keyboardOnPrimary = palette['keyboardOnPrimary']!;
      _theme.outline = color;
      _theme.keyboardBorder = color;
    });
  }

  void _applyAutoMode(int mode) {
    setState(() {
      _autoMode = mode;
      switch (mode) {
        case 0:
          _applyColor(Colors.white);
          break;
        case 1:
          _applyColor(Colors.black);
          break;
        case 2:
          _applyColor(const Color(0xFF6C63FF));
          break;
        case 3:
          _applyColor(const Color(0xFF1A1A2E));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        title: const Text('المظهر'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('المظاهر المخصصة بي', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                if (_selectedBackground != null)
                  Container(
                    width: 120,
                    height: 80,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.purple, width: 2),
                      image: DecorationImage(
                        image: AssetImage(_selectedBackground!),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: const Center(
                      child: Icon(Icons.check, color: Colors.white, size: 40),
                    ),
                  ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => _BackgroundsPicker(
                          onSelect: (path) {
                            setState(() => _selectedBackground = path);
                            _theme.backgroundImage = path;
                          },
                        ),
                      ),
                    );
                  },
                  child: Container(
                    width: 120,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.purple, width: 2),
                    ),
                    child: const Icon(Icons.add, color: Colors.purple, size: 40),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('تلقائي', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildAutoTile('تلقائي', 0, Colors.white),
                const SizedBox(width: 8),
                _buildAutoTile('حسب النظام', 1, Colors.black),
                const SizedBox(width: 8),
                _buildAutoTile('لون تفاعلي', 2, Colors.purple[100]!),
              ],
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _applyAutoMode(3),
              child: Container(
                width: 120,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _autoMode == 3 ? Colors.purple : Colors.white24,
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text('المظهر الداكن التلقائي',
                      style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            const Text('الألوان', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1.5,
              ),
              itemCount: _colors.length,
              itemBuilder: (ctx, i) {
                final color = _colors[i];
                final isSelected = _selectedColor == color;
                return GestureDetector(
                  onTap: () => _applyColor(color),
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.purple : Colors.white12,
                        width: isSelected ? 3 : 1,
                      ),
                    ),
                    child: isSelected
                        ? const Center(
                            child: Icon(Icons.check, color: Colors.white, size: 24),
                          )
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text('المناظر الطبيعية', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _backgrounds.length,
                itemBuilder: (ctx, i) {
                  final bg = _backgrounds[i];
                  final isSelected = _selectedBackground == bg['path'];
                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedBackground = bg['path']);
                      _theme.backgroundImage = bg['path'];
                    },
                    child: Container(
                      width: 130,
                      margin: const EdgeInsets.only(right: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected ? Colors.purple : Colors.white12,
                          width: isSelected ? 3 : 1,
                        ),
                        image: DecorationImage(
                          image: AssetImage(bg['path']!),
                          fit: BoxFit.cover,
                          onError: (_, __) {},
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.white38),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('إلغاء', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      widget.onApply(_theme);
                      Navigator.pop(context);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('تطبيق'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutoTile(String label, int value, Color color) {
    final selected = _autoMode == value;
    return GestureDetector(
      onTap: () => _applyAutoMode(value),
      child: Container(
        width: 100,
        height: 60,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? Colors.purple : Colors.white24,
            width: selected ? 3 : 1,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white,
              fontSize: 10,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackgroundsPicker extends StatelessWidget {
  final Function(String) onSelect;
  const _BackgroundsPicker({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final backgrounds = [
      'assets/backgrounds/mountain.jpg',
      'assets/backgrounds/ocean.jpg',
      'assets/backgrounds/sunset.jpg',
      'assets/backgrounds/forest.jpg',
      'assets/backgrounds/desert.jpg',
      'assets/backgrounds/winter.jpg',
      'assets/backgrounds/space.jpg',
      'assets/backgrounds/galaxy.jpg',
      'assets/backgrounds/city.jpg',
      'assets/backgrounds/neon.jpg',
      'assets/backgrounds/abstract.jpg',
      'assets/backgrounds/dark.jpg',
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('اختر خلفية')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.7,
        ),
        itemCount: backgrounds.length,
        itemBuilder: (ctx, i) {
          return GestureDetector(
            onTap: () {
              onSelect(backgrounds[i]);
              Navigator.pop(context);
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset(
                backgrounds[i],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.white10),
              ),
            ),
          );
        },
      ),
    );
  }
}
