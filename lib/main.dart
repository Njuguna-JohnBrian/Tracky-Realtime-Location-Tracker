import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tracky/providers/location_provoder.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter live Maps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.read(currentLocationProvider).value;
    final double longitude;
    final double latitude;

    if (location != null) {
      longitude = location.longitude;
      latitude = location.latitude;
    } else {
      longitude = 10.0;
      latitude = 10.0;
    }

    return SafeArea(
      child: Scaffold(
        body: ref.watch(currentLocationProvider).when(
              data: (data) {
                print("${data.latitude}, ${data.longitude}");
                print("${data.speed}");
                // return Text("Has Data, ${data.latitude}, ${data.longitude}");
                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: LatLng(
                      data.latitude,
                      data.longitude,
                    ),
                    zoom: 14,
                  ),
                  markers: {
                    Marker(
                      markerId: const MarkerId(
                        "Tracky",
                      ),
                      position: LatLng(
                        data.latitude,
                        data.longitude,
                      ),
                      draggable: true,
                    )
                  },
                );
              },
              error: (e, s) {
                print(e);
                print(s);
                return Text("Error");
              },
              loading: () => Text("Loading"),
            ),
      ),
    );
  }
}

final geolocator = GeolocatorPlatform.instance;

final currentLocationProvider = StreamProvider<Position>((ref) {
  return Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 0.05.toInt(),
    ),
  );
});
