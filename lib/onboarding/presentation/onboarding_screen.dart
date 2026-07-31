import 'package:flutter/material.dart';
import 'package:wallet/core/backup_service.dart';
import 'package:wallet/core/currency_cubit.dart';
import 'package:wallet/core/notification_service.dart';
import 'package:wallet/core/shared_preference.dart';
import 'package:wallet/home/home.dart';
import 'package:wallet/l10n/application/localization_cubit.dart';
import 'package:wallet/l10n/l10n.dart';

/// First-launch introduction. Walks the user through the only required setup
/// (currency) and explains the core features (adding entries, categories,
/// reminders) before dropping them into the app. Shown once, then gated behind
/// the `onboardingCompleted` flag.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  final TextEditingController _currencyController = TextEditingController(
    text: CurrencyCubit.instance.state,
  );
  int _index = 0;
  static const int _pageCount = 6;

  @override
  void dispose() {
    _controller.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _index == _pageCount - 1;

  void _next() {
    if (_isLastPage) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      );
    }
  }

  Future<void> _finish() async {
    await CurrencyCubit.instance.changeSymbol(_currencyController.text);
    await SingletonSharedPreference.setOnboardingCompleted(value: true);
    if (!mounted) return;
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute<HomeScreen>(
        builder: (context) => const HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _isLastPage ? null : _finish,
                child: Opacity(
                  opacity: _isLastPage ? 0 : 1,
                  child: Text(l10n.skip),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (value) => setState(() => _index = value),
                children: [
                  const _LanguagePage(),
                  _CurrencyPage(controller: _currencyController),
                  const _AddEntryPage(),
                  const _CategoriesPage(),
                  const _RemindersPage(),
                  const _BackupPage(),
                ],
              ),
            ),
            _BottomControls(
              index: _index,
              pageCount: _pageCount,
              isLastPage: _isLastPage,
              onBack: () => _controller.previousPage(
                duration: const Duration(milliseconds: 250),
                curve: Curves.ease,
              ),
              onNext: _next,
            ),
          ],
        ),
      ),
    );
  }
}

/// Shared layout for every intro page: a large icon, a title, supporting body
/// text, and an optional interactive [child] (language buttons, currency
/// field, reminder toggle).
class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
    this.child,
  });

  final IconData icon;
  final String title;
  final String body;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 96, color: theme.colorScheme.primary),
          const SizedBox(height: 32),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            body,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (child != null) ...[
            const SizedBox(height: 32),
            child!,
          ],
        ],
      ),
    );
  }
}

class _LanguagePage extends StatelessWidget {
  const _LanguagePage();

  static const _languages = [
    ('tk', 'Türkmen'),
    ('en', 'English'),
    ('ru', 'Русский'),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final current = LocalizationCubit.instance.state.languageCode;
    return _OnboardingPage(
      icon: Icons.waving_hand_outlined,
      title: l10n.onbWelcomeTitle,
      body: l10n.onbWelcomeBody,
      child: Column(
        children: [
          for (final (code, name) in _languages)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: double.infinity,
                child: code == current
                    ? FilledButton(
                        onPressed: () =>
                            LocalizationCubit.instance.changeLocale(code),
                        child: Text(name),
                      )
                    : OutlinedButton(
                        onPressed: () =>
                            LocalizationCubit.instance.changeLocale(code),
                        child: Text(name),
                      ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CurrencyPage extends StatelessWidget {
  const _CurrencyPage({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _OnboardingPage(
      icon: Icons.payments_outlined,
      title: l10n.onbCurrencyTitle,
      body: l10n.onbCurrencyBody,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        textCapitalization: TextCapitalization.characters,
        decoration: InputDecoration(
          labelText: l10n.currencySymbol,
          hintText: l10n.currencyHint,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

class _AddEntryPage extends StatelessWidget {
  const _AddEntryPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _OnboardingPage(
      icon: Icons.add_circle_outline,
      title: l10n.onbAddTitle,
      body: l10n.onbAddBody,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: 'introIncome',
            onPressed: null,
            backgroundColor: Colors.green,
            child: Icon(Icons.add),
          ),
          SizedBox(width: 24),
          FloatingActionButton(
            heroTag: 'introExpense',
            onPressed: null,
            backgroundColor: Colors.red,
            child: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class _CategoriesPage extends StatelessWidget {
  const _CategoriesPage();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _OnboardingPage(
      icon: Icons.category_outlined,
      title: l10n.onbCategoriesTitle,
      body: l10n.onbCategoriesBody,
    );
  }
}

class _RemindersPage extends StatefulWidget {
  const _RemindersPage();

  @override
  State<_RemindersPage> createState() => _RemindersPageState();
}

class _RemindersPageState extends State<_RemindersPage> {
  bool _requested = false;

  Future<void> _enable() async {
    await NotificationService().requestPermissions();
    if (!mounted) return;
    setState(() => _requested = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _OnboardingPage(
      icon: Icons.notifications_active_outlined,
      title: l10n.onbRemindersTitle,
      body: l10n.onbRemindersBody,
      child: _requested
          ? const Icon(Icons.check_circle, color: Colors.green, size: 40)
          : FilledButton.icon(
              onPressed: _enable,
              icon: const Icon(Icons.notifications_outlined),
              label: Text(l10n.enableReminders),
            ),
    );
  }
}

class _BackupPage extends StatefulWidget {
  const _BackupPage();

  @override
  State<_BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<_BackupPage> {
  bool _enabled = false;

  Future<void> _enable() async {
    // Turns the feature on. The first backup runs later, once there is data to
    // save and the app is opened/closed — a brand-new user has nothing yet.
    await BackupService.instance.setEnabled(value: true);
    if (!mounted) return;
    setState(() => _enabled = true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return _OnboardingPage(
      icon: Icons.cloud_sync_outlined,
      title: l10n.onbBackupTitle,
      body: l10n.onbBackupBody,
      child: _enabled
          ? const Icon(Icons.check_circle, color: Colors.green, size: 40)
          : FilledButton.icon(
              onPressed: _enable,
              icon: const Icon(Icons.backup_outlined),
              label: Text(l10n.enableAutoBackup),
            ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.index,
    required this.pageCount,
    required this.isLastPage,
    required this.onBack,
    required this.onNext,
  });

  final int index;
  final int pageCount;
  final bool isLastPage;
  final VoidCallback onBack;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Row(
        children: [
          TextButton(
            onPressed: index == 0 ? null : onBack,
            child: Opacity(
              opacity: index == 0 ? 0 : 1,
              child: Text(l10n.back),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < pageCount; i++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == index ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == index
                          ? theme.colorScheme.primary
                          : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onNext,
            child: Text(isLastPage ? l10n.getStarted : l10n.pass),
          ),
        ],
      ),
    );
  }
}
