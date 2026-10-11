import 'package:flutter/material.dart';
import 'editor_screen.dart';
import 'colors_library.dart';
import 'preset_themes.dart';
import 'assets_screen.dart';
import 'shapes_library.dart';
import '../models/futo_theme.dart';

class

cat > lib/screens/home_screen.dart << 'EOF'
import 'package:flutter/material.dart';
import 'editor_screen.dart';
import 'colors_library.dart';
import 'preset_themes.dart';
import 'assets_screen.dart';
import 'shapes_library.dart';
import '../models/futo_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NEON FUTO STUDIO',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('مرحباً بك 👋',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 5),
            const Text('اختر ما تريد تخصيصه لثيم لوحة المفاتيح',
                style: TextStyle(color: Colors.grey, fontSize: 14)),
            const SizedBox(height: 25),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1.1,
              children: [
                _buildCard(context, 'لوحة المفاتيح', Icons.keyboard, Colors.purple,
                    () => _go(context, const EditorScreen())),
                _buildCard(context, 'مكتبة الألوان', Icons.color_lens, Colors.pink,
                    () => _go(context, ColorsLibrary(initialColor: Colors.purple, currentTheme: FutoTheme(), onColorSelected: (c) {}))),
                _buildCard(context, 'الثيمات الجاهزة', Icons.auto_awesome, Colors.amber,
                    () => _go(context, const PresetThemesScreen())),
                _buildCard(context, 'مكتبة الأشكال', Icons.category, Colors.blue,
                    () => _go(context, ShapesLibrary(onShapeSelected: (s) {}))),
                _buildCard(context, 'الأصول', Icons.attach_file, Colors.cyan, () => _go(context, AssetsScreen(onAssetSelected: (t, p) {}))),
                _buildCard(context, 'الخطوط', Icons.text_fields, Colors.orange, () {}),
                _buildCard(context, 'الاستيراد والتصدير', Icons.import_export, Colors.green, () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _go(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, Color color,
      VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.9), color.withOpacity(0.3)],
          ),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
