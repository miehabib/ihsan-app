/// permission_handler-based implementation of [PermissionService].
library;

import 'package:permission_handler/permission_handler.dart';
import 'package:ihsan_app/core/services/permission_service.dart';

class PermissionHandlerService implements PermissionService {
  @override
  Future<AppPermissionStatus> checkLocationPermission() async {
    final status = await Permission.locationWhenInUse.status;
    return _mapStatus(status);
  }

  @override
  Future<AppPermissionStatus> requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request();
    return _mapStatus(status);
  }

  @override
  Future<bool> openSettings() {
    return openAppSettings();
  }

  /// Maps the platform-specific [PermissionStatus] to our domain enum.
  AppPermissionStatus _mapStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return AppPermissionStatus.granted;
      case PermissionStatus.denied:
        return AppPermissionStatus.denied;
      case PermissionStatus.permanentlyDenied:
        return AppPermissionStatus.permanentlyDenied;
      case PermissionStatus.restricted:
        return AppPermissionStatus.restricted;
      default:
        return AppPermissionStatus.denied;
    }
  }
}
