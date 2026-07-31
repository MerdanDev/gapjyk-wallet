import 'package:flutter/services.dart';

/// Dart side of the native backup channel (see `MainActivity.kt`). Android
/// only: it writes and prunes durable, survives-uninstall backups in the
/// public Downloads folder. On other platforms `BackupService` handles the
/// durable copy itself, so these methods are never called there.
class DurableBackupChannel {
  DurableBackupChannel._();

  static const MethodChannel _channel =
      MethodChannel('dev.merdan.wallet/backup');

  /// Writes [bytes] to `Download/Gapjyk/[fileName]`, replacing any same-named
  /// file. Returns the saved location.
  static Future<String?> writeDownload(String fileName, Uint8List bytes) {
    return _channel.invokeMethod<String>('writeDownload', {
      'fileName': fileName,
      'bytes': bytes,
    });
  }

  /// Keeps only the newest [keep] `Gapjyk` backups in Downloads.
  static Future<void> pruneDownloads(int keep) {
    return _channel.invokeMethod<void>('pruneDownloads', {'keep': keep});
  }
}
