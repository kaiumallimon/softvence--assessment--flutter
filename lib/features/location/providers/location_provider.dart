import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentLocation;
  
  /* Getter to get current location */
  Position? get currentLocation => _currentLocation;

  /* Setter to set current location */
  void setCurrentLocation(Position? location) {
    _currentLocation = location;
    notifyListeners();
  }
}
