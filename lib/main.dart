/// Entry point of the Ihsan application.
///
/// Wraps the app in a [ProviderScope] so Riverpod's dependency injection
/// is available throughout the widget tree. All concrete service wiring
/// is done via providers (see `core/providers/core_providers.dart`),
/// keeping this file minimal.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ihsan_app/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock orientation to portrait for consistent Islamic UI layouts.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    // ProviderScope is the root of all Riverpod state.
    // Override providers here for integration tests.
    const ProviderScope(
      child: IhsanApp(),
    ),
  );
}
