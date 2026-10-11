class KeyButtonItem {
  final String name;
  final String path;
  final String type;

  KeyButtonItem({
    required this.name,
    required this.path,
    required this.type,
  });
}

class KeyButtonsData {
  /// قائمة بجميع الثيمات (2030 ثيم)
  /// كل ثيم له 4 صور: normal, pressed, functional, action
  static List<String> get _themeNames {
    // نستخرج الأسماء الفريدة من الصور
    // لكن لا يمكن قراءة المجلدات في وقت التشغيل بسهولة
    // لذا سنستخدم القائمة المولدة من shell
    return _allThemeNames;
  }

  /// قائمة بأسماء الثيمات (سيتم تحديثها لاحقاً)
  static List<String> get _allThemeNames {
    // قائمة مبدئية بأسماء الثيمات
    // يمكن توليدها تلقائياً في المستقبل
    return List.generate(2030, (i) {
      final num = (i + 1).toString().padLeft(4, '0');
      return '$num'; // اسم مؤقت
    });
  }

  static List<KeyButtonItem> getNormalButtons() {
    return _generateList('normal');
  }

  static List<KeyButtonItem> getPressedButtons() {
    return _generateList('pressed');
  }

  static List<KeyButtonItem> getFunctionalButtons() {
    return _generateList('functional');
  }

  static List<KeyButtonItem> getActionButtons() {
    return _generateList('action');
  }

  static List<KeyButtonItem> _generateList(String type) {
    final List<KeyButtonItem> items = [];
    for (int i = 1; i <= 500; i++) {
      final num = i.toString().padLeft(4, '0');
      items.add(KeyButtonItem(
        name: 'شكل $i',
        path: 'assets/key_buttons/$type/${num}_',
        type: type,
      ));
    }
    return items;
  }
}
