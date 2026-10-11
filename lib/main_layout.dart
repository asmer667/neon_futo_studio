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

  final List<Widget> _screens = [
    const EditorScreen(),
    ColorsLibrary(
      initialColor: Colors.purple,
      currentTheme: FutoTheme(),
      onColorSelected: (c) {},
    ),
    ShapesLibrary(onShapeSelected: (s) {}),
    BackgroundsScreen(onBackgroundSelected: (p) {}),
    AssetsScreen(onAssetSelected: (t, p) {}),
    const ExportScreen(),
    const PresetThemesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        backgroundColor: const Color(0xFF1A1A2E),
        indicatorColor: const Color(0xFF6C63FF).withOpacity(0.3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.keyboard_outlined),
            selectedIcon: Icon(Icons.keyboard, color: Color(0xFF6C63FF)),
            label: 'المفاتيح',
          ),
          NavigationDestination(
            icon: Icon(Icons.palette_outlined),
            selectedIcon: Icon(Icons.palette, color: Color(0xFF6C63FF)),
            label: 'الألوان',
          ),
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category, color: Color(0xFF6C63FF)),
            label: 'الأشكال',
          ),
          NavigationDestination(
            icon: Icon(Icons.wallpaper_outlined),
            selectedIcon: Icon(Icons.wallpaper, color: Color(0xFF6C63FF)),
            label: 'الخلفيات',
          ),
          NavigationDestination(
            icon: Icon(Icons.attach_file_outlined),
            selectedIcon: Icon(Icons.attach_file, color: Color(0xFF6C63FF)),
            label: 'الأصول',
          ),
          NavigationDestination(
            icon: Icon(Icons.import_export_outlined),
            selectedIcon: Icon(Icons.import_export, color: Color(0xFF6C63FF)),
            label: 'تصدير',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_awesome_outlined),
            selectedIcon: Icon(Icons.auto_awesome, color: Color(0xFF6C63FF)),
            label: 'جاهزة',
          ),
        ],
      ),
    );
  }
}
