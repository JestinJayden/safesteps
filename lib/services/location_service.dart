// ─── services/location_service.dart ──────────────────────────────────────────

import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

class LocationService extends ChangeNotifier {
  Position? _currentPosition;
  bool _isTracking = false;
  String _error = '';

  Position? get currentPosition => _currentPosition;
  bool get isTracking => _isTracking;
  String get error => _error;

  double get lat => _currentPosition?.latitude ?? 51.9225;   // fallback: Rotterdam
  double get lng => _currentPosition?.longitude ?? 4.4792;

  Future<bool> requestPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _error = 'GPS is uitgeschakeld op dit apparaat';
      notifyListeners();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _error = 'Locatietoegang geweigerd';
        notifyListeners();
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _error = 'Locatietoegang permanent geweigerd — open instellingen';
      notifyListeners();
      return false;
    }
    return true;
  }

  Future<void> startTracking(Function(double lat, double lng) onUpdate) async {
    final granted = await requestPermission();
    if (!granted) return;

    _isTracking = true;
    notifyListeners();

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // update elke 5 meter
      ),
    ).listen((Position position) {
      _currentPosition = position;
      notifyListeners();
      onUpdate(position.latitude, position.longitude);
    });
  }

  void stopTracking() {
    _isTracking = false;
    notifyListeners();
  }

  // Berekent afstand in meter tussen twee posities
  double distanceBetween(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }
}
