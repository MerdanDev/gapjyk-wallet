import 'package:flutter/material.dart';
import 'package:wallet/core/analytics_service.dart';
import 'package:wallet/core/color_schemes.g.dart';
import 'package:wallet/core/push_notification_service.dart';
import 'package:wallet/core/shared_preference.dart';
import 'package:wallet/home/home.dart';
import 'package:wallet/l10n/l10n.dart';
import 'package:wallet/l10n/localization_override.dart';
import 'package:wallet/onboarding/presentation/onboarding_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      navigatorObservers: [
        if (AnalyticsService.observer != null) AnalyticsService.observer!,
      ],
      title: 'Gapjyk',
      darkTheme: ThemeData.dark().copyWith(
        colorScheme: darkColorScheme,
      ),
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
        colorScheme: lightColorScheme,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: SingletonSharedPreference.loadOnboardingCompleted()
          ? const HomeScreen()
          : const OnboardingScreen(),
      builder: (context, child) {
        return LocalizationOverride(
          builder: (context) {
            return child ?? const SizedBox.shrink();
          },
        );
      },
    );
  }
}
