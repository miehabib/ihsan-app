/// Reusable compass widget for the Qibla feature.
///
/// Renders a compass dial that rotates based on the device heading
/// and displays a Qibla indicator pointing toward the Kaaba.
///
/// Architecture decision: This widget receives all data through
/// constructor parameters — it does NOT read providers. The screen
/// is responsible for connecting providers to widget props.
library;

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ihsan_app/core/theme/app_theme.dart';

class CompassWidget extends StatelessWidget {
  const CompassWidget({
    super.key,
    required this.qiblaDirection,
    required this.compassHeading,
  });

  /// The bearing from the user to the Kaaba (degrees, 0–360).
  final double qiblaDirection;

  /// The current compass heading (degrees, 0–360 where 0 = North).
  final double compassHeading;

  @override
  Widget build(BuildContext context) {
    // The Qibla needle angle relative to the device's current heading.
    // Subtract the compass heading so that the needle always points
    // toward the Kaaba regardless of which way the device faces.
    final qiblaAngle = qiblaDirection - compassHeading;

    return SizedBox(
      width: 280,
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating compass dial
          Transform.rotate(
            angle: _degreesToRadians(-compassHeading),
            child: CustomPaint(
              size: const Size(280, 280),
              painter: _CompassDialPainter(),
            ),
          ),
          // Qibla direction indicator
          Transform.rotate(
            angle: _degreesToRadians(qiblaAngle),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 4,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.primaryColor,
                        AppTheme.primaryColor.withValues(alpha: 0.3),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                Icon(
                  Icons.mosque,
                  color: AppTheme.primaryColor,
                  size: 32,
                ),
              ],
            ),
          ),
          // Center dot
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: AppTheme.accentColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }

  double _degreesToRadians(double degrees) => degrees * pi / 180;
}

/// Custom painter for the compass dial background.
class _CompassDialPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer circle
    final outerPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius - 10, outerPaint);

    // Direction tick marks and labels
    final tickPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2;

    final directions = {
      0: 'N',
      90: 'E',
      180: 'S',
      270: 'W',
    };

    for (int i = 0; i < 360; i += 15) {
      final isCardinal = directions.containsKey(i);
      final isMajor = i % 45 == 0;
      final tickLength = isCardinal ? 20.0 : (isMajor ? 14.0 : 8.0);

      final angle = (i - 90) * pi / 180;
      final outerPoint = Offset(
        center.dx + (radius - 12) * cos(angle),
        center.dy + (radius - 12) * sin(angle),
      );
      final innerPoint = Offset(
        center.dx + (radius - 12 - tickLength) * cos(angle),
        center.dy + (radius - 12 - tickLength) * sin(angle),
      );

      tickPaint.color = isCardinal ? AppTheme.primaryDark : Colors.grey.shade500;
      tickPaint.strokeWidth = isCardinal ? 3 : (isMajor ? 2 : 1);
      canvas.drawLine(outerPoint, innerPoint, tickPaint);

      // Draw cardinal labels
      if (isCardinal) {
        final textPainter = TextPainter(
          text: TextSpan(
            text: directions[i],
            style: TextStyle(
              color: i == 0 ? Colors.red.shade700 : AppTheme.primaryDark,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        );
        textPainter.layout();

        final textOffset = Offset(
          center.dx + (radius - 42) * cos(angle) - textPainter.width / 2,
          center.dy + (radius - 42) * sin(angle) - textPainter.height / 2,
        );
        textPainter.paint(canvas, textOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
