import 'package:geolocator/geolocator.dart';

class LocationRepository {
  LocationRepository();

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
}
