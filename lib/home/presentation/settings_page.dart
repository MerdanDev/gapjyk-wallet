import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:wallet/core/backup_service.dart';
import 'package:wallet/core/currency_cubit.dart';
import 'package:wallet/counter/counter.dart';
import 'package:wallet/counter/cubit/budget_cubit.dart';
import 'package:wallet/counter/cubit/category_cubit.dart';
import 'package:wallet/counter/infrastructure/backup_codec.dart';
import 'package:wallet/counter/infrastructure/counter_repository.dart';
import 'package:wallet/home/presentation/budget_page.dart';
import 'package:wallet/home/presentation/category_screen.dart';
import 'package:wallet/l10n/application/localization_cubit.dart';
import 'package:wallet/l10n/l10n.dart';

/// App Store id for the iOS listing. Empty until the iOS app is published —
/// fill it in then so the rate button can open the App Store on iOS.
const String _appStoreId = '';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> _editCurrency(BuildContext context, String current) async {
    final controller = TextEditingController(text: current);
    final symbol = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.currency),
          content: TextField(
            controller: controller,
            textAlign: TextAlign.center,
            textCapitalization: TextCapitalization.characters,
            autofocus: true,
            decoration: InputDecoration(
              labelText: context.l10n.currencySymbol,
              hintText: context.l10n.currencyHint,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(context.l10n.save),
            ),
          ],
        );
      },
    );
    if (symbol != null) {
      await CurrencyCubit.instance.changeSymbol(symbol);
    }
  }

  Future<void> _restoreBackup(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final failedMessage = context.l10n.restoreFailed;

    // Accept the current `.xlsx` workbook and legacy `.csv` exports; the
    // format is detected from the file contents on read.
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv'],
    );
    // User canceled the picker
    if (result == null) return;

    final path = result.files.single.path;
    if (path == null) {
      messenger.showSnackBar(SnackBar(content: Text(failedMessage)));
      return;
    }

    final BackupData backup;
    try {
      backup = decodeBackup(await File(path).readAsBytes());
    } on Object {
      // A malformed or non-backup file throws while parsing; surface it
      // instead of crashing with no feedback.
      messenger.showSnackBar(SnackBar(content: Text(failedMessage)));
      return;
    }

    if (context.mounted) await _applyBackup(context, backup);
  }

  Future<void> _restoreLatestAutoBackup(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final failedMessage = context.l10n.restoreFailed;

    final backup = await BackupService.instance.latestPrivateBackup();
    if (backup == null) {
      messenger.showSnackBar(SnackBar(content: Text(failedMessage)));
      return;
    }

    if (context.mounted) await _applyBackup(context, backup);
  }

  /// Applies a decoded [backup] to the live state. Shared by manual restore and
  /// "restore latest automatic backup" so both behave identically.
  Future<void> _applyBackup(BuildContext context, BackupData backup) async {
    final messenger = ScaffoldMessenger.of(context);
    final successMessage = context.l10n.restoreSuccess;

    // Restore categories and budgets first so transactions and their category
    // references land against an up-to-date set.
    CounterCategoryCubit.instance.restoreBackup(backup.categories);
    BudgetCubit.instance.restoreBackup(backup.budgets);
    CounterBloc.instance.add(RestoreBackUp(list: backup.entries));

    // The currency is a personal choice, so only adopt the backup's when it
    // actually differs and the user confirms — never overwrite it silently.
    final currency = backup.currency;
    if (currency != null &&
        currency.isNotEmpty &&
        currency != CurrencyCubit.instance.state &&
        context.mounted &&
        await _confirmCurrencyChange(context, currency)) {
      await CurrencyCubit.instance.changeSymbol(currency);
    }

    messenger.showSnackBar(SnackBar(content: Text(successMessage)));
  }

  Future<void> _toggleAutoBackup(
    BuildContext context, {
    required bool on,
  }) async {
    final messenger = ScaffoldMessenger.of(context);
    final enabledMessage = context.l10n.autoBackupEnabledMessage;

    await BackupService.instance.setEnabled(value: on);
    if (!mounted) return;
    setState(() {});
    if (on) {
      messenger.showSnackBar(SnackBar(content: Text(enabledMessage)));
    }
  }

  String _autoBackupSubtitle(BuildContext context) {
    final last = BackupService.instance.lastBackupAt;
    if (last == null) return context.l10n.autoBackupSubtitle;
    String two(int n) => n.toString().padLeft(2, '0');
    final stamp = '${last.year}-${two(last.month)}-${two(last.day)} '
        '${two(last.hour)}:${two(last.minute)}';
    return context.l10n.autoBackupLast(stamp);
  }

  Future<bool> _confirmCurrencyChange(
    BuildContext context,
    String symbol,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.currency),
          content: Text(context.l10n.restoreCurrencyPrompt(symbol)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.restoreCurrencyConfirm),
            ),
          ],
        );
      },
    );
    return confirmed ?? false;
  }

  Future<void> _restorePreUpdate(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final successMessage = context.l10n.restoreSuccess;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(context.l10n.restorePreUpdate),
          content: Text(context.l10n.restorePreUpdateConfirm),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.restorePreUpdate),
            ),
          ],
        );
      },
    );
    if (confirmed ?? false) {
      // Wait for the bloc to actually apply the restore (which also clears the
      // snapshot) before rebuilding, so the now-redundant restore tile is gone
      // on the next frame rather than lingering for a beat.
      final applied = CounterBloc.instance.stream.first;
      CounterBloc.instance.add(RestorePreUpdateBackup());
      await applied;
      messenger.showSnackBar(
        SnackBar(content: Text(successMessage)),
      );
      if (mounted) setState(() {});
    }
  }

  Future<void> _rateApp(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final failedMessage = context.l10n.rateAppFailed;
    final inAppReview = InAppReview.instance;
    try {
      // Open the store listing directly so the user can leave a review,
      // since the native in-app prompt may be silently throttled.
      await inAppReview.openStoreListing(
        appStoreId: _appStoreId,
      );
    } on Object {
      messenger.showSnackBar(
        SnackBar(content: Text(failedMessage)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.category_outlined),
            title: Text(context.l10n.categories),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<CategoryScreen>(
                  builder: (context) {
                    return const CategoryScreen();
                  },
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline),
            title: Text(context.l10n.budgets),
            subtitle: Text(context.l10n.budgetsSubtitle),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<BudgetPage>(
                  builder: (context) {
                    return const BudgetPage();
                  },
                ),
              );
            },
          ),
          BlocBuilder<CurrencyCubit, String>(
            bloc: CurrencyCubit.instance,
            builder: (context, symbol) {
              return ListTile(
                leading: const Icon(Icons.payments_outlined),
                title: Text(context.l10n.currency),
                subtitle: symbol.isNotEmpty ? Text(symbol) : null,
                onTap: () => _editCurrency(context, symbol),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.cloud_sync_outlined),
            title: Text(context.l10n.autoBackup),
            subtitle: Text(_autoBackupSubtitle(context)),
            value: BackupService.instance.enabled,
            onChanged: (on) => _toggleAutoBackup(context, on: on),
          ),
          if (BackupService.instance.enabled)
            ListTile(
              leading: const Icon(Icons.history),
              title: Text(context.l10n.restoreLatest),
              onTap: () => _restoreLatestAutoBackup(context),
            ),
          ListTile(
            leading: const Icon(Icons.backup_outlined),
            title: Text(context.l10n.backUp),
            onTap: () async {
              const name = 'back_up.xlsx';
              final messenger = ScaffoldMessenger.of(context);
              final dialogTitle = context.l10n.select_output_file;
              final savedPrefix = context.l10n.save_success;

              // A complete snapshot as a spreadsheet workbook: one tab each for
              // transactions, the full category list (including unused ones),
              // monthly budgets and settings (currency). Built in memory so the
              // picker gets the bytes directly, with no scratch file left
              // behind.
              final bytes = encodeBackup(
                currency: CurrencyCubit.instance.state,
                categories: CounterCategoryCubit.instance.state,
                budgets: BudgetCubit.instance.state,
                entries: CounterBloc.instance.data,
              );

              final outputFile = await FilePicker.saveFile(
                dialogTitle: dialogTitle,
                fileName: name,
                type: FileType.custom,
                allowedExtensions: ['xlsx'],
                bytes: Uint8List.fromList(bytes),
              );

              if (outputFile != null) {
                messenger.showSnackBar(
                  SnackBar(content: Text('$savedPrefix $outputFile')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_backup_restore),
            title: Text(context.l10n.restore_backUp),
            onTap: () => _restoreBackup(context),
          ),
          if (CounterRepository.hasIncomeExpenseBackup())
            ListTile(
              leading: const Icon(Icons.restore),
              title: Text(context.l10n.restorePreUpdate),
              subtitle: Text(context.l10n.restorePreUpdateSubtitle),
              onTap: () => _restorePreUpdate(context),
            ),
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(context.l10n.languageSettings),
            onTap: () async {
              final selectedLanguage = await showDialog<String>(
                context: context,
                builder: (BuildContext context) {
                  return SimpleDialog(
                    title: Text(context.l10n.selectLanguage),
                    children: [
                      ListTile(
                        onTap: () => Navigator.pop(context, 'tk'),
                        title: const Text('Türkmen'),
                      ),
                      ListTile(
                        onTap: () => Navigator.pop(context, 'en'),
                        title: const Text('English'),
                      ),
                      ListTile(
                        onTap: () => Navigator.pop(context, 'ru'),
                        title: const Text('Русский'),
                      ),
                    ],
                  );
                },
              );
              if (selectedLanguage != null) {
                await LocalizationCubit.instance.changeLocale(selectedLanguage);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_outline),
            title: Text(context.l10n.rateApp),
            subtitle: Text(context.l10n.rateAppSubtitle),
            onTap: () => _rateApp(context),
          ),
        ],
      ),
    );
  }
}
