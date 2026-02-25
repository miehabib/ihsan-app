/// Local data source for Qibla direction calculation.
///
/// Uses the Haversine-based bearing formula to compute the initial
/// bearing from the user's position to the Kaaba. This is a pure
/// math calculation — no sensor input here.
library;

import 'dart:math';
import 'package:ihsan_app/core/constants/app_constants.dart';
import 'package:ihsan_app/features/qibla/data/models/qibla_model.dart';

/// Contract for the Qibla data source.
abstract class QiblaLocalDataSource {
  /// Calculate the Qibla bearing for the given coordinates.
  QiblaModel calculateQiblaDirection({
    required double latitude,
    required double longitude,
  });
}

/// Implementation using the great-circle bearing formula.
class QiblaCalculationDataSource implements QiblaLocalDataSource {
  @override
  QiblaModel calculateQiblaDirection({
    required double latitude,
    required double longitude,
  }) {
    final direction = _calculateBearing(
      latitude,
      longitude,
      AppConstants.kaabaLatitude,
      AppConstants.kaabaLongitude,
    );

    return QiblaModel(
      direction: direction,
      latitude: latitude,
      longitude: longitude,
    );
  }

  /// Calculates the initial bearing from point (lat1, lon1)
  /// to point (lat2, lon2) using the forward azimuth formula.
  ///
  /// Returns degrees in the range [0, 360).
  double _calculateBearing(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLon = _toRadians(lon2 - lon1);
    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);

    final y = sin(dLon) * cos(lat2Rad);
    final x = cos(lat1Rad) * sin(lat2Rad) -
        sin(lat1Rad) * cos(lat2Rad) * cos(dLon);

    final bearing = atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  double _toRadians(double degrees) => degrees * pi / 180;
  double _toDegrees(double radians) => radians * 180 / pi;
}
