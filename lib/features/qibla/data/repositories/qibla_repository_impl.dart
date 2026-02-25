/// Concrete implementation of [QiblaRepository].
library;

import 'package:dartz/dartz.dart';
import 'package:ihsan_app/core/error/failures.dart';
import 'package:ihsan_app/core/utils/result.dart';
import 'package:ihsan_app/features/qibla/data/datasources/qibla_local_datasource.dart';
import 'package:ihsan_app/features/qibla/domain/entities/qibla_entity.dart';
import 'package:ihsan_app/features/qibla/domain/repositories/qibla_repository.dart';

class QiblaRepositoryImpl implements QiblaRepository {
  const QiblaRepositoryImpl({
    required QiblaLocalDataSource localDataSource,
  }) : _localDataSource = localDataSource;

  final QiblaLocalDataSource _localDataSource;

  @override
  FutureResult<QiblaEntity> getQiblaDirection({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final result = _localDataSource.calculateQiblaDirection(
        latitude: latitude,
        longitude: longitude,
      );
      return Right(result);
    } catch (e) {
      return Left(
        ServerFailure(message: 'Failed to calculate Qibla direction: $e'),
      );
    }
  }
}
