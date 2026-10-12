import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/shape_data.dart';
import '../models/futo_theme.dart';
import '../widgets/live_preview_dialog.dart';

class KeyTypesScreen extends StatefulWidget {
  final String currentShape;
  final FutoTheme? theme;
  final bool isEnglish;
  final String title;
  final String type; // normal, pressed, functional, action
  final Function(String) onShapeSelected;

  const KeyTypesScreen({
    super.key,
    required this.currentShape,
    required this.title,
    required this.onShapeSelected,
    this.type = 'normal',
    this.theme,
    this.isEnglish = false,
  });

  @override
  State<KeyTypesScreen> createState() => _KeyTypesScreenState();
}

class _KeyTypesScreenState extends State<KeyTypesScreen> {
  // 0 = الأشكال البسيطة (500)
  // 1 = أزرار الثيمات القديمة (8000)
  // 2 = أزرار الثيمات الجديدة (10000)
  int _sourceTab = 0;
  String _selectedCategory = 'الكل';
  final TextEditingController _searchController = TextEditingController();

  // الأشكال البسيطة
  late List<ShapeItem> _allShapes;
  late List<ShapeItem> _filteredShapes;

  // أزرار الثيمات القديمة (v1)
  List<String> _allButtonsV1 = [];
  List<String> _filteredButtonsV1 = [];

  // أزرار الثيمات الجديدة (v2)
  List<String> _allButtonsV2 = [];
  List<String> _filteredButtonsV2 = [];

  bool _isLoading = true;

  final List<String> _shapeCategories = [
    'الكل', 'كلاسيكية', 'نجوم', 'قلوب', 'دوائر', 'سداسية',
    'ماسية', 'موجات', 'زهور', 'كريستال', 'ثلج', 'نار',
    'أوراق', 'أسهم', 'مربعة', 'مثلثة', 'معقدة', 'طبيعية',
  ];

  @override
  void initState() {
    super.initState();
    _allShapes = ShapeData.getAllShapes();
    _filteredShapes = _allShapes;
    _loadAllButtons();
  }

  Future<void> _loadAllButtons() async {
    try {
      // تحميل V1 (8000)
      final jsonStrV1 = await rootBundle.loadString('assets/key_buttons_data.json');
      final dataV1 = json.decode(jsonStrV1) as Map<String, dynamic>;
      _allButtonsV1 = (dataV1[widget.type] as List).cast<String>();
      _filteredButtonsV1 = _allButtonsV1;

      // تحميل V2 (10000)
      final jsonStrV2 = await rootBundle.loadString('assets/key_buttons_v2_data.json');
      final dataV2 = json.decode(jsonStrV2) as Map<String, dynamic>;
      _allButtonsV2 = (dataV2[widget.type] as List).cast<String>();
      _filteredButtonsV2 = _allButtonsV2;

      setState(() => _isLoading = false);
    } catch (e) {
      debugPrint('❌ خطأ: $e');
      setState(() => _isLoading = false);
    }
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

  void _filterButtonsV1() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredButtonsV1 = _allButtonsV1;
      } else {
        _filteredButtonsV1 = _allButtonsV1.where((b) => b.toLowerCase().contains(query)).toList();
      }
    });
  }

  void _filterButtonsV2() {
    setState(() {
      final query = _searchController.text.toLowerCase();
      if (query.isEmpty) {
        _filteredButtonsV2 = _allButtonsV2;
      } else {
        _filteredButtonsV2 = _allButtonsV2.where((b) => b.toLowerCase().contains(query)).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // التبويبات الرئيسية الثلاثة
                Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildSourceTab(0, 'الأشكال', Icons.category),
                      ),
                      Expanded(
                        child: _buildSourceTab(1, '8 آلاف', Icons.keyboard),
                      ),
                      Expanded(
                        child: _buildSourceTab(2, '10 آلاف', Icons.auto_awesome),
                      ),
                    ],
                  ),
                ),
                // المحتوى
                Expanded(
                  child: IndexedStack(
                    index: _sourceTab,
                    children: [
                      _buildShapesTab(),
                      _buildButtonsTab(isV2: false),
                      _buildButtonsTab(isV2: true),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSourceTab(int index, String label, IconData icon) {
    final selected = _sourceTab == index;
    return GestureDetector(
      onTap: () => setState(() => _sourceTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? Colors.purple.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.purple : Colors.grey, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.purple : Colors.grey,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== تبويب الأشكال البسيطة =====
  Widget _buildShapesTab() {
    return Column(
      children: [
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _shapeCategories.length,
            itemBuilder: (ctx, i) {
              final cat = _shapeCategories[i];
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
                  selectedColor: Colors.purple,
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
              final isSelected = widget.currentShape == shape.path;
              return GestureDetector(
                onTap: () {
                  if (widget.theme != null) {
                    final tempTheme = widget.theme!;
                    tempTheme.keyShape = shape.path;
                    showDialog(
                      context: context,
                      builder: (_) => LivePreviewDialog(
                        theme: tempTheme,
                        title: 'معاينة: ${shape.name}',
                        isEnglish: widget.isEnglish,
                        onApply: (newTheme) {
                          widget.onShapeSelected(shape.path);
                        },
                      ),
                    );
                  } else {
                    widget.onShapeSelected(shape.path);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.purple : Colors.white24,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
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
    );
  }

  // ===== تبويب أزرار الثيمات (v1 أو v2) =====
  Widget _buildButtonsTab({required bool isV2}) {
    final buttons = isV2 ? _filteredButtonsV2 : _filteredButtonsV1;
    final basePath = isV2 ? 'assets/key_buttons_v2' : 'assets/key_buttons';

    if (buttons.isEmpty) {
      return const Center(child: Text('لا توجد صور'));
    }

    return Column(
      children: [
        // شريط البحث
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _searchController,
            onChanged: (_) {
              if (isV2) {
                _filterButtonsV2();
              } else {
                _filterButtonsV1();
              }
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن زر...',
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
        // العدد
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            '${buttons.length} صورة',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: buttons.length,
            itemBuilder: (ctx, i) {
              final fileName = buttons[i];
              final path = '$basePath/${widget.type}/$fileName';
              final isSelected = widget.currentShape == path;

              return GestureDetector(
                onTap: () {
                  if (widget.theme != null) {
                    final tempTheme = widget.theme!;
                    tempTheme.keyShape = path;
                    showDialog(
                      context: context,
                      builder: (_) => LivePreviewDialog(
                        theme: tempTheme,
                        title: 'معاينة الزر',
                        isEnglish: widget.isEnglish,
                        onApply: (newTheme) {
                          widget.onShapeSelected(path);
                        },
                      ),
                    );
                  } else {
                    widget.onShapeSelected(path);
                    Navigator.pop(context);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.purple : Colors.white24,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4),
                    child: Image.asset(
                      path,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.broken_image,
                        color: Colors.white38,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
