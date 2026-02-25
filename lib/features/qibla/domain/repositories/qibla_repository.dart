/// Qibla repository contract (domain layer).
library;

import 'package:ihsan_app/core/utils/result.dart';
import 'package:ihsan_app/features/qibla/domain/entities/qibla_entity.dart';

abstract class QiblaRepository {
  /// Calculate the Qibla direction for the given coordinates.
  FutureResult<QiblaEntity> getQiblaDirection({
    required double latitude,
    required double longitude,
  });
}
