/// Qibla direction domain entity.
///
/// Represents the computed Qibla bearing relative to the user's
/// location. This is a pure domain object with no framework dependencies.
library;

class QiblaEntity {
  const QiblaEntity({
    required this.direction,
    required this.latitude,
    required this.longitude,
  });

  /// The bearing in degrees from the user's location to the Kaaba.
  /// Range: 0–360 where 0 = North, 90 = East, etc.
  final double direction;

  /// User's latitude used for the calculation.
  final double latitude;

  /// User's longitude used for the calculation.
  final double longitude;

  @override
  String toString() =>
      'QiblaEntity(direction: ${direction.toStringAsFixed(2)}°, '
      'lat: $latitude, lng: $longitude)';
}
