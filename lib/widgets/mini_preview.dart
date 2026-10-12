import 'package:flutter/material.dart';
import '../models/futo_theme.dart';

class MiniPreview extends StatelessWidget {
  final FutoTheme theme;
  final double height;
  final bool isEnglish;

  const MiniPreview({
    super.key,
    required this.theme,
    this.height = 200,
    this.isEnglish = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.keyboardSurface,
        borderRadius: BorderRadius.circular(theme.keyRadius * 2),
        border: Border.all(color: theme.keyboardBorder, width: 1),
        image: theme.backgroundImage != null && theme.backgroundImage!.isNotEmpty
            ? DecorationImage(
                image: AssetImage(theme.backgroundImage!),
                fit: BoxFit.cover,
                opacity: 0.3,
                onError: (_, __) {},
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: isEnglish
            ? _buildEnglishRows()
            : _buildArabicRows(),
      ),
    );
  }

  List<Widget> _buildArabicRows() {
    return [
      _buildRow(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], isNumber: true),
      _buildRow(['ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح']),
      _buildRow(['ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك']),
      _buildRow(['ئ', 'ء', 'ؤ', 'ر', 'لا', 'ى', 'ة', 'و', 'ز', 'ظ']),
      const SizedBox(height: 3),
      Row(
        children: [
          _buildKey('?123', isSpecial: true),
          _buildKey(' ', flex: 3),
          _buildKey('⌫', isSpecial: true),
        ],
      ),
    ];
  }

  List<Widget> _buildEnglishRows() {
    return [
      _buildRow(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], isNumber: true),
      _buildRow(['q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p']),
      _buildRow(['a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l']),
      _buildRow(['z', 'x', 'c', 'v', 'b', 'n', 'm']),
      const SizedBox(height: 3),
      Row(
        children: [
          _buildKey('?123', isSpecial: true),
          _buildKey(' ', flex: 3),
          _buildKey('⌫', isSpecial: true),
        ],
      ),
    ];
  }

  Widget _buildRow(List<String> keys, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: keys.map((k) => _buildKey(k, isNumber: isNumber)).toList(),
      ),
    );
  }

  Widget _buildKey(String label, {int flex = 1, bool isSpecial = false, bool isNumber = false}) {
    final baseColor = isSpecial
        ? theme.keyboardPrimary
        : (isNumber ? theme.keyboardContainer.withOpacity(0.7) : theme.keyboardContainer);
    final textColor = isSpecial ? theme.keyboardOnPrimary : theme.onKeyboard;
    final hasImage = theme.keyShape.isNotEmpty && theme.keyShape.startsWith('assets/');

    return Expanded(
      flex: flex,
      child: Container(
        margin: const EdgeInsets.all(1.5),
        height: 26,
        decoration: BoxDecoration(
          color: hasImage ? Colors.transparent : baseColor,
          borderRadius: BorderRadius.circular(theme.keyRadius / 1.5),
          border: Border.all(color: theme.keyboardBorder, width: 0.3),
        ),
        child: Stack(
          children: [
            if (hasImage)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(theme.keyRadius / 1.5),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      baseColor.withOpacity(0.6),
                      BlendMode.srcATop,
                    ),
                    child: Image.asset(
                      theme.keyShape,
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
                  fontFamily: _getFontFamily(),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFontFamily() {
    final font = theme.fontFamily;
    // الخطوط اللاتينية لا تدعم العربية → نستخدم Cairo
    if (['Roboto', 'Poppins', 'Montserrat', 'Open Sans', 'Lato', 'Inter',
         'Oswald', 'Raleway', 'Nunito', 'Ubuntu', 'Rubik', 'Work Sans',
         'Fira Sans', 'Quicksand', 'Mulish', 'Karla', 'Manrope', 'DM Sans',
         'Outfit', 'Sora', 'Space Grotesk'].contains(font)) {
      return 'Cairo';
    }
    return font;
  }
}
