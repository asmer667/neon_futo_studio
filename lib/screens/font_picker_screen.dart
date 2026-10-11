import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FontPickerScreen extends StatefulWidget {
  final Function(String) onFontSelected;
  final String? currentFont;
  const FontPickerScreen({super.key, required this.onFontSelected, this.currentFont});

  @override
  State<FontPickerScreen> createState() => _FontPickerScreenState();
}

class _FontPickerScreenState extends State<FontPickerScreen> {
  String _selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = [
    'All', 'Sans Serif', 'Serif', 'Display', 'Handwriting', 'Monospace'
  ];

  // قائمة الخطوط المتاحة (اختيار من Google Fonts)
  final List<Map<String, String>> _fonts = [
    {'name': 'Cairo', 'family': 'Cairo', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Tajawal', 'family': 'Tajawal', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Roboto', 'family': 'Roboto', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Poppins', 'family': 'Poppins', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Amiri', 'family': 'Amiri', 'category': 'Serif', 'author': 'Google'},
    {'name': 'Montserrat', 'family': 'Montserrat', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Open Sans', 'family': 'OpenSans', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Lato', 'family': 'Lato', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Playfair Display', 'family': 'PlayfairDisplay', 'category': 'Display', 'author': 'Google'},
    {'name': 'Merriweather', 'family': 'Merriweather', 'category': 'Serif', 'author': 'Google'},
    {'name': 'Oswald', 'family': 'Oswald', 'category': 'Display', 'author': 'Google'},
    {'name': 'Raleway', 'family': 'Raleway', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Nunito', 'family': 'Nunito', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Ubuntu', 'family': 'Ubuntu', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Rubik', 'family': 'Rubik', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Noto Sans', 'family': 'NotoSans', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Work Sans', 'family': 'WorkSans', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Fira Sans', 'family': 'FiraSans', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Quicksand', 'family': 'Quicksand', 'category': 'Sans Serif', 'author': 'Google'},
    {'name': 'Bebas Neue', 'family': 'BebasNeue', 'category': 'Display', 'author': 'Google'},
    {'name': 'Dancing Script', 'family': 'DancingScript', 'category': 'Handwriting', 'author': 'Google'},
    {'name': 'Pacifico', 'family': 'Pacifico', 'category': 'Handwriting', 'author': 'Google'},
    {'name': 'Indie Flower', 'family': 'IndieFlower', 'category': 'Handwriting', 'author': 'Google'},
    {'name': 'Shadows Into Light', 'family': 'ShadowsIntoLight', 'category': 'Handwriting', 'author': 'Google'},
    {'name': 'Inconsolata', 'family': 'Inconsolata', 'category': 'Monospace', 'author': 'Google'},
    {'name': 'Roboto Mono', 'family': 'RobotoMono', 'category': 'Monospace', 'author': 'Google'},
    {'name': 'Source Code Pro', 'family': 'SourceCodePro', 'category': 'Monospace', 'author': 'Google'},
    {'name': 'JetBrains Mono', 'family': 'JetBrainsMono', 'category': 'Monospace', 'author': 'Google'},
  ];

  List<Map<String, String>> get _filteredFonts {
    return _fonts.where((f) {
      final matchCategory = _selectedCategory == 'All' || f['category'] == _selectedCategory;
      final matchSearch = _searchController.text.isEmpty ||
          f['name']!.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Font Picker')),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Search fonts...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white10,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          // التصنيفات
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _categories.length,
              itemBuilder: (ctx, i) {
                final cat = _categories[i];
                final selected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: selected,
                    onSelected: (_) => setState(() => _selectedCategory = cat),
                    selectedColor: Colors.purple,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          // قائمة الخطوط
          Expanded(
            child: ListView.builder(
              itemCount: _filteredFonts.length,
              itemBuilder: (ctx, i) {
                final font = _filteredFonts[i];
                final isSelected = widget.currentFont == font['family'];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    title: Text(
                      font['name']!,
                      style: TextStyle(
                        fontFamily: font['family'],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'AaBbCc 0123',
                      style: TextStyle(fontFamily: font['family'], fontSize: 16),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check, color: Colors.purple)
                        : Text(font['category']!, style: const TextStyle(fontSize: 10)),
                    onTap: () {
                      widget.onFontSelected(font['family']!);
                      Navigator.pop(context);
                    },
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
