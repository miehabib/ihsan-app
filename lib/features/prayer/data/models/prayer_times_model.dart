/// Prayer Times data model.
///
/// This model extends / maps to the domain [PrayerTimesEntity].
/// It knows how to serialize/deserialize (for caching and future API
/// responses) and how to be constructed from the Adhan package output.
///
/// Architecture decision: Models live in the data layer because
/// serialization is an implementation detail the domain should not
/// know about.
library;

import 'package:ihsan_app/features/prayer/domain/entities/prayer_times_entity.dart';

class PrayerTimesModel extends PrayerTimesEntity {
  const PrayerTimesModel({
    required super.fajr,
    required super.sunrise,
    required super.dhuhr,
    required super.asr,
    required super.maghrib,
    required super.isha,
    required super.date,
    required super.calculationMethod,
    super.latitude,
    super.longitude,
  });

  /// Construct from a JSON map (for API / cache deserialization).
  factory PrayerTimesModel.fromJson(Map<String, dynamic> json) {
    return PrayerTimesModel(
      fajr: DateTime.parse(json['fajr'] as String),
      sunrise: DateTime.parse(json['sunrise'] as String),
      dhuhr: DateTime.parse(json['dhuhr'] as String),
      asr: DateTime.parse(json['asr'] as String),
      maghrib: DateTime.parse(json['maghrib'] as String),
      isha: DateTime.parse(json['isha'] as String),
      date: DateTime.parse(json['date'] as String),
      calculationMethod: json['calculation_method'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  /// Serialize to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'fajr': fajr.toIso8601String(),
      'sunrise': sunrise.toIso8601String(),
      'dhuhr': dhuhr.toIso8601String(),
      'asr': asr.toIso8601String(),
      'maghrib': maghrib.toIso8601String(),
      'isha': isha.toIso8601String(),
      'date': date.toIso8601String(),
      'calculation_method': calculationMethod,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// Convert a domain entity back into a model (useful for caching).
  factory PrayerTimesModel.fromEntity(PrayerTimesEntity entity) {
    return PrayerTimesModel(
      fajr: entity.fajr,
      sunrise: entity.sunrise,
      dhuhr: entity.dhuhr,
      asr: entity.asr,
      maghrib: entity.maghrib,
      isha: entity.isha,
      date: entity.date,
      calculationMethod: entity.calculationMethod,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}
