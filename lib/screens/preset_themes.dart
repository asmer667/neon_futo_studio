import 'package:flutter/material.dart';
import '../models/keyboard_theme.dart';
import 'editor_screen.dart';

class PresetThemesScreen extends StatelessWidget {
  const PresetThemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themes = PresetThemes.all;
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
                color: theme.layer2,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.layer6),
                boxShadow: [
                  BoxShadow(color: theme.layer3.withOpacity(0.3), blurRadius: 15),
                ],
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Center(
                      child: Icon(
                        _iconForShape(theme.keyShape),
                        size: 60,
                        color: theme.layer3,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: theme.layer3.withOpacity(0.2),
                      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          theme.name,
                          style: TextStyle(
                            color: theme.layer5,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              color: theme.layer5,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditorScreen(initialTheme: theme),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.download, size: 20),
                              color: theme.layer5,
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('سيتم تصدير ${theme.name}')),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
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

  IconData _iconForShape(String shape) {
    switch (shape) {
      case 'heart': return Icons.favorite;
      case 'star': return Icons.star;
      case 'circle': return Icons.circle;
      case 'hexagon': return Icons.hexagon;
      case 'diamond': return Icons.diamond;
      case 'snowflake': return Icons.ac_unit;
      default: return Icons.square;
    }
  }
}
