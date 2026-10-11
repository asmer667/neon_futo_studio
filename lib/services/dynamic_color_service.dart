import 'package:flutter/material.dart';

class DynamicColorService {
  /// استخراج اللون الأساسي من صورة (باستخدام متوسط البكسلات)
  /// ملاحظة: هذه طريقة مبسطة. للحصول على دقة أعلى، نحتاج إلى مكتبة palette_generator
  static Color extractPrimaryColor(Color? fallback) {
    // في المستقبل: يمكن استخدام palette_generator
    // حالياً نستخدم اللون الأساسي الثابت
    return fallback ?? const Color(0xFF6C63FF);
  }

  /// توليد لوحة ألوان كاملة من لون أساسي واحد
  static Map<String, Color> generatePalette(Color seed) {
    final hsl = HSLColor.fromColor(seed);

    return {
      'primary': seed,
      'onPrimary': seed.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      'primaryContainer': HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        (hsl.saturation * 0.7).clamp(0.0, 1.0),
        (hsl.lightness * 0.5).clamp(0.0, 1.0),
      ).toColor(),
      'onPrimaryContainer': seed.computeLuminance() > 0.5 ? Colors.black : Colors.white,
      'secondary': HSLColor.fromAHSL(
        1.0,
        (hsl.hue + 30) % 360,
        hsl.saturation,
        hsl.lightness,
      ).toColor(),
      'tertiary': HSLColor.fromAHSL(
        1.0,
        (hsl.hue + 60) % 360,
        hsl.saturation,
        hsl.lightness,
      ).toColor(),
      'background': HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        (hsl.saturation * 0.3).clamp(0.0, 1.0),
        0.05,
      ).toColor(),
      'surface': HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        (hsl.saturation * 0.4).clamp(0.0, 1.0),
        0.10,
      ).toColor(),
      'keyboardSurface': HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        (hsl.saturation * 0.4).clamp(0.0, 1.0),
        0.12,
      ).toColor(),
      'keyboardContainer': HSLColor.fromAHSL(
        1.0,
        hsl.hue,
        (hsl.saturation * 0.6).clamp(0.0, 1.0),
        (hsl.lightness * 0.8).clamp(0.0, 1.0),
      ).toColor(),
      'keyboardPrimary': seed,
      'keyboardOnPrimary': seed.computeLuminance() > 0.5 ? Colors.black : Colors.white,
    };
  }
}
