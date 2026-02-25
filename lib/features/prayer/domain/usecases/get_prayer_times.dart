/// Use case: Get today's prayer times.
///
/// This is the primary use case for the prayer feature. The presentation
/// layer calls this with location + calculation method, and receives
/// either a [PrayerTimesEntity] or a [Failure].
///
/// Architecture decision: Even though this use case currently just
/// delegates to the repository, having the use case layer means we can
/// later add domain logic (caching strategies, analytics events,
/// combining multiple repo calls) without touching the UI.
library;

import 'package:ihsan_app/core/utils/result.dart';
import 'package:ihsan_app/core/utils/usecase.dart';
import 'package:ihsan_app/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:ihsan_app/features/prayer/domain/repositories/prayer_repository.dart';

class GetPrayerTimesUseCase implements UseCase<PrayerTimesEntity, PrayerTimesParams> {
  const GetPrayerTimesUseCase(this._repository);

  final PrayerRepository _repository;

  @override
  FutureResult<PrayerTimesEntity> call(PrayerTimesParams params) {
    return _repository.getPrayerTimes(
      latitude: params.latitude,
      longitude: params.longitude,
      calculationMethod: params.calculationMethod,
    );
  }
}

/// Parameters for [GetPrayerTimesUseCase].
class PrayerTimesParams {
  const PrayerTimesParams({
    required this.latitude,
    required this.longitude,
    required this.calculationMethod,
  });

  final double latitude;
  final double longitude;
  final String calculationMethod;
}
