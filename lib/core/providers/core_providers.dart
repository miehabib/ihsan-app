/// Core-level Riverpod providers for shared services.
///
/// These providers wire up the concrete implementations of core service
/// contracts. Features depend on the *abstract* type so they remain
/// testable — just override the provider in tests with a mock.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ihsan_app/core/services/compass_service.dart';
import 'package:ihsan_app/core/services/flutter_compass_service.dart';
import 'package:ihsan_app/core/services/geolocator_location_service.dart';
import 'package:ihsan_app/core/services/location_service.dart';
import 'package:ihsan_app/core/services/permission_handler_service.dart';
import 'package:ihsan_app/core/services/permission_service.dart';

/// Provides the [LocationService] implementation.
final locationServiceProvider = Provider<LocationService>((ref) {
  return GeolocatorLocationService();
});

/// Provides the [PermissionService] implementation.
final permissionServiceProvider = Provider<PermissionService>((ref) {
  return PermissionHandlerService();
});

/// Provides the [CompassService] implementation.
final compassServiceProvider = Provider<CompassService>((ref) {
  return FlutterCompassService();
});
