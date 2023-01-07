import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:tracky/keys.dart';
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

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final geolocator = GeolocatorPlatform.instance;
  final Completer<GoogleMapController> _controller = Completer();

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor destinationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentIcon = BitmapDescriptor.defaultMarker;

  late Position currentLocation;

  void getCurrentLocation() async {
    await geolocator.getCurrentPosition().then((location) {
      setState(() {
        currentLocation = location;
      });
    });

    GoogleMapController googleMapController = await _controller.future;

    geolocator.getPositionStream().listen((newLocation) {
      setState(() {
        currentLocation = newLocation;
      });

      googleMapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            zoom: 15,
            target: LatLng(
              newLocation.latitude,
              newLocation.longitude,
            ),
          ),
        ),
      );
    });
  }

  static const LatLng sourceLocation = LatLng(
    -0.4338090,
    36.9588860,
  );
  static const LatLng destination = LatLng(-0.43056, 36.98046);

  List<LatLng> polylineCoordinates = [];

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      ApiKey.api,
      PointLatLng(
        sourceLocation.latitude,
        sourceLocation.longitude,
      ),
      PointLatLng(
        destination.latitude,
        destination.longitude,
      ),
    );

    print("POUINTS: ${result.status}");
    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        polylineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        );
      }
      setState(() {});
    }
  }

  void setCustommarker() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_source.png")
        .then((icon) {
      sourceIcon = icon;
    });

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_destination.png")
        .then((icon) {
      destinationIcon = icon;
    });
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/Pin_current_location.png")
        .then((icon) {
      currentIcon = icon;
    });
  }

  @override
  void initState() {
    getCurrentLocation();
    getPolyPoints();
    setCustommarker();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(currentLocation);
    return SafeArea(
      child: Scaffold(
        body: currentLocation == null
            ? const Center(
                child: Text("Loading...."),
              )
            : GoogleMap(
                mapType: MapType.hybrid,
                indoorViewEnabled: false,
                trafficEnabled: false,
                initialCameraPosition: const CameraPosition(
                  target: sourceLocation,
                  zoom: 15,
                ),
                polylines: {
                  Polyline(
                    polylineId: const PolylineId(
                      "route",
                    ),
                    points: polylineCoordinates,
                    color: Colors.red,
                    width: 6,
                  ),
                },
                markers: {
                  Marker(
                    markerId: const MarkerId(
                      "Current Location",
                    ),
                    icon: currentIcon,
                    position: LatLng(
                      currentLocation.latitude,
                      currentLocation.longitude,
                    ),
                    draggable: true,
                  ),
                  Marker(
                    markerId: const MarkerId(
                      "Source",
                    ),
                    icon: sourceIcon,
                    position: sourceLocation,
                    draggable: true,
                  ),
                  Marker(
                    markerId: const MarkerId(
                      "Destination",
                    ),
                    icon: destinationIcon,
                    position: destination,
                    draggable: true,
                  )
                },
                onMapCreated: (mapController) {
                  _controller.complete(mapController);
                },
              ),
      ),
    );
  }
}

// final geolocator = GeolocatorPlatform.instance;

// final currentLocationProvider = StreamProvider<Position>((ref) {
//   return Geolocator.getPositionStream(
//     locationSettings: LocationSettings(
//       accuracy: LocationAccuracy.best,
//       distanceFilter: 0.5.toInt(),
//     ),
//   );
// });