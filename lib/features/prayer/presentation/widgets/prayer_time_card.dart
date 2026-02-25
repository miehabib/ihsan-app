/// Reusable widget: A single prayer time row.
///
/// Displays the prayer name, time, and an optional highlight
/// when it is the next upcoming prayer.
library;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ihsan_app/core/theme/app_theme.dart';

class PrayerTimeCard extends StatelessWidget {
  const PrayerTimeCard({
    super.key,
    required this.name,
    required this.time,
    this.isNext = false,
  });

  final String name;
  final DateTime time;
  final bool isNext;

  @override
  Widget build(BuildContext context) {
    final timeFormat = DateFormat.jm(); // e.g., 5:30 AM
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isNext
            ? AppTheme.primaryColor.withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(color: AppTheme.primaryColor, width: 2)
            : Border.all(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: Icon(
          _iconForPrayer(name),
          color: isNext ? AppTheme.primaryColor : Colors.grey[600],
          size: 28,
        ),
        title: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
            color: isNext ? AppTheme.primaryColor : null,
          ),
        ),
        trailing: Text(
          timeFormat.format(time),
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
            color: isNext ? AppTheme.primaryColor : null,
          ),
        ),
      ),
    );
  }

  /// Maps prayer name to a representative icon.
  IconData _iconForPrayer(String name) {
    switch (name.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight;
      case 'sunrise':
        return Icons.wb_sunny_outlined;
      case 'dhuhr':
        return Icons.wb_sunny;
      case 'asr':
        return Icons.sunny_snowing;
      case 'maghrib':
        return Icons.nights_stay_outlined;
      case 'isha':
        return Icons.nights_stay;
      default:
        return Icons.access_time;
    }
  }
}
