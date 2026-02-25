/// Prayer Times screen.
///
/// Consumes [prayerTimesProvider] and renders loading / error / data
/// states using [AsyncValue.when]. Contains ZERO business logic —
/// all calculation, location, and error mapping happens in providers
/// and use cases.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ihsan_app/core/theme/app_theme.dart';
import 'package:ihsan_app/features/prayer/presentation/providers/prayer_providers.dart';
import 'package:ihsan_app/features/prayer/presentation/widgets/prayer_times_list.dart';

class PrayerTimesScreen extends ConsumerWidget {
  const PrayerTimesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimesAsync = ref.watch(prayerTimesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Times'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(prayerTimesProvider),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: prayerTimesAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Getting your location...'),
            ],
          ),
        ),
        error: (error, stackTrace) => _ErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(prayerTimesProvider),
        ),
        data: (prayerTimes) {
          final dateFormat = DateFormat.yMMMMEEEEd(); // e.g., Monday, January 1, 2026

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Date header
                Card(
                  color: AppTheme.primaryColor,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Text(
                          dateFormat.format(prayerTimes.date),
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                  ),
                        ),
                        const SizedBox(height: 4),
                        if (prayerTimes.nextPrayer != null)
                          Text(
                            'Next: ${prayerTimes.nextPrayer!.key}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        if (prayerTimes.nextPrayer == null)
                          Text(
                            'All prayers completed',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: Colors.white70,
                                ),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Prayer times list
                PrayerTimesList(prayerTimes: prayerTimes),

                const SizedBox(height: 16),

                // Calculation method info
                Text(
                  'Method: ${_formatMethodName(prayerTimes.calculationMethod)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[500],
                      ),
                  textAlign: TextAlign.center,
                ),

                if (prayerTimes.latitude != null &&
                    prayerTimes.longitude != null)
                  Text(
                    'Location: ${prayerTimes.latitude!.toStringAsFixed(4)}, '
                    '${prayerTimes.longitude!.toStringAsFixed(4)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[400],
                        ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Converts snake_case method name to a human-readable label.
  String _formatMethodName(String method) {
    return method
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}

/// Error view with a retry button.
class _ErrorView extends StatelessWidget {
  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
