package com.example.neon_futo_studio

import android.content.ContentValues
import android.content.Context
import android.net.Uri
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream

class MediaStoreSaver(private val context: Context) : MethodChannel.MethodCallHandler {

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "saveToDownloads" -> {
                val fileName = call.argument<String>("fileName")
                val bytes = call.argument<ByteArray>("bytes")
                val mimeType = call.argument<String>("mimeType") ?: "application/octet-stream"
                val folderName = call.argument<String>("folderName") ?: "FUTO THEME 1"

                if (fileName == null || bytes == null) {
                    result.error("INVALID_ARGS", "fileName and bytes are required", null)
                    return
                }

                try {
                    val savedPath = saveToDownloads(fileName, bytes, mimeType, folderName)
                    result.success(savedPath)
                } catch (e: Exception) {
                    result.error("SAVE_FAILED", e.message, null)
                }
            }
            "getDownloadPath" -> {
                val path = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                    "Download/FUTO THEME 1"
                } else {
                    "${Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)}/FUTO THEME 1"
                }
                result.success(path)
            }

            "notifyMediaStore" -> {
                try {
                    val filePath = call.argument<String>("filePath")
                    if (filePath != null) {
                        val file = File(filePath)
                        android.media.MediaScannerConnection.scanFile(
                            context,
                            arrayOf(file.absolutePath),
                            null,
                            null
                        )
                    }
                    result.success(true)
                } catch (e: Exception) {
                    result.error("SCAN_FAILED", e.message, null)
                }
            }
            "openAppSettings" -> {
                try {
                    val intent = android.content.Intent(
                        android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS,
                        android.net.Uri.parse("package:" + context.packageName)
                    )
                    intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
                    context.startActivity(intent)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("OPEN_SETTINGS_FAILED", e.message, null)
                }
            }
            "requestManageExternalStorage" -> {
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
                        if (!Environment.isExternalStorageManager()) {
                            val intent = android.content.Intent(
                                android.provider.Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION,
                                android.net.Uri.parse("package:" + context.packageName)
                            )
                            intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
                            context.startActivity(intent)
                            result.success(true)
                        } else {
                            result.success(true)
                        }
                    } else {
                        result.success(true)
                    }
                } catch (e: Exception) {
                    result.error("PERMISSION_FAILED", e.message, null)
                }
            }
            else -> result.notImplemented()
        }
    }


    private fun saveToDownloads(
        fileName: String,
        bytes: ByteArray,
        mimeType: String,
        folderName: String
    ): String? {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            // Android 10+: استخدام MediaStore
            saveWithMediaStore(fileName, bytes, mimeType, folderName)
        } else {
            // Android 9 وما دون: استخدام المسار المباشر
            saveWithDirectPath(fileName, bytes, folderName)
        }
    }

    private fun saveWithMediaStore(
        fileName: String,
        bytes: ByteArray,
        mimeType: String,
        folderName: String
    ): String? {
        val resolver = context.contentResolver
        val values = ContentValues().apply {
            put(MediaStore.MediaColumns.DISPLAY_NAME, fileName)
            put(MediaStore.MediaColumns.MIME_TYPE, mimeType)
            put(MediaStore.MediaColumns.RELATIVE_PATH, "${Environment.DIRECTORY_DOWNLOADS}/$folderName")
            put(MediaStore.MediaColumns.IS_PENDING, 1)
        }

        val collection = MediaStore.Downloads.EXTERNAL_CONTENT_URI
        val uri: Uri? = resolver.insert(collection, values)

        uri?.let {
            resolver.openOutputStream(it).use { outputStream ->
                outputStream?.write(bytes)
                outputStream?.flush()
            }

            values.clear()
            values.put(MediaStore.MediaColumns.IS_PENDING, 0)
            resolver.update(it, values, null, null)

            // إرجاع المسار الكامل
            return getPathFromUri(it)
        }

        return null
    }

    private fun saveWithDirectPath(
        fileName: String,
        bytes: ByteArray,
        folderName: String
    ): String? {
        val downloadsDir = Environment.getExternalStoragePublicDirectory(Environment.DIRECTORY_DOWNLOADS)
        val themeDir = File(downloadsDir, folderName)
        if (!themeDir.exists()) {
            themeDir.mkdirs()
        }
        val file = File(themeDir, fileName)
        FileOutputStream(file).use { it.write(bytes) }
        return file.absolutePath
    }

    private fun getPathFromUri(uri: Uri): String? {
        val projection = arrayOf(MediaStore.MediaColumns.DATA)
        context.contentResolver.query(uri, projection, null, null, null)?.use { cursor ->
            if (cursor.moveToFirst()) {
                val columnIndex = cursor.getColumnIndexOrThrow(MediaStore.MediaColumns.DATA)
                return cursor.getString(columnIndex)
            }
        }
        return uri.toString()
    }
}
