import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Data {
  double latitude;
  double longitude;

  Data({required this.latitude, required this.longitude});
}

final locationProvider = StreamProvider.autoDispose((ref) {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  final controller = StreamController();

  controller.onListen = () {
    controller.sink.add([]);
  };

  final sub = _geolocatorPlatform
      .getPositionStream(
    locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10,
    ),
  )
      .listen((event) {
    final data = Data(
      latitude: event.latitude,
      longitude: event.longitude,
    );

    controller.sink.add(data);
  });
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
