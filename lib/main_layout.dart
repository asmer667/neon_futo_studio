import 'package:flutter/material.dart';
import 'screens/editor_screen.dart';
import 'screens/colors_library.dart';
import 'screens/shapes_library.dart';
import 'screens/assets_screen.dart';
import 'screens/preset_themes.dart';
import 'screens/export_screen.dart';
import 'screens/backgrounds_screen.dart';
import 'models/futo_theme.dart';
import 'core/translations.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animController;

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
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onNavChanged(int i) {
    if (i == _selectedIndex) return;
    setState(() => _selectedIndex = i);
    _animController.reset();
    _animController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
        child: KeyedSubtree(
          key: ValueKey<int>(_selectedIndex),
          child: _screens[_selectedIndex],
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: _selectedIndex,
          onDestinationSelected: _onNavChanged,
          backgroundColor: Colors.transparent,
          elevation: 0,
          indicatorColor: const Color(0xFF6C63FF).withOpacity(0.3),
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.keyboard_outlined),
              selectedIcon: const Icon(Icons.keyboard, color: Color(0xFF6C63FF)),
              label: AppTranslations.get('keyboard'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.palette_outlined),
              selectedIcon: const Icon(Icons.palette, color: Color(0xFF6C63FF)),
              label: AppTranslations.get('colors'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.category_outlined),
              selectedIcon: const Icon(Icons.category, color: Color(0xFF6C63FF)),
              label: AppTranslations.get('shapes'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.wallpaper_outlined),
              selectedIcon: const Icon(Icons.wallpaper, color: Color(0xFF6C63FF)),
              label: AppTranslations.get('backgrounds'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.attach_file_outlined),
              selectedIcon: const Icon(Icons.attach_file, color: Color(0xFF6C63FF)),
              label: AppTranslations.get('assets'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.import_export_outlined),
              selectedIcon: const Icon(Icons.import_export, color: Color(0xFF6C63FF)),
              label: AppTranslations.get('export'),
            ),
            NavigationDestination(
              icon: const Icon(Icons.auto_awesome_outlined),
              selectedIcon: const Icon(Icons.auto_awesome, color: Color(0xFF6C63FF)),
              label: AppTranslations.get('presets'),
            ),
          ],
        ),
      ),
    );
  }
}
