import 'package:flutter/material.dart';
import 'colors_library.dart';
import 'shapes_library.dart';
import 'icons_library.dart';
import 'font_picker_screen.dart';
import 'generate_rectangle_screen.dart';
import 'border_settings_screen.dart';
import 'assets_screen.dart';
import 'theme_settings_screen.dart';
import 'gradients_screen.dart';
import 'key_types_screen.dart';
import '../models/futo_theme.dart';
import '../core/translations.dart';
import '../services/zip_exporter.dart';
import '../services/history_service.dart';

class EditorScreen extends StatefulWidget {
  final FutoTheme? initialTheme;
  const EditorScreen({super.key, this.initialTheme});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> with SingleTickerProviderStateMixin {
  late FutoTheme _theme;
  int _mainTab = 0; // 0=Matchrules, 1=Asset, 2=Colors, 3=Config
  late AnimationController _pulseController;
  double _zoom = 1.0;
  bool _showGrid = false;

  final List<FutoTheme> _undoStack = [];
  final List<FutoTheme> _redoStack = [];

  @override
  void initState() {
    super.initState();
    _theme = widget.initialTheme ?? FutoTheme();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void didUpdateWidget(EditorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // تحديث الثيم عند تغييره من الخارج (الشريط السفلي)
    if (widget.initialTheme != null && widget.initialTheme != oldWidget.initialTheme) {
      setState(() {
        _theme = widget.initialTheme!;
      });
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _saveUndo() {
    _undoStack.add(_theme);
    _redoStack.clear();
    if (_undoStack.length > 30) _undoStack.removeAt(0);
  }

  void _undo() {
    if (_undoStack.isEmpty) return;
    _redoStack.add(_theme);
    setState(() => _theme = _undoStack.removeLast());
  }

  void _redo() {
    if (_redoStack.isEmpty) return;
    _undoStack.add(_theme);
    setState(() => _theme = _redoStack.removeLast());
  }

  Future<void> _pickColor(Color current, Function(Color) onPick) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ColorsLibrary(
          initialColor: current,
          currentTheme: _theme,
          onColorSelected: (c) {
            _saveUndo();
            setState(() => onPick(c));
          },
        ),
      ),
    );
  }

  Future<void> _pickShape() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ShapesLibrary(
          onShapeSelected: (shapePath) {
            _saveUndo();
            setState(() => _theme.keyShape = shapePath);
          },
        ),
      ),
    );
  }

  Future<void> _pickIcon() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => IconsLibrary(
          onIconSelected: (icon) {
            _saveUndo();
            setState(() {});
          },
        ),
      ),
    );
  }

  Future<void> _exportTheme() async {
    final controller = TextEditingController(text: _theme.name);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        title: Text(AppTranslations.get('save_theme')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: AppTranslations.get('theme_name'),
                hintText: 'my_theme',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${AppTranslations.get('exported_to')}: Download/FUTO THEME 1/',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppTranslations.get('cancel')),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, controller.text),
            child: Text(AppTranslations.get('save')),
          ),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      try {
        // تحديث اسم الثيم
        _theme.name = result;
        
        final exporter = ZipExporter();
        final path = await exporter.exportTheme(_theme, result);
        await HistoryService.addOperation('$result.zip', 'export', 'ZIP');
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('✅ ${AppTranslations.get('saved_successfully')}: $path'),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('❌ ${AppTranslations.get('error')}: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(_theme.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.undo),
            onPressed: _undo,
            tooltip: 'Undo',
          ),
          IconButton(
            icon: const Icon(Icons.redo),
            onPressed: _redo,
            tooltip: 'Redo',
          ),
          IconButton(
            icon: Icon(_showGrid ? Icons.grid_on : Icons.grid_off),
            onPressed: () => setState(() => _showGrid = !_showGrid),
            tooltip: 'Grid',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () => setState(() => _zoom = (_zoom + 0.1).clamp(0.5, 2.0)),
            tooltip: 'Zoom In',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () => setState(() => _zoom = (_zoom - 0.1).clamp(0.5, 2.0)),
            tooltip: 'Zoom Out',
          ),
          IconButton(
            icon: const Icon(Icons.translate),
            onPressed: () {
              setState(() {
                AppTranslations.isEnglish = !AppTranslations.isEnglish;
              });
            },
            tooltip: AppTranslations.isEnglish ? 'العربية' : 'English',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportTheme,
            tooltip: AppTranslations.get('export_zip'),
          ),
        ],
      ),
      body: Column(
        children: [
          // المعاينة الحية
          Expanded(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _theme.keyboardSurface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: _theme.keyboardBorder),
                gradient: _theme.useGradient && _theme.gradientColors != null
                    ? LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: _theme.gradientColors!,
                      )
                    : null,
                image: !_theme.useGradient &&
                        _theme.backgroundImage != null &&
                        _theme.backgroundImage!.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(_theme.backgroundImage!),
                        fit: BoxFit.cover,
                        opacity: 0.7,
                        onError: (_, __) {},
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // طبقة تعتيم فوق الخلفية
                  if (_theme.backgroundImage != null &&
                      _theme.backgroundImage!.isNotEmpty)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  // المحتوى
                  Center(
                    child: Transform.scale(
                      scale: _zoom,
                      child: _buildKeyboardPreview(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // التبويبات الأربعة
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: cs.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  // شريط التبويبات
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        _buildTabButton(0, AppTranslations.get('matchrules'), Icons.link),
                        _buildTabButton(1, AppTranslations.get('assets_tab'), Icons.folder),
                        _buildTabButton(2, AppTranslations.get('colors'), Icons.palette),
                        _buildTabButton(3, AppTranslations.get('config'), Icons.settings),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  // محتوى التبويب
                  Expanded(
                    child: IndexedStack(
                      index: _mainTab,
                      children: [
                        _buildMatchrulesTab(),
                        _buildAssetsTab(),
                        _buildColorsTab(),
                        _buildConfigTab(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // شريط التبويبات
  // ============================================================
  Widget _buildTabButton(int index, String label, IconData icon) {
    final selected = _mainTab == index;
    final cs = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _mainTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: selected ? cs.primary.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: selected ? cs.primary : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? cs.primary : Colors.grey, size: 22),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: selected ? cs.primary : Colors.grey,
                  fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // تبويب Matchrules
  // ============================================================
  Widget _buildMatchrulesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader(AppTranslations.get('border_matchrules'), Icons.crop_square),
        const SizedBox(height: 10),

        _keyTypeTile(
          title: 'الأزرار العادية',
          subtitle: 'الحروف والأرقام',
          icon: Icons.keyboard,
          shapePath: _theme.normalShape.isNotEmpty ? _theme.normalShape : _theme.keyShape,
          onPick: () => _pickKeyType('normal'),
        ),
        const SizedBox(height: 10),

        _keyTypeTile(
          title: 'الأزرار الوظيفية',
          subtitle: 'Shift, Backspace, Enter',
          icon: Icons.settings,
          shapePath: _theme.functionalShape.isNotEmpty ? _theme.functionalShape : _theme.keyShape,
          onPick: () => _pickKeyType('functional'),
        ),
        const SizedBox(height: 10),

        _keyTypeTile(
          title: 'أزرار الإجراءات',
          subtitle: 'Action, Emoji, Voice',
          icon: Icons.touch_app,
          shapePath: _theme.actionShape.isNotEmpty ? _theme.actionShape : _theme.keyShape,
          onPick: () => _pickKeyType('action'),
        ),
        const SizedBox(height: 10),

        _keyTypeTile(
          title: 'الأزرار المضغوطة',
          subtitle: 'عند الضغط على الزر',
          icon: Icons.ads_click,
          shapePath: _theme.pressedShape.isNotEmpty ? _theme.pressedShape : _theme.keyShape,
          onPick: () => _pickKeyType('pressed'),
        ),
        const SizedBox(height: 20),

        _sectionHeader('ICON MATCHRULES', Icons.emoji_emotions),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Icon(Icons.emoji_emotions),
            title: const Text('أيقونات الأزرار'),
            subtitle: const Text('اختر أيقونات للأزرار'),
            trailing: IconButton(
              icon: const Icon(Icons.add),
              onPressed: _pickIcon,
            ),
          ),
        ),
        const SizedBox(height: 20),

        _sectionHeader('إعدادات إضافية', Icons.tune),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Icon(Icons.crop_free),
            title: const Text('9-Slicing للحدود'),
            subtitle: const Text('تحديد هوامش التمدد'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BorderSettingsScreen(
                    theme: _theme,
                    onThemeUpdated: (t) => setState(() {}),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAssetsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader(AppTranslations.get('border_assets'), Icons.crop_square),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildAssetTile('شكل الزر', _theme.keyShape, _pickShape),
            _buildAssetTile('أيقونة', '', _pickIcon),
            _buildAssetTile('إضافة', '', () {}),
          ],
        ),
        const SizedBox(height: 20),

        _sectionHeader(AppTranslations.get('icon_assets'), Icons.emoji_emotions),
        const SizedBox(height: 10),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildAssetTile('أيقونة 1', '', () {}),
            _buildAssetTile('أيقونة 2', '', () {}),
            _buildAssetTile('إضافة', '', () {}),
          ],
        ),
        const SizedBox(height: 20),

        _sectionHeader(AppTranslations.get('other_assets'), Icons.folder),
        const SizedBox(height: 10),
        Card(
          child: ListTile(
            leading: const Icon(Icons.attach_file),
            title: const Text('رفع أصول إضافية'),
            subtitle: const Text('خلفيات، خطوط، صور'),
            trailing: const Icon(Icons.upload),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AssetsScreen(
                    onAssetSelected: (type, path) {
                      _saveUndo();
                      setState(() {
                        if (type == 'background') _theme.backgroundImage = path;
                        if (type == 'font') _theme.fontPath = path;
                      });
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAssetTile(String label, String path, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: path.isNotEmpty ? Colors.purple : Colors.white24,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (path.isNotEmpty && path.startsWith('assets/'))
              Image.asset(path, width: 40, height: 40,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image, color: Colors.white38))
            else
              const Icon(Icons.add, color: Colors.white54, size: 32),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // تبويب Colors (44 لوناً)
  // ============================================================
  Widget _buildColorsTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _sectionHeader(AppTranslations.get('manual_colors'), Icons.palette),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _colorCircle('primary', _theme.primary, (c) => _theme.primary = c),
            _colorCircle('onPrimary', _theme.onPrimary, (c) => _theme.onPrimary = c),
            _colorCircle('primaryCont', _theme.primaryContainer, (c) => _theme.primaryContainer = c),
            _colorCircle('onPrimaryCont', _theme.onPrimaryContainer, (c) => _theme.onPrimaryContainer = c),
            _colorCircle('secondary', _theme.secondary, (c) => _theme.secondary = c),
            _colorCircle('onSecondary', _theme.onSecondary, (c) => _theme.onSecondary = c),
            _colorCircle('secondaryCont', _theme.secondaryContainer, (c) => _theme.secondaryContainer = c),
            _colorCircle('onSecondaryCont', _theme.onSecondaryContainer, (c) => _theme.onSecondaryContainer = c),
            _colorCircle('tertiary', _theme.tertiary, (c) => _theme.tertiary = c),
            _colorCircle('onTertiary', _theme.onTertiary, (c) => _theme.onTertiary = c),
            _colorCircle('tertiaryCont', _theme.tertiaryContainer, (c) => _theme.tertiaryContainer = c),
            _colorCircle('onTertiaryCont', _theme.onTertiaryContainer, (c) => _theme.onTertiaryContainer = c),
            _colorCircle('error', _theme.error, (c) => _theme.error = c),
            _colorCircle('onError', _theme.onError, (c) => _theme.onError = c),
            _colorCircle('errorCont', _theme.errorContainer, (c) => _theme.errorContainer = c),
            _colorCircle('onErrorCont', _theme.onErrorContainer, (c) => _theme.onErrorContainer = c),
            _colorCircle('background', _theme.background, (c) => _theme.background = c),
            _colorCircle('onBackground', _theme.onBackground, (c) => _theme.onBackground = c),
            _colorCircle('surface', _theme.surface, (c) => _theme.surface = c),
            _colorCircle('onSurface', _theme.onSurface, (c) => _theme.onSurface = c),
            _colorCircle('surfaceVariant', _theme.surfaceVariant, (c) => _theme.surfaceVariant = c),
            _colorCircle('onSurfaceVariant', _theme.onSurfaceVariant, (c) => _theme.onSurfaceVariant = c),
            _colorCircle('outline', _theme.outline, (c) => _theme.outline = c),
            _colorCircle('outlineVariant', _theme.outlineVariant, (c) => _theme.outlineVariant = c),
            _colorCircle('shadow', _theme.shadow, (c) => _theme.shadow = c),
            _colorCircle('scrim', _theme.scrim, (c) => _theme.scrim = c),
            _colorCircle('keyboardSurface', _theme.keyboardSurface, (c) => _theme.keyboardSurface = c),
            _colorCircle('keyboardCont', _theme.keyboardContainer, (c) => _theme.keyboardContainer = c),
            _colorCircle('onKeyboard', _theme.onKeyboard, (c) => _theme.onKeyboard = c),
            _colorCircle('onKeyboardCont', _theme.onKeyboardContainer, (c) => _theme.onKeyboardContainer = c),
            _colorCircle('keyboardPrimary', _theme.keyboardPrimary, (c) => _theme.keyboardPrimary = c),
            _colorCircle('keyboardOnPrimary', _theme.keyboardOnPrimary, (c) => _theme.keyboardOnPrimary = c),
            _colorCircle('keyboardSecondary', _theme.keyboardSecondary, (c) => _theme.keyboardSecondary = c),
            _colorCircle('keyboardOnSecondary', _theme.keyboardOnSecondary, (c) => _theme.keyboardOnSecondary = c),
            _colorCircle('keyboardError', _theme.keyboardError, (c) => _theme.keyboardError = c),
            _colorCircle('keyboardOnError', _theme.keyboardOnError, (c) => _theme.keyboardOnError = c),
            _colorCircle('keyboardShadow', _theme.keyboardShadow, (c) => _theme.keyboardShadow = c),
            _colorCircle('keyboardBorder', _theme.keyboardBorder, (c) => _theme.keyboardBorder = c),
            _colorCircle('keyboardRipple', _theme.keyboardRipple, (c) => _theme.keyboardRipple = c),
          ],
        ),
      ],
    );
  }

  Widget _colorCircle(String label, Color color, Function(Color) onPick) {
    return GestureDetector(
      onTap: () {
        _saveUndo();
        _pickColor(color, onPick);
      },
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white24),
            ),
          ),
          const SizedBox(height: 2),
          SizedBox(
            width: 55,
            child: Text(
              label,
              style: const TextStyle(fontSize: 8),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // تبويب Config
  // ============================================================
  Widget _buildConfigTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _sectionHeader(AppTranslations.get('keyboard_section'), Icons.keyboard),
        SwitchListTile(
          title: Text(AppTranslations.get('key_borders')),
          value: _theme.autoBorders,
          onChanged: (v) => setState(() => _theme.autoBorders = v),
        ),
        ListTile(
          title: Text('Roundedness: ${_theme.keyRadius.toStringAsFixed(1)}'),
          subtitle: Slider(
            value: _theme.keyRadius,
            min: 0,
            max: 30,
            onChanged: (v) => setState(() => _theme.keyRadius = v),
          ),
        ),
        SwitchListTile(
          title: Text(AppTranslations.get('center_hints')),
          value: _theme.centerHints,
          onChanged: (v) => setState(() => _theme.centerHints = v),
        ),
        const Divider(),

        _sectionHeader(AppTranslations.get('key_text'), Icons.text_fields),
        ListTile(
          title: Text('Text scale: ${_theme.scaleText.toStringAsFixed(1)}'),
          subtitle: Slider(
            value: _theme.scaleText,
            min: 0.5,
            max: 2.0,
            onChanged: (v) => setState(() => _theme.scaleText = v),
          ),
        ),
        ListTile(
          title: Text('Text weight: ${_theme.weightText}'),
          subtitle: Slider(
            value: _theme.weightText.toDouble(),
            min: 100,
            max: 900,
            divisions: 8,
            onChanged: (v) => setState(() => _theme.weightText = v.toInt()),
          ),
        ),
        const Divider(),

        _sectionHeader(AppTranslations.get('background_image'), Icons.wallpaper),
        FilledButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GradientsScreen(
                  onGradientSelected: (colors) {
                    _saveUndo();
                    setState(() {
                      _theme.gradientColors = colors;
                      _theme.useGradient = true;
                      _theme.backgroundImage = null;
                    });
                  },
                ),
              ),
            );
          },
          icon: const Icon(Icons.gradient),
          label: Text(AppTranslations.get('select_gradient')),
        ),
        const SizedBox(height: 8),
        if (_theme.useGradient)
          OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _theme.useGradient = false;
                _theme.gradientColors = null;
              });
            },
            icon: const Icon(Icons.close),
            label: Text(AppTranslations.get('remove_gradient')),
          ),
        const SizedBox(height: 8),
        // Opacity Slider
        ListTile(
          title: Text('${AppTranslations.get('opacity')}: ${_theme.backgroundOpacity.toStringAsFixed(1)}'),
          subtitle: Slider(
            value: _theme.backgroundOpacity,
            min: 0.0,
            max: 1.0,
            onChanged: (v) => setState(() => _theme.backgroundOpacity = v),
          ),
        ),
        // Action Bar Opacity
        ListTile(
          title: Text('${AppTranslations.get('action_bar_opacity')}: ${_theme.actionBarOpacity.toStringAsFixed(1)}'),
          subtitle: Slider(
            value: _theme.actionBarOpacity,
            min: 0.0,
            max: 1.0,
            onChanged: (v) => setState(() => _theme.actionBarOpacity = v),
          ),
        ),
        // زر Crop
        OutlinedButton.icon(
          onPressed: () {
            _showCropDialog();
          },
          icon: const Icon(Icons.crop),
          label: Text(AppTranslations.get('crop')),
        ),
        const SizedBox(height: 8),
        Card(
          child: ListTile(
            leading: _theme.backgroundImage != null
                ? const Icon(Icons.image)
                : const Icon(Icons.add_photo_alternate),
            title: Text(_theme.backgroundImage == null
                ? 'لا توجد خلفية'
                : _theme.backgroundImage!.split('/').last),
            trailing: const Icon(Icons.upload),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AssetsScreen(
                    onAssetSelected: (type, path) {
                      if (type == 'background') {
                        _saveUndo();
                        setState(() => _theme.backgroundImage = path);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const Divider(),

        _sectionHeader(AppTranslations.get('font_section'), Icons.text_fields),
        Card(
          child: ListTile(
            leading: const Icon(Icons.font_download),
            title: Text(_theme.fontPath == null
                ? 'لا يوجد خط مخصص'
                : _theme.fontPath!.split('/').last),
            trailing: const Icon(Icons.upload),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => AssetsScreen(
                    onAssetSelected: (type, path) {
                      if (type == 'font') {
                        _saveUndo();
                        setState(() => _theme.fontPath = path);
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        FilledButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FontPickerScreen(
                  currentFont: _theme.fontFamily,
                  onFontSelected: (font) {
                    _saveUndo();
                    setState(() => _theme.fontFamily = font);
                  },
                ),
              ),
            );
          },
          icon: const Icon(Icons.search),
          label: Text(AppTranslations.get('browse_google_fonts')),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => GenerateRectangleScreen(
                  onGenerate: (params) {
                    _saveUndo();
                    setState(() {
                      _theme.keyRadius = params['roundedness'];
                    });
                  },
                ),
              ),
            );
          },
          icon: const Icon(Icons.crop_square),
          label: Text(AppTranslations.get('generate_rectangle')),
        ),
        const Divider(height: 40),
        _sectionHeader(AppTranslations.get('metadata'), Icons.info),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(text: _theme.name),
          onChanged: (v) => setState(() => _theme.name = v),
          decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(text: _theme.id),
          onChanged: (v) => setState(() => _theme.id = v),
          decoration: const InputDecoration(labelText: 'ID', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(text: _theme.description),
          onChanged: (v) => setState(() => _theme.description = v),
          decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
          maxLines: 2,
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(text: _theme.author),
          onChanged: (v) => setState(() => _theme.author = v),
          decoration: const InputDecoration(labelText: 'Author', border: OutlineInputBorder()),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: TextEditingController(text: _theme.version),
          onChanged: (v) => setState(() => _theme.version = v),
          decoration: const InputDecoration(labelText: 'Version', border: OutlineInputBorder()),
        ),
      ],
    );
  }

  void _showCropDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Crop Background'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('اختر نسبة القص'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                '1:1', '4:3', '16:9', '3:4', '9:16', 'Free'
              ].map((ratio) => ChoiceChip(
                label: Text(ratio),
                selected: false,
                onSelected: (_) => Navigator.pop(ctx),
              )).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 18),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  // ============================================================
  // المعاينة الحية (5 صفوف)
  // ============================================================
  Widget _buildKeyboardPreview() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.85, end: 1.0).animate(
        CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // شريط التلميحات (Hint Bar)
            _buildHintBar(),
            const SizedBox(height: 4),
            // صف الأرقام
            _buildRow(['1', '2', '3', '4', '5', '6', '7', '8', '9', '0'], isNumberRow: true),
            const SizedBox(height: 2),
            // الصفوف العربية
            _buildRow(['ض', 'ص', 'ث', 'ق', 'ف', 'غ', 'ع', 'ه', 'خ', 'ح']),
            _buildRow(['ش', 'س', 'ي', 'ب', 'ل', 'ا', 'ت', 'ن', 'م', 'ك']),
            _buildRow(['ئ', 'ء', 'ؤ', 'ر', 'لا', 'ى', 'ة', 'و', 'ز', 'ظ']),
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
      ),
    );
  }

  Widget _buildHintBar() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: _theme.keyboardSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildHintKey('>'),
          _buildHintSuggestion('thus'),
          _buildHintSuggestion('the'),
          _buildHintSuggestion('"thr"'),
          const Spacer(),
          Icon(Icons.mic, color: _theme.onKeyboard, size: 18),
        ],
      ),
    );
  }

  Widget _buildHintKey(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: _theme.keyboardContainer.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(color: _theme.onKeyboard, fontSize: 12),
      ),
    );
  }

  Widget _buildHintSuggestion(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: _theme.keyboardContainer.withOpacity(0.3),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _theme.onKeyboard,
          fontSize: 12,
          fontFamily: _theme.fontFamily,
        ),
      ),
    );
  }

  Widget _buildRow(List<String> keys, {bool isNumberRow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 1),
      child: Row(
        children: keys.map((k) => _buildKey(k, isNumber: isNumberRow)).toList(),
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
        height: 38,
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
