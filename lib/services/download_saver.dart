import 'dart:io';
import 'dart:typed_data';
import 'package:android_intent_plus/android_intent.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadSaver {
  static const String folderName = 'FUTO THEME 1';

  /// حفظ ملف في مجلد FUTO THEME 1 داخل Download
  static Future<String?> saveToDownloads({
    required String fileName,
    required Uint8List bytes,
    String mimeType = 'application/zip',
  }) async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      // أندرويد 10+ (API 29+): استخدام MediaStore (بدون صلاحية)
      if (sdkInt >= 29) {
        return _saveUsingMediaStore(fileName, bytes, mimeType);
      } else {
        // أندرويد 9 وما دون: استخدام المسار المباشر مع الصلاحيات
        return _saveUsingLegacyPath(fileName, bytes, sdkInt);
      }
    } else {
      // iOS أو سطح المكتب
      return _saveToAppDocuments(fileName, bytes);
    }
  }

  /// أندرويد 10+: MediaStore API (بدون صلاحيات)
  static Future<String?> _saveUsingMediaStore(
      String fileName, Uint8List bytes, String mimeType) async {
    try {
      // استخدام MethodChannel للتواصل مع كود Android الأصلي
      // في Flutter، نستخدم حزمة مثل `better_download_saver` أو `media_store_plus`
      // هنا سنستخدم مسار مؤقت ثم نستخدم MediaStore

      // ملاحظة: هذا يتطلب كوداً أصلياً في Android
      // سنستخدم حلاً بديلاً: كتابة في مجلد التطبيق المؤقت أولاً
      // ثم استخدام Android Intent لفتحه في التطبيق المناسب

      // الحل الأبسط: استخدام حزمة `media_store_plus` (سنضيفها في pubspec)
      return await _saveUsingMediaStorePlus(fileName, bytes, mimeType);
    } catch (e) {
      debugPrint('MediaStore Error: $e');
      return null;
    }
  }

  /// حفظ باستخدام media_store_plus (حزمة جاهزة)
  static Future<String?> _saveUsingMediaStorePlus(
      String fileName, Uint8List bytes, String mimeType) async {
    try {
      // استيراد الحزمة
      // import 'package:media_store_plus/media_store_plus.dart';
      
      // MediaStore.appFolder = folderName;
      // final uri = await MediaStore().saveFile(
      //   fileName: fileName,
      //   bytes: bytes,
      //   mimeType: mimeType,
      // );
      // return uri;
      
      // مؤقتاً: حفظ في مجلد التطبيق
      final dir = Directory('/storage/emulated/0/Download/$folderName');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      debugPrint('MediaStore Plus Error: $e');
      return null;
    }
  }

  /// أندرويد 9 وما دون: المسار المباشر
  static Future<String?> _saveUsingLegacyPath(
      String fileName, Uint8List bytes, int sdkInt) async {
    // طلب صلاحية الكتابة
    if (sdkInt < 29) {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        return null;
      }
    }

    try {
      final dir = Directory('/storage/emulated/0/Download/$folderName');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      debugPrint('Legacy Save Error: $e');
      return null;
    }
  }

  /// حفظ في مجلد التطبيق (احتياطي)
  static Future<String?> _saveToAppDocuments(
      String fileName, Uint8List bytes) async {
    final dir = Directory('/data/data/com.example.neon_futo_studio/files');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  /// فتح إعدادات التطبيق لمنح الصلاحية يدوياً
  static Future<void> openAppSettings() async {
    if (Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:com.example.neon_futo_studio',
      );
      await intent.launch();
    }
  }

  /// طلب صلاحية الوصول لجميع الملفات (Android 11+)
  static Future<bool> requestManageExternalStorage() async {
    if (Platform.isAndroid) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt >= 30) {
        // فتح إعدادات "الوصول لجميع الملفات"
        final intent = AndroidIntent(
          action: 'android.settings.MANAGE_APP_ALL_FILES_ACCESS_PERMISSION',
          data: 'package:com.example.neon_futo_studio',
        );
        await intent.launch();
        return true;
      }
    }
    return false;
  }
}
