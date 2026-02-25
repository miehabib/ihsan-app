/// Concrete implementation of [PrayerRepository].
///
/// Architecture decision: The repository decides *which* data source
/// to use. Currently it only uses the local Adhan-based source.
/// When the remote API is ready, the strategy becomes:
///   1. Try remote source → cache the result locally.
///   2. If remote fails → fall back to local calculation.
///
/// The domain layer never knows about this strategy — it just calls
/// the repository and gets a [Result].
library;

import 'package:dartz/dartz.dart';
import 'package:ihsan_app/core/error/failures.dart';
import 'package:ihsan_app/core/utils/result.dart';
import 'package:ihsan_app/features/prayer/data/datasources/prayer_local_datasource.dart';
import 'package:ihsan_app/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:ihsan_app/features/prayer/domain/repositories/prayer_repository.dart';

class PrayerRepositoryImpl implements PrayerRepository {
  const PrayerRepositoryImpl({
    required PrayerLocalDataSource localDataSource,
    // required PrayerRemoteDataSource remoteDataSource, // uncomment when ready
  }) : _localDataSource = localDataSource;

  final PrayerLocalDataSource _localDataSource;
  // final PrayerRemoteDataSource _remoteDataSource;

  @override
  FutureResult<PrayerTimesEntity> getPrayerTimes({
    required double latitude,
    required double longitude,
    required String calculationMethod,
  }) async {
    return _calculateLocally(
      latitude: latitude,
      longitude: longitude,
      calculationMethod: calculationMethod,
      date: DateTime.now(),
    );
  }

  @override
  FutureResult<PrayerTimesEntity> getPrayerTimesForDate({
    required double latitude,
    required double longitude,
    required String calculationMethod,
    required DateTime date,
  }) async {
    return _calculateLocally(
      latitude: latitude,
      longitude: longitude,
      calculationMethod: calculationMethod,
      date: date,
    );
  }

  /// Wraps the local calculation in a try/catch and returns [Result].
  FutureResult<PrayerTimesEntity> _calculateLocally({
    required double latitude,
    required double longitude,
    required String calculationMethod,
    required DateTime date,
  }) async {
    try {
      final result = _localDataSource.calculatePrayerTimes(
        latitude: latitude,
        longitude: longitude,
        calculationMethod: calculationMethod,
        date: date,
      );
      return Right(result);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to calculate prayer times: $e'),
      );
    }
  }
}
