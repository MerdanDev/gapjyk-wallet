import 'package:firebase_analytics/firebase_analytics.dart';

/// Thin wrapper around Firebase Analytics used only for anonymous app-usage
/// metrics (daily / weekly / monthly active users).
///
/// Firebase derives DAU/WAU/MAU automatically from the `session_start` and
/// `user_engagement` events it logs once collection is enabled — those counts
/// are keyed on a pseudonymous per-install app-instance id, not on any user
/// identity. To stay within our privacy policy this service deliberately:
///   * never calls [FirebaseAnalytics.setUserId] or sets user properties,
///   * disables collection of advertising/consent-based identifiers.
/// So no user is identified; we only ever learn *how many* installs are active.
class AnalyticsService {
  AnalyticsService._();

  static FirebaseAnalytics? _analytics;

  /// Navigator observer that logs `screen_view` events, which feed the
  /// engagement/active-user metrics. Attach to `MaterialApp.navigatorObservers`.
  ///
  /// Null until [attach] runs. It stays null when Firebase failed to initialize
  /// so the app can launch without analytics rather than crash building the
  /// root widget — callers guard with `if (observer != null)`.
  static FirebaseAnalyticsObserver? observer;

  /// Wires up the navigator observer. Cheap (no network), so it is called
  /// synchronously during bootstrap right after `Firebase.initializeApp`
  /// succeeds, before `runApp` — the root `App` reads [observer] as it builds.
  static void attach() {
    final analytics = FirebaseAnalytics.instance;
    _analytics = analytics;
    observer = FirebaseAnalyticsObserver(analytics: analytics);
  }

  /// Enables anonymous usage collection and records the launch. These are
  /// network-touching calls, so they run off the startup critical path (after
  /// `runApp`). No-op if [attach] never ran (Firebase unavailable).
  static Future<void> init() async {
    final analytics = _analytics;
    if (analytics == null) return;
    // Explicitly opt out of any identity/ad signals; keep only aggregate usage.
    await analytics.setConsent(
      adStorageConsentGranted: false,
      adUserDataConsentGranted: false,
      adPersonalizationSignalsConsentGranted: false,
      analyticsStorageConsentGranted: true,
    );
    await analytics.setAnalyticsCollectionEnabled(true);
    await analytics.logAppOpen();
  }
}
