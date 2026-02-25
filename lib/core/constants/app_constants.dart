/// Application-wide constants.
///
/// Centralising magic values here ensures a single source of truth
/// and makes future changes (API URLs, default settings) trivial.
library;

abstract class AppConstants {
  // ── API (placeholder for future backend integration) ───────────────────
  static const String baseUrl = 'https://api.ihsan.app/v1';

  // ── Kaaba coordinates (used for Qibla calculation) ─────────────────────
  static const double kaabaLatitude = 21.4225;
  static const double kaabaLongitude = 39.8262;

  // ── Default prayer calculation method ──────────────────────────────────
  /// Default to Muslim World League; users can override this in settings.
  static const String defaultCalculationMethod = 'muslim_world_league';

  // ── Location ───────────────────────────────────────────────────────────
  static const int locationTimeoutSeconds = 10;
  static const int locationDistanceFilterMeters = 100;

  // ── UI ─────────────────────────────────────────────────────────────────
  static const String appName = 'Ihsan';
  static const double defaultPadding = 16.0;
}
