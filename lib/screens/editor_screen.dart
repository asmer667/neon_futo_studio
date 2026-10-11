import 'package:flutter/material.dart';
import 'colors_library.dart';
import 'shapes_library.dart';
import '../models/futo_theme.dart';
import '../core/translations.dart';
import '../services/zip_exporter.dart';
import 'border_settings_screen.dart';

class EditorScreen extends StatefulWidget {
  final FutoTheme? initialTheme;
  const EditorScreen({super.key, this.initialTheme});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late FutoTheme _theme;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _theme = widget.initialTheme ?? FutoTheme();
  }

  void _pickColor(Color current, Function(Color) onPick) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ColorsLibrary(
          initialColor: current,
          currentTheme: _theme,
          onColorSelected: (c) {
            setState(() => onPick(c));
          },
        ),
      ),
    );
  }

  void _pickShape() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShapesLibrary(
          onShapeSelected: (shapePath) {
            setState(() => _theme.keyShape = shapePath);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_theme.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {
              setState(() {
                AppTranslations.isEnglish = !AppTranslations.isEnglish;
              });
            },
            tooltip: AppTranslations.isEnglish ? 'العربية' : 'English',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () => _exportTheme(),
            tooltip: AppTranslations.get('export_zip'),
          ),
        ],
      ),
      body: Column(
        children: [
          // المعاينة الحية
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _theme.keyboardSurface,
                borderRadius: BorderRadius.circular(28),
                border: Border.all(color: _theme.keyboardBorder),
              ),
              child: Center(child: _buildKeyboardPreview()),
            ),
          ),
          // لوحة التحكم
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 0, label: Text('الألوان'), icon: Icon(Icons.palette)),
                        ButtonSegment(value: 1, label: Text('الشكل'), icon: Icon(Icons.category)),
                        ButtonSegment(value: 2, label: Text('الخط'), icon: Icon(Icons.text_fields)),
                      ],
                      selected: {_selectedTab},
                      onSelectionChanged: (s) => setState(() => _selectedTab = s.first),
                    ),
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _selectedTab,
                      children: [
                        _buildColorsTab(),
                        _buildShapeTab(),
                        _buildFontTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== تبويب الألوان =====
  Widget _buildColorsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _colorTile('اللون الأساسي (Primary)', _theme.primary, (c) => _theme.primary = c),
        _colorTile('أزرار عادية (Keyboard Container)', _theme.keyboardContainer, (c) => _theme.keyboardContainer = c),
        _colorTile('أزرار خاصة (Keyboard Primary)', _theme.keyboardPrimary, (c) => _theme.keyboardPrimary = c),
        _colorTile('خلفية اللوحة (Keyboard Surface)', _theme.keyboardSurface, (c) => _theme.keyboardSurface = c),
        _colorTile('لون النص (On Keyboard)', _theme.onKeyboard, (c) => _theme.onKeyboard = c),
        _colorTile('الحدود (Border)', _theme.keyboardBorder, (c) => _theme.keyboardBorder = c),
      ],
    );
  }

  Widget _colorTile(String label, Color current, Function(Color) onPick) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        title: Text(label),
        trailing: GestureDetector(
          onTap: () => _pickColor(current, onPick),
          child: Container(
            width: 45,
            height: 38,
            decoration: BoxDecoration(
              color: current,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
          ),
        ),
      ),
    );
  }

  // ===== تبويب الشكل =====
  Widget _buildShapeTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // عرض الشكل الحالي
          Card(
            child: ListTile(
              leading: _theme.keyShape.isNotEmpty && _theme.keyShape.startsWith('assets/')
                  ? Image.asset(_theme.keyShape, width: 40, height: 40, errorBuilder: (_, __, ___) => const Icon(Icons.category))
                  : const Icon(Icons.category),
              title: Text(_theme.keyShape.isEmpty
                  ? 'لم يتم اختيار شكل'
                  : 'الشكل: ${_theme.keyShape.split('/').last}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: _pickShape,
            ),
          ),
          const SizedBox(height: 16),
          // شريط حدة الأزرار
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('حدة الحواف: ${_theme.keyRadius.toStringAsFixed(1)}'),
                  Slider(
                    value: _theme.keyRadius,
                    min: 0,
                    max: 30,
                    onChanged: (v) => setState(() => _theme.keyRadius = v),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _pickShape,
            icon: const Icon(Icons.grid_view),
            label: const Text('فتح مكتبة الأشكال (500)'),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BorderSettingsScreen(
                    theme: _theme,
                    onThemeUpdated: (t) => setState(() {}),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.tune),
            label: const Text('إعدادات 9-Slicing'),
          ),
        ],
      ),
    );
  }

  // ===== تبويب الخط =====
  Widget _buildFontTab() {
    final fonts = ['Cairo', 'Tajawal', 'Roboto', 'Poppins'];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: fonts.map((f) {
        return RadioListTile<String>(
          title: Text(f, style: TextStyle(fontFamily: f)),
          value: f,
          groupValue: _theme.fontFamily,
          onChanged: (v) => setState(() => _theme.fontFamily = v!),
        );
      }).toList(),
    );
  }

  // ===== المعاينة =====
  Widget _buildKeyboardPreview() {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // صف الأرقام
          _buildRow(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], isNumberRow: true),
          const SizedBox(height: 2),
          // الصف الأول
          _buildRow(['ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح']),
          // الصف الثاني
          _buildRow(['ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك']),
          // الصف الثالث
          _buildRow(['ئ', 'ء', 'ؤ', 'ر', 'لا', 'ى', 'ة', 'و', 'ز', 'ظ']),
          // الصف الرابع
          _buildRow(['ذ', 'د', 'ج', 'ح', 'خ', 'ه', 'ع', 'غ', 'ف', 'ق']),
          const SizedBox(height: 4),
          // الصف الخامس (الأزرار الخاصة)
          Row(
            children: [
              _buildKey('123', isSpecial: true),
              _buildKey('،', isSpecial: true),
              _buildKey(' ', flex: 4),
              _buildKey('.', isSpecial: true),
              _buildKey('⌫', isSpecial: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> keys, {bool isNumberRow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: keys.map((k) => _buildKey(k, isNumber: isNumberRow)).toList(),
      ),
    );
  }

  Widget _buildKey(String label, {int flex = 1, bool isSpecial = false, bool isNumber = false}) {
    final baseColor = isSpecial
        ? _theme.keyboardPrimary
        : (isNumber ? _theme.keyboardContainer.withOpacity(0.7) : _theme.keyboardContainer);
    final textColor = isSpecial ? _theme.keyboardOnPrimary : _theme.onKeyboard;
    final hasImage = _theme.keyShape.isNotEmpty && _theme.keyShape.startsWith('assets/');

    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 38,
        decoration: BoxDecoration(
          color: hasImage ? Colors.transparent : baseColor,
          borderRadius: BorderRadius.circular(_theme.keyRadius),
          border: Border.all(color: _theme.keyboardBorder, width: 0.5),
        ),
        child: Stack(
          children: [
            // الصورة الحقيقية للزر (إن وجدت)
            if (hasImage)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(_theme.keyRadius),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      baseColor.withOpacity(0.6),
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      _theme.keyShape,
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) => Container(color: baseColor),
                    ),
                  ),
                ),
              ),
            // النص
            Center(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontFamily: _theme.fontFamily,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportTheme() async {
    final controller = TextEditingController(text: _theme.name);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text('تصدير الثيم'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'اسم الملف',
            hintText: 'my_theme',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: const Text('تصدير ZIP'),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        final exporter = ZipExporter();
        final path = await exporter.exportTheme(_theme, result);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('تم التصدير إلى: ' + path)),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('خطأ: ' + e.toString())),
          );
        }
      }
    }
  }
}
