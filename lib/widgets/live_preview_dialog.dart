import 'package:flutter/material.dart';
import '../models/futo_theme.dart';

class LivePreviewDialog extends StatefulWidget {
  final FutoTheme theme;
  final String title;
  final Function(FutoTheme) onApply;
  final bool isEnglish;

  const LivePreviewDialog({
    super.key,
    required this.theme,
    required this.title,
    required this.onApply,
    this.isEnglish = false,
  });

  @override
  State<LivePreviewDialog> createState() => _LivePreviewDialogState();
}

class _LivePreviewDialogState extends State<LivePreviewDialog> {
  late FutoTheme _theme;

  @override
  void initState() {
    super.initState();
    _theme = widget.theme;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(10),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: _theme.background,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: [
            // شريط علوي
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _theme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Icon(Icons.preview, color: _theme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.title,
                      style: TextStyle(
                        color: _theme.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: _theme.onSurface),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // المعاينة الحية
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildKeyboardPreview(),
                  ],
                ),
              ),
            ),

            // أزرار التحكم
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _theme.surface,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: _theme.outline),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'إلغاء',
                        style: TextStyle(color: _theme.onSurface),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        widget.onApply(_theme);
                        Navigator.pop(context);
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: _theme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'تطبيق',
                        style: TextStyle(color: _theme.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKeyboardPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _theme.keyboardSurface,
        borderRadius: BorderRadius.circular(_theme.keyRadius * 2),
        border: Border.all(color: _theme.keyboardBorder, width: 2),
        image: _theme.backgroundImage != null && _theme.backgroundImage!.isNotEmpty
            ? DecorationImage(
                image: AssetImage(_theme.backgroundImage!),
                fit: BoxFit.cover,
                opacity: 0.3,
                onError: (_, __) {},
              )
            : null,
      ),
      child: Column(
        children: [
          // Hint Bar
          _buildHintBar(),
          const SizedBox(height: 4),
          // صف الأرقام
          _buildRow(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], isNumber: true),
          // الصفوف العربية
          if (widget.isEnglish)
              _buildRow(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'])
            else
              _buildRow(['ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح']),
          if (widget.isEnglish)
              _buildRow(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'])
            else
              _buildRow(['ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك']),
          if (widget.isEnglish)
              _buildRow(['z', 'x', 'c', 'v', 'b', 'n', 'm'])
            else
              _buildRow(['ئ', 'ء', 'ؤ', 'ر', 'لا', 'ى', 'ة', 'و', 'ز', 'ظ']),
          if (!widget.isEnglish)
              _buildRow(['ذ', 'د', 'ج', 'ح', 'خ', 'ه', 'ع', 'غ', 'ف', 'ق']),
          const SizedBox(height: 4),
          // الصف السفلي
          Row(
            children: [
              _buildKey('?123', isSpecial: true),
              _buildKey('،', isSpecial: true),
              _buildKey('☺', isSpecial: true),
              _buildKey(' ', flex: 4),
              _buildKey('.', isSpecial: true),
              _buildKey('⌫', isSpecial: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHintBar() {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: _theme.surface.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildHintKey('>'),
          _buildHintSuggestion('thus'),
          _buildHintSuggestion('the'),
          _buildHintSuggestion('"thr"'),
          const Spacer(),
          Icon(Icons.mic, color: _theme.onSurface, size: 16),
        ],
      ),
    );
  }

  Widget _buildHintKey(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: _theme.keyboardContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label, style: TextStyle(color: _theme.onKeyboard, fontSize: 10)),
    );
  }

  Widget _buildHintSuggestion(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: _theme.keyboardContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _theme.onKeyboard,
          fontSize: 10,
          fontFamily: _theme.fontFamily,
        ),
      ),
    );
  }

  Widget _buildRow(List<String> keys, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: keys.map((k) => _buildKey(k, isNumber: isNumber)).toList(),
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
        height: 42,
        decoration: BoxDecoration(
          color: hasImage ? Colors.transparent : baseColor,
          borderRadius: BorderRadius.circular(_theme.keyRadius),
          border: Border.all(color: _theme.keyboardBorder, width: 0.5),
        ),
        child: Stack(
          children: [
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
            Center(
              child: Text(
                label,
                style: TextStyle(
                  color: textColor,
                  fontFamily: _theme.fontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
