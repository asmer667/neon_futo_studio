import 'package:flutter/material.dart';
import 'theme_preview.dart';
import '../models/futo_theme.dart';

class ColorsLibrary extends StatefulWidget {
  final Function(Color) onColorSelected;
  final Color initialColor;
  final FutoTheme? currentTheme;

  const ColorsLibrary({
    super.key,
    required this.onColorSelected,
    required this.initialColor,
    this.currentTheme,
  });

  @override
  State<ColorsLibrary> createState() => _ColorsLibraryState();
}

class _ColorsLibraryState extends State<ColorsLibrary> {
  late List<Color> _allColors;
  late List<Color> _filteredColors;
  Color _selectedColor = Colors.purple;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';

  final List<String> _categories = [
    'الكل', 'أحمر', 'برتقالي', 'أصفر', 'أخضر',
    'أزرق', 'بنفسجي', 'وردي', 'رمادي',
  ];

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
    _generateColors();
    _filteredColors = _allColors;
  }

  void _generateColors() {
    final List<Color> colors = [];
    for (int hue = 0; hue < 360; hue += 3) {
      for (int sat = 2; sat <= 10; sat += 2) {
        for (int light = 2; light <= 10; light += 2) {
          colors.add(HSLColor.fromAHSL(1.0, hue.toDouble(), sat / 10, light / 10).toColor());
        }
      }
    }
    for (int i = 0; i <= 255; i += 5) {
      colors.add(Color.fromARGB(255, i, i, i));
    }
    _allColors = colors;
  }

  void _filterColors() {
    setState(() {
      if (_searchController.text.isEmpty && _selectedCategory == 'الكل') {
        _filteredColors = _allColors;
      } else {
        _filteredColors = _allColors.where((c) {
          final hsl = HSLColor.fromColor(c);
          final hue = hsl.hue;
          bool matchesCategory = true;
          if (_selectedCategory != 'الكل') {
            if (_selectedCategory == 'أحمر') matchesCategory = hue < 15 || hue >= 345;
            else if (_selectedCategory == 'برتقالي') matchesCategory = hue >= 15 && hue < 45;
            else if (_selectedCategory == 'أصفر') matchesCategory = hue >= 45 && hue < 75;
            else if (_selectedCategory == 'أخضر') matchesCategory = hue >= 75 && hue < 165;
            else if (_selectedCategory == 'أزرق') matchesCategory = hue >= 165 && hue < 255;
            else if (_selectedCategory == 'بنفسجي') matchesCategory = hue >= 255 && hue < 285;
            else if (_selectedCategory == 'وردي') matchesCategory = hue >= 285 && hue < 345;
            else if (_selectedCategory == 'رمادي') matchesCategory = hsl.saturation < 0.1;
          }
          return matchesCategory;
        }).toList();
      }
    });
  }

  void _showPreviewDialog(Color color) {
    // نطبق اللون مؤقتاً على الثيم لعرض المعاينة
    final previewTheme = widget.currentTheme ?? FutoTheme();
    previewTheme.primary = color;
    previewTheme.keyboardPrimary = color;
    previewTheme.keyboardContainer = color.withOpacity(0.3);
    previewTheme.outline = color;

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(10),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.85,
          decoration: BoxDecoration(
            color: previewTheme.background,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              // شريط علوي
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: previewTheme.surface,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '#${color.value.toRadixString(16).toUpperCase()}',
                        style: TextStyle(
                          color: previewTheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: previewTheme.onSurface),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
              ),
              // المعاينة
              Expanded(
                child: ThemePreview(theme: previewTheme, isEnglish: false),
              ),
              // أزرار التحكم
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: previewTheme.surface,
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('إلغاء'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          widget.onColorSelected(color);
                          Navigator.pop(ctx);
                        },
                        child: const Text('تطبيق'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('مكتبة الألوان'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _filterColors(),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن لون...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    itemBuilder: (ctx, i) {
                      final cat = _categories[i];
                      final selected = cat == _selectedCategory;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(cat),
                          selected: selected,
                          onSelected: (_) {
                            setState(() => _selectedCategory = cat);
                            _filterColors();
                          },
                          selectedColor: Colors.purple,
                          backgroundColor: Colors.white10,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: _selectedColor,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white24),
            ),
            child: Center(
              child: Text(
                '#${_selectedColor.value.toRadixString(16).toUpperCase()}',
                style: TextStyle(
                  color: _selectedColor.computeLuminance() > 0.5 ? Colors.black : Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: _filteredColors.length,
              itemBuilder: (ctx, i) {
                final color = _filteredColors[i];
                final isSelected = color.value == _selectedColor.value;
                return GestureDetector(
                  onTap: () {
                    setState(() => _selectedColor = color);
                    _showPreviewDialog(color);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected ? Colors.white : Colors.transparent,
                        width: 3,
                      ),
                      boxShadow: isSelected
                          ? [BoxShadow(color: color.withOpacity(0.6), blurRadius: 10)]
                          : [],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 20)
                        : null,
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
