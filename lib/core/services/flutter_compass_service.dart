/// flutter_compass-based implementation of [CompassService].
library;

import 'package:flutter_compass/flutter_compass.dart';
import 'package:ihsan_app/core/services/compass_service.dart';

class FlutterCompassService implements CompassService {
  @override
  Stream<double?> get headingStream {
    return FlutterCompass.events?.map((event) => event.heading) ??
        const Stream.empty();
  }

  @override
  Future<bool> isCompassAvailable() async {
    // FlutterCompass.events is null when sensor is unavailable.
    return FlutterCompass.events != null;
  }
}
