/// Riverpod providers for the Prayer feature.
///
/// Wires together data sources → repository → use case → state.
/// The UI only reads [prayerTimesProvider]; it never touches
/// repositories or data sources directly.
///
/// Architecture decision: Each layer has its own provider so we can
/// override any layer independently in tests (e.g., inject a fake
/// data source while keeping the real repository logic).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ihsan_app/core/constants/app_constants.dart';
import 'package:ihsan_app/core/error/failures.dart';
import 'package:ihsan_app/core/providers/core_providers.dart';
import 'package:ihsan_app/core/services/location_service.dart';
import 'package:ihsan_app/features/prayer/data/datasources/prayer_local_datasource.dart';
import 'package:ihsan_app/features/prayer/data/repositories/prayer_repository_impl.dart';
import 'package:ihsan_app/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:ihsan_app/features/prayer/domain/repositories/prayer_repository.dart';
import 'package:ihsan_app/features/prayer/domain/usecases/get_prayer_times.dart';

// ── Data source providers ────────────────────────────────────────────────────

final prayerLocalDataSourceProvider = Provider<PrayerLocalDataSource>((ref) {
  return AdhanPrayerDataSource();
});

// ── Repository provider ──────────────────────────────────────────────────────

final prayerRepositoryProvider = Provider<PrayerRepository>((ref) {
  return PrayerRepositoryImpl(
    localDataSource: ref.watch(prayerLocalDataSourceProvider),
  );
});

// ── Use case provider ────────────────────────────────────────────────────────

final getPrayerTimesUseCaseProvider = Provider<GetPrayerTimesUseCase>((ref) {
  return GetPrayerTimesUseCase(ref.watch(prayerRepositoryProvider));
});

// ── Calculation method provider (user-configurable) ──────────────────────────

/// Holds the currently selected calculation method name.
/// Defaults to [AppConstants.defaultCalculationMethod].
/// Can be updated from a settings screen in the future.
final calculationMethodProvider = StateProvider<String>((ref) {
  return AppConstants.defaultCalculationMethod;
});

// ── Main state provider ──────────────────────────────────────────────────────

/// The primary provider consumed by the Prayer Times UI.
///
/// It auto-fetches location, then calculates prayer times.
/// Returns [AsyncValue<PrayerTimesEntity>] so the UI can handle
/// loading / error / data states declaratively.
final prayerTimesProvider =
    FutureProvider.autoDispose<PrayerTimesEntity>((ref) async {
  // 1. Get current location
  final locationService = ref.watch(locationServiceProvider);
  final locationResult = await locationService.getCurrentLocation();

  // 2. Unwrap location or throw
  final LocationData location = locationResult.fold(
    (failure) => throw PrayerTimesException(failure.message),
    (data) => data,
  );

  // 3. Get the selected calculation method
  final method = ref.watch(calculationMethodProvider);

  // 4. Call use case
  final useCase = ref.watch(getPrayerTimesUseCaseProvider);
  final result = await useCase(PrayerTimesParams(
    latitude: location.latitude,
    longitude: location.longitude,
    calculationMethod: method,
  ));

  // 5. Unwrap result or throw
  return result.fold(
    (failure) => throw PrayerTimesException(failure.message),
    (entity) => entity,
  );
});

// ── Custom exception for provider errors ─────────────────────────────────────

/// Thrown inside [prayerTimesProvider] so that [AsyncValue.error] contains
/// a descriptive message the UI can display.
class PrayerTimesException implements Exception {
  const PrayerTimesException(this.message);
  final String message;

  @override
  String toString() => message;
}
