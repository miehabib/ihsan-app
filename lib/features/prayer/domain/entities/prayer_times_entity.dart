/// Prayer Times domain entity.
///
/// This is a **pure domain object** — no framework dependencies,
/// no serialization logic, no annotations. It represents the concept
/// of "today's prayer times" as the business understands it.
///
/// The data layer maps API/package responses into this entity via models.
library;

class PrayerTimesEntity {
  const PrayerTimesEntity({
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
    required this.calculationMethod,
    this.latitude,
    this.longitude,
  });

  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final DateTime date;

  /// Name of the calculation method used (e.g., "muslim_world_league").
  final String calculationMethod;

  /// Coordinates used for the calculation (for display / debugging).
  final double? latitude;
  final double? longitude;

  /// Returns the next upcoming prayer from now, or `null` if all
  /// prayers for today have passed.
  MapEntry<String, DateTime>? get nextPrayer {
    final now = DateTime.now();
    final prayers = toMap();
    for (final entry in prayers.entries) {
      if (entry.value.isAfter(now)) {
        return entry;
      }
    }
    return null; // all prayers have passed for today
  }

  /// Returns an ordered map of prayer name → time.
  Map<String, DateTime> toMap() {
    return {
      'Fajr': fajr,
      'Sunrise': sunrise,
      'Dhuhr': dhuhr,
      'Asr': asr,
      'Maghrib': maghrib,
      'Isha': isha,
    };
  }

  @override
  String toString() =>
      'PrayerTimesEntity(date: $date, method: $calculationMethod)';
}
