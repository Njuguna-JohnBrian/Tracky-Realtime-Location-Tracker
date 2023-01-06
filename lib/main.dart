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
  final Completer<GoogleMapController> _controller = Completer();
  static const LatLng sourceLocation = LatLng(
    37.33500926,
    -122.03272188,
  );
  static const LatLng destination = LatLng(
    37.33429383,
    -122.06600055,
  );

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
      result.points.forEach(
        (PointLatLng point) => polylineCoordinates.add(
          LatLng(
            point.latitude,
            point.longitude,
          ),
        ),
      );
      setState(() {});
    }
  }

  @override
  void initState() {
    getPolyPoints();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: sourceLocation,
          zoom: 12,
        ),
        polylines: {
          Polyline(
            polylineId: PolylineId(
              "route",
            ),
            points: polylineCoordinates,
            color: Colors.red,
            width: 6,
          ),
        },
        markers: {
          const Marker(
            markerId: MarkerId(
              "Source",
            ),
            position: sourceLocation,
            draggable: true,
          ),
          const Marker(
            markerId: MarkerId(
              "Destination",
            ),
            position: destination,
            draggable: true,
          )
        },
      )),
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
