/// Reusable widget: Prayer times list.
///
/// Renders all six prayer times from a [PrayerTimesEntity],
/// highlighting the next upcoming prayer.
library;

import 'package:flutter/material.dart';
import 'package:ihsan_app/features/prayer/domain/entities/prayer_times_entity.dart';
import 'package:ihsan_app/features/prayer/presentation/widgets/prayer_time_card.dart';

class PrayerTimesList extends StatelessWidget {
  const PrayerTimesList({
    super.key,
    required this.prayerTimes,
  });

  final PrayerTimesEntity prayerTimes;

  @override
  Widget build(BuildContext context) {
    final prayers = prayerTimes.toMap();
    final nextPrayer = prayerTimes.nextPrayer;

    return Column(
      children: prayers.entries.map((entry) {
        return PrayerTimeCard(
          name: entry.key,
          time: entry.value,
          isNext: nextPrayer != null && entry.key == nextPrayer.key,
        );
      }).toList(),
    );
  }
}
