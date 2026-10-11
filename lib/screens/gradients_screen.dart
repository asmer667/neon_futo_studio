import 'package:flutter/material.dart';

class GradientsScreen extends StatelessWidget {
  final Function(List<Color>) onGradientSelected;
  const GradientsScreen({super.key, required this.onGradientSelected});

  static final List<List<Color>> lightGradients = [
    [const Color(0xFFFFE0E0), const Color(0xFFE0F0FF)],
    [const Color(0xFFE8F5E9), const Color(0xFFFFF9C4)],
    [const Color(0xFFFCE4EC), const Color(0xFFE1BEE7)],
    [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2)],
    [const Color(0xFFE0F7FA), const Color(0xFFB2EBF2)],
    [const Color(0xFFF3E5F5), const Color(0xFFE1BEE7)],
    [const Color(0xFFFFFDE7), const Color(0xFFFFF9C4)],
    [const Color(0xFFE8EAF6), const Color(0xFFC5CAE9)],
    [const Color(0xFFFBE9E7), const Color(0xFFFFCCBC)],
    [const Color(0xFFF1F8E9), const Color(0xFFDCEDC8)],
    [const Color(0xFFE0F2F1), const Color(0xFFB2DFDB)],
    [const Color(0xFFF9FBE7), const Color(0xFFF0F4C3)],
  ];

  static final List<List<Color>> darkGradients = [
    [const Color(0xFF1A1A2E), const Color(0xFF16213E)],
    [const Color(0xFF0F0F1A), const Color(0xFF1A1A2E)],
    [const Color(0xFF2C1810), const Color(0xFF1A0F0A)],
    [const Color(0xFF0D1B2A), const Color(0xFF1B263B)],
    [const Color(0xFF1B1B2E), const Color(0xFF2D1B2E)],
    [const Color(0xFF0A1929), const Color(0xFF1A2332)],
    [const Color(0xFF2E1B1B), const Color(0xFF1A0F0F)],
    [const Color(0xFF1B2E1B), const Color(0xFF0F1A0F)],
    [const Color(0xFF2E1B2E), const Color(0xFF1A0F1A)],
    [const Color(0xFF0F1A2E), const Color(0xFF1A2E3E)],
    [const Color(0xFF2E2E1B), const Color(0xFF1A1A0F)],
    [const Color(0xFF1A2E2E), const Color(0xFF0F1A1A)],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('التدرجات')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // التدرجات الفاتحة
          Row(
            children: [
              const Icon(Icons.light_mode, color: Colors.amber),
              const SizedBox(width: 8),
              const Text('تدريج ألوان فاتحة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {},
              ),
            ],
          ),
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
            itemCount: lightGradients.length,
            itemBuilder: (ctx, i) {
              return _buildGradientTile(lightGradients[i]);
            },
          ),
          const SizedBox(height: 30),

          // التدرجات الداكنة
          Row(
            children: [
              const Icon(Icons.dark_mode, color: Colors.purple),
              const SizedBox(width: 8),
              const Text('تدريج ألوان داكنة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.expand_more),
                onPressed: () {},
              ),
            ],
          ),
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
            itemCount: darkGradients.length,
            itemBuilder: (ctx, i) {
              return _buildGradientTile(darkGradients[i]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGradientTile(List<Color> colors) {
    return GestureDetector(
      onTap: () {
        onGradientSelected(colors);
        Navigator.pop(context);
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: colors,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white12),
        ),
        child: const Center(
          child: Icon(Icons.touch_app, color: Colors.white54, size: 24),
        ),
      ),
    );
  }
}
