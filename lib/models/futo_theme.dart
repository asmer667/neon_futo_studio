import 'package:flutter/material.dart';

/// نموذج الثيم المتوافق مع FUTO Keyboard
/// يحتوي على 44 لوناً رسمياً + إعدادات إضافية
class FutoTheme {
  String name;
  String author;
  String description;
  String id;
  String version;
  bool autoBorders;
  bool centerHints;
  double scaleText;
  int weightText;
  double keyRadius;
  // 9-slicing insets (هوامش التمدد)
  int borderLeftInset;
  int borderTopInset;
  int borderRightInset;
  int borderBottomInset;
  String fontFamily;
  String? fontPath;
  String keyShape;
  String normalShape;      // شكل الأزرار العادية
  String functionalShape;  // شكل الأزرار الوظيفية (Shift, Backspace, Enter)
  String actionShape;      // شكل أزرار الإجراءات
  String pressedShape;     // شكل الأزرار المضغوطة
  String? backgroundImage;
  List<Color>? gradientColors;
  bool useGradient;
  int autoMode;
  double backgroundOpacity;
  double actionBarOpacity;
  List<double>? cropRect; // [left, top, right, bottom] // 0=تلقائي, 1=حسب النظام, 2=لون تفاعلي, 3=داكن
  String? borderImage;
  Map<String, String> customAssets;

  // 44 لوناً رسمياً (سنملأها بالقيم الافتراضية)
  // الألوان الأساسية
  Color primary;
  Color onPrimary;
  Color primaryContainer;
  Color onPrimaryContainer;
  Color secondary;
  Color onSecondary;
  Color secondaryContainer;
  Color onSecondaryContainer;
  Color tertiary;
  Color onTertiary;
  Color tertiaryContainer;
  Color onTertiaryContainer;
  Color error;
  Color onError;
  Color errorContainer;
  Color onErrorContainer;
  Color background;
  Color onBackground;
  Color surface;
  Color onSurface;
  Color surfaceVariant;
  Color onSurfaceVariant;
  Color outline;
  Color outlineVariant;
  Color shadow;
  Color scrim;
  Color inverseSurface;
  Color inverseOnSurface;
  Color inversePrimary;
  Color keyboardSurface;
  Color keyboardContainer;
  Color onKeyboard;
  Color onKeyboardContainer;
  Color keyboardPrimary;
  Color keyboardOnPrimary;
  Color keyboardSecondary;
  Color keyboardOnSecondary;
  Color keyboardTertiary;
  Color keyboardOnTertiary;
  Color keyboardError;
  Color keyboardOnError;
  Color keyboardShadow;
  Color keyboardBorder;
  Color keyboardRipple;
  Color surfaceTint;
  Color surfaceBright;
  Color surfaceDim;
  Color surfaceContainer;
  Color surfaceContainerHigh;
  Color surfaceContainerHighest;
  Color surfaceContainerLow;
  Color surfaceContainerLowest;
  Color keyboardSurfaceVariant;
  Color keyboardContainerVariant;


  FutoTheme({
    this.name = 'ثيم جديد',
    this.author = 'NEON FUTO STUDIO',
    this.description = '',
    this.id = 'com.neonfuto.theme',
    this.version = '1.0',
    this.autoBorders = true,
    this.centerHints = false,
    this.scaleText = 1.0,
    this.weightText = 400,
    this.keyRadius = 8.0,
    this.borderLeftInset = 20,
    this.borderTopInset = 20,
    this.borderRightInset = 20,
    this.borderBottomInset = 20,
    this.fontFamily = 'Cairo',
    this.fontPath,
    this.keyShape = '',
    this.normalShape = '',
    this.functionalShape = '',
    this.actionShape = '',
    this.pressedShape = '',
    this.backgroundImage,
    this.gradientColors,
    this.useGradient = false,
    this.autoMode = 0,
    this.backgroundOpacity = 1.0,
    this.actionBarOpacity = 0.5,
    this.cropRect,
    this.borderImage,
    this.customAssets = const {},
    // الألوان الافتراضية
    this.primary = const Color(0xFF6C63FF),
    this.onPrimary = Colors.white,
    this.primaryContainer = const Color(0xFF3D3A7A),
    this.onPrimaryContainer = Colors.white,
    this.secondary = const Color(0xFF00D2FF),
    this.onSecondary = Colors.black,
    this.secondaryContainer = const Color(0xFF006B80),
    this.onSecondaryContainer = Colors.white,
    this.tertiary = const Color(0xFFFF6B9D),
    this.onTertiary = Colors.white,
    this.tertiaryContainer = const Color(0xFF7A2E4A),
    this.onTertiaryContainer = Colors.white,
    this.error = const Color(0xFFCF6679),
    this.onError = Colors.black,
    this.errorContainer = const Color(0xFF8B0000),
    this.onErrorContainer = Colors.white,
    this.background = const Color(0xFF0F0F1A),
    this.onBackground = Colors.white,
    this.surface = const Color(0xFF1A1A2E),
    this.onSurface = Colors.white,
    this.surfaceVariant = const Color(0xFF252540),
    this.onSurfaceVariant = Colors.white70,
    this.outline = const Color(0xFF6C63FF),
    this.outlineVariant = const Color(0xFF3D3A7A),
    this.shadow = Colors.black,
    this.scrim = Colors.black54,
    this.inverseSurface = const Color(0xFFE0E0E0),
    this.inverseOnSurface = const Color(0xFF1A1A2E),
    this.inversePrimary = const Color(0xFF9C8FFF),
    this.keyboardSurface = const Color(0xFF1A1A2E),
    this.keyboardContainer = const Color(0xFF252540),
    this.onKeyboard = Colors.white,
    this.onKeyboardContainer = Colors.white70,
    this.keyboardPrimary = const Color(0xFF6C63FF),
    this.keyboardOnPrimary = Colors.white,
    this.keyboardSecondary = const Color(0xFF00D2FF),
    this.keyboardOnSecondary = Colors.black,
    this.keyboardTertiary = const Color(0xFFFF6B9D),
    this.keyboardOnTertiary = Colors.white,
    this.keyboardError = const Color(0xFFCF6679),
    this.keyboardOnError = Colors.black,
    this.keyboardShadow = Colors.black45,
    this.keyboardBorder = Colors.white24,
    this.keyboardRipple = const Color(0x33FFFFFF),
    this.surfaceTint = const Color(0xFF6C63FF),
    this.surfaceBright = const Color(0xFF3A3A5A),
    this.surfaceDim = const Color(0xFF0F0F1A),
    this.surfaceContainer = const Color(0xFF1A1A2E),
    this.surfaceContainerHigh = const Color(0xFF252540),
    this.surfaceContainerHighest = const Color(0xFF303050),
    this.surfaceContainerLow = const Color(0xFF15152A),
    this.surfaceContainerLowest = const Color(0xFF0A0A15),
    this.keyboardSurfaceVariant = const Color(0xFF252540),
    this.keyboardContainerVariant = const Color(0xFF303050),

  });

  /// تحويل الثيم إلى Map للتصدير بصيغة TOML
  Map<String, dynamic> toTomlMap() {
    return {
      'version': version,
      'name': name,
      'author': author,
      'id': id,
      'options': {
        'auto_borders': autoBorders,
        'center_hints': centerHints,
        'scale_text': scaleText,
        'weight_text': weightText,
      },
      'colors': {
        'primary': _colorToHex(primary),
        'on_primary': _colorToHex(onPrimary),
        'primary_container': _colorToHex(primaryContainer),
        'on_primary_container': _colorToHex(onPrimaryContainer),
        'secondary': _colorToHex(secondary),
        'on_secondary': _colorToHex(onSecondary),
        'secondary_container': _colorToHex(secondaryContainer),
        'on_secondary_container': _colorToHex(onSecondaryContainer),
        'tertiary': _colorToHex(tertiary),
        'on_tertiary': _colorToHex(onTertiary),
        'tertiary_container': _colorToHex(tertiaryContainer),
        'on_tertiary_container': _colorToHex(onTertiaryContainer),
        'error': _colorToHex(error),
        'on_error': _colorToHex(onError),
        'error_container': _colorToHex(errorContainer),
        'on_error_container': _colorToHex(onErrorContainer),
        'background': _colorToHex(background),
        'on_background': _colorToHex(onBackground),
        'surface': _colorToHex(surface),
        'on_surface': _colorToHex(onSurface),
        'surface_variant': _colorToHex(surfaceVariant),
        'on_surface_variant': _colorToHex(onSurfaceVariant),
        'outline': _colorToHex(outline),
        'outline_variant': _colorToHex(outlineVariant),
        'shadow': _colorToHex(shadow),
        'scrim': _colorToHex(scrim),
        'inverse_surface': _colorToHex(inverseSurface),
        'inverse_on_surface': _colorToHex(inverseOnSurface),
        'inverse_primary': _colorToHex(inversePrimary),
        'keyboard_surface': _colorToHex(keyboardSurface),
        'keyboard_container': _colorToHex(keyboardContainer),
        'on_keyboard': _colorToHex(onKeyboard),
        'on_keyboard_container': _colorToHex(onKeyboardContainer),
        'keyboard_primary': _colorToHex(keyboardPrimary),
        'keyboard_on_primary': _colorToHex(keyboardOnPrimary),
        'keyboard_secondary': _colorToHex(keyboardSecondary),
        'keyboard_on_secondary': _colorToHex(keyboardOnSecondary),
        'keyboard_tertiary': _colorToHex(keyboardTertiary),
        'keyboard_on_tertiary': _colorToHex(keyboardOnTertiary),
        'keyboard_error': _colorToHex(keyboardError),
        'keyboard_on_error': _colorToHex(keyboardOnError),
        'keyboard_shadow': _colorToHex(keyboardShadow),
        'keyboard_border': _colorToHex(keyboardBorder),
        'keyboard_ripple': _colorToHex(keyboardRipple),
      },
    };
  }

  static String _colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }
}
