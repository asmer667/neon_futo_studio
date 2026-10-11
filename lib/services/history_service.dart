import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HistoryService {
  static const String _fileName = 'history.json';

  /// حفظ عملية جديدة
  static Future<void> addOperation(String name, String type, String size) async {
    final history = await getHistory();
    history.insert(0, {
      'name': name,
      'type': type,
      'size': size,
      'date': DateTime.now().toIso8601String(),
    });
    // الاحتفاظ بآخر 50 عملية فقط
    if (history.length > 50) history.removeRange(50, history.length);
    await _save(history);
  }

  /// الحصول على السجل
  static Future<List<Map<String, String>>> getHistory() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$_fileName');
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      final list = jsonDecode(content) as List;
      return list.map((e) => Map<String, String>.from(e)).toList();
    } catch (e) {
      return [];
    }
  }

  /// مسح السجل
  static Future<void> clearHistory() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    if (await file.exists()) await file.delete();
  }

  static Future<void> _save(List<Map<String, String>> history) async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$_fileName');
    await file.writeAsString(jsonEncode(history));
  }
}
