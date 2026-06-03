// ─── models/zone.dart ─────────────────────────────────────────────────────────

class Zone {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final double radiusMeters;
  final double comfortScore; // 1.0 – 10.0
  final bool goodLighting;
  final bool busy;

  const Zone({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    required this.radiusMeters,
    required this.comfortScore,
    required this.goodLighting,
    required this.busy,
  });

  ZoneLevel get level {
    if (comfortScore >= 7) return ZoneLevel.comfortable;
    if (comfortScore >= 4) return ZoneLevel.caution;
    return ZoneLevel.busy;
  }

  factory Zone.fromJson(Map<String, dynamic> json) => Zone(
        id: json['id'],
        name: json['name'],
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        radiusMeters: (json['radius_m'] as num).toDouble(),
        comfortScore: (json['comfort_score'] as num).toDouble(),
        goodLighting: json['good_lighting'] as bool,
        busy: json['busy'] as bool,
      );
}

enum ZoneLevel { comfortable, caution, busy }
