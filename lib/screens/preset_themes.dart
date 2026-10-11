import 'package:flutter/material.dart';
import '../models/futo_theme.dart';
import 'editor_screen.dart';

class PresetThemesScreen extends StatelessWidget {
  const PresetThemesScreen({super.key});

  List<FutoTheme> _getThemes() {
    return [
      FutoTheme(
        name: 'ثيم القلوب',
        keyboardSurface: const Color(0xFF2D1B2E),
        keyboardContainer: const Color(0xFFE91E63),
        keyboardPrimary: const Color(0xFFFF4081),
        onKeyboard: Colors.white,
      ),
      FutoTheme(
        name: 'ثيم النجوم',
        keyboardSurface: const Color(0xFF1A1A3E),
        keyboardContainer: const Color(0xFFFFD700),
        keyboardPrimary: const Color(0xFFFFA000),
        onKeyboard: Colors.black,
      ),
      FutoTheme(
        name: 'ثيم الدوائر',
        keyboardSurface: const Color(0xFF1B2E1B),
        keyboardContainer: const Color(0xFF4CAF50),
        keyboardPrimary: const Color(0xFF81C784),
        onKeyboard: Colors.white,
      ),
      FutoTheme(
        name: 'ثيم السداسي',
        keyboardSurface: const Color(0xFF2E1B1B),
        keyboardContainer: const Color(0xFFFF5722),
        keyboardPrimary: const Color(0xFFFF8A65),
        onKeyboard: Colors.white,
      ),
      FutoTheme(
        name: 'ثيم الماس',
        keyboardSurface: const Color(0xFF1B1B2E),
        keyboardContainer: const Color(0xFF9C27B0),
        keyboardPrimary: const Color(0xFFBA68C8),
        onKeyboard: Colors.white,
      ),
      FutoTheme(
        name: 'ثيم الثلج',
        keyboardSurface: const Color(0xFF1B2E3E),
        keyboardContainer: const Color(0xFF00BCD4),
        keyboardPrimary: const Color(0xFF4DD0E1),
        onKeyboard: Colors.white,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themes = _getThemes();
    return Scaffold(
      appBar: AppBar(title: const Text('الثيمات الجاهزة')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.8,
        ),
        itemCount: themes.length,
        itemBuilder: (ctx, i) {
          final theme = themes[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EditorScreen(initialTheme: theme)),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.keyboardSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white24),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(
                        Icons.keyboard,
                        size: 60,
                        color: theme.keyboardContainer,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.keyboardContainer.withOpacity(0.2),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                    ),
                    child: Text(
                      theme.name,
                      style: TextStyle(
                        color: theme.onKeyboard,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
