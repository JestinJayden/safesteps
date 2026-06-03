// ─── models/walk_session.dart ─────────────────────────────────────────────────

class WalkSession {
  final int? id;
  final DateTime startTime;
  final DateTime? endTime;
  final double distanceKm;
  final int durationSeconds;
  final int zoneWarnings;

  const WalkSession({
    this.id,
    required this.startTime,
    this.endTime,
    required this.distanceKm,
    required this.durationSeconds,
    required this.zoneWarnings,
  });

  String get formattedDuration {
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String get formattedDistance => '${distanceKm.toStringAsFixed(1)} km';

  Map<String, dynamic> toMap() => {
        'id': id,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'distance_km': distanceKm,
        'duration_seconds': durationSeconds,
        'zone_warnings': zoneWarnings,
      };

  factory WalkSession.fromMap(Map<String, dynamic> map) => WalkSession(
        id: map['id'] as int?,
        startTime: DateTime.parse(map['start_time'] as String),
        endTime: map['end_time'] != null ? DateTime.parse(map['end_time'] as String) : null,
        distanceKm: (map['distance_km'] as num).toDouble(),
        durationSeconds: map['duration_seconds'] as int,
        zoneWarnings: map['zone_warnings'] as int,
      );
}
