/// Core error handling: Application-specific exceptions.
///
/// These are thrown in the **data layer** and caught by repository
/// implementations, which then convert them into typed [Failure] objects
/// for the domain / presentation layers.
library;

/// Base class for exceptions that originate from the data layer.
abstract class AppException implements Exception {
  const AppException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => '$runtimeType(message: $message, statusCode: $statusCode)';
}

class ServerException extends AppException {
  const ServerException({super.message = 'Server error', super.statusCode});
}

class CacheException extends AppException {
  const CacheException({super.message = 'Cache error'});
}

class LocationException extends AppException {
  const LocationException({super.message = 'Location error'});
}

class PermissionException extends AppException {
  const PermissionException({super.message = 'Permission denied'});
}

class SensorException extends AppException {
  const SensorException({super.message = 'Sensor error'});
}
