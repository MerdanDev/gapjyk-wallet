# Wallet (gapjyk-wallet) — agent guide

**What it is:** Flutter personal-finance app — balance tracking, budgets, a transaction
calendar, and receipt scanning (OCR). Ships on Play Store. Scaffolded with Very Good CLI.
**Stack:** Flutter · bloc + flutter_bloc (state) · Firebase (core/analytics/messaging) ·
flutter_tesseract_ocr (receipt OCR) · syncfusion_flutter_charts · flutter_local_notifications ·
home_widget · shared_preferences · intl/l10n. Lint: `very_good_analysis`.

## Commands
| Task | Command |
|---|---|
| Install | `flutter pub get` |
| Run (dev) | `flutter run --flavor development --target lib/main_development.dart` |
| Test | `flutter test` (or `very_good test --coverage`) |
| Lint / analyze | `flutter analyze` |
| Localizations | `flutter gen-l10n` after ARB edits (`lib/l10n/arb/`) |
| Build | `flutter build appbundle --flavor production --target lib/main_production.dart` |
| Release APK | tag `vX.Y.Z` matching `pubspec.yaml`; `release.yaml` builds and publishes it |

## Layout
```
lib/
├── bootstrap.dart         # shared bootstrap
├── main{,_development,_staging,_production}.dart   # entry points (see Gotchas re bare main.dart)
├── app/view/             # root App widget
├── core/                 # shared infrastructure
├── home/                 # {application, domain, infrastructure, presentation}
├── onboarding/presentation/
├── counter/              # ⚠ Very Good CLI scaffold — see Gotchas
└── l10n/{application,arb}/
```

## Architecture
- **Feature-first**, each feature layered application / domain / infrastructure / presentation.
  State is bloc/cubit.
- Firebase is initialized in `bootstrap.dart` / flavor mains — analytics + push messaging.
- **3 flavors** with `main_*.dart` entry points; there is also a bare `main.dart`. Prefer the
  flavored targets for anything shippable.

## Gotchas
- **The release workflow refuses a tag that disagrees with `pubspec.yaml`.** Because this app
  ships on Play, where the build number may only climb, pubspec stays the source of truth and
  the tag merely records it — bump the version first, then tag.
- **Don't move the release APK's `--target-platform` into Gradle.** Dropping x86_64 saves ~30MB
  of a 91MB GitHub APK, but the bundle uploaded to Play must keep it or Chromebooks and x86
  devices can no longer install.
- `lib/counter/` is the **default Very Good CLI counter scaffold** — dead code, not a real
  feature. Safe to delete; don't model new features on it.
- OCR uses `flutter_tesseract_ocr`, which needs trained-data assets bundled — check `assets/`
  and platform setup before touching the scan flow.
- CI (`.github/workflows/main.yaml`) enforces `very_good_analysis` + coverage. Test suite was
  recently repaired to be "order-independent under a shared isolate" — keep tests isolate-safe.
- **`bootstrap.dart` must not block the first frame.** Only SharedPreferences + a guarded
  Firebase init run before `runApp`; everything else is deferred and time-boxed via `_guard`.
  A blocking pre-`runApp` call strands the app on the splash screen (this bit the FCM
  `getToken()` call). See **Deeper notes → backup**.
- **Auto-backup filenames are date-only and prune to 14.** Same-day writes overwrite; the
  Android durable copy goes to MediaStore `Download/Gapjyk/` via a Kotlin channel in
  `MainActivity.kt`. Don't switch to date+time names without fixing prune.

## Decisions
- **Auto-backup writes on app open and close only** (no on-every-change / debounce) — the user
  chose session-granularity; data persists to prefs synchronously so the next open covers a
  crash. To two places: a private copy and a durable one that survives uninstall.

## Deeper notes
- [backup](.claude/docs/backup.md) — backup/restore, the dual (private + MediaStore/Files)
  auto-backup, and the hardened `bootstrap.dart` startup order. Load when touching startup,
  backup, or the onboarding/settings backup UI.

---

## Working rules for agents

This file is the map for this repo. Trust it as the starting point — don't re-survey what it
already answers. But verify a specific before relying on it; if a path, command, or version has
drifted, fix it here as part of your change. A doc that lies costs more than no doc.

**Keep it current in the same change that makes it stale** — new command, moved module, changed
convention, discovered gotcha. Never leave it for later.

- Corrections and durable facts → the section above where they belong.
- Over ~30 lines, or specific to one subsystem → `.claude/docs/<topic>.md`, linked from a
  **Deeper notes** section with a one-line hook. Load those only when touching that area.
- Prune as readily as you add. Delete what's no longer true.
- This is an index, not an encyclopedia. Past ~100 lines, the excess belongs in `.claude/docs/`.
  Every line here competes with the actual work for context.

**Don't write:** what the code, `README`, or `git log` already states plainly; narration of what
you did this session; speculation; generated file trees.

**Accepted preferences** — when the user states a preference, corrects your approach, or approves
an option, and it still applies next week, add it under **Decisions** as `- <rule> — <why>`.
Durable choices only, not one-off task instructions. If a new preference contradicts one already
written, replace it rather than stacking a contradiction.
