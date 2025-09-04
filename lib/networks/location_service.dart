import 'package:geolocator/geolocator.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    /* Check if location services are enabled. */
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    /* If location services are not enabled, return a error message. */
    if (!isLocationServiceEnabled) {
      return Future.error('Location services are disabled.');
    }

    /* Check for location permissions. */
    LocationPermission permission = await Geolocator.checkPermission();

    /* If permissions are denied, request permissions. */
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    /* If permissions are denied forever, return a error message. */
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are denied');
    }
    /* If permissions are granted, get the current location. */
    return await Geolocator.getCurrentPosition();
  }
}
