import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../models/zone.dart';

class WalkRoute {
  final List<LatLng> points;
  final double distanceKm;
  final int durationSec;
  final bool isSafe;
  final int busyZonesCrossed;

  const WalkRoute({
    required this.points, required this.distanceKm, required this.durationSec,
    required this.isSafe, required this.busyZonesCrossed,
  });

  String get distanceLabel => '${distanceKm.toStringAsFixed(1)} km';
  String get durationLabel => '${durationSec ~/ 60} min';
}

class RouteService extends ChangeNotifier {
  WalkRoute? _safeRoute;
  WalkRoute? _fastRoute;
  bool _isLoading = false;
  String _error = '';

  WalkRoute? get safeRoute => _safeRoute;
  WalkRoute? get fastRoute => _fastRoute;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasRoutes => _safeRoute != null && _fastRoute != null;

  // Demo-bestemmingen
  static const LatLng hogeschoolWijnhaven = LatLng(51.9168, 4.4860);
  static const LatLng kunsthalMuseumpark  = LatLng(51.9145, 4.4722);

  // Groene omweg via Het Park (alle waypoints liggen in groene zones)
  static const List<LatLng> _safeWaypoints = [
    LatLng(51.9122, 4.4852), // Leuvehaven (langs water)
    LatLng(51.9085, 4.4778), // Schiedamsedijk (groene kade)
    LatLng(51.9065, 4.4702), // Het Park
    LatLng(51.9105, 4.4690), // Het Park Noord
    LatLng(51.9130, 4.4706), // Museumpark Zuid
  ];

  static const double _lngMetersPerDeg = 68500.0; // op breedte Rotterdam
  static const double _latMetersPerDeg = 111320.0;

  Future<bool> calculateBothRoutes(LatLng start, LatLng end, List<Zone> allZones) async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // RODE route: direct pad, geen vermijding -> gaat door het drukke centrum
      final fast = await _fetchRoute([start, end], avoidZones: const []);

      // GROENE route: via park-waypoints EN vermijd alle niet-groene zones
      final avoid = allZones.where((z) => z.level != ZoneLevel.comfortable).toList();
      var safe = await _fetchRoute([start, ..._safeWaypoints, end], avoidZones: avoid);
      // Fallback: als avoid_polygons de routering blokkeert, probeer alleen waypoints
      safe ??= await _fetchRoute([start, ..._safeWaypoints, end], avoidZones: const []);

      if (fast == null || safe == null) {
        _error = 'Kon routes niet berekenen. Check je internetverbinding.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _fastRoute = WalkRoute(
        points: fast.$1, distanceKm: fast.$2, durationSec: fast.$3,
        isSafe: false, busyZonesCrossed: _countBusyCrossings(fast.$1, allZones),
      );
      _safeRoute = WalkRoute(
        points: safe.$1, distanceKm: safe.$2, durationSec: safe.$3,
        isSafe: true, busyZonesCrossed: _countBusyCrossings(safe.$1, allZones),
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Fout bij routeberekening';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<(List<LatLng>, double, int)?> _fetchRoute(
    List<LatLng> waypoints, {required List<Zone> avoidZones}) async {
    final url = '$OPENROUTESERVICE_BASE_URL/directions/foot-walking/geojson';
    final body = <String, dynamic>{
      'coordinates': waypoints.map((w) => [w.longitude, w.latitude]).toList(),
    };

    if (avoidZones.isNotEmpty) {
      final polygons = avoidZones.map((z) {
        // Vierkant iets groter dan de zone, zodat de route er ruim omheen blijft
        final latD = (z.radiusMeters * 1.3) / _latMetersPerDeg;
        final lngD = (z.radiusMeters * 1.3) / _lngMetersPerDeg;
        return [[
          [z.lng - lngD, z.lat - latD],
          [z.lng + lngD, z.lat - latD],
          [z.lng + lngD, z.lat + latD],
          [z.lng - lngD, z.lat + latD],
          [z.lng - lngD, z.lat - latD],
        ]];
      }).toList();
      body['options'] = {
        'avoid_polygons': {'type': 'MultiPolygon', 'coordinates': polygons}
      };
    }

    final response = await http.post(
      Uri.parse(url),
      headers: {'Authorization': OPENROUTESERVICE_API_KEY, 'Content-Type': 'application/json'},
      body: jsonEncode(body),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final features = json['features'] as List<dynamic>?;
      if (features != null && features.isNotEmpty) {
        final f = features[0] as Map<String, dynamic>;
        final coords = f['geometry']['coordinates'] as List<dynamic>;
        final props = f['properties']['summary'] as Map<String, dynamic>;
        final points = coords.map((c) => LatLng((c[1] as num).toDouble(), (c[0] as num).toDouble())).toList();
        final dist = ((props['distance'] as num?) ?? 0).toDouble() / 1000;
        final dur = ((props['duration'] as num?) ?? 0).toInt();
        return (points, dist, dur);
      }
    }
    return null;
  }

  int _countBusyCrossings(List<LatLng> points, List<Zone> zones) {
    int count = 0;
    for (final z in zones) {
      if (z.level == ZoneLevel.comfortable) continue;
      final crosses = points.any((p) {
        final dLat = (p.latitude - z.lat) * _latMetersPerDeg;
        final dLng = (p.longitude - z.lng) * _lngMetersPerDeg;
        return sqrt(dLat * dLat + dLng * dLng) < z.radiusMeters;
      });
      if (crosses) count++;
    }
    return count;
  }

  void clear() {
    _safeRoute = null;
    _fastRoute = null;
    _error = '';
    notifyListeners();
  }
}
