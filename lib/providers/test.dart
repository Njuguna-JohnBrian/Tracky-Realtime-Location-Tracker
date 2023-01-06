// return SafeArea(
//       child: Scaffold(
//         body: ref.watch(currentLocationProvider).when(
//               data: (data) {
//                 print("${data.latitude}, ${data.longitude}");
//                 print("${data.speed}");
//                 // return Text("Has Data, ${data.latitude}, ${data.longitude}");
//                 return GoogleMap(
//                   initialCameraPosition: const CameraPosition(
//                     target: sourceLocation,
//                     zoom: 12,
//                   ),
//                   polylines: {
//                     Polyline(
//                       polylineId: PolylineId(
//                         "route",
//                       ),
//                       points: polylineCoordinates,
//                     ),
//                   },
//                   markers: {
//                     const Marker(
//                       markerId: MarkerId(
//                         "Source",
//                       ),
//                       position: sourceLocation,
//                       draggable: true,
//                     ),
//                     const Marker(
//                       markerId: MarkerId(
//                         "Destination",
//                       ),
//                       position: destination,
//                       draggable: true,
//                     )
//                   },
//                 );
//               },
//               error: (e, s) {
//                 print(e);
//                 print(s);
//                 return const Text("Error");
//               },
//               loading: () => const Text("Loading"),
//             ),
//       ),
//     );