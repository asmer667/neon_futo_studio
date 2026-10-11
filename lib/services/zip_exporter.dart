import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../models/futo_theme.dart';
import 'download_saver.dart';

class ZipExporter {
  Future<String> exportTheme(FutoTheme theme, String fileName) async {
    final archive = Archive();
    final Map<String, List<int>> assets = {};

    // 1. نسخ صور الأشكال الأربعة
    String? normalAsset;
    String? functionalAsset;
    String? actionAsset;
    String? pressedAsset;

    // الأزرار العادية
    final normalPath = theme.normalShape.isNotEmpty ? theme.normalShape : theme.keyShape;
    if (normalPath.isNotEmpty && normalPath.startsWith('assets/')) {
      try {
        final ByteData data = await rootBundle.load(normalPath);
        assets['Button-default.png'] = data.buffer.asUint8List();
        normalAsset = 'Button-default.png';
      } catch (e) {}
    }

    // الأزرار الوظيفية
    final functionalPath = theme.functionalShape.isNotEmpty ? theme.functionalShape : theme.keyShape;
    if (functionalPath.isNotEmpty && functionalPath.startsWith('assets/')) {
      try {
        final ByteData data = await rootBundle.load(functionalPath);
        assets['Button-function.png'] = data.buffer.asUint8List();
        functionalAsset = 'Button-function.png';
      } catch (e) {}
    }

    // أزرار الإجراءات
    final actionPath = theme.actionShape.isNotEmpty ? theme.actionShape : theme.keyShape;
    if (actionPath.isNotEmpty && actionPath.startsWith('assets/')) {
      try {
        final ByteData data = await rootBundle.load(actionPath);
        assets['Button-action.png'] = data.buffer.asUint8List();
        actionAsset = 'Button-action.png';
      } catch (e) {}
    }

    // الأزرار المضغوطة
    final pressedPath = theme.pressedShape.isNotEmpty ? theme.pressedShape : theme.keyShape;
    if (pressedPath.isNotEmpty && pressedPath.startsWith('assets/')) {
      try {
        final ByteData data = await rootBundle.load(pressedPath);
        assets['Button-default-press.png'] = data.buffer.asUint8List();
        pressedAsset = 'Button-default-press.png';
      } catch (e) {}
    }

    // 2. نسخ الخلفية (إن وجدت)
    String? bgAssetName;
    if (theme.backgroundImage != null && theme.backgroundImage!.isNotEmpty) {
      try {
        final ByteData data = await rootBundle.load(theme.backgroundImage!);
        final Uint8List bytes = data.buffer.asUint8List();
        bgAssetName = theme.backgroundImage!.split('/').last;
        assets[bgAssetName] = bytes;
      } catch (e) {
        // تجاهل
      }
    }

    // 3. نسخ الخط (إن وجد)
    String? fontAssetName;
    if (theme.fontPath != null && theme.fontPath!.isNotEmpty) {
      try {
        final file = File(theme.fontPath!);
        if (await file.exists()) {
          final Uint8List bytes = await file.readAsBytes();
          fontAssetName = theme.fontPath!.split('/').last;
          assets[fontAssetName] = bytes;
        }
      } catch (e) {
        // تجاهل
      }
    }

    // 4. إضافة الأصول إلى ZIP (في جذر ZIP مباشرة)
    for (final entry in assets.entries) {
      archive.addFile(ArchiveFile(entry.key, entry.value.length, entry.value));
    }

    // 5. توليد theme.txt بصيغة FUTO الصحيحة
    final buffer = StringBuffer();
    buffer.writeln('version = ${int.tryParse(theme.version) ?? 1}');
    buffer.writeln('name = "${theme.name}"');
    buffer.writeln('author = "${theme.author}"');
    buffer.writeln('id = "${theme.id}"');
    if (theme.description.isNotEmpty) {
      buffer.writeln('description = "${theme.description}"');
    }
    buffer.writeln();

    // ===== قسم options =====
    buffer.writeln('[options]');
    buffer.writeln('auto_borders = ${theme.autoBorders}');
    buffer.writeln('center_hints = ${theme.centerHints}');
    buffer.writeln('roundedness = ${theme.roundedness}');
    buffer.writeln('scale_text = ${theme.scaleText}');
    buffer.writeln('scale_hints = ${theme.hintScale}');
    buffer.writeln('weight_text = ${theme.weightText}');
    buffer.writeln('weight_hints = ${theme.hintWeight}');
    buffer.writeln('key_borders = ${theme.keyBorders}');
    buffer.writeln();

    // ===== قسم colors (25 لوناً كما في FUTO) =====
    buffer.writeln('[colors]');
    _colorLine(buffer, 'primary', theme.primary, theme.autoPrimary);
    _colorLine(buffer, 'on_primary', theme.onPrimary, theme.autoOnPrimary);
    _colorLine(buffer, 'primary_container', theme.primaryContainer, theme.autoPrimaryContainer);
    buffer.writeln('on_primary_container = "${_hexA(theme.onPrimaryContainer)}"');
    buffer.writeln('inverse_primary = "${_hexA(theme.inversePrimary)}"');
    buffer.writeln();
    _colorLine(buffer, 'secondary', theme.secondary, theme.autoSecondary);
    buffer.writeln('on_secondary = "${_hexA(theme.onSecondary)}"');
    buffer.writeln('secondary_container = "${_hexA(theme.secondaryContainer)}"');
    buffer.writeln('on_secondary_container = "${_hexA(theme.onSecondaryContainer)}"');
    buffer.writeln();
    buffer.writeln('tertiary = "${_hexA(theme.tertiary)}"');
    buffer.writeln('on_tertiary = "${_hexA(theme.onTertiary)}"');
    buffer.writeln('tertiary_container = "${_hexA(theme.tertiaryContainer)}"');
    buffer.writeln('on_tertiary_container = "${_hexA(theme.onTertiaryContainer)}"');
    buffer.writeln();
    _colorLine(buffer, 'background', theme.background, theme.autoBackground);
    buffer.writeln('on_background = "${_hexA(theme.onBackground)}"');
    buffer.writeln();
    _colorLine(buffer, 'surface', theme.surface, theme.autoSurface);
    buffer.writeln('on_surface = "${_hexA(theme.onSurface)}"');
    _colorLine(buffer, 'surface_variant', theme.surfaceVariant, theme.autoSurfaceVariant);
    buffer.writeln('on_surface_variant = "${_hexA(theme.onSurfaceVariant)}"');
    buffer.writeln('surface_tint = "${_hexA(theme.surfaceTint)}"');
    buffer.writeln('inverse_surface = "${_hexA(theme.inverseSurface)}"');
    buffer.writeln('inverse_on_surface = "${_hexA(theme.inverseOnSurface)}"');
    buffer.writeln();
    buffer.writeln('error = "${_hexA(theme.error)}"');
    buffer.writeln('on_error = "${_hexA(theme.onError)}"');
    buffer.writeln('error_container = "${_hexA(theme.errorContainer)}"');
    buffer.writeln('on_error_container = "${_hexA(theme.onErrorContainer)}"');
    buffer.writeln();
    _colorLine(buffer, 'outline', theme.outline, theme.autoOutline);
    buffer.writeln('outline_variant = "${_hexA(theme.outlineVariant)}"');
    buffer.writeln('scrim = "${_hexA(theme.scrim)}"');
    buffer.writeln();
    buffer.writeln('surface_bright = "${_hexA(theme.surfaceBright)}"');
    buffer.writeln('surface_dim = "${_hexA(theme.surfaceDim)}"');
    buffer.writeln('surface_container = "${_hexA(theme.surfaceContainer)}"');
    buffer.writeln('surface_container_high = "${_hexA(theme.surfaceContainerHigh)}"');
    buffer.writeln('surface_container_highest = "${_hexA(theme.surfaceContainerHighest)}"');
    buffer.writeln('surface_container_low = "${_hexA(theme.surfaceContainerLow)}"');
    buffer.writeln('surface_container_lowest = "${_hexA(theme.surfaceContainerLowest)}"');
    buffer.writeln();
    buffer.writeln('keyboard_surface = "${_hexA(theme.keyboardSurface)}"');
    buffer.writeln('keyboard_surface_dim = "${_hexA(theme.keyboardSurface)}"');
    buffer.writeln('keyboard_container = "${_hexA(theme.keyboardContainer)}"');
    buffer.writeln('keyboard_container_variant = "${_hexA(theme.keyboardContainerVariant)}"');
    buffer.writeln('on_keyboard_container = "${_hexA(theme.onKeyboardContainer)}"');
    buffer.writeln('keyboard_press = "${_hexA(theme.keyboardPrimary)}"');
    buffer.writeln('keyboard_container_pressed = "${_hexA(theme.keyboardPrimary)}"');
    buffer.writeln('on_keyboard_container_pressed = "${_hexA(theme.keyboardOnPrimary)}"');
    buffer.writeln();

    // ===== قسم الخط =====
    if (fontAssetName != null) {
      buffer.writeln('[options.font]');
      buffer.writeln('font = "$fontAssetName"');
      buffer.writeln();
    }

    // ===== قسم الخلفية =====
    if (bgAssetName != null) {
      buffer.writeln('[options.background]');
      buffer.writeln('image = "$bgAssetName"');
      buffer.writeln('opacity = ${theme.backgroundOpacity}');
      buffer.writeln('action_bar_opacity = ${theme.actionBarOpacity}');
      if (theme.cropEnabled) {
        buffer.writeln('cropping = [${theme.cropLeft}, ${theme.cropTop}, ${theme.cropRight}, ${theme.cropBottom}]');
      }
      buffer.writeln();
    }

    // ===== قسم matchrules (متقدم) =====
    if (normalAsset != null) {
      // 1. الأزرار المضغوطة
      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "pressed functional"');
      buffer.writeln('asset = "${pressedAsset ?? normalAsset}"');
      buffer.writeln();

      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "pressed action"');
      buffer.writeln('asset = "${pressedAsset ?? normalAsset}"');
      buffer.writeln();

      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "pressed"');
      buffer.writeln('asset = "${pressedAsset ?? normalAsset}"');
      buffer.writeln();

      // 2. الأزرار الوظيفية
      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "functional"');
      buffer.writeln('asset = "${functionalAsset ?? normalAsset}"');
      buffer.writeln();

      // 3. أزرار الإجراءات
      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "action"');
      buffer.writeln('asset = "${actionAsset ?? normalAsset}"');
      buffer.writeln();

      // 4. الأزرار العادية
      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "normal"');
      buffer.writeln('asset = "$normalAsset"');
      buffer.writeln();
    }

    // ===== قسم asset.border =====
    if (normalAsset != null) {
      _writeAssetBorder(buffer, 'Button-default.png',
        theme.normalBackgroundTint, theme.normalForegroundTint,
        theme.normalSlicingLeft, theme.normalSlicingTop,
        theme.normalSlicingRight, theme.normalSlicingBottom);

      if (pressedAsset != null) {
        _writeAssetBorder(buffer, 'Button-default-press.png',
          theme.pressedBackgroundTint, theme.pressedForegroundTint,
          theme.pressedSlicingLeft, theme.pressedSlicingTop,
          theme.pressedSlicingRight, theme.pressedSlicingBottom);
      }

      if (functionalAsset != null) {
        _writeAssetBorder(buffer, 'Button-function.png',
          theme.functionalBackgroundTint, theme.functionalForegroundTint,
          theme.functionalSlicingLeft, theme.functionalSlicingTop,
          theme.functionalSlicingRight, theme.functionalSlicingBottom);
      }

      if (actionAsset != null) {
        _writeAssetBorder(buffer, 'Button-action.png',
          theme.actionBackgroundTint, theme.actionForegroundTint,
          theme.actionSlicingLeft, theme.actionSlicingTop,
          theme.actionSlicingRight, theme.actionSlicingBottom);
      }
    }

    // ===== قسم asset.icon =====
    if (theme.backspaceIcon.isNotEmpty) _writeAssetIcon(buffer, 'Icon-backspace.png');
    if (theme.shiftIcon.isNotEmpty) _writeAssetIcon(buffer, 'Icon-shift.png');
    if (theme.enterIcon.isNotEmpty) _writeAssetIcon(buffer, 'Icon-enter.png');
    if (theme.emojiIcon.isNotEmpty) _writeAssetIcon(buffer, 'Icon-emoji.png');

    // 6. إضافة theme.txt إلى الأرشيف
    final configContent = utf8.encode(buffer.toString());
    archive.addFile(ArchiveFile('theme.txt', configContent.length, configContent));

    // 7. إنشاء ZIP وحفظه في Download/FUTO THEME 1/
    final zipData = ZipEncoder().encode(archive);
    final safeName = fileName.replaceAll(RegExp(r'[^\w\s-]'), '_');

    final savedPath = await DownloadSaver.saveToDownloads(
      fileName: '$safeName.zip',
      bytes: Uint8List.fromList(zipData!),
      mimeType: 'application/zip',
    );

    if (savedPath == null) {
      throw Exception('فشل الحفظ في مجلد التنزيلات. تأكد من منح الصلاحيات.');
    }

    return savedPath;
  }


  void _writeAssetBorder(
    StringBuffer buffer,
    String name,
    String bgTint,
    String fgTint,
    double sl,
    double st,
    double sr,
    double sb,
  ) {
    buffer.writeln('[[asset.border]]');
    buffer.writeln('name = "$name"');
    buffer.writeln('background_tint = "$bgTint"');
    buffer.writeln('foreground_tint = "$fgTint"');
    buffer.writeln('padding = [0, 0, 0, 0]');
    buffer.writeln('slicing = [$sl, $st, $sr, $sb]');
    buffer.writeln('gap = [1, 1, 1, 1]');
    buffer.writeln('target_density = 640');
    buffer.writeln();
  }

  void _writeAssetIcon(StringBuffer buffer, String name) {
    buffer.writeln('[[asset.icon]]');
    buffer.writeln('name = "$name"');
    buffer.writeln('target_density = 640');
    buffer.writeln();
  }

  /// تحويل اللون إلى صيغة #RRGGBBAA (كما يطلب FUTO)

  /// كتابة سطر لون (يدوي أو تلقائي)
  void _colorLine(StringBuffer buffer, String key, Color color, bool isAuto) {
    if (isAuto) {
      buffer.writeln('$key = "auto"');
    } else {
      buffer.writeln('$key = "${_hexA(color)}"');
    }
  }

  String _hexA(Color color) {
    final r = (color.value >> 16) & 0xFF;
    final g = (color.value >> 8) & 0xFF;
    final b = color.value & 0xFF;
    final a = (color.value >> 24) & 0xFF;
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}${a.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
  }
}
