/// Permission service abstraction.
///
/// Provides a clean interface for checking and requesting runtime
/// permissions so feature code never depends on a specific permission
/// library directly.
library;

/// Enum representing the status after a permission check/request.
enum AppPermissionStatus {
  granted,
  denied,
  permanentlyDenied,
  restricted,
}

/// Contract for managing runtime permissions.
abstract class PermissionService {
  /// Check the current status of location permission.
  Future<AppPermissionStatus> checkLocationPermission();

  /// Request location permission from the user.
  Future<AppPermissionStatus> requestLocationPermission();

  /// Open the device's app settings page so the user can grant
  /// permissions manually (useful after permanent denial).
  Future<bool> openSettings();
}
