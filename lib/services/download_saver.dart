import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DownloadSaver {
  static const String _channel = 'com.neonfuto.studio/mediastore';
  static const String folderName = 'FUTO THEME 1';

  static final MethodChannel _methodChannel = MethodChannel(_channel);

  /// حفظ ملف في مجلد FUTO THEME 1 داخل Download باستخدام MediaStore
  static Future<String?> saveToDownloads({
    required String fileName,
    required Uint8List bytes,
    String mimeType = 'application/zip',
  }) async {
    try {
      // على أندرويد فقط
      if (Platform.isAndroid) {
        final String? path = await _methodChannel.invokeMethod<String>(
          'saveToDownloads',
          {
            'fileName': fileName,
            'bytes': bytes,
            'mimeType': mimeType,
            'folderName': folderName,
          },
        );

        if (path != null) {
          debugPrint('✅ تم الحفظ في: $path');
          return path;
        }
      }

      // على المنصات الأخرى: استخدام المسار العادي
      return await _saveToAppDocuments(fileName, bytes);
    } on PlatformException catch (e) {
      debugPrint('❌ PlatformException: ${e.message}');
      // محاولة الحفظ بالطريقة القديمة كحل احتياطي
      return await _saveFallback(fileName, bytes);
    } catch (e) {
      debugPrint('❌ Error: $e');
      return await _saveFallback(fileName, bytes);
    }
  }

  /// حفظ احتياطي مباشرة في Download
  static Future<String?> _saveFallback(String fileName, Uint8List bytes) async {
    try {
      final dir = Directory('/storage/emulated/0/Download/$folderName');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);

      // محاولة إعلام MediaStore بالملف الجديد
      try {
        await _methodChannel.invokeMethod('notifyMediaStore', {
          'filePath': file.path,
        });
      } catch (_) {
        // تجاهل إذا لم يكن متوفراً
      }

      return file.path;
    } catch (e) {
      debugPrint('❌ Fallback Error: $e');
      return null;
    }
  }

  /// حفظ في مجلد التطبيق (احتياطي أخير)
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
    try {
      await _methodChannel.invokeMethod('openAppSettings');
    } catch (e) {
      debugPrint('Error opening app settings: $e');
    }
  }

  /// طلب صلاحية الوصول لجميع الملفات (Android 11+)
  static Future<bool> requestManageExternalStorage() async {
    try {
      final bool? result = await _methodChannel
          .invokeMethod<bool>('requestManageExternalStorage');
      return result ?? false;
    } catch (e) {
      debugPrint('Error requesting permission: $e');
      return false;
    }
  }

  /// الحصول على مسار مجلد التنزيلات
  static Future<String?> getDownloadPath() async {
    try {
      return await _methodChannel.invokeMethod<String>('getDownloadPath');
    } catch (e) {
      return 'Download/$folderName';
    }
  }
}
