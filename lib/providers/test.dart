import 'package:geolocator/geolocator.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final geolocatorContStaNotiPro = StateNotifierProvider.autoDispose<
    GeolocatorContStaNoti, AsyncValue<Position>>(
  (ref) => GeolocatorContStaNoti(AsyncValue.loading())..getContinuousLocation(),
);

class GeolocatorContStaNoti extends StateNotifier<AsyncValue<Position>> {
  GeolocatorContStaNoti(AsyncValue<Position> state) : super(state);

  Future<void> getContinuousLocation() async {
    try {
      if (await checkPermission()) {
        final position = await Geolocator.getCurrentPosition();
        state = AsyncValue.data(position);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<bool> checkPermission() async {
    bool _serviceEnabled;
    LocationPermission _permission;

    try {
      _serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!_serviceEnabled) {
        state = new Error() as AsyncValue<Position>;
      }
      _permission = await Geolocator.checkPermission();
      if (_permission == LocationPermission.denied) {
        _permission = await Geolocator.requestPermission();
        if (_permission == LocationPermission.denied) {
          state = new Error() as AsyncValue<Position>;
        }
      } else if (_permission == LocationPermission.whileInUse) {
        return true;
      } else if (_permission == LocationPermission.deniedForever) {
        state = new Error() as AsyncValue<Position>;
        ;
      }
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}



// SafeArea(
//       child: Scaffold(
//         body: ref.watch(geolocatorContStaNotiPro).when(
//               data: (data) {
//                 print("${data.latitude}, ${data.longitude}");
//                 return Text("Has Data, ${data.latitude}, ${data.longitude}");
//               },
//               error: (e, s) {
//                 print(e);
//                 print(s);
//                 return Text("Error");
//               },
//               loading: () => Text("Loading"),
//             ),
//       ),
//     );