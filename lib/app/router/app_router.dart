/// Application router configuration using GoRouter.
///
/// Architecture decision: All route definitions are centralised here.
/// Each feature contributes its own routes via clearly separated path
/// constants, making it easy to add new features without modifying
/// existing route logic.
///
/// GoRouter is chosen for its declarative API, deep linking support,
/// and built-in redirect / guard capabilities for future auth flows.
library;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ihsan_app/features/prayer/presentation/screens/prayer_times_screen.dart';
import 'package:ihsan_app/features/qibla/presentation/screens/qibla_screen.dart';
import 'package:ihsan_app/app/home_screen.dart';

// ── Route path constants ─────────────────────────────────────────────────────

abstract class AppRoutes {
  static const String home = '/';
  static const String prayerTimes = '/prayer-times';
  static const String qibla = '/qibla';

  // Future routes (scaffolded for planning)
  static const String quran = '/quran';
  static const String courses = '/courses';
  static const String profile = '/profile';
  static const String settings = '/settings';
}

// ── Router configuration ─────────────────────────────────────────────────────

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: AppRoutes.prayerTimes,
      name: 'prayer-times',
      builder: (context, state) => const PrayerTimesScreen(),
    ),
    GoRoute(
      path: AppRoutes.qibla,
      name: 'qibla',
      builder: (context, state) => const QiblaScreen(),
    ),
    // ── Future feature routes (placeholder) ──────────────────────────────
    // GoRoute(path: AppRoutes.quran, ...),
    // GoRoute(path: AppRoutes.courses, ...),
    // GoRoute(path: AppRoutes.profile, ...),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text(
        'Page not found: ${state.uri}',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ),
  ),
);
