import 'package:flutter/material.dart';
import '../models/futo_theme.dart';
import '../widgets/live_preview_dialog.dart';

class BackgroundsScreen extends StatefulWidget {
  final Function(String path) onBackgroundSelected;
  final String? currentBackground;
  final FutoTheme? theme;

  const BackgroundsScreen({
    super.key,
    required this.onBackgroundSelected,
    this.currentBackground,
    this.theme,
  });

  @override
  State<BackgroundsScreen> createState() => _BackgroundsScreenState();
}

class _BackgroundsScreenState extends State<BackgroundsScreen> {
  String _selectedCategory = 'الكل';
  final List<String> _categories = ['الكل', 'طبيعية', 'فضاء', 'مدن', 'تجريدية', 'داكنة'];

  final List<Map<String, String>> _backgrounds = [
    {'name': 'جبل', 'path': 'assets/backgrounds/mountain.jpg', 'cat': 'طبيعية'},
    {'name': 'محيط', 'path': 'assets/backgrounds/ocean.jpg', 'cat': 'طبيعية'},
    {'name': 'غروب', 'path': 'assets/backgrounds/sunset.jpg', 'cat': 'طبيعية'},
    {'name': 'غابة', 'path': 'assets/backgrounds/forest.jpg', 'cat': 'طبيعية'},
    {'name': 'صحراء', 'path': 'assets/backgrounds/desert.jpg', 'cat': 'طبيعية'},
    {'name': 'شتاء', 'path': 'assets/backgrounds/winter.jpg', 'cat': 'طبيعية'},
    {'name': 'فضاء', 'path': 'assets/backgrounds/space.jpg', 'cat': 'فضاء'},
    {'name': 'مجرة', 'path': 'assets/backgrounds/galaxy.jpg', 'cat': 'فضاء'},
    {'name': 'مدينة', 'path': 'assets/backgrounds/city.jpg', 'cat': 'مدن'},
    {'name': 'نيون', 'path': 'assets/backgrounds/neon.jpg', 'cat': 'مدن'},
    {'name': 'تجريدي', 'path': 'assets/backgrounds/abstract.jpg', 'cat': 'تجريدية'},
    {'name': 'داكن', 'path': 'assets/backgrounds/dark.jpg', 'cat': 'داكنة'},
  ];

  List<Map<String, String>> get _filtered {
    if (_selectedCategory == 'الكل') return _backgrounds;
    return _backgrounds.where((b) => b['cat'] == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الخلفيات')),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.7,
              ),
              itemCount: _filtered.length,
              itemBuilder: (ctx, i) {
                final bg = _filtered[i];
                final isSelected = widget.currentBackground == bg['path'];
                return GestureDetector(
                  onTap: () {
                    if (widget.theme != null) {
                      final tempTheme = widget.theme!;
                      tempTheme.backgroundImage = bg['path'];
                      showDialog(
                        context: context,
                        builder: (_) => LivePreviewDialog(
                          theme: tempTheme,
                          title: 'معاينة: ${bg['name']}',
                          onApply: (newTheme) {
                            widget.onBackgroundSelected(bg['path']!);
                          },
                        ),
                      );
                    } else {
                      widget.onBackgroundSelected(bg['path']!);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('تم اختيار ${bg['name']}')),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? Colors.purple : Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(
                              bg['path']!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.white10,
                                child: const Icon(Icons.image, color: Colors.white38),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(14)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.transparent, Colors.black.withOpacity(0.8)],
                              ),
                            ),
                            child: Text(
                              bg['name']!,
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        if (isSelected)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.purple,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check, color: Colors.white, size: 16),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
