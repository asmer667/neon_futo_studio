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

  // الثيم المشترك بين كل الشاشات
  final FutoTheme _sharedTheme = FutoTheme();

  // GlobalKeys للوصول إلى الشاشات
  final GlobalKey<_EditorScreenWrapperState> _editorKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    )..forward();
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

  // الدوال التي تستقبل الاختيار من الشريط السفلي
  void _onColorSelected(Color c) {
    _sharedTheme.primary = c;
    _sharedTheme.keyboardPrimary = c;
    _sharedTheme.keyboardContainer = c.withOpacity(0.3);
    _sharedTheme.outline = c;
    _sharedTheme.keyboardBorder = c;
    // تحديث المحرر
    _editorKey.currentState?.updateTheme(_sharedTheme);
    setState(() {});
  }

  void _onShapeSelected(String path) {
    _sharedTheme.keyShape = path;
    _editorKey.currentState?.updateTheme(_sharedTheme);
    setState(() {});
  }

  void _onBackgroundSelected(String path) {
    _sharedTheme.backgroundImage = path;
    _sharedTheme.useGradient = false;
    _editorKey.currentState?.updateTheme(_sharedTheme);
    setState(() {});
  }

  void _onAssetSelected(String type, String path) {
    if (type == 'background') _sharedTheme.backgroundImage = path;
    if (type == 'font') _sharedTheme.fontPath = path;
    if (type == 'shape') _sharedTheme.keyShape = path;
    _editorKey.currentState?.updateTheme(_sharedTheme);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('app_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {
              setState(() {
                AppTranslations.isEnglish = !AppTranslations.isEnglish;
              });
            },
            tooltip: AppTranslations.isEnglish ? 'العربية' : 'English',
          ),
        ],
      ),
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
          child: _buildScreen(),
        ),
      ),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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

  Widget _buildScreen() {
    switch (_selectedIndex) {
      case 0:
        return _EditorScreenWrapper(
          key: _editorKey,
          theme: _sharedTheme,
        );
      case 1:
        return ColorsLibrary(
          initialColor: _sharedTheme.primary,
          currentTheme: _sharedTheme,
          onColorSelected: _onColorSelected,
        );
      case 2:
        return ShapesLibrary(onShapeSelected: _onShapeSelected);
      case 3:
        return BackgroundsScreen(
          currentBackground: _sharedTheme.backgroundImage,
          onBackgroundSelected: _onBackgroundSelected,
        );
      case 4:
        return AssetsScreen(onAssetSelected: _onAssetSelected);
      case 5:
        return const ExportScreen();
      case 6:
        return const PresetThemesScreen();
      default:
        return _EditorScreenWrapper(key: _editorKey, theme: _sharedTheme);
    }
  }
}

/// Wrapper للوصول إلى المحرر من الخارج
class _EditorScreenWrapper extends StatefulWidget {
  final FutoTheme theme;
  const _EditorScreenWrapper({super.key, required this.theme});

  @override
  State<_EditorScreenWrapper> createState() => _EditorScreenWrapperState();
}

class _EditorScreenWrapperState extends State<_EditorScreenWrapper> {
  late FutoTheme _theme;

  @override
  void initState() {
    super.initState();
    _theme = widget.theme;
  }

  /// دالة عامة لتحديث الثيم من الخارج
  void updateTheme(FutoTheme newTheme) {
    setState(() {
      _theme = newTheme;
    });
  }

  @override
  Widget build(BuildContext context) {
    return EditorScreen(initialTheme: _theme);
  }
}
