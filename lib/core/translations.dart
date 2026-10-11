class AppTranslations {
  static bool isEnglish = false;

  static String get(String key) {
    if (isEnglish) return _en[key] ?? key;
    return _ar[key] ?? key;
  }

  static final Map<String, String> _ar = {
    // عام
    'app_title': 'NEON FUTO STUDIO',
    'save': 'حفظ',
    'cancel': 'إلغاء',
    'apply': 'تطبيق',
    'close': 'إغلاق',
    'delete': 'حذف',
    'edit': 'تعديل',
    'add': 'إضافة',
    'search': 'ابحث...',
    'all': 'الكل',
    'error': 'خطأ',
    'success': 'نجاح',
    'loading': 'جاري التحميل...',

    // التنقل
    'keyboard': 'المفاتيح',
    'colors': 'الألوان',
    'shapes': 'الأشكال',
    'backgrounds': 'الخلفيات',
    'assets': 'الأصول',
    'export': 'تصدير',
    'presets': 'جاهزة',
    'themes': 'المظهر',

    // المحرر
    'matchrules': 'Matchrules',
    'assets_tab': 'Assets',
    'config': 'Config',
    'border_matchrules': 'BORDER MATCHRULES',
    'icon_matchrules': 'ICON MATCHRULES',
    'border_assets': 'BORDER ASSETS',
    'icon_assets': 'ICON ASSETS',
    'other_assets': 'OTHER ASSETS',
    'manual_colors': 'MANUAL COLORS',
    'metadata': 'METADATA',
    'keyboard_section': 'KEYBOARD',
    'key_text': 'KEY TEXT',
    'background_image': 'BACKGROUND IMAGE',
    'font_section': 'FONT',

    // الإعدادات
    'key_borders': 'حدود المفاتيح',
    'roundedness': 'الحدة',
    'center_hints': 'تلميحات مركزية',
    'text_scale': 'حجم النص',
    'hint_scale': 'حجم التلميحات',
    'text_weight': 'وزن النص',
    'hint_weight': 'وزن التلميحات',
    'opacity': 'الشفافية',
    'action_bar_opacity': 'شفافية شريط الإجراءات',
    'crop': 'قص',
    'browse_google_fonts': 'تصفح خطوط Google',
    'generate_rectangle': 'توليد مستطيل',
    'description': 'الوصف',
    'author': 'المؤلف',
    'version': 'الإصدار',
    'name': 'الاسم',
    'id': 'المعرف',

    // التدرجات
    'gradients': 'التدرجات',
    'light_gradients': 'تدرج ألوان فاتحة',
    'dark_gradients': 'تدرج ألوان داكنة',
    'select_gradient': 'اختيار تدرج',
    'remove_gradient': 'إزالة التدرج',

    // الأوضاع التلقائية
    'auto': 'تلقائي',
    'system': 'حسب النظام',
    'dynamic': 'لون تفاعلي',
    'dark_auto': 'المظهر الداكن التلقائي',
    'custom_themes': 'المظاهر المخصصة بي',

    // التصدير
    'export_zip': 'تصدير ZIP',
    'file_name': 'اسم الملف',
    'theme_exported': 'تم التصدير بنجاح',
    'exported_to': 'تم الحفظ في',
    'import': 'استيراد',
    'supported_formats': 'الصيغ المدعومة',
    'operation_history': 'سجل العمليات',
    'no_operations': 'لا توجد عمليات بعد',

    // الأدوات
    'undo': 'تراجع',
    'redo': 'إعادة',
    'grid': 'شبكة',
    'zoom_in': 'تكبير',
    'zoom_out': 'تصغير',
    'language': 'اللغة',
    'english': 'English',
    'arabic': 'العربية',

    // المعاينة
    'theme_preview': 'معاينة الثيم',
    'preview': 'معاينة',

    // الحفظ
    'save_theme': 'حفظ الثيم',
    'theme_name': 'اسم الثيم',
    'saved_successfully': 'تم الحفظ بنجاح',
    'save_failed': 'فشل الحفظ',
    'folder_name': 'FUTO THEME 1',

    // الأصول
    'upload_background': 'رفع خلفية',
    'upload_font': 'رفع خط',
    'upload_shape': 'رفع شكل',
    'custom_background': 'خلفية مخصصة',
    'custom_font': 'خط مخصص',
    'preset_backgrounds': 'خلفيات جاهزة',
    'preset_fonts': 'خطوط جاهزة',
    'pick_from_gallery': 'اختر من المعرض',
    'pick_font_file': 'اختر ملف خط (TTF/OTF)',

    // الألوان
    'color_picker': 'اختيار لون',
    'hex_value': 'قيمة HEX',
    'red': 'أحمر',
    'orange': 'برتقالي',
    'yellow': 'أصفر',
    'green': 'أخضر',
    'blue': 'أزرق',
    'purple': 'بنفسجي',
    'pink': 'وردي',
    'grey': 'رمادي',
  };

  static final Map<String, String> _en = {
    // General
    'app_title': 'NEON FUTO STUDIO',
    'save': 'Save',
    'cancel': 'Cancel',
    'apply': 'Apply',
    'close': 'Close',
    'delete': 'Delete',
    'edit': 'Edit',
    'add': 'Add',
    'search': 'Search...',
    'all': 'All',
    'error': 'Error',
    'success': 'Success',
    'loading': 'Loading...',

    // Navigation
    'keyboard': 'Keyboard',
    'colors': 'Colors',
    'shapes': 'Shapes',
    'backgrounds': 'Backgrounds',
    'assets': 'Assets',
    'export': 'Export',
    'presets': 'Presets',
    'themes': 'Themes',

    // Editor
    'matchrules': 'Matchrules',
    'assets_tab': 'Assets',
    'config': 'Config',
    'border_matchrules': 'BORDER MATCHRULES',
    'icon_matchrules': 'ICON MATCHRULES',
    'border_assets': 'BORDER ASSETS',
    'icon_assets': 'ICON ASSETS',
    'other_assets': 'OTHER ASSETS',
    'manual_colors': 'MANUAL COLORS',
    'metadata': 'METADATA',
    'keyboard_section': 'KEYBOARD',
    'key_text': 'KEY TEXT',
    'background_image': 'BACKGROUND IMAGE',
    'font_section': 'FONT',

    // Settings
    'key_borders': 'Key borders',
    'roundedness': 'Roundedness',
    'center_hints': 'Center hints',
    'text_scale': 'Text scale',
    'hint_scale': 'Hint scale',
    'text_weight': 'Text weight',
    'hint_weight': 'Hint weight',
    'opacity': 'Opacity',
    'action_bar_opacity': 'Action bar opacity',
    'crop': 'Crop',
    'browse_google_fonts': 'Browse Google Fonts',
    'generate_rectangle': 'Generate Rectangle',
    'description': 'Description',
    'author': 'Author',
    'version': 'Version',
    'name': 'Name',
    'id': 'ID',

    // Gradients
    'gradients': 'Gradients',
    'light_gradients': 'Light Gradients',
    'dark_gradients': 'Dark Gradients',
    'select_gradient': 'Select Gradient',
    'remove_gradient': 'Remove Gradient',

    // Auto modes
    'auto': 'Auto',
    'system': 'System',
    'dynamic': 'Dynamic',
    'dark_auto': 'Dark Auto',
    'custom_themes': 'My Custom Themes',

    // Export
    'export_zip': 'Export ZIP',
    'file_name': 'File Name',
    'theme_exported': 'Exported successfully',
    'exported_to': 'Saved to',
    'import': 'Import',
    'supported_formats': 'Supported Formats',
    'operation_history': 'Operation History',
    'no_operations': 'No operations yet',

    // Tools
    'undo': 'Undo',
    'redo': 'Redo',
    'grid': 'Grid',
    'zoom_in': 'Zoom In',
    'zoom_out': 'Zoom Out',
    'language': 'Language',
    'english': 'English',
    'arabic': 'العربية',

    // Preview
    'theme_preview': 'Theme Preview',
    'preview': 'Preview',

    // Save
    'save_theme': 'Save Theme',
    'theme_name': 'Theme Name',
    'saved_successfully': 'Saved successfully',
    'save_failed': 'Save failed',
    'folder_name': 'FUTO THEME 1',

    // Assets
    'upload_background': 'Upload Background',
    'upload_font': 'Upload Font',
    'upload_shape': 'Upload Shape',
    'custom_background': 'Custom Background',
    'custom_font': 'Custom Font',
    'preset_backgrounds': 'Preset Backgrounds',
    'preset_fonts': 'Preset Fonts',
    'pick_from_gallery': 'Pick from gallery',
    'pick_font_file': 'Pick font file (TTF/OTF)',

    // Colors
    'color_picker': 'Color Picker',
    'hex_value': 'HEX Value',
    'red': 'Red',
    'orange': 'Orange',
    'yellow': 'Yellow',
    'green': 'Green',
    'blue': 'Blue',
    'purple': 'Purple',
    'pink': 'Pink',
    'grey': 'Grey',
  };
}
