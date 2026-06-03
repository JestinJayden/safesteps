import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/zone.dart';
import '../main.dart';

// Een route om te tekenen met een eigen kleur
class MapRoute {
  final List<LatLng> points;
  final Color color;
  final bool highlighted;
  const MapRoute({required this.points, required this.color, this.highlighted = false});
}

class RotterdamMap extends StatelessWidget {
  final List<Zone> zones;
  final LatLng? userLocation;
  final List<MapRoute> routes;
  final LatLng? startMarker;
  final LatLng? endMarker;
  final double height;
  final double initialZoom;
  final LatLng? center;

  const RotterdamMap({super.key, required this.zones, this.userLocation,
    this.routes = const [], this.startMarker, this.endMarker,
    this.height = 200, this.initialZoom = 12.5, this.center});

  Color _zoneColor(ZoneLevel level) => switch (level) {
    ZoneLevel.comfortable => AppTheme.green,
    ZoneLevel.caution => AppTheme.amber,
    ZoneLevel.busy => AppTheme.red,
  };

  @override
  Widget build(BuildContext context) {
    final mapCenter = center ?? userLocation ?? const LatLng(51.9160, 4.4785);
    return SizedBox(
      height: height,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: mapCenter, initialZoom: initialZoom,
          interactionOptions: const InteractionOptions(flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'nl.hr.steply', maxZoom: 19,
          ),
          // Zones als gekleurde cirkels
          CircleLayer(circles: zones.map((zone) {
            final color = _zoneColor(zone.level);
            return CircleMarker(point: LatLng(zone.lat, zone.lng), radius: zone.radiusMeters,
              useRadiusInMeter: true, color: color.withOpacity(0.25),
              borderColor: color.withOpacity(0.65), borderStrokeWidth: 1.5);
          }).toList()),
          // Routes (niet-gemarkeerde eerst, gemarkeerde bovenop)
          PolylineLayer(polylines: [
            ...routes.where((r) => !r.highlighted).map((r) => Polyline(
              points: r.points, color: r.color.withOpacity(0.55), strokeWidth: 4)),
            ...routes.where((r) => r.highlighted).map((r) => Polyline(
              points: r.points, color: r.color, strokeWidth: 6)),
          ]),
          // Start- en eindmarkers
          MarkerLayer(markers: [
            if (startMarker != null)
              Marker(point: startMarker!, width: 32, height: 32,
                child: const Icon(Icons.trip_origin, color: AppTheme.navy, size: 26)),
            if (endMarker != null)
              Marker(point: endMarker!, width: 36, height: 36,
                child: const Icon(Icons.location_on, color: AppTheme.pink, size: 34)),
            if (userLocation != null)
              Marker(point: userLocation!, width: 28, height: 28,
                child: Container(
                  decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.2), shape: BoxShape.circle),
                  child: Container(margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(color: AppTheme.navy, shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5))))),
          ]),
          const RichAttributionWidget(attributions: [TextSourceAttribution('OpenStreetMap')]),
        ],
      ),
    );
  }
}
