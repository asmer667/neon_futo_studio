import 'package:flutter/material.dart';
import '../services/theme_manager.dart';
import '../models/futo_theme.dart';
import 'editor_screen.dart';

class SavedThemesScreen extends StatefulWidget {
  const SavedThemesScreen({super.key});

  @override
  State<SavedThemesScreen> createState() => _SavedThemesScreenState();
}

class _SavedThemesScreenState extends State<SavedThemesScreen> {
  List<Map<String, dynamic>> _themes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThemes();
  }

  Future<void> _loadThemes() async {
    final themes = await ThemeManager.getSavedThemes();
    setState(() {
      _themes = themes;
      _isLoading = false;
    });
  }

  Future<void> _deleteTheme(String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('حذف الثيم؟'),
        content: Text('هل تريد حذف "$name"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ThemeManager.deleteTheme(name);
      _loadThemes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الثيمات المحفوظة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadThemes,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _themes.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.folder_open, size: 80, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('لا توجد ثيمات محفوظة'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: _themes.length,
                  itemBuilder: (ctx, i) {
                    final theme = _themes[i];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: _parseColor(theme['primary']),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.keyboard, color: Colors.white),
                        ),
                        title: Text(theme['name'] ?? 'بدون اسم'),
                        subtitle: Text('${theme['author'] ?? ''} • v${theme['version'] ?? '1'}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => EditorScreen(
                                      initialTheme: FutoTheme(
                                        name: theme['name'] ?? '',
                                        author: theme['author'] ?? '',
                                        id: theme['id'] ?? '',
                                        description: theme['description'] ?? '',
                                        version: theme['version'] ?? '1',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _deleteTheme(theme['name']),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Color _parseColor(String? hex) {
    if (hex == null) return Colors.purple;
    try {
      final clean = hex.replaceAll('#', '');
      if (clean.length == 6) return Color(int.parse('FF$clean', radix: 16));
      if (clean.length == 8) return Color(int.parse(clean, radix: 16));
    } catch (e) {}
    return Colors.purple;
  }
}
