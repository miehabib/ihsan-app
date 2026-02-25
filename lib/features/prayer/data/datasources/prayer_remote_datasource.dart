/// Remote data source for prayer times (placeholder).
///
/// This file scaffolds the remote API layer that will be implemented
/// when the Ihsan backend is ready. Currently unused by the repository,
/// but the structure is in place so adding it later is a single-line
/// change in the repository.
library;

import 'package:ihsan_app/features/prayer/data/models/prayer_times_model.dart';

/// Contract for the remote prayer times data source.
abstract class PrayerRemoteDataSource {
  /// Fetch prayer times from the backend API.
  Future<PrayerTimesModel> fetchPrayerTimes({
    required double latitude,
    required double longitude,
    required String calculationMethod,
    required DateTime date,
  });
}

/// Placeholder implementation — throws [UnimplementedError] until
/// the backend API is available.
class PrayerRemoteDataSourceImpl implements PrayerRemoteDataSource {
  // TODO: Inject HTTP client (Dio / http) when backend is ready.

  @override
  Future<PrayerTimesModel> fetchPrayerTimes({
    required double latitude,
    required double longitude,
    required String calculationMethod,
    required DateTime date,
  }) {
    // Placeholder: will call `${AppConstants.baseUrl}/prayer-times`
    throw UnimplementedError(
      'Remote prayer times API is not yet implemented. '
      'Using local Adhan calculation.',
    );
  }
}
