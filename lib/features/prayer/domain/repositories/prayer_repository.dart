/// Prayer Times repository contract (domain layer).
///
/// The domain layer defines *what* the repository must do;
/// the data layer defines *how*. This inversion of dependency
/// is the cornerstone of Clean Architecture — the domain never
/// imports anything from the data layer.
library;

import 'package:ihsan_app/core/utils/result.dart';
import 'package:ihsan_app/features/prayer/domain/entities/prayer_times_entity.dart';

abstract class PrayerRepository {
  /// Get today's prayer times for the given coordinates.
  ///
  /// [calculationMethod] is the name of the method (e.g.,
  /// "muslim_world_league", "egyptian", "karachi", etc.).
  FutureResult<PrayerTimesEntity> getPrayerTimes({
    required double latitude,
    required double longitude,
    required String calculationMethod,
  });

  /// Get prayer times for a specific [date].
  FutureResult<PrayerTimesEntity> getPrayerTimesForDate({
    required double latitude,
    required double longitude,
    required String calculationMethod,
    required DateTime date,
  });
}
