/// Use case: Get prayer times for a specific date.
///
/// Separated from [GetPrayerTimesUseCase] because the parameter set
/// differs (includes a [DateTime]). Each use case stays focused on
/// a single responsibility.
library;

import 'package:ihsan_app/core/utils/result.dart';
import 'package:ihsan_app/core/utils/usecase.dart';
import 'package:ihsan_app/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:ihsan_app/features/prayer/domain/repositories/prayer_repository.dart';

class GetPrayerTimesForDateUseCase
    implements UseCase<PrayerTimesEntity, PrayerTimesForDateParams> {
  const GetPrayerTimesForDateUseCase(this._repository);

  final PrayerRepository _repository;

  @override
  FutureResult<PrayerTimesEntity> call(PrayerTimesForDateParams params) {
    return _repository.getPrayerTimesForDate(
      latitude: params.latitude,
      longitude: params.longitude,
      calculationMethod: params.calculationMethod,
      date: params.date,
    );
  }
}

/// Parameters for [GetPrayerTimesForDateUseCase].
class PrayerTimesForDateParams {
  const PrayerTimesForDateParams({
    required this.latitude,
    required this.longitude,
    required this.calculationMethod,
    required this.date,
  });

  final double latitude;
  final double longitude;
  final String calculationMethod;
  final DateTime date;
}
