import 'package:flutter/material.dart';
import '../models/futo_theme.dart';

class BorderSettingsScreen extends StatefulWidget {
  final FutoTheme theme;
  final Function(FutoTheme) onThemeUpdated;

  const BorderSettingsScreen({
    super.key,
    required this.theme,
    required this.onThemeUpdated,
  });

  @override
  State<BorderSettingsScreen> createState() => _BorderSettingsScreenState();
}

class _BorderSettingsScreenState extends State<BorderSettingsScreen> {
  late int _left, _top, _right, _bottom;

  @override
  void initState() {
    super.initState();
    _left = widget.theme.borderLeftInset;
    _top = widget.theme.borderTopInset;
    _right = widget.theme.borderRightInset;
    _bottom = widget.theme.borderBottomInset;
  }

  void _save() {
    widget.theme.borderLeftInset = _left;
    widget.theme.borderTopInset = _top;
    widget.theme.borderRightInset = _right;
    widget.theme.borderBottomInset = _bottom;
    widget.onThemeUpdated(widget.theme);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات 9-Slicing'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            '9-Slicing للحدود',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'تسمح لك هذه الإعدادات بتحديد المناطق الثابتة من الصورة (الزوايا) التي لا تتمدد، بينما تتمدد الحواف والمركز حسب حجم الزر.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 25),

          // رسم توضيحي
          Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.purple, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                // خطوط تقسيم 9-slicing
                Positioned(
                  left: _left.toDouble(),
                  top: 0,
                  bottom: 0,
                  child: Container(width: 2, color: Colors.red),
                ),
                Positioned(
                  right: _right.toDouble(),
                  top: 0,
                  bottom: 0,
                  child: Container(width: 2, color: Colors.red),
                ),
                Positioned(
                  top: _top.toDouble(),
                  left: 0,
                  right: 0,
                  child: Container(height: 2, color: Colors.blue),
                ),
                Positioned(
                  bottom: _bottom.toDouble(),
                  left: 0,
                  right: 0,
                  child: Container(height: 2, color: Colors.blue),
                ),
                // المناطق الأربع
                Positioned(
                  left: 0, top: 0,
                  child: Container(width: _left.toDouble(), height: _top.toDouble(),
                      color: Colors.red.withOpacity(0.2)),
                ),
                Positioned(
                  right: 0, top: 0,
                  child: Container(width: _right.toDouble(), height: _top.toDouble(),
                      color: Colors.red.withOpacity(0.2)),
                ),
                Positioned(
                  left: 0, bottom: 0,
                  child: Container(width: _left.toDouble(), height: _bottom.toDouble(),
                      color: Colors.red.withOpacity(0.2)),
                ),
                Positioned(
                  right: 0, bottom: 0,
                  child: Container(width: _right.toDouble(), height: _bottom.toDouble(),
                      color: Colors.red.withOpacity(0.2)),
                ),
                // المركز
                Center(
                  child: Text('المركز\n(يتمدد)', textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white54, fontSize: 12)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Sliders
          _buildSlider('الهامش الأيسر (Left Inset)', _left, (v) => setState(() => _left = v.toInt())),
          _buildSlider('الهامش العلوي (Top Inset)', _top, (v) => setState(() => _top = v.toInt())),
          _buildSlider('الهامش الأيمن (Right Inset)', _right, (v) => setState(() => _right = v.toInt())),
          _buildSlider('الهامش السفلي (Bottom Inset)', _bottom, (v) => setState(() => _bottom = v.toInt())),

          const SizedBox(height: 30),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('حفظ الإعدادات'),
          ),
        ],
      ),
    );
  }

  Widget _buildSlider(String label, int value, Function(double) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value'),
        Slider(
          value: value.toDouble(),
          min: 0,
          max: 100,
          divisions: 100,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
