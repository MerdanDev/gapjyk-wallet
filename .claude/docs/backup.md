# Backup subsystem

Load this when touching backup/restore, `bootstrap.dart` startup order, or the
onboarding/settings backup UI.

## Manual backup (pre-existing)
- `encodeBackup` / `decodeBackup` in
  `lib/counter/infrastructure/backup_codec.dart` — the `.xlsx` workbook (tabs:
  Transactions, Categories, Budgets, Settings) plus legacy-CSV import. `xlsx` is
  the required export format; keep it spreadsheet-openable.
- Settings → "Back up" builds bytes from the four singletons and hands them to
  `FilePicker.saveFile`; "Restore back up" reads a file and applies via
  `_applyBackup` (shared with auto-restore).

## Automatic backup
- `lib/core/backup_service.dart` — `BackupService.instance`. `backupNow()`
  reuses `encodeBackup` from the live singletons and writes two copies, then
  prunes each to the newest 14. **No-op when disabled or when there are zero
  transactions** — the empty-store guard stops a wiped session from overwriting
  a good same-day backup.
- **Filenames are date-only** (`gapjyk-backup-YYYY-MM-DD.xlsx`): same-day writes
  overwrite, so at most one file per day. Prune/sort logic depends on that
  lexical order — don't switch to date+time without also fixing prune.
- **Two locations:**
  - Private: `getApplicationSupportDirectory()/backups/` — feeds "restore
    latest automatic backup". Wiped on clear-data/uninstall.
  - Durable (survives uninstall): Android → MediaStore `Download/Gapjyk/` via
    the `dev.merdan.wallet/backup` MethodChannel in
    `android/.../MainActivity.kt`; iOS → `getApplicationDocumentsDirectory()`,
    exposed in Files via the `UIFileSharingEnabled` /
    `LSSupportsOpeningDocumentsInPlace` keys in `ios/Runner/Info.plist`.
- **Triggers: on open and on close only.** The on-close trigger is a
  `WidgetsBindingObserver` (`paused`) registered in `bootstrap.dart`; the
  on-open one is a single `backupNow()` in the post-`runApp` background init.
  No debounce/dirty-flag — safe because every data change persists to
  SharedPreferences synchronously, so the next open captures a crashed session.
- Enable flow: onboarding `_BackupPage` and the Settings `SwitchListTile` both
  call `BackupService.instance.setEnabled(value: true)`, which flips the pref
  and takes an immediate backup. On Android 10+ MediaStore needs no runtime
  permission; on API ≤28 the durable write relies on the manifest's
  `WRITE_EXTERNAL_STORAGE` (maxSdk 28) and silently degrades to private-only if
  denied.

## Startup order (hardened)
`bootstrap.dart` runs only the first-frame essentials before `runApp` —
`WidgetsFlutterBinding`, a guarded+timed `Firebase.initializeApp` +
`AnalyticsService.attach()`, and `SharedPreferences`. Everything else
(analytics network calls, notifications, FCM, home widget, the on-open backup)
runs **after** `runApp` via `_guard` (try/catch + timeout). Keep new startup
work off the pre-`runApp` path unless the first frame genuinely needs it — a
blocking call there is what stranded the app on the splash screen (FCM
`getToken`, fixed in 2.1.0).

## Tests
`test/core/backup_service_test.dart` mocks `plugins.flutter.io/path_provider`
(no new dependency) and relies on `Platform.isAndroid/isIOS` both being false on
the test host, so only the private copy is exercised. Uses `resetAppState` and
is isolate-safe.
