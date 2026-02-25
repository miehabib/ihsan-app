/// Main application widget.
///
/// This is the root of the widget tree. It configures the
/// [MaterialApp.router] with GoRouter and the application theme.
/// It does NOT contain any business logic.
library;

import 'package:flutter/material.dart';
import 'package:ihsan_app/app/router/app_router.dart';
import 'package:ihsan_app/core/constants/app_constants.dart';
import 'package:ihsan_app/core/theme/app_theme.dart';

class IhsanApp extends StatelessWidget {
  const IhsanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
