/// Geolocator-based implementation of [LocationService].
///
/// This lives in `core/services/` because location is a cross-cutting
/// concern used by multiple features (prayer times, qibla, etc.).
library;

import 'package:dartz/dartz.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ihsan_app/core/constants/app_constants.dart';
import 'package:ihsan_app/core/error/failures.dart';
import 'package:ihsan_app/core/services/location_service.dart';
import 'package:ihsan_app/core/utils/result.dart';

class GeolocatorLocationService implements LocationService {
  @override
  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  @override
  FutureResult<LocationData> getCurrentLocation() async {
    try {
      // Check if location services are enabled
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return const Left(
          LocationFailure(message: 'Location services are disabled'),
        );
      }

      // Check/request permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return const Left(
            PermissionFailure(message: 'Location permission denied'),
          );
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return const Left(
          PermissionFailure(
            message: 'Location permission permanently denied. '
                'Please enable it in app settings.',
          ),
        );
      }

      // Get position
      final position = await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: const Duration(
            seconds: AppConstants.locationTimeoutSeconds,
          ),
        ),
      );

      return Right(
        LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );
    } on LocationServiceDisabledException {
      return const Left(
        LocationFailure(message: 'Location services are disabled'),
      );
    } on PermissionRequestInProgressException {
      return const Left(
        LocationFailure(message: 'Permission request already in progress'),
      );
    } catch (e) {
      return Left(
        LocationFailure(message: 'Failed to get location: ${e.toString()}'),
      );
    }
  }
}
