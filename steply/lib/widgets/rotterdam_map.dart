// ─── widgets/rotterdam_map.dart ───────────────────────────────────────────────
// Echte kaart via OpenStreetMap met zones, route en live locatie.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/zone.dart';
import '../main.dart';

class RotterdamMap extends StatelessWidget {
  final List<Zone> zones;
  final LatLng? userLocation;
  final List<LatLng> routePoints;
  final double height;
  final double initialZoom;
  final LatLng? center;

  const RotterdamMap({
    super.key,
    required this.zones,
    this.userLocation,
    this.routePoints = const [],
    this.height = 200,
    this.initialZoom = 12.5,
    this.center,
  });

  Color _zoneColor(ZoneLevel level) => switch (level) {
        ZoneLevel.comfortable => AppTheme.green,
        ZoneLevel.caution => AppTheme.amber,
        ZoneLevel.busy => AppTheme.red,
      };

  @override
  Widget build(BuildContext context) {
    final mapCenter = center ?? userLocation ?? const LatLng(51.9225, 4.4792);
    return SizedBox(
      height: height,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: mapCenter,
          initialZoom: initialZoom,
          interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'nl.hr.steply',
            maxZoom: 19,
          ),
          if (routePoints.isNotEmpty)
            PolylineLayer(
              polylines: [Polyline(points: routePoints, color: AppTheme.navy, strokeWidth: 4)],
            ),
          CircleLayer(
            circles: zones.map((zone) {
              final color = _zoneColor(zone.level);
              return CircleMarker(
                point: LatLng(zone.lat, zone.lng),
                radius: zone.radiusMeters,
                useRadiusInMeter: true,
                color: color.withOpacity(0.28),
                borderColor: color.withOpacity(0.65),
                borderStrokeWidth: 1.5,
              );
            }).toList(),
          ),
          if (userLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: userLocation!,
                  width: 28, height: 28,
                  child: Container(
                    decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.2), shape: BoxShape.circle),
                    child: Container(
                      margin: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E6FE0),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const RichAttributionWidget(
            attributions: [TextSourceAttribution('OpenStreetMap')],
          ),
        ],
      ),
    );
  }
}
