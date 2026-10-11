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

    // 1. نسخ صورة الشكل المختار (إن وجدت)
    String? shapeAssetName;
    if (theme.keyShape.isNotEmpty && theme.keyShape.startsWith('assets/')) {
      try {
        final ByteData data = await rootBundle.load(theme.keyShape);
        final Uint8List bytes = data.buffer.asUint8List();
        // نحول الشكل إلى 4 صور للأزرار الأربعة
        assets['Button-default.png'] = bytes;
        assets['Button-default-press.png'] = bytes;
        assets['Button-function.png'] = bytes;
        assets['Button-action.png'] = bytes;
        shapeAssetName = 'Button-default.png';
      } catch (e) {
        // تجاهل
      }
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
    buffer.writeln('roundedness = ${theme.keyRadius / 30}');
    buffer.writeln('scale_text = ${theme.scaleText}');
    buffer.writeln('scale_hints = ${theme.scaleText}');
    buffer.writeln('weight_text = ${theme.weightText}');
    buffer.writeln('weight_hints = ${theme.weightText}');
    buffer.writeln();

    // ===== قسم colors (25 لوناً كما في FUTO) =====
    buffer.writeln('[colors]');
    buffer.writeln('primary = "${_hexA(theme.primary)}"');
    buffer.writeln('on_primary = "${_hexA(theme.onPrimary)}"');
    buffer.writeln('primary_container = "${_hexA(theme.primaryContainer)}"');
    buffer.writeln('on_primary_container = "${_hexA(theme.onPrimaryContainer)}"');
    buffer.writeln('inverse_primary = "${_hexA(theme.inversePrimary)}"');
    buffer.writeln();
    buffer.writeln('secondary = "${_hexA(theme.secondary)}"');
    buffer.writeln('on_secondary = "${_hexA(theme.onSecondary)}"');
    buffer.writeln('secondary_container = "${_hexA(theme.secondaryContainer)}"');
    buffer.writeln('on_secondary_container = "${_hexA(theme.onSecondaryContainer)}"');
    buffer.writeln();
    buffer.writeln('tertiary = "${_hexA(theme.tertiary)}"');
    buffer.writeln('on_tertiary = "${_hexA(theme.onTertiary)}"');
    buffer.writeln('tertiary_container = "${_hexA(theme.tertiaryContainer)}"');
    buffer.writeln('on_tertiary_container = "${_hexA(theme.onTertiaryContainer)}"');
    buffer.writeln();
    buffer.writeln('background = "${_hexA(theme.background)}"');
    buffer.writeln('on_background = "${_hexA(theme.onBackground)}"');
    buffer.writeln();
    buffer.writeln('surface = "${_hexA(theme.surface)}"');
    buffer.writeln('on_surface = "${_hexA(theme.onSurface)}"');
    buffer.writeln('surface_variant = "${_hexA(theme.surfaceVariant)}"');
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
    buffer.writeln('outline = "${_hexA(theme.outline)}"');
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
      buffer.writeln();
    }

    // ===== قسم matchrules =====
    if (shapeAssetName != null) {
      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "pressed"');
      buffer.writeln('asset = "Button-default-press.png"');
      buffer.writeln();
      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "functional"');
      buffer.writeln('asset = "Button-function.png"');
      buffer.writeln();
      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "action"');
      buffer.writeln('asset = "Button-action.png"');
      buffer.writeln();
      buffer.writeln('[[matchrules.border]]');
      buffer.writeln('selector = "normal"');
      buffer.writeln('asset = "Button-default.png"');
      buffer.writeln();
    }

    // ===== قسم asset.border =====
    if (shapeAssetName != null) {
      buffer.writeln('[[asset.border]]');
      buffer.writeln('name = "Button-default.png"');
      buffer.writeln('background_tint = "#ffffff"');
      buffer.writeln('foreground_tint = "${_hexA(theme.onKeyboard)}"');
      buffer.writeln('padding = [0, 0, 0, 0]');
      buffer.writeln('slicing = [0.3, 0.3, 0.7, 0.7]');
      buffer.writeln('gap = [1, 1, 1, 1]');
      buffer.writeln('target_density = 640');
      buffer.writeln();

      buffer.writeln('[[asset.border]]');
      buffer.writeln('name = "Button-default-press.png"');
      buffer.writeln('background_tint = "#ffffff"');
      buffer.writeln('foreground_tint = "#ffffff"');
      buffer.writeln('padding = [0, 0, 0, 0]');
      buffer.writeln('slicing = [0.3, 0.3, 0.7, 0.7]');
      buffer.writeln('gap = [1, 1, 1, 1]');
      buffer.writeln('target_density = 640');
      buffer.writeln();

      buffer.writeln('[[asset.border]]');
      buffer.writeln('name = "Button-function.png"');
      buffer.writeln('background_tint = "#ffffff"');
      buffer.writeln('foreground_tint = "${_hexA(theme.onKeyboard)}"');
      buffer.writeln('padding = [0, 0, 0, 0]');
      buffer.writeln('slicing = [0.3, 0.3, 0.7, 0.7]');
      buffer.writeln('gap = [1, 1, 1, 1]');
      buffer.writeln('target_density = 640');
      buffer.writeln();

      buffer.writeln('[[asset.border]]');
      buffer.writeln('name = "Button-action.png"');
      buffer.writeln('background_tint = "#ffffff"');
      buffer.writeln('foreground_tint = "${_hexA(theme.onKeyboard)}"');
      buffer.writeln('padding = [0, 0, 0, 0]');
      buffer.writeln('slicing = [0.3, 0.3, 0.7, 0.7]');
      buffer.writeln('gap = [1, 1, 1, 1]');
      buffer.writeln('target_density = 640');
      buffer.writeln();
    }

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

  /// تحويل اللون إلى صيغة #RRGGBBAA (كما يطلب FUTO)
  String _hexA(Color color) {
    final r = (color.value >> 16) & 0xFF;
    final g = (color.value >> 8) & 0xFF;
    final b = color.value & 0xFF;
    final a = (color.value >> 24) & 0xFF;
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}${a.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
  }
}
