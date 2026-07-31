package dev.merdan.wallet

import android.content.ContentUris
import android.content.ContentValues
import android.os.Build
import android.os.Environment
import android.provider.MediaStore
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * Hosts the Flutter UI and a small MethodChannel used by BackupService to write
 * durable, survives-uninstall backups into the public Downloads folder.
 *
 * On API >= 29 this goes through MediaStore (no storage permission needed); on
 * API <= 28 it writes the file directly (the manifest declares
 * WRITE_EXTERNAL_STORAGE with maxSdkVersion=28). Backups land in
 * Download/Gapjyk/ with date-based names, so lexical-descending order is
 * newest-first — which is how [pruneDownloads] keeps only the most recent files.
 */
class MainActivity : FlutterActivity() {
    private val channelName = "dev.merdan.wallet/backup"

    /** Subfolder under public Downloads. Environment.DIRECTORY_DOWNLOADS is
     *  "Download", so the on-disk path is Download/Gapjyk. */
    private val relativeDir = Environment.DIRECTORY_DOWNLOADS + "/Gapjyk"
    private val mimeXlsx =
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            channelName,
        ).setMethodCallHandler { call, result ->
            try {
                when (call.method) {
                    "writeDownload" -> {
                        val fileName = call.argument<String>("fileName")!!
                        val bytes = call.argument<ByteArray>("bytes")!!
                        result.success(writeDownload(fileName, bytes))
                    }
                    "pruneDownloads" -> {
                        pruneDownloads(call.argument<Int>("keep") ?: 14)
                        result.success(null)
                    }
                    else -> result.notImplemented()
                }
            } catch (e: Exception) {
                result.error("backup_error", e.message, null)
            }
        }
    }

    /**
     * Writes [bytes] to Download/Gapjyk/[fileName], replacing any same-named
     * file so same-day backups overwrite instead of piling up as "name (1)".
     * Returns the resulting location (content uri or file path).
     */
    private fun writeDownload(fileName: String, bytes: ByteArray): String {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val resolver = contentResolver
            val collection = MediaStore.Downloads.EXTERNAL_CONTENT_URI
            // Drop any existing same-name entry first; MediaStore would
            // otherwise de-duplicate by appending " (1)" to the display name.
            resolver.delete(
                collection,
                "${MediaStore.Downloads.DISPLAY_NAME}=? AND " +
                    "${MediaStore.Downloads.RELATIVE_PATH}=?",
                arrayOf(fileName, "$relativeDir/"),
            )
            val values = ContentValues().apply {
                put(MediaStore.Downloads.DISPLAY_NAME, fileName)
                put(MediaStore.Downloads.MIME_TYPE, mimeXlsx)
                put(MediaStore.Downloads.RELATIVE_PATH, relativeDir)
                put(MediaStore.Downloads.IS_PENDING, 1)
            }
            val uri = resolver.insert(collection, values)
                ?: throw IllegalStateException("MediaStore insert returned null")
            resolver.openOutputStream(uri)?.use { it.write(bytes) }
                ?: throw IllegalStateException("Could not open output stream")
            values.clear()
            values.put(MediaStore.Downloads.IS_PENDING, 0)
            resolver.update(uri, values, null, null)
            return uri.toString()
        }
        // API <= 28: direct file write under public Downloads.
        val dir = File(
            Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS,
            ),
            "Gapjyk",
        )
        if (!dir.exists()) dir.mkdirs()
        val file = File(dir, fileName)
        file.writeBytes(bytes)
        return file.absolutePath
    }

    /**
     * Keeps only the newest [keep] Gapjyk backups. Filenames are date-based, so
     * sorting by display name descending yields newest-first and everything
     * past [keep] is deleted.
     */
    private fun pruneDownloads(keep: Int) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            val resolver = contentResolver
            val collection = MediaStore.Downloads.EXTERNAL_CONTENT_URI
            val projection = arrayOf(MediaStore.Downloads._ID)
            val selection = "${MediaStore.Downloads.RELATIVE_PATH}=?"
            val args = arrayOf("$relativeDir/")
            val sort = "${MediaStore.Downloads.DISPLAY_NAME} DESC"
            val ids = mutableListOf<Long>()
            resolver.query(collection, projection, selection, args, sort)
                ?.use { cursor ->
                    val idCol =
                        cursor.getColumnIndexOrThrow(MediaStore.Downloads._ID)
                    while (cursor.moveToNext()) ids.add(cursor.getLong(idCol))
                }
            ids.drop(keep).forEach { id ->
                resolver.delete(
                    ContentUris.withAppendedId(collection, id),
                    null,
                    null,
                )
            }
            return
        }
        val dir = File(
            Environment.getExternalStoragePublicDirectory(
                Environment.DIRECTORY_DOWNLOADS,
            ),
            "Gapjyk",
        )
        val files = dir.listFiles()?.sortedByDescending { it.name } ?: return
        files.drop(keep).forEach { it.delete() }
    }
}
