/// Riverpod providers for the Qibla feature.
///
/// Follows the same layered provider pattern as the Prayer feature:
/// data source → repository → use case → state.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ihsan_app/core/providers/core_providers.dart';
import 'package:ihsan_app/core/services/location_service.dart';
import 'package:ihsan_app/features/qibla/data/datasources/qibla_local_datasource.dart';
import 'package:ihsan_app/features/qibla/data/repositories/qibla_repository_impl.dart';
import 'package:ihsan_app/features/qibla/domain/entities/qibla_entity.dart';
import 'package:ihsan_app/features/qibla/domain/repositories/qibla_repository.dart';
import 'package:ihsan_app/features/qibla/domain/usecases/get_qibla_direction.dart';

// ── Data source provider ─────────────────────────────────────────────────────

final qiblaLocalDataSourceProvider = Provider<QiblaLocalDataSource>((ref) {
  return QiblaCalculationDataSource();
});

// ── Repository provider ──────────────────────────────────────────────────────

final qiblaRepositoryProvider = Provider<QiblaRepository>((ref) {
  return QiblaRepositoryImpl(
    localDataSource: ref.watch(qiblaLocalDataSourceProvider),
  );
});

// ── Use case provider ────────────────────────────────────────────────────────

final getQiblaDirectionUseCaseProvider =
    Provider<GetQiblaDirectionUseCase>((ref) {
  return GetQiblaDirectionUseCase(ref.watch(qiblaRepositoryProvider));
});

// ── Qibla direction provider ─────────────────────────────────────────────────

/// Computes the Qibla bearing based on the user's location.
final qiblaDirectionProvider =
    FutureProvider.autoDispose<QiblaEntity>((ref) async {
  // 1. Get current location
  final locationService = ref.watch(locationServiceProvider);
  final locationResult = await locationService.getCurrentLocation();

  final LocationData location = locationResult.fold(
    (failure) => throw QiblaException(failure.message),
    (data) => data,
  );

  // 2. Call use case
  final useCase = ref.watch(getQiblaDirectionUseCaseProvider);
  final result = await useCase(QiblaParams(
    latitude: location.latitude,
    longitude: location.longitude,
  ));

  return result.fold(
    (failure) => throw QiblaException(failure.message),
    (entity) => entity,
  );
});

// ── Compass heading stream provider ──────────────────────────────────────────

/// Streams the device compass heading in real time.
/// Returns `null` when the compass is unavailable.
final compassHeadingProvider = StreamProvider.autoDispose<double?>((ref) {
  final compassService = ref.watch(compassServiceProvider);
  return compassService.headingStream;
});

// ── Custom exception ─────────────────────────────────────────────────────────

class QiblaException implements Exception {
  const QiblaException(this.message);
  final String message;

  @override
  String toString() => message;
}
