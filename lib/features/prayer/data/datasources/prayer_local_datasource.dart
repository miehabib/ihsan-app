/// Local data source for prayer times — uses the Adhan package.
///
/// Architecture decision: The data source is the lowest layer — it
/// talks directly to the Adhan calculation library. The repository
/// sits above it and can fall back between local and remote sources.
///
/// When a remote API is added later, a `PrayerRemoteDataSource` will
/// be created alongside this one, and the repository will handle
/// the cache-first / network-first strategy.
library;

import 'package:adhan/adhan.dart' as adhan;
import 'package:ihsan_app/features/prayer/data/models/prayer_times_model.dart';

/// Contract for the local prayer times data source.
abstract class PrayerLocalDataSource {
  /// Calculate prayer times for the given coordinates and date.
  PrayerTimesModel calculatePrayerTimes({
    required double latitude,
    required double longitude,
    required String calculationMethod,
    required DateTime date,
  });
}

/// Implementation using the Adhan Dart package.
class AdhanPrayerDataSource implements PrayerLocalDataSource {
  @override
  PrayerTimesModel calculatePrayerTimes({
    required double latitude,
    required double longitude,
    required String calculationMethod,
    required DateTime date,
  }) {
    final coordinates = adhan.Coordinates(latitude, longitude);
    final params = _resolveCalculationParameters(calculationMethod);
    final components = adhan.DateComponents.from(date);
    final prayerTimes = adhan.PrayerTimes(coordinates, components, params);

    return PrayerTimesModel(
      fajr: prayerTimes.fajr.toLocal(),
      sunrise: prayerTimes.sunrise.toLocal(),
      dhuhr: prayerTimes.dhuhr.toLocal(),
      asr: prayerTimes.asr.toLocal(),
      maghrib: prayerTimes.maghrib.toLocal(),
      isha: prayerTimes.isha.toLocal(),
      date: date,
      calculationMethod: calculationMethod,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Maps a string method name to [adhan.CalculationParameters].
  ///
  /// This central mapping makes it easy to add new methods or
  /// let users configure via settings.
  adhan.CalculationParameters _resolveCalculationParameters(String method) {
    switch (method) {
      case 'muslim_world_league':
        return adhan.CalculationMethod.muslim_world_league.getParameters();
      case 'egyptian':
        return adhan.CalculationMethod.egyptian.getParameters();
      case 'karachi':
        return adhan.CalculationMethod.karachi.getParameters();
      case 'umm_al_qura':
        return adhan.CalculationMethod.umm_al_qura.getParameters();
      case 'dubai':
        return adhan.CalculationMethod.dubai.getParameters();
      case 'qatar':
        return adhan.CalculationMethod.qatar.getParameters();
      case 'kuwait':
        return adhan.CalculationMethod.kuwait.getParameters();
      case 'singapore':
        return adhan.CalculationMethod.singapore.getParameters();
      case 'north_america':
        return adhan.CalculationMethod.north_america.getParameters();
      case 'tehran':
        return adhan.CalculationMethod.tehran.getParameters();
      case 'turkey':
        return adhan.CalculationMethod.turkey.getParameters();
      default:
        // Default to Muslim World League if unknown method is passed.
        return adhan.CalculationMethod.muslim_world_league.getParameters();
    }
  }
}
