import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/futo_theme.dart';

class ThemeManager {
  static const String _fileName = 'saved_themes.json';

  /// حفظ ثيم جديد (يضيف، مع ضمان ID فريد)
  static Future<void> saveTheme(FutoTheme theme) async {
    final themes = await getSavedThemes();
    final map = theme.toTomlMap();

    // توليد ID فريد لكل ثيم
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final safeName = theme.name
        .replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_')
        .toLowerCase();
    map['id'] = 'com.neonfuto.theme.${safeName}_$timestamp';

    // التحقق إذا كان موجوداً بنفس الاسم → إضافة رقم
    String newName = theme.name;
    int counter = 1;
    while (themes.any((t) => t['name'] == newName)) {
      newName = '${theme.name} ($counter)';
      counter++;
    }
    map['name'] = newName;

    themes.insert(0, map);
    await _save(themes);
  }

  /// الحصول على كل الثيمات المحفوظة
  static Future<List<Map<String, dynamic>>> getSavedThemes() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_fileName');
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final list = jsonDecode(content) as List;
      return list.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// حذف ثيم
  static Future<void> deleteTheme(String name) async {
    final themes = await getSavedThemes();
    themes.removeWhere((t) => t['name'] == name);
    await _save(themes);
  }

  /// مسح كل الثيمات
  static Future<void> clearAll() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (await file.exists()) await file.delete();
  }

  static Future<void> _save(List<Map<String, dynamic>> themes) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    await file.writeAsString(jsonEncode(themes));
  }
}
