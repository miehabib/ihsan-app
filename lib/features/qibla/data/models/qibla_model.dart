/// Qibla data model.
library;

import 'package:ihsan_app/features/qibla/domain/entities/qibla_entity.dart';

class QiblaModel extends QiblaEntity {
  const QiblaModel({
    required super.direction,
    required super.latitude,
    required super.longitude,
  });

  /// Construct from JSON (for API / cache deserialization).
  factory QiblaModel.fromJson(Map<String, dynamic> json) {
    return QiblaModel(
      direction: (json['direction'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }

  /// Serialize to JSON.
  Map<String, dynamic> toJson() {
    return {
      'direction': direction,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  factory QiblaModel.fromEntity(QiblaEntity entity) {
    return QiblaModel(
      direction: entity.direction,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}
