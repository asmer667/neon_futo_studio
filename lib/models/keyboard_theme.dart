import 'package:flutter/material.dart';

class KeyboardTheme {
  String name;
  Color layer1; // خلفية التطبيق
  Color layer2; // خلفية لوحة المفاتيح
  Color layer3; // لون الأزرار العادية
  Color layer4; // لون الأزرار الخاصة (Space, Enter)
  Color layer5; // لون النص
  Color layer6; // لون الحدود
  Color layer7; // لون الظل
  Color layer8; // لون التمييز (Highlight)
  double keyRadius;
  String fontFamily;
  String? backgroundImage;
  String keyShape; // circle, square, star, heart, hexagon, etc.

  KeyboardTheme({
    required this.name,
    this.layer1 = const Color(0xFF0F0F1A),
    this.layer2 = const Color(0xFF1A1A2E),
    this.layer3 = const Color(0xFF6C63FF),
    this.layer4 = const Color(0xFF00D2FF),
    this.layer5 = Colors.white,
    this.layer6 = Colors.white24,
    this.layer7 = Colors.black45,
    this.layer8 = const Color(0xFFFFD700),
    this.keyRadius = 8.0,
    this.fontFamily = 'Cairo',
    this.backgroundImage,
    this.keyShape = 'square',
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'layer1': layer1.value,
        'layer2': layer2.value,
        'layer3': layer3.value,
        'layer4': layer4.value,
        'layer5': layer5.value,
        'layer6': layer6.value,
        'layer7': layer7.value,
        'layer8': layer8.value,
        'keyRadius': keyRadius,
        'fontFamily': fontFamily,
        'backgroundImage': backgroundImage,
        'keyShape': keyShape,
      };

  factory KeyboardTheme.fromJson(Map<String, dynamic> json) => KeyboardTheme(
        name: json['name'],
        layer1: Color(json['layer1']),
        layer2: Color(json['layer2']),
        layer3: Color(json['layer3']),
        layer4: Color(json['layer4']),
        layer5: Color(json['layer5']),
        layer6: Color(json['layer6']),
        layer7: Color(json['layer7']),
        layer8: Color(json['layer8']),
        keyRadius: json['keyRadius'].toDouble(),
        fontFamily: json['fontFamily'],
        backgroundImage: json['backgroundImage'],
        keyShape: json['keyShape'] ?? 'square',
      );
}

// ثيمات جاهزة
class PresetThemes {
  static List<KeyboardTheme> get all => [
        KeyboardTheme(
          name: 'ثيم القلوب',
          layer2: const Color(0xFF2D1B2E),
          layer3: const Color(0xFFE91E63),
          layer4: const Color(0xFFFF4081),
          layer5: Colors.white,
          layer8: const Color(0xFFFF80AB),
          keyShape: 'heart',
          keyRadius: 20,
        ),
        KeyboardTheme(
          name: 'ثيم النجوم',
          layer2: const Color(0xFF1A1A3E),
          layer3: const Color(0xFFFFD700),
          layer4: const Color(0xFFFFA000),
          layer5: Colors.black,
          layer8: const Color(0xFFFFF176),
          keyShape: 'star',
          keyRadius: 15,
        ),
        KeyboardTheme(
          name: 'ثيم الدوائر',
          layer2: const Color(0xFF1B2E1B),
          layer3: const Color(0xFF4CAF50),
          layer4: const Color(0xFF81C784),
          layer5: Colors.white,
          layer8: const Color(0xFFA5D6A7),
          keyShape: 'circle',
          keyRadius: 30,
        ),
        KeyboardTheme(
          name: 'ثيم السداسي',
          layer2: const Color(0xFF2E1B1B),
          layer3: const Color(0xFFFF5722),
          layer4: const Color(0xFFFF8A65),
          layer5: Colors.white,
          layer8: const Color(0xFFFFAB91),
          keyShape: 'hexagon',
          keyRadius: 10,
        ),
        KeyboardTheme(
          name: 'ثيم الماس',
          layer2: const Color(0xFF1B1B2E),
          layer3: const Color(0xFF9C27B0),
          layer4: const Color(0xFFBA68C8),
          layer5: Colors.white,
          layer8: const Color(0xFFCE93D8),
          keyShape: 'diamond',
          keyRadius: 12,
        ),
        KeyboardTheme(
          name: 'ثيم الثلج',
          layer2: const Color(0xFF1B2E3E),
          layer3: const Color(0xFF00BCD4),
          layer4: const Color(0xFF4DD0E1),
          layer5: Colors.white,
          layer8: const Color(0xFF80DEEA),
          keyShape: 'snowflake',
          keyRadius: 18,
        ),
      ];
}
