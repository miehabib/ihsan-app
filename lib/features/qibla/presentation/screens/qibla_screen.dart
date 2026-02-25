/// Qibla screen.
///
/// Combines [qiblaDirectionProvider] (bearing to Kaaba) with
/// [compassHeadingProvider] (device sensor) to render a live-updating
/// compass that points toward the Qibla.
///
/// Permission handling is done gracefully — the UI shows clear
/// messages and actions for each permission state.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ihsan_app/core/theme/app_theme.dart';
import 'package:ihsan_app/features/qibla/presentation/providers/qibla_providers.dart';
import 'package:ihsan_app/features/qibla/presentation/widgets/compass_widget.dart';

class QiblaScreen extends ConsumerWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final qiblaAsync = ref.watch(qiblaDirectionProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Direction'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(qiblaDirectionProvider);
            },
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: qiblaAsync.when(
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
        error: (error, stackTrace) => _QiblaErrorView(
          message: error.toString(),
          onRetry: () => ref.invalidate(qiblaDirectionProvider),
        ),
        data: (qibla) => _QiblaContent(qiblaDirection: qibla.direction),
      ),
    );
  }
}

/// Main content when Qibla data is available.
/// Listens to compass heading separately for real-time updates.
class _QiblaContent extends ConsumerWidget {
  const _QiblaContent({required this.qiblaDirection});

  final double qiblaDirection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compassAsync = ref.watch(compassHeadingProvider);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Qibla Direction',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppTheme.primaryDark,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              '${qiblaDirection.toStringAsFixed(1)}° from North',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 32),

            // Compass display
            compassAsync.when(
              loading: () => const SizedBox(
                width: 280,
                height: 280,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, _) => _CompassUnavailable(
                message: error.toString(),
              ),
              data: (heading) {
                if (heading == null) {
                  return const _CompassUnavailable(
                    message: 'Compass sensor is not available on this device.',
                  );
                }

                return CompassWidget(
                  qiblaDirection: qiblaDirection,
                  compassHeading: heading,
                );
              },
            ),

            const SizedBox(height: 32),

            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: AppTheme.primaryColor, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'How to use',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Hold your device flat and face the direction '
                      'indicated by the mosque icon. That is the '
                      'direction of the Kaaba.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when the compass sensor is unavailable.
class _CompassUnavailable extends StatelessWidget {
  const _CompassUnavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 280,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 2),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.explore_off, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Error view for the Qibla screen.
class _QiblaErrorView extends StatelessWidget {
  const _QiblaErrorView({
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
              'Could not determine Qibla direction',
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
