import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class KeyTypesScreen extends StatefulWidget {
  final String currentShape;
  final String title;
  final String type; // normal, pressed, functional, action
  final Function(String) onShapeSelected;

  const KeyTypesScreen({
    super.key,
    required this.currentShape,
    required this.title,
    required this.onShapeSelected,
    this.type = 'normal',
  });

  @override
  State<KeyTypesScreen> createState() => _KeyTypesScreenState();
}

class _KeyTypesScreenState extends State<KeyTypesScreen> {
  List<String> _allImages = [];
  List<String> _filteredImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    try {
      final jsonStr = await rootBundle.loadString('assets/key_buttons_data.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;
      final images = (data[widget.type] as List).cast<String>();

      setState(() {
        _allImages = images;
        _filteredImages = images;
        _isLoading = false;
      });

      debugPrint('✅ تم تحميل ${images.length} صورة من نوع ${widget.type}');
    } catch (e) {
      debugPrint('❌ خطأ: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} (${_filteredImages.length})'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredImages.isEmpty
              ? const Center(child: Text('لا توجد صور'))
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: _filteredImages.length,
                  itemBuilder: (ctx, i) {
                    final fileName = _filteredImages[i];
                    final path = 'assets/key_buttons/${widget.type}/$fileName';
                    final isSelected = widget.currentShape == path;

                    return GestureDetector(
                      onTap: () {
                        widget.onShapeSelected(path);
                        Navigator.pop(context);
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
                          padding: const EdgeInsets.all(4.0),
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
    );
  }
}
