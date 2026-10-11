import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';

class AssetsScreen extends StatefulWidget {
  final Function(String type, String path) onAssetSelected;
  final String? currentBackground;
  final String? currentFont;

  const AssetsScreen({
    super.key,
    required this.onAssetSelected,
    this.currentBackground,
    this.currentFont,
  });

  @override
  State<AssetsScreen> createState() => _AssetsScreenState();
}

class _AssetsScreenState extends State<AssetsScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _selectedBackground;
  String? _selectedFont;

  final List<Map<String, String>> _presetFonts = [
    {'name': 'Cairo', 'family': 'Cairo'},
    {'name': 'Tajawal', 'family': 'Tajawal'},
    {'name': 'Roboto', 'family': 'Roboto'},
    {'name': 'Poppins', 'family': 'Poppins'},
    {'name': 'Amiri', 'family': 'Amiri'},
    {'name': 'Montserrat', 'family': 'Montserrat'},
  ];

  Future<void> _pickCustomBackground() async {
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _selectedBackground = image.path);
        widget.onAssetSelected('background', image.path);
        _showSnack('✅ تم اختيار الخلفية');
      }
    } catch (e) {
      _showSnack('خطأ: $e');
    }
  }

  Future<void> _pickCustomFont() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['ttf', 'otf'],
      );
      if (result != null && result.files.single.path != null) {
        setState(() => _selectedFont = result.files.single.path);
        widget.onAssetSelected('font', result.files.single.path!);
        _showSnack('✅ تم اختيار الخط: ${result.files.single.name}');
      }
    } catch (e) {
      _showSnack('خطأ: $e');
    }
  }

  void _showSnack(String msg) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إدارة الأصول (Assets)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ===== قسم الخلفيات =====
          _sectionTitle('الخلفيات', Icons.wallpaper),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: _selectedBackground != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(_selectedBackground!),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.image, size: 50),
                      ),
                    )
                  : const Icon(Icons.image, size: 50),
              title: Text(_selectedBackground == null
                  ? 'لم يتم اختيار خلفية'
                  : 'خلفية مخصصة'),
              subtitle: const Text('اضغط لاختيار خلفية من المعرض'),
              trailing: const Icon(Icons.upload),
              onTap: _pickCustomBackground,
            ),
          ),

          const Divider(height: 40),

          // ===== قسم الخطوط =====
          _sectionTitle('الخطوط', Icons.text_fields),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.upload_file, size: 40),
              title: Text(_selectedFont == null
                  ? 'لم يتم اختيار خط'
                  : 'خط مخصص: ${_selectedFont!.split('/').last}'),
              subtitle: const Text('اضغط لاختيار ملف خط (TTF/OTF) من الهاتف'),
              trailing: const Icon(Icons.upload),
              onTap: _pickCustomFont,
            ),
          ),
          const SizedBox(height: 10),
          const Text('خطوط جاهزة:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          ..._presetFonts.map((font) {
            return Card(
              child: ListTile(
                leading: Text('Aa', style: TextStyle(fontFamily: font['family'], fontSize: 24)),
                title: Text(font['name']!),
                trailing: IconButton(
                  icon: const Icon(Icons.check),
                  onPressed: () {
                    setState(() => _selectedFont = font['family']);
                    widget.onAssetSelected('font_preset', font['family']!);
                  },
                ),
              ),
            );
          }).toList(),

          const Divider(height: 40),

          // ===== قسم الأشكال المرفوعة =====
          _sectionTitle('أشكال مخصصة', Icons.category),
          const SizedBox(height: 10),
          Card(
            child: ListTile(
              leading: const Icon(Icons.upload_file, size: 40),
              title: const Text('رفع شكل مخصص'),
              subtitle: const Text('رفع صورة PNG لاستخدامها كشكل زر'),
              trailing: const Icon(Icons.upload),
              onTap: () async {
                final image = await _imagePicker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  widget.onAssetSelected('shape', image.path);
                  _showSnack('✅ تم اختيار الشكل');
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
