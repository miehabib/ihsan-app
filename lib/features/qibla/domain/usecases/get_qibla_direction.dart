/// Use case: Get Qibla direction.
///
/// Takes the user's coordinates and returns the bearing to the Kaaba.
library;

import 'package:ihsan_app/core/utils/result.dart';
import 'package:ihsan_app/core/utils/usecase.dart';
import 'package:ihsan_app/features/qibla/domain/entities/qibla_entity.dart';
import 'package:ihsan_app/features/qibla/domain/repositories/qibla_repository.dart';

class GetQiblaDirectionUseCase implements UseCase<QiblaEntity, QiblaParams> {
  const GetQiblaDirectionUseCase(this._repository);

  final QiblaRepository _repository;

  @override
  FutureResult<QiblaEntity> call(QiblaParams params) {
    return _repository.getQiblaDirection(
      latitude: params.latitude,
      longitude: params.longitude,
    );
  }
}

/// Parameters for [GetQiblaDirectionUseCase].
class QiblaParams {
  const QiblaParams({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;
}
