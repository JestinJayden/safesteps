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

  // Laad zones uit de lokale JSON dataset
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

  // Geef de zone terug waar de gebruiker nu in zit (op basis van GPS).
  // Geeft null terug als de gebruiker niet in een bekende zone is.
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

  // Wordt aangeroepen vanuit WalkScreen elke keer dat GPS update binnenkomt.
  // Geeft true terug als de armband moet trillen (zone-overgang naar slechter).
  bool updateLocation(double lat, double lng, {bool eveningMode = false}) {
    final zone = getZoneForLocation(lat, lng);
    final prevLevel = _currentLevel;

    if (zone != null) {
      _currentZone = zone;

      // ── Rule-based logica ────────────────────────────────────────────────
      // Regel 1: Avondmodus verhoogt drempel — bij avond eerder trillen
      final score = eveningMode ? zone.comfortScore - 1.5 : zone.comfortScore;

      // Regel 2: Slecht verlicht 's avonds = altijd caution of lager
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

    // Trilling triggeren als niveau verslechtert
    final shouldVibrate = _isWorseThan(prevLevel, _currentLevel);
    return shouldVibrate;
  }

  bool _isWorseThan(ZoneLevel prev, ZoneLevel current) {
    final order = [ZoneLevel.comfortable, ZoneLevel.caution, ZoneLevel.busy];
    return order.indexOf(current) > order.indexOf(prev);
  }

  // Haversine formule: afstand in meters tussen twee GPS-coördinaten
  double _distanceMeters(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0;
    final dLat = _toRad(lat2 - lat1);
    final dLng = _toRad(lng2 - lng1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRad(lat1)) * cos(_toRad(lat2)) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return r * c;
  }

  double _toRad(double deg) => deg * pi / 180;
}
