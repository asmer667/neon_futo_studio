import 'package:flutter/material.dart';
import '../models/futo_theme.dart';
import 'editor_screen.dart';

class PresetThemesScreen extends StatelessWidget {
  const PresetThemesScreen({super.key});

  /// 20 ثيماً حقيقياً، كل واحد مربوط بشكل من الأشكال الـ 500
  List<FutoTheme> _getRealThemes() {
    return [
      // 1. ثيم القلوب
      FutoTheme(
        name: 'ثيم القلوب',
        keyboardSurface: const Color(0xFF2D1B2E),
        keyboardContainer: const Color(0xFFE91E63),
        keyboardPrimary: const Color(0xFFFF4081),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.white,
        keyShape: 'assets/03_hearts/01_classic_heart.png',
        keyRadius: 20,
      ),
      // 2. ثيم النجوم
      FutoTheme(
        name: 'ثيم النجوم',
        keyboardSurface: const Color(0xFF1A1A3E),
        keyboardContainer: const Color(0xFFFFD700),
        keyboardPrimary: const Color(0xFFFFA000),
        onKeyboard: Colors.black,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/02_stars/01_5_point_star.png',
        keyRadius: 15,
      ),
      // 3. ثيم الدوائر
      FutoTheme(
        name: 'ثيم الدوائر',
        keyboardSurface: const Color(0xFF1B2E1B),
        keyboardContainer: const Color(0xFF4CAF50),
        keyboardPrimary: const Color(0xFF81C784),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/04_circles/01_full_circle.png',
        keyRadius: 30,
      ),
      // 4. ثيم السداسي
      FutoTheme(
        name: 'ثيم السداسي',
        keyboardSurface: const Color(0xFF2E1B1B),
        keyboardContainer: const Color(0xFFFF5722),
        keyboardPrimary: const Color(0xFFFF8A65),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/05_hexagons/01_regular_hexagon.png',
        keyRadius: 10,
      ),
      // 5. ثيم الماس
      FutoTheme(
        name: 'ثيم الماس',
        keyboardSurface: const Color(0xFF1B1B2E),
        keyboardContainer: const Color(0xFF9C27B0),
        keyboardPrimary: const Color(0xFFBA68C8),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/06_diamonds/01_classic_diamond.png',
        keyRadius: 12,
      ),
      // 6. ثيم الثلج
      FutoTheme(
        name: 'ثيم الثلج',
        keyboardSurface: const Color(0xFF1B2E3E),
        keyboardContainer: const Color(0xFF00BCD4),
        keyboardPrimary: const Color(0xFF4DD0E1),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/10_snow/01_snowflake.png',
        keyRadius: 18,
      ),
      // 7. ثيم النار
      FutoTheme(
        name: 'ثيم النار',
        keyboardSurface: const Color(0xFF2E0F0F),
        keyboardContainer: const Color(0xFFFF3D00),
        keyboardPrimary: const Color(0xFFFF6E40),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/11_fire/01_flame.png',
        keyRadius: 8,
      ),
      // 8. ثيم الأوراق
      FutoTheme(
        name: 'ثيم الأوراق',
        keyboardSurface: const Color(0xFF1B2E1B),
        keyboardContainer: const Color(0xFF2E7D32),
        keyboardPrimary: const Color(0xFF66BB6A),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/12_leaves/01_leaf.png',
        keyRadius: 14,
      ),
      // 9. ثيم الزهور
      FutoTheme(
        name: 'ثيم الزهور',
        keyboardSurface: const Color(0xFF2E1B2E),
        keyboardContainer: const Color(0xFFE91E63),
        keyboardPrimary: const Color(0xFFF06292),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.white,
        keyShape: 'assets/08_flowers/01_simple_flower.png',
        keyRadius: 25,
      ),
      // 10. ثيم الموجات
      FutoTheme(
        name: 'ثيم الموجات',
        keyboardSurface: const Color(0xFF0F1A2E),
        keyboardContainer: const Color(0xFF1976D2),
        keyboardPrimary: const Color(0xFF42A5F5),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/07_waves/01_single_wave.png',
        keyRadius: 10,
      ),
      // 11. ثيم الكريستال
      FutoTheme(
        name: 'ثيم الكريستال',
        keyboardSurface: const Color(0xFF1A1A3E),
        keyboardContainer: const Color(0xFF7986CB),
        keyboardPrimary: const Color(0xFF9FA8DA),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/09_crystals/01_crystal_shard.png',
        keyRadius: 15,
      ),
      // 12. ثيم الأسهم
      FutoTheme(
        name: 'ثيم الأسهم',
        keyboardSurface: const Color(0xFF1A2E2E),
        keyboardContainer: const Color(0xFF00897B),
        keyboardPrimary: const Color(0xFF4DB6AC),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/13_arrows/01_arrow_up.png',
        keyRadius: 12,
      ),
      // 13. ثيم الحروف
      FutoTheme(
        name: 'ثيم الحروف',
        keyboardSurface: const Color(0xFF2E2E1B),
        keyboardContainer: const Color(0xFFFFB300),
        keyboardPrimary: const Color(0xFFFFD54F),
        onKeyboard: Colors.black,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/22_alphabet_shapes/01_letter_a.png',
        keyRadius: 10,
      ),
      // 14. ثيم الطبيعة
      FutoTheme(
        name: 'ثيم الطبيعة',
        keyboardSurface: const Color(0xFF1B2E1B),
        keyboardContainer: const Color(0xFF558B2F),
        keyboardPrimary: const Color(0xFF8BC34A),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/17_nature/01_tree.png',
        keyRadius: 20,
      ),
      // 15. ثيم الفضاء
      FutoTheme(
        name: 'ثيم الفضاء',
        keyboardSurface: const Color(0xFF0A0A1A),
        keyboardContainer: const Color(0xFF3F51B5),
        keyboardPrimary: const Color(0xFF5C6BC0),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/20_night/01_moon.png',
        keyRadius: 15,
      ),
      // 16. ثيم الخيال
      FutoTheme(
        name: 'ثيم الخيال',
        keyboardSurface: const Color(0xFF2E1B2E),
        keyboardContainer: const Color(0xFF7B1FA2),
        keyboardPrimary: const Color(0xFFAB47BC),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.white,
        keyShape: 'assets/24_fantasy/01_dragon.png',
        keyRadius: 18,
      ),
      // 17. ثيم الفقاعات
      FutoTheme(
        name: 'ثيم الفقاعات',
        keyboardSurface: const Color(0xFF0F1A2E),
        keyboardContainer: const Color(0xFF0288D1),
        keyboardPrimary: const Color(0xFF4FC3F7),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/25_abstract/04_bubble.png',
        keyRadius: 25,
      ),
      // 18. ثيم المعدن
      FutoTheme(
        name: 'ثيم المعدن',
        keyboardSurface: const Color(0xFF1A1A1A),
        keyboardContainer: const Color(0xFF9E9E9E),
        keyboardPrimary: const Color(0xFFBDBDBD),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/19_metallic/01_gold.png',
        keyRadius: 10,
      ),
      // 19. ثيم المربعات
      FutoTheme(
        name: 'ثيم المربعات',
        keyboardSurface: const Color(0xFF1A2E1A),
        keyboardContainer: const Color(0xFF388E3C),
        keyboardPrimary: const Color(0xFF66BB6A),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/14_squares/01_square.png',
        keyRadius: 5,
      ),
      // 20. ثيم المثلثات
      FutoTheme(
        name: 'ثيم المثلثات',
        keyboardSurface: const Color(0xFF2E1B1B),
        keyboardContainer: const Color(0xFFD32F2F),
        keyboardPrimary: const Color(0xFFEF5350),
        onKeyboard: Colors.white,
        keyboardOnPrimary: Colors.black,
        keyShape: 'assets/15_triangles/01_triangle.png',
        keyRadius: 8,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themes = _getRealThemes();
    return Scaffold(
      appBar: AppBar(
        title: const Text('الثيمات الجاهزة'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.75,
        ),
        itemCount: themes.length,
        itemBuilder: (ctx, i) {
          final theme = themes[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => EditorScreen(initialTheme: theme),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: theme.keyboardSurface,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white12),
                boxShadow: [
                  BoxShadow(
                    color: theme.keyboardContainer.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // معاينة مصغرة للثيم
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: _buildMiniPreview(theme),
                    ),
                  ),
                  // اسم الثيم
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: theme.keyboardContainer.withOpacity(0.3),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(24),
                      ),
                    ),
                    child: Text(
                      theme.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: theme.onKeyboard,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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

  Widget _buildMiniPreview(FutoTheme theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            _miniKey('ض', theme),
            _miniKey('ص', theme),
            _miniKey('ث', theme),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            _miniKey('ش', theme),
            _miniKey('س', theme),
            _miniKey('ي', theme),
          ],
        ),
        const SizedBox(height: 3),
        Row(
          children: [
            _miniKey('123', theme, isSpecial: true),
            _miniKey(' ', theme, flex: 2),
            _miniKey('⌫', theme, isSpecial: true),
          ],
        ),
      ],
    );
  }

  Widget _miniKey(String label, FutoTheme theme,
      {int flex = 1, bool isSpecial = false}) {
    final color = isSpecial ? theme.keyboardPrimary : theme.keyboardContainer;
    final hasImage = theme.keyShape.isNotEmpty;

    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(1),
        height: 24,
        decoration: BoxDecoration(
          color: hasImage ? Colors.transparent : color,
          borderRadius: BorderRadius.circular(theme.keyRadius / 2),
        ),
        child: Stack(
          children: [
            if (hasImage)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(theme.keyRadius / 2),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      color.withOpacity(0.7),
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      theme.keyShape,
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) => Container(color: color),
                    ),
                  ),
                ),
              ),
            Center(
              child: Text(
                label,
                style: TextStyle(
                  color: theme.onKeyboard,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
