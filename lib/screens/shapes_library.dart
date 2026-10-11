import 'package:flutter/material.dart';
import '../models/shape_data.dart';

class ShapesLibrary extends StatefulWidget {
  final Function(String shapePath) onShapeSelected;
  const ShapesLibrary({super.key, required this.onShapeSelected});

  @override
  State<ShapesLibrary> createState() => _ShapesLibraryState();
}

class _ShapesLibraryState extends State<ShapesLibrary> {
  String _selectedCategory = 'الكل';
  late List<ShapeItem> _allShapes;
  late List<ShapeItem> _filteredShapes;

  final List<String> _categories = [
    'الكل', 'كلاسيكية', 'نجوم', 'قلوب', 'دوائر', 'سداسية',
    'ماسية', 'موجات', 'زهور', 'كريستال', 'ثلج', 'نار',
    'أوراق', 'أسهم', 'مربعة', 'مثلثة', 'معقدة', 'طبيعية',
    'كريستال 2', 'معدنية', 'ليلية', 'موسمية', 'حروف',
    'خاصة', 'خيالية', 'مجردة',
  ];

  @override
  void initState() {
    super.initState();
    _allShapes = ShapeData.getAllShapes();
    _filteredShapes = _allShapes;
  }

  void _filterShapes() {
    setState(() {
      if (_selectedCategory == 'الكل') {
        _filteredShapes = _allShapes;
      } else {
        _filteredShapes = _allShapes.where((s) => s.category == _selectedCategory).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مكتبة الأشكال (${_filteredShapes.length})'),
      ),
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
                    onSelected: (_) {
                      setState(() => _selectedCategory = cat);
                      _filterShapes();
                    },
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
                crossAxisCount: 4,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _filteredShapes.length,
              itemBuilder: (ctx, i) {
                final shape = _filteredShapes[i];
                return GestureDetector(
                  onTap: () {
                    widget.onShapeSelected(shape.path);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('تم اختيار ${shape.name}')),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        shape.path,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.broken_image,
                          color: Colors.white38,
                        ),
                      ),
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
