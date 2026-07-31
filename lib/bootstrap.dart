import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:wallet/core/analytics_service.dart';
import 'package:wallet/core/backup_service.dart';
import 'package:wallet/core/currency_cubit.dart';
import 'package:wallet/core/notification_service.dart';
import 'package:wallet/core/push_notification_service.dart';
import 'package:wallet/core/shared_preference.dart';
import 'package:wallet/core/widget_service.dart';
import 'package:wallet/counter/bloc/bloc.dart';
import 'package:wallet/counter/cubit/counter_cubit.dart';
import 'package:wallet/firebase_options.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    log('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    log('onError(${bloc.runtimeType}, $error, $stackTrace)');
    super.onError(bloc, error, stackTrace);
  }
}

Future<void> bootstrap(
  FutureOr<Widget> Function() builder, {
  FutureOr<void> Function()? onPrefsReady,
}) async {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase core is the only external init that must run before the first
  // frame: the root App reads AnalyticsService.observer while building. Guarded
  // and time-boxed so a failed/slow init degrades analytics + push instead of
  // stranding the app on the splash screen (see the getToken() hang this
  // pattern was hardened against).
  await _guard('Firebase.initializeApp', () async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    AnalyticsService.attach();
  });

  Bloc.observer = const AppBlocObserver();

  // Required before runApp: App.build reads onboarding/currency from here.
  final pref = await SharedPreferences.getInstance();
  SingletonSharedPreference.init(pref);

  // Optional hook (dev flavor only) to prime SharedPreferences before the
  // bloc/cubit singletons read their initial state — e.g. seeding demo data.
  if (onPrefsReady != null) {
    await onPrefsReady();
  }

  // Add cross-flavor configuration here

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CounterCubit(),
        ),
        BlocProvider(
          create: (_) => CounterBloc(),
        ),
        BlocProvider(
          create: (_) => CurrencyCubit(),
        ),
      ],
      child: await builder(),
    ),
  );

  // Everything below is off the first-frame critical path. Fired after runApp
  // and individually guarded + timed out, so a slow or throwing plugin can
  // never block startup — the app is already on screen.
  unawaited(_initInBackground());
}

/// Runs the non-essential startup work once the UI is already up. Each step is
/// isolated by [_guard] so one failure neither aborts the rest nor surfaces to
/// the user.
Future<void> _initInBackground() async {
  await _guard('timezones', () async => tz.initializeTimeZones());

  // Anonymous usage analytics (DAU/WAU/MAU) — no user is identified.
  await _guard('AnalyticsService.init', AnalyticsService.init);

  final notificationService = NotificationService();
  await _guard(
    'NotificationService.init',
    notificationService.initNotification,
  );
  // Wire FCM up after the local plugin so its Android channels already exist
  // and foreground pushes can be rendered through the same plugin.
  await _guard(
    'PushNotificationService.init',
    () => PushNotificationService(notificationService).init(),
  );

  // Bridge balance/income/expense to the home-screen widget and start
  // listening for its button taps. Reads persisted data directly, so it only
  // needs SharedPreferences to be ready.
  await _guard('WidgetService.init', WidgetService.init);

  // Automatic backup: register the on-close trigger, then take the on-open
  // snapshot. Both no-op unless the user enabled the feature.
  WidgetsBinding.instance.addObserver(_BackupLifecycleObserver());
  await _guard(
    'BackupService.backupNow(open)',
    BackupService.instance.backupNow,
  );
}

/// Fires an automatic backup when the app is sent to the background, pairing
/// with the on-open snapshot above to give the on-open / on-close cadence the
/// backup feature promises.
class _BackupLifecycleObserver extends WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      unawaited(BackupService.instance.backupNow());
    }
  }
}

/// Runs [task] with a timeout, swallowing and logging any error so a single
/// misbehaving startup step cannot hang or crash bootstrap. [label] identifies
/// the step in logs.
Future<void> _guard(
  String label,
  FutureOr<void> Function() task, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  try {
    await Future<void>.sync(task).timeout(timeout);
  } on Object catch (error, stack) {
    log(
      'bootstrap step "$label" failed (continuing): $error',
      stackTrace: stack,
    );
  }
}
