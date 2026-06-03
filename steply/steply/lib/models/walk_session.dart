class WalkSession {
  final int? id;
  final DateTime startTime;
  final DateTime? endTime;
  final double distanceKm;
  final int durationSeconds;
  final int zoneWarnings;

  const WalkSession({
    this.id, required this.startTime, this.endTime,
    required this.distanceKm, required this.durationSeconds, required this.zoneWarnings,
  });

  String get formattedDuration {
    final m = durationSeconds ~/ 60;
    final s = durationSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Map<String, dynamic> toMap() => {
        'start_time': startTime.toIso8601String(),
        'end_time': endTime?.toIso8601String(),
        'distance_km': distanceKm,
        'duration_seconds': durationSeconds,
        'zone_warnings': zoneWarnings,
      };
}
