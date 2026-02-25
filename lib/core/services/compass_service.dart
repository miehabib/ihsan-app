/// Compass service abstraction.
///
/// Wraps the device's magnetometer so that Qibla calculations
/// remain testable and sensor-agnostic.
library;

/// Contract for reading compass heading data.
abstract class CompassService {
  /// Stream of compass heading values in degrees (0–360).
  /// Returns `null` values when the sensor is unavailable.
  Stream<double?> get headingStream;

  /// Whether the device has a magnetometer / compass.
  Future<bool> isCompassAvailable();
}
