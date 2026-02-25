/// Core error handling: Base [Failure] abstraction.
///
/// All domain-level errors extend [Failure] so that the presentation layer
/// can react to typed failures without depending on implementation details
/// (e.g., HTTP status codes, platform exceptions).
///
/// This follows the principle of keeping error types in the domain layer
/// while letting data-layer code map raw exceptions into the correct
/// [Failure] subclass.
library;

import 'package:equatable/equatable.dart';

/// Base class for all failures in the application.
///
/// Uses [Equatable] so failures can be compared in tests and state checks
/// without writing manual `==` / `hashCode` overrides.
abstract class Failure extends Equatable {
  const Failure({this.message = '', this.statusCode});

  /// Human-readable description of what went wrong.
  final String message;

  /// Optional status code from an API or platform layer.
  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

// ─── Concrete failure types ─────────────────────────────────────────────────

/// Failure originating from a remote server / API call.
class ServerFailure extends Failure {
  const ServerFailure({super.message = 'Server error', super.statusCode});
}

/// Failure originating from the local cache or database.
class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error'});
}

/// Failure when the device has no network connectivity.
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'No internet connection'});
}

/// Failure related to device location services.
class LocationFailure extends Failure {
  const LocationFailure({super.message = 'Location error'});
}

/// Failure related to required permissions not being granted.
class PermissionFailure extends Failure {
  const PermissionFailure({super.message = 'Permission denied'});
}

/// Failure related to device sensor access (e.g., compass).
class SensorFailure extends Failure {
  const SensorFailure({super.message = 'Sensor error'});
}
