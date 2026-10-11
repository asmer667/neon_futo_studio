import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../models/futo_theme.dart';

class ZipImporter {
  /// يستورد ملف ZIP ويستخرج منه الثيم
  Future<FutoTheme?> importTheme() async {
    try {
      // 1. اختيار ملف ZIP
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['zip'],
      );

      if (result == null || result.files.single.path == null) return null;

      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();

      // 2. فك ضغط ZIP
      final archive = ZipDecoder().decodeBytes(bytes);

      // 3. البحث عن theme.txt
      ArchiveFile? themeFile;
      for (final f in archive) {
        if (f.name == 'theme.txt') {
          themeFile = f;
          break;
        }
      }

      if (themeFile == null) {
        throw Exception('ملف theme.txt غير موجود في الـ ZIP');
      }

      // 4. قراءة محتوى theme.txt
      final content = utf8.decode(themeFile.content as List<int>);

      // 5. تحويل TOML إلى FutoTheme
      return _parseToml(content);
    } catch (e) {
      throw Exception('فشل الاستيراد: $e');
    }
  }

  FutoTheme _parseToml(String content) {
    final theme = FutoTheme();
    final lines = content.split('\n');
    String currentSection = '';

    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;

      // اكتشاف الأقسام
      if (line.startsWith('[') && line.endsWith(']')) {
        currentSection = line.substring(1, line.length - 1);
        continue;
      }

      // قراءة القيم
      final parts = line.split('=');
      if (parts.length < 2) continue;

      final key = parts[0].trim();
      final value = parts.sublist(1).join('=').trim().replaceAll('"', '');

      switch (currentSection) {
        case '':
          if (key == 'name') theme.name = value;
          if (key == 'author') theme.author = value;
          if (key == 'id') theme.id = value;
          if (key == 'version') theme.version = value;
          break;
        case 'options':
          if (key == 'auto_borders') theme.autoBorders = value == 'true';
          if (key == 'center_hints') theme.centerHints = value == 'true';
          if (key == 'scale_text') theme.scaleText = double.tryParse(value) ?? 1.0;
          if (key == 'weight_text') theme.weightText = int.tryParse(value) ?? 400;
          break;
        case 'colors':
          final color = _hexToColor(value);
          if (color != null) {
            switch (key) {
              case 'primary': theme.primary = color; break;
              case 'on_primary': theme.onPrimary = color; break;
              case 'primary_container': theme.primaryContainer = color; break;
              case 'on_primary_container': theme.onPrimaryContainer = color; break;
              case 'secondary': theme.secondary = color; break;
              case 'on_secondary': theme.onSecondary = color; break;
              case 'tertiary': theme.tertiary = color; break;
              case 'on_tertiary': theme.onTertiary = color; break;
              case 'error': theme.error = color; break;
              case 'on_error': theme.onError = color; break;
              case 'background': theme.background = color; break;
              case 'on_background': theme.onBackground = color; break;
              case 'surface': theme.surface = color; break;
              case 'on_surface': theme.onSurface = color; break;
              case 'surface_variant': theme.surfaceVariant = color; break;
              case 'on_surface_variant': theme.onSurfaceVariant = color; break;
              case 'outline': theme.outline = color; break;
              case 'outline_variant': theme.outlineVariant = color; break;
              case 'shadow': theme.shadow = color; break;
              case 'scrim': theme.scrim = color; break;
              case 'keyboard_surface': theme.keyboardSurface = color; break;
              case 'keyboard_container': theme.keyboardContainer = color; break;
              case 'on_keyboard': theme.onKeyboard = color; break;
              case 'on_keyboard_container': theme.onKeyboardContainer = color; break;
              case 'keyboard_primary': theme.keyboardPrimary = color; break;
              case 'keyboard_on_primary': theme.keyboardOnPrimary = color; break;
              case 'keyboard_secondary': theme.keyboardSecondary = color; break;
              case 'keyboard_on_secondary': theme.keyboardOnSecondary = color; break;
              case 'keyboard_error': theme.keyboardError = color; break;
              case 'keyboard_on_error': theme.keyboardOnError = color; break;
              case 'keyboard_shadow': theme.keyboardShadow = color; break;
              case 'keyboard_border': theme.keyboardBorder = color; break;
              case 'keyboard_ripple': theme.keyboardRipple = color; break;
            }
          }
          break;
        case 'options.border':
          if (key == 'left_inset') theme.borderLeftInset = int.tryParse(value) ?? 20;
          if (key == 'top_inset') theme.borderTopInset = int.tryParse(value) ?? 20;
          if (key == 'right_inset') theme.borderRightInset = int.tryParse(value) ?? 20;
          if (key == 'bottom_inset') theme.borderBottomInset = int.tryParse(value) ?? 20;
          break;
      }
    }

    return theme;
  }

  Color? _hexToColor(String hex) {
    try {
      hex = hex.replaceAll('#', '').replaceAll('"', '').trim();
      if (hex.length == 6) hex = 'FF$hex';
      if (hex.length != 8) return null;
      return Color(int.parse(hex, radix: 16));
    } catch (e) {
      return null;
    }
  }
}
