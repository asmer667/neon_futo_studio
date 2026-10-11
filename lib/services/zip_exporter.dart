import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import '../models/futo_theme.dart';
import 'download_saver.dart';

class ZipExporter {
  Future<String> exportTheme(FutoTheme theme, String fileName) async {
    final archive = Archive();
    final Map<String, List<int>> assets = {};

    // 1. نسخ صورة الشكل المختار
    String? shapeAssetName;
    if (theme.keyShape.isNotEmpty && theme.keyShape.startsWith('assets/')) {
      try {
        final ByteData data = await rootBundle.load(theme.keyShape);
        final Uint8List bytes = data.buffer.asUint8List();
        shapeAssetName = theme.keyShape.split('/').last;
        assets[shapeAssetName] = bytes;
      } catch (e) {
        // تجاهل
      }
    }

    // 2. نسخ الخلفية
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

    // 3. نسخ الخط المرفوع
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

    // 4. إضافة الأصول إلى الأرشيف
    for (final entry in assets.entries) {
      archive.addFile(ArchiveFile('assets/${entry.key}', entry.value.length, entry.value));
    }

    // 5. توليد theme.txt
    final buffer = StringBuffer();
    buffer.writeln('version = "${theme.version}"');
    buffer.writeln('name = "${theme.name}"');
    buffer.writeln('author = "${theme.author}"');
    buffer.writeln('id = "${theme.id}"');
    if (theme.description.isNotEmpty) {
      buffer.writeln('description = "${theme.description}"');
    }
    buffer.writeln();

    buffer.writeln('[options]');
    buffer.writeln('auto_borders = ${theme.autoBorders}');
    buffer.writeln('center_hints = ${theme.centerHints}');
    buffer.writeln('scale_text = ${theme.scaleText}');
    buffer.writeln('weight_text = ${theme.weightText}');
    buffer.writeln();

    buffer.writeln('[colors]');
    buffer.writeln('primary = "${_hex(theme.primary)}"');
    buffer.writeln('on_primary = "${_hex(theme.onPrimary)}"');
    buffer.writeln('primary_container = "${_hex(theme.primaryContainer)}"');
    buffer.writeln('on_primary_container = "${_hex(theme.onPrimaryContainer)}"');
    buffer.writeln('secondary = "${_hex(theme.secondary)}"');
    buffer.writeln('on_secondary = "${_hex(theme.onSecondary)}"');
    buffer.writeln('secondary_container = "${_hex(theme.secondaryContainer)}"');
    buffer.writeln('on_secondary_container = "${_hex(theme.onSecondaryContainer)}"');
    buffer.writeln('tertiary = "${_hex(theme.tertiary)}"');
    buffer.writeln('on_tertiary = "${_hex(theme.onTertiary)}"');
    buffer.writeln('tertiary_container = "${_hex(theme.tertiaryContainer)}"');
    buffer.writeln('on_tertiary_container = "${_hex(theme.onTertiaryContainer)}"');
    buffer.writeln('error = "${_hex(theme.error)}"');
    buffer.writeln('on_error = "${_hex(theme.onError)}"');
    buffer.writeln('error_container = "${_hex(theme.errorContainer)}"');
    buffer.writeln('on_error_container = "${_hex(theme.onErrorContainer)}"');
    buffer.writeln('background = "${_hex(theme.background)}"');
    buffer.writeln('on_background = "${_hex(theme.onBackground)}"');
    buffer.writeln('surface = "${_hex(theme.surface)}"');
    buffer.writeln('on_surface = "${_hex(theme.onSurface)}"');
    buffer.writeln('surface_variant = "${_hex(theme.surfaceVariant)}"');
    buffer.writeln('on_surface_variant = "${_hex(theme.onSurfaceVariant)}"');
    buffer.writeln('outline = "${_hex(theme.outline)}"');
    buffer.writeln('outline_variant = "${_hex(theme.outlineVariant)}"');
    buffer.writeln('shadow = "${_hex(theme.shadow)}"');
    buffer.writeln('scrim = "${_hex(theme.scrim)}"');
    buffer.writeln('keyboard_surface = "${_hex(theme.keyboardSurface)}"');
    buffer.writeln('keyboard_container = "${_hex(theme.keyboardContainer)}"');
    buffer.writeln('on_keyboard = "${_hex(theme.onKeyboard)}"');
    buffer.writeln('on_keyboard_container = "${_hex(theme.onKeyboardContainer)}"');
    buffer.writeln('keyboard_primary = "${_hex(theme.keyboardPrimary)}"');
    buffer.writeln('keyboard_on_primary = "${_hex(theme.keyboardOnPrimary)}"');
    buffer.writeln('keyboard_secondary = "${_hex(theme.keyboardSecondary)}"');
    buffer.writeln('keyboard_on_secondary = "${_hex(theme.keyboardOnSecondary)}"');
    buffer.writeln('keyboard_error = "${_hex(theme.keyboardError)}"');
    buffer.writeln('keyboard_on_error = "${_hex(theme.keyboardOnError)}"');
    buffer.writeln('keyboard_shadow = "${_hex(theme.keyboardShadow)}"');
    buffer.writeln('keyboard_border = "${_hex(theme.keyboardBorder)}"');
    buffer.writeln('keyboard_ripple = "${_hex(theme.keyboardRipple)}"');
    buffer.writeln('surface_tint = "${_hex(theme.surfaceTint)}"');
    buffer.writeln('surface_bright = "${_hex(theme.surfaceBright)}"');
    buffer.writeln('surface_dim = "${_hex(theme.surfaceDim)}"');
    buffer.writeln('surface_container = "${_hex(theme.surfaceContainer)}"');
    buffer.writeln('surface_container_high = "${_hex(theme.surfaceContainerHigh)}"');
    buffer.writeln('surface_container_highest = "${_hex(theme.surfaceContainerHighest)}"');
    buffer.writeln('surface_container_low = "${_hex(theme.surfaceContainerLow)}"');
    buffer.writeln('surface_container_lowest = "${_hex(theme.surfaceContainerLowest)}"');
    buffer.writeln('keyboard_surface_variant = "${_hex(theme.keyboardSurfaceVariant)}"');
    buffer.writeln('keyboard_container_variant = "${_hex(theme.keyboardContainerVariant)}"');
    buffer.writeln();

    if (shapeAssetName != null) {
      buffer.writeln('[matchrules]');
      buffer.writeln('border_matchrules = [');
      buffer.writeln('  { match = "normal", asset = "assets/$shapeAssetName" },');
      buffer.writeln('  { match = "functional", asset = "assets/$shapeAssetName" },');
      buffer.writeln('  { match = "pressed", asset = "assets/$shapeAssetName" },');
      buffer.writeln(']');
      buffer.writeln();

      buffer.writeln('[options.border]');
      buffer.writeln('left_inset = ${theme.borderLeftInset}');
      buffer.writeln('top_inset = ${theme.borderTopInset}');
      buffer.writeln('right_inset = ${theme.borderRightInset}');
      buffer.writeln('bottom_inset = ${theme.borderBottomInset}');
      buffer.writeln();
    }

    if (bgAssetName != null) {
      buffer.writeln('[options.background]');
      buffer.writeln('image = "assets/$bgAssetName"');
      buffer.writeln('opacity = ${theme.backgroundOpacity}');
      buffer.writeln('action_bar_opacity = ${theme.actionBarOpacity}');
      if (theme.cropRect != null && theme.cropRect!.length == 4) {
        buffer.writeln('cropping = [${theme.cropRect![0]}, ${theme.cropRect![1]}, ${theme.cropRect![2]}, ${theme.cropRect![3]}]');
      }
      buffer.writeln();
    }

    if (fontAssetName != null) {
      buffer.writeln('[options.font]');
      buffer.writeln('font = "assets/$fontAssetName"');
      buffer.writeln();
    }

    final configContent = utf8.encode(buffer.toString());
    archive.addFile(ArchiveFile('theme.txt', configContent.length, configContent));

    final zipData = ZipEncoder().encode(archive);
    final dir = await getApplicationDocumentsDirectory();
    final safeName = fileName.replaceAll(RegExp(r'[^\w\s-]'), '_');
    final zipFile = File('${dir.path}/$safeName.zip');
    await zipFile.writeAsBytes(zipData!);
    return zipFile.path;
  }

  String _hex(Color color) {
    final r = (color.value >> 16) & 0xFF;
    final g = (color.value >> 8) & 0xFF;
    final b = color.value & 0xFF;
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
  }
}
