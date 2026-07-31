import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:wallet/core/currency_cubit.dart';
import 'package:wallet/core/durable_backup_channel.dart';
import 'package:wallet/core/shared_preference.dart';
import 'package:wallet/counter/bloc/bloc.dart';
import 'package:wallet/counter/cubit/budget_cubit.dart';
import 'package:wallet/counter/cubit/category_cubit.dart';
import 'package:wallet/counter/infrastructure/backup_codec.dart';

/// Opt-in automatic backups.
///
/// When enabled, a complete snapshot is written on app open and close (wired in
/// `bootstrap.dart` and the root lifecycle observer) to two places:
///  * a **private** copy under the app support dir, used by "restore latest";
///  * a **durable** copy that survives uninstall — `Download/Gapjyk/` on
///    Android (via [DurableBackupChannel]), the Files-exposed Documents dir on
///    iOS.
///
/// Files are named `gapjyk-backup-YYYY-MM-DD.xlsx`, so same-day writes
/// overwrite and only [_retain] days are kept. The workbook is produced by the
/// same [encodeBackup] used for manual export, from the live singletons.
class BackupService {
  BackupService._();

  static final BackupService instance = BackupService._();

  /// How many dated backups to keep in each location.
  static const int _retain = 14;

  static const String _prefix = 'gapjyk-backup-';
  static const String _suffix = '.xlsx';

  bool _inProgress = false;

  bool get enabled => SingletonSharedPreference.loadAutoBackupEnabled();

  DateTime? get lastBackupAt =>
      SingletonSharedPreference.loadLastAutoBackupAt();

  /// Turns automatic backup on or off. Enabling triggers an immediate backup so
  /// the user has one straight away and can see it land.
  Future<void> setEnabled({required bool value}) async {
    await SingletonSharedPreference.setAutoBackupEnabled(value: value);
    if (value) await backupNow();
  }

  /// Writes a snapshot to both locations. No-op when disabled or when there is
  /// nothing worth backing up (no transactions) — the latter guard stops an
  /// emptied session from overwriting a good same-day backup. Never throws:
  /// backup is best-effort and must not disrupt app open/close.
  Future<void> backupNow() async {
    if (!enabled || _inProgress) return;
    final entries = CounterBloc.instance.data;
    if (entries.isEmpty) return;

    _inProgress = true;
    try {
      final bytes = Uint8List.fromList(
        encodeBackup(
          currency: CurrencyCubit.instance.state,
          categories: CounterCategoryCubit.instance.state,
          budgets: BudgetCubit.instance.state,
          entries: entries,
        ),
      );
      final fileName = '$_prefix${_dateStamp(DateTime.now())}$_suffix';

      await _writePrivate(fileName, bytes);
      await _writeDurable(fileName, bytes);

      await SingletonSharedPreference.setLastAutoBackupAt(DateTime.now());
    } on Object catch (error, stack) {
      log('Automatic backup failed: $error', stackTrace: stack);
    } finally {
      _inProgress = false;
    }
  }

  /// Decodes the most recent private backup, or null when none exists. Used by
  /// the Settings "restore latest automatic backup" action.
  Future<BackupData?> latestPrivateBackup() async {
    try {
      final dir = await _privateDir();
      final files = _datedBackups(dir);
      if (files.isEmpty) return null;
      return decodeBackup(await files.first.readAsBytes());
    } on Object catch (error, stack) {
      log('Reading latest backup failed: $error', stackTrace: stack);
      return null;
    }
  }

  Future<void> _writePrivate(String fileName, Uint8List bytes) async {
    final dir = await _privateDir();
    await File('${dir.path}/$fileName').writeAsBytes(bytes);
    _pruneDir(dir);
  }

  Future<void> _writeDurable(String fileName, Uint8List bytes) async {
    if (Platform.isAndroid) {
      await DurableBackupChannel.writeDownload(fileName, bytes);
      await DurableBackupChannel.pruneDownloads(_retain);
      return;
    }
    if (Platform.isIOS) {
      // Documents is exposed in the Files app (see Info.plist), so this copy is
      // user-accessible and survives app updates.
      final dir = await getApplicationDocumentsDirectory();
      await File('${dir.path}/$fileName').writeAsBytes(bytes);
      _pruneDir(dir);
    }
  }

  Future<Directory> _privateDir() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory('${base.path}/backups');
    if (!dir.existsSync()) dir.createSync(recursive: true);
    return dir;
  }

  /// Dated backup files in [dir], newest first. Names are date-based, so a
  /// lexical-descending sort is chronological.
  List<File> _datedBackups(Directory dir) {
    if (!dir.existsSync()) return const [];
    final files = dir.listSync().whereType<File>().where((f) {
      final name = f.uri.pathSegments.last;
      return name.startsWith(_prefix) && name.endsWith(_suffix);
    }).toList()
      ..sort((a, b) => b.path.compareTo(a.path));
    return files;
  }

  void _pruneDir(Directory dir) {
    final files = _datedBackups(dir);
    for (final file in files.skip(_retain)) {
      try {
        file.deleteSync();
      } on Object {
        // Best-effort cleanup; a file we can't delete isn't fatal.
      }
    }
  }

  String _dateStamp(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }
}
