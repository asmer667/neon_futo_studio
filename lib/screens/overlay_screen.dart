import 'package:flutter/material.dart';
import 'key_types_screen.dart';

class OverlayItem {
  String keyLabel;      // اسم الزر (مثلاً: "a", "ض", "space")
  String imagePath;     // مسار الصورة
  double size;          // الحجم (1.0 = 100%)
  double offsetX;       // الإزاحة الأفقية (-1.0 إلى 1.0)
  double offsetY;       // الإزاحة الرأسية
  double width;         // العرض النسبي
  double height;        // الارتفاع النسبي

  OverlayItem({
    required this.keyLabel,
    required this.imagePath,
    this.size = 0.5,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.width = 0.5,
    this.height = 0.5,
  });

  Map<String, dynamic> toJson() => {
    'keyLabel': keyLabel,
    'imagePath': imagePath,
    'size': size,
    'offsetX': offsetX,
    'offsetY': offsetY,
    'width': width,
    'height': height,
  };

  factory OverlayItem.fromJson(Map<String, dynamic> json) => OverlayItem(
    keyLabel: json['keyLabel'] ?? '',
    imagePath: json['imagePath'] ?? '',
    size: (json['size'] ?? 0.5).toDouble(),
    offsetX: (json['offsetX'] ?? 0.0).toDouble(),
    offsetY: (json['offsetY'] ?? 0.0).toDouble(),
    width: (json['width'] ?? 0.5).toDouble(),
    height: (json['height'] ?? 0.5).toDouble(),
  );
}

class OverlayScreen extends StatefulWidget {
  final List<Map<String, dynamic>> currentOverlays;
  final Function(List<Map<String, dynamic>>) onOverlaysUpdated;

  const OverlayScreen({
    super.key,
    required this.currentOverlays,
    required this.onOverlaysUpdated,
  });

  @override
  State<OverlayScreen> createState() => _OverlayScreenState();
}

class _OverlayScreenState extends State<OverlayScreen> {
  late List<OverlayItem> _overlays;

  // قائمة الأزرار المتاحة
  final List<String> _keyLabels = [
    // عربي
    'ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح',
    'ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك',
    'ئ', 'ء', 'ؤ', 'ر', 'لا', 'ى', 'ة', 'و', 'ز', 'ظ',
    'ذ', 'د', 'ج', 'خ', 'ه', 'ع', 'غ', 'ف', 'ق',
    // إنجليزي
    'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p',
    'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l',
    'z', 'x', 'c', 'v', 'b', 'n', 'm',
    // خاصة
    'space', 'enter', 'backspace', 'shift', 'emoji', '?123', '،', '.',
  ];

  @override
  void initState() {
    super.initState();
    _overlays = widget.currentOverlays
        .map((o) => OverlayItem.fromJson(o))
        .toList();
  }

  void _addOverlay() {
    setState(() {
      _overlays.add(OverlayItem(
        keyLabel: _keyLabels[0],
        imagePath: '',
      ));
    });
  }

  void _removeOverlay(int index) {
    setState(() => _overlays.removeAt(index));
  }

  void _save() {
    widget.onOverlaysUpdated(_overlays.map((o) => o.toJson()).toList());
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة شكل لأي زر'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addOverlay,
            tooltip: 'إضافة Overlay جديد',
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
            tooltip: 'حفظ',
          ),
        ],
      ),
      body: _overlays.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.layers, size: 80, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text('لا توجد Overlays'),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: _addOverlay,
                    icon: const Icon(Icons.add),
                    label: const Text('إضافة Overlay'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _overlays.length,
              itemBuilder: (ctx, i) {
                final overlay = _overlays[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.layers, color: Colors.purple),
                            const SizedBox(width: 8),
                            Text(
                              'Overlay ${i + 1}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeOverlay(i),
                            ),
                          ],
                        ),
                        const Divider(),

                        // اختيار الزر
                        DropdownButtonFormField<String>(
                          value: overlay.keyLabel,
                          decoration: const InputDecoration(labelText: 'الزر'),
                          items: _keyLabels.map((k) => DropdownMenuItem(
                            value: k,
                            child: Text(k),
                          )).toList(),
                          onChanged: (v) => setState(() => overlay.keyLabel = v!),
                        ),
                        const SizedBox(height: 12),

                        // اختيار الصورة
                        Card(
                          child: ListTile(
                            leading: overlay.imagePath.isNotEmpty
                                ? Image.asset(overlay.imagePath, width: 40, height: 40,
                                    errorBuilder: (_, __, ___) => const Icon(Icons.image))
                                : const Icon(Icons.add_photo_alternate),
                            title: Text(overlay.imagePath.isEmpty
                                ? 'لم يتم اختيار صورة'
                                : overlay.imagePath.split('/').last),
                            trailing: const Icon(Icons.edit),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => KeyTypesScreen(
                                    currentShape: overlay.imagePath,
                                    title: 'اختر صورة',
                                    type: 'normal',
                                    onShapeSelected: (path) {
                                      setState(() => overlay.imagePath = path);
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 12),

                        // الحجم
                        Text('الحجم: ${(overlay.size * 100).toInt()}%'),
                        Slider(
                          value: overlay.size,
                          min: 0.1,
                          max: 1.0,
                          divisions: 18,
                          onChanged: (v) => setState(() => overlay.size = v),
                        ),

                        // العرض
                        Text('العرض: ${(overlay.width * 100).toInt()}%'),
                        Slider(
                          value: overlay.width,
                          min: 0.1,
                          max: 1.0,
                          divisions: 18,
                          onChanged: (v) => setState(() => overlay.width = v),
                        ),

                        // الارتفاع
                        Text('الارتفاع: ${(overlay.height * 100).toInt()}%'),
                        Slider(
                          value: overlay.height,
                          min: 0.1,
                          max: 1.0,
                          divisions: 18,
                          onChanged: (v) => setState(() => overlay.height = v),
                        ),

                        // الإزاحة الأفقية
                        Text('الموضع الأفقي: ${overlay.offsetX.toStringAsFixed(2)}'),
                        Slider(
                          value: overlay.offsetX,
                          min: -1.0,
                          max: 1.0,
                          divisions: 20,
                          onChanged: (v) => setState(() => overlay.offsetX = v),
                        ),

                        // الإزاحة الرأسية
                        Text('الموضع الرأسي: ${overlay.offsetY.toStringAsFixed(2)}'),
                        Slider(
                          value: overlay.offsetY,
                          min: -1.0,
                          max: 1.0,
                          divisions: 20,
                          onChanged: (v) => setState(() => overlay.offsetY = v),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
