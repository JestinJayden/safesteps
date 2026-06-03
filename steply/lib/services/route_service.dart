// ─── services/route_service.dart ──────────────────────────────────────────────
// Berekent wandelroutes via OpenRouteService API, vermijdt zones o.b.v. voorkeuren

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../models/zone.dart';

class RouteService extends ChangeNotifier {
  List<LatLng> _currentRoutePoints = [];
  double _currentRouteDistance = 0;
  int _currentRouteDuration = 0;
  String _error = '';

  List<LatLng> get currentRoutePoints => _currentRoutePoints;
  double get currentRouteDistance => _currentRouteDistance;
  int get currentRouteDuration => _currentRouteDuration;
  String get error => _error;

  Future<bool> calculateRoute(
    LatLng start,
    LatLng end,
    List<Zone> allZones, {
    required bool avoidBusy,
    required bool avoidBadRoads,
    required bool avoidDark,
  }) async {
    try {
      _error = '';
      final url = '$OPENROUTESERVICE_BASE_URL/directions/foot-walking';
      final response = await http.get(
        Uri.parse(
          '$url?api_key=$OPENROUTESERVICE_API_KEY&'
          'start=${start.longitude},${start.latitude}&'
          'end=${end.longitude},${end.latitude}&'
          'geometry=geojson&format=json',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final routes = json['routes'] as List<dynamic>?;
        if (routes != null && routes.isNotEmpty) {
          final route = routes[0] as Map<String, dynamic>;
          final geometry = route['geometry'] as Map<String, dynamic>;
          final coords = geometry['coordinates'] as List<dynamic>;
          _currentRoutePoints = coords.map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble())).toList();
          _currentRouteDistance = ((route['distance'] as num?) ?? 0).toDouble() / 1000;
          _currentRouteDuration = ((route['duration'] as num?) ?? 0).toInt();
          notifyListeners();
          return true;
        }
      }
      _error = 'Kon route niet berekenen. Probeer opnieuw.';
      notifyListeners();
      return false;
    } catch (e) {
      _error = 'Fout bij routeberekening: $e';
      notifyListeners();
      return false;
    }
  }

  String get formattedDistance => '${_currentRouteDistance.toStringAsFixed(1)} km';
  String get formattedDuration {
    final minutes = _currentRouteDuration ~/ 60;
    return '$minutes min';
  }
}
