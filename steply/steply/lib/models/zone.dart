class Zone {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final double radiusMeters;
  final double comfortScore;
  final bool goodLighting;
  final bool busy;

  const Zone({
    required this.id, required this.name, required this.lat, required this.lng,
    required this.radiusMeters, required this.comfortScore,
    required this.goodLighting, required this.busy,
  });

  ZoneLevel get level {
    if (comfortScore >= 7) return ZoneLevel.comfortable;
    if (comfortScore >= 4) return ZoneLevel.caution;
    return ZoneLevel.busy;
  }

  factory Zone.fromJson(Map<String, dynamic> j) => Zone(
        id: j['id'], name: j['name'],
        lat: (j['lat'] as num).toDouble(), lng: (j['lng'] as num).toDouble(),
        radiusMeters: (j['radius_m'] as num).toDouble(),
        comfortScore: (j['comfort_score'] as num).toDouble(),
        goodLighting: j['good_lighting'] as bool, busy: j['busy'] as bool,
      );
}

enum ZoneLevel { comfortable, caution, busy }
