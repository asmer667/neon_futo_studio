import 'package:flutter/material.dart';
import 'screens/editor_screen.dart';
import 'screens/colors_library.dart';
import 'screens/shapes_library.dart';
import 'screens/assets_screen.dart';
import 'screens/preset_themes.dart';
import 'screens/export_screen.dart';
import 'screens/backgrounds_screen.dart';
import 'models/futo_theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<_NavItem> _items = [
    _NavItem(icon: Icons.keyboard, label: 'لوحة المفاتيح'),
    _NavItem(icon: Icons.color_lens, label: 'مكتبة الألوان'),
    _NavItem(icon: Icons.category, label: 'مكتبة الأشكال'),
    _NavItem(icon: Icons.text_fields, label: 'الخطوط'),
    _NavItem(icon: Icons.wallpaper, label: 'الخلفيات'),
    _NavItem(icon: Icons.attach_file, label: 'الأصول'),
    _NavItem(icon: Icons.import_export, label: 'الاستيراد والتصدير'),
    _NavItem(icon: Icons.auto_awesome, label: 'الثيمات الجاهزة'),
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      body: Row(
        children: [
          // الشريط الجانبي
          NavigationRail(
            extended: isWide,
            minExtendedWidth: 200,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            labelType: isWide ? NavigationRailLabelType.none : NavigationRailLabelType.selected,
            leading: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF00D2FF)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Icon(Icons.keyboard, color: Colors.white, size: 30),
                  ),
                  if (isWide) const SizedBox(height: 10),
                  if (isWide)
                    const Text('NEON\nFUTO', textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                ],
              ),
            ),
            destinations: _items.map((item) {
              return NavigationRailDestination(
                icon: Icon(item.icon),
                label: Text(item.label),
              );
            }).toList(),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          // المحتوى
          Expanded(child: _buildScreen()),
        ],
      ),
    );
  }

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return const EditorScreen();
      case 1:
        return ColorsLibrary(
          initialColor: Colors.purple,
          currentTheme: FutoTheme(),
          onColorSelected: (c) {},
        );
      case 2:
        return ShapesLibrary(onShapeSelected: (s) {});
      case 3:
        return const _PlaceholderScreen(title: 'الخطوط');
      case 4:
        return BackgroundsScreen(onBackgroundSelected: (p) {});
      case 5:
        return AssetsScreen(onAssetSelected: (t, p) {});
      case 6:
        return const ExportScreen();
      case 7:
        return const PresetThemesScreen();
      default:
        return const EditorScreen();
    }
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text('قسم $title قادم قريباً', style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}
