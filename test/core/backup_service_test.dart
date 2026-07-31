import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wallet/core/backup_service.dart';
import 'package:wallet/core/shared_preference.dart';
import 'package:wallet/counter/counter.dart';
import 'package:wallet/counter/domain/income_expense.dart';
import 'package:wallet/counter/infrastructure/backup_codec.dart';

import '../helpers/helpers.dart';

/// Mirrors BackupService's naming so assertions don't depend on today's date.
final _backupName = RegExp(r'^gapjyk-backup-\d{4}-\d{2}-\d{2}\.xlsx$');

void main() {
  const pathChannel = MethodChannel('plugins.flutter.io/path_provider');
  late Directory tempDir;
  late Directory backupsDir;

  setUp(() async {
    // Isolate-safe: clears prefs and the shared CounterBloc (CI runs every file
    // in one isolate). See resetAppState.
    await resetAppState();
    await SingletonSharedPreference.setAutoBackupEnabled(value: true);

    // Point path_provider at a throwaway dir. On the test host both
    // Platform.isAndroid and isIOS are false, so only the private (support-dir)
    // copy is written — no channel is needed for the durable copy.
    tempDir = Directory.systemTemp.createTempSync('backup_test');
    backupsDir = Directory('${tempDir.path}/backups');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, (call) async {
      if (call.method == 'getApplicationSupportDirectory') return tempDir.path;
      return null;
    });

    // A transaction so backupNow has something worth saving (it skips an empty
    // store to avoid overwriting a good same-day backup).
    CounterBloc.instance.data.add(
      IncomeExpense(
        uuid: 'test-entry',
        amount: 12.5,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(pathChannel, null);
    if (tempDir.existsSync()) tempDir.deleteSync(recursive: true);
  });

  group('BackupService.backupNow', () {
    test('writes a dated workbook that round-trips the data', () async {
      await BackupService.instance.backupNow();

      final files = backupsDir.listSync().whereType<File>().toList();
      expect(files, hasLength(1));
      final name = files.single.uri.pathSegments.last;
      expect(name, matches(_backupName));

      final restored = decodeBackup(files.single.readAsBytesSync());
      expect(restored.entries.map((e) => e.uuid), contains('test-entry'));
    });

    test('does nothing when the store is empty', () async {
      CounterBloc.instance.data.clear();

      await BackupService.instance.backupNow();

      final present = backupsDir.existsSync()
          ? backupsDir.listSync()
          : <FileSystemEntity>[];
      expect(present, isEmpty);
    });

    test('does nothing when disabled', () async {
      await SingletonSharedPreference.setAutoBackupEnabled(value: false);

      await BackupService.instance.backupNow();

      final present = backupsDir.existsSync()
          ? backupsDir.listSync()
          : <FileSystemEntity>[];
      expect(present, isEmpty);
    });

    test('prunes to the newest 14 dated backups', () async {
      backupsDir.createSync(recursive: true);
      // 20 older dated files; date-based names sort chronologically.
      for (var day = 1; day <= 20; day++) {
        final d = day.toString().padLeft(2, '0');
        File('${backupsDir.path}/gapjyk-backup-2026-01-$d.xlsx')
            .writeAsBytesSync(const [0]);
      }

      await BackupService.instance.backupNow();

      final names = backupsDir
          .listSync()
          .whereType<File>()
          .map((f) => f.uri.pathSegments.last)
          .toList()
        ..sort();
      expect(names, hasLength(14));
      // Today's backup is the newest, so it must survive the prune.
      expect(names.where(_backupName.hasMatch), isNotEmpty);
      // The oldest pre-seeded files are the ones dropped.
      expect(names, isNot(contains('gapjyk-backup-2026-01-01.xlsx')));
    });
  });
}
