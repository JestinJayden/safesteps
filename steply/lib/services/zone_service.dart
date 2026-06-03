// ─── services/zone_service.dart ───────────────────────────────────────────────
// Rule-based logica: bepaalt welke zone de gebruiker in zit en of de
// armband moet trillen. Geen AI — expliciete regels zodat het transparant is.

import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/zone.dart';

class ZoneService extends ChangeNotifier {
  List<Zone> _zones = [];
  Zone? _currentZone;
  ZoneLevel _currentLevel = ZoneLevel.comfortable;
  bool _isLoaded = false;

  List<Zone> get zones => _zones;
  Zone? get currentZone => _currentZone;
  ZoneLevel get currentLevel => _currentLevel;
  bool get isLoaded => _isLoaded;

  Future<void> loadZones() async {
    try {
      final jsonStr = await rootBundle.loadString('lib/data/zones_rotterdam.json');
      final List<dynamic> jsonList = json.decode(jsonStr);
      _zones = jsonList.map((j) => Zone.fromJson(j as Map<String, dynamic>)).toList();
      _isLoaded = true;
      notifyListeners();
    } catch (e) {
      debugPrint('ZoneService: fout bij laden zones: $e');
    }
  }

  Zone? getZoneForLocation(double lat, double lng) {
    Zone? closest;
    double closestDist = double.infinity;
    for (final zone in _zones) {
      final dist = _distanceMeters(lat, lng, zone.lat, zone.lng);
      if (dist <= zone.radiusMeters && dist < closestDist) {
        closest = zone;
        closestDist = dist;
      }
    }
    return closest;
  }

  bool updateLocation(double lat, double lng, {bool eveningMode = false}) {
    final zone = getZoneForLocation(lat, lng);
    final prevLevel = _currentLevel;
    if (zone != null) {
      _currentZone = zone;
      final score = eveningMode ? zone.comfortScore - 1.5 : zone.comfortScore;
      if (eveningMode && !zone.goodLighting) {
        _currentLevel = ZoneLevel.busy;
      } else if (score >= 7) {
        _currentLevel = ZoneLevel.comfortable;
      } else if (score >= 4) {
        _currentLevel = ZoneLevel.caution;
      } else {
        _currentLevel = ZoneLevel.busy;
      }
    } else {
      _currentZone = null;
      _currentLevel = ZoneLevel.comfortable;
    }
    notifyListeners();
    return _isWorseThan(prevLevel, _currentLevel);
  }

  bool _isWorseThan(ZoneLevel prev, ZoneLevel current) {
    final order = [ZoneLevel.comfortable, ZoneLevel.caution, ZoneLevel.busy];
    return order.indexOf(current) > order.indexOf(prev);
  }

  double _distanceMeters(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) + cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  double _toRad(double deg) => deg * pi / 180;
}
