/// Location service abstraction.
///
/// Architecture decision: The core services layer owns the **contract**
/// (abstract class) while the data layer provides platform-specific
/// implementations. This keeps features testable — just inject a fake
/// [LocationService] during tests.
library;

import 'package:ihsan_app/core/utils/result.dart';

/// Value object representing a geographic position.
class LocationData {
  const LocationData({
    required this.latitude,
    required this.longitude,
  });

  final double latitude;
  final double longitude;

  @override
  String toString() => 'LocationData(lat: $latitude, lng: $longitude)';
}

/// Contract for obtaining the device's current location.
abstract class LocationService {
  /// Returns the current [LocationData] or a [Failure].
  FutureResult<LocationData> getCurrentLocation();

  /// Whether location services are enabled on the device.
  Future<bool> isLocationServiceEnabled();
}
