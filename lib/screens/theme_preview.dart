import 'package:flutter/material.dart';
import '../models/futo_theme.dart';

class ThemePreview extends StatelessWidget {
  final FutoTheme theme;
  final bool isEnglish;

  const ThemePreview({super.key, required this.theme, this.isEnglish = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: theme.background,
      appBar: AppBar(
        title: Text(isEnglish ? 'Theme Preview' : 'معاينة الثيم'),
        backgroundColor: theme.surface,
        foregroundColor: theme.onSurface,
        actions: [
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ThemePreview(theme: theme, isEnglish: !isEnglish),
                ),
              );
            },
            tooltip: isEnglish ? 'العربية' : 'English',
          ),
        ],
      ),
      body: Column(
        children: [
          // معلومات الثيم
          Container(
            padding: const EdgeInsets.all(16),
            color: theme.surfaceVariant,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEnglish ? theme.name : theme.name,
                  style: TextStyle(
                    color: theme.onSurfaceVariant,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${isEnglish ? "Author" : "المؤلف"}: ${theme.author}',
                  style: TextStyle(color: theme.onSurfaceVariant, fontSize: 14),
                ),
                Text(
                  '${isEnglish ? "Font" : "الخط"}: ${theme.fontFamily}',
                  style: TextStyle(color: theme.onSurfaceVariant, fontSize: 14),
                ),
              ],
            ),
          ),
          // المعاينة
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildKeyboardPreview(),
                  const SizedBox(height: 20),
                  _buildButtonShowcase(),
                  const SizedBox(height: 20),
                  _buildTextShowcase(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyboardPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.keyboardSurface,
        borderRadius: BorderRadius.circular(theme.keyRadius * 2),
        border: Border.all(color: theme.keyboardBorder, width: 2),
      ),
      child: Column(
        children: [
          _buildRow(['ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح']),
          _buildRow(['ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك']),
          _buildRow(['ئ', 'ء', 'ؤ', 'ر', 'لا', 'ى', 'ة', 'و', 'ز', 'ظ']),
          _buildRow(['ذ', 'د', 'ج', 'ح', 'خ', 'ه', 'ع', 'غ', 'ف', 'ق']),
          const SizedBox(height: 8),
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

  Widget _buildRow(List<String> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: keys.map((k) => _buildKey(k)).toList(),
      ),
    );
  }

  Widget _buildKey(String label, {int flex = 1, bool isSpecial = false}) {
    final color = isSpecial ? theme.keyboardPrimary : theme.keyboardContainer;
    final textColor = isSpecial ? theme.keyboardOnPrimary : theme.onKeyboard;
    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(2),
        height: 50,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(theme.keyRadius),
          border: Border.all(color: theme.keyboardBorder, width: 0.5),
          boxShadow: [
            BoxShadow(
              color: theme.keyboardShadow,
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: textColor,
              fontFamily: theme.fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish ? 'Buttons' : 'الأزرار',
          style: TextStyle(
            color: theme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildChip(isEnglish ? 'Primary' : 'أساسي', theme.primary, theme.onPrimary),
            _buildChip(isEnglish ? 'Secondary' : 'ثانوي', theme.secondary, theme.onSecondary),
            _buildChip(isEnglish ? 'Tertiary' : 'ثالثي', theme.tertiary, theme.onTertiary),
            _buildChip(isEnglish ? 'Error' : 'خطأ', theme.error, theme.onError),
          ],
        ),
      ],
    );
  }

  Widget _buildChip(String label, Color bg, Color fg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(theme.keyRadius * 2),
      ),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTextShowcase() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isEnglish ? 'Typography' : 'الخطوط',
          style: TextStyle(
            color: theme.onBackground,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          isEnglish ? 'The quick brown fox jumps over the lazy dog' : 'نص تجريبي باللغة العربية لمعاينة الخط',
          style: TextStyle(
            color: theme.onBackground,
            fontFamily: theme.fontFamily,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          isEnglish ? 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' : 'أ ب ت ث ج ح خ د ذ ر ز س ش ص ض ط ظ ع غ ف ق ك ل م ن ه و ي',
          style: TextStyle(
            color: theme.onSurfaceVariant,
            fontFamily: theme.fontFamily,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
