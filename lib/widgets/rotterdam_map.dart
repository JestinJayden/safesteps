// ─── widgets/rotterdam_map.dart ───────────────────────────────────────────────
// Echte kaart via OpenStreetMap (flutter_map). Tekent de zones uit de dataset
// als gekleurde cirkels en toont optioneel de gebruikerslocatie.

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../models/zone.dart';
import '../main.dart';

class RotterdamMap extends StatelessWidget {
  final List<Zone> zones;
  final LatLng? userLocation;
  final double height;
  final double initialZoom;
  final LatLng? center;

  const RotterdamMap({
    super.key,
    required this.zones,
    this.userLocation,
    this.height = 200,
    this.initialZoom = 12.5,
    this.center,
  });

  // Kleur per zone-niveau (met doorzichtigheid voor de vulling)
  Color _zoneColor(ZoneLevel level) => switch (level) {
        ZoneLevel.comfortable => AppTheme.green,
        ZoneLevel.caution => AppTheme.amber,
        ZoneLevel.busy => AppTheme.red,
      };

  @override
  Widget build(BuildContext context) {
    final mapCenter = center ??
        userLocation ??
        const LatLng(51.9225, 4.4792); // Rotterdam centrum

    return SizedBox(
      height: height,
      child: FlutterMap(
        options: MapOptions(
          initialCenter: mapCenter,
          initialZoom: initialZoom,
          interactionOptions: const InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          // De echte kaart-tegels van OpenStreetMap
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'nl.hr.safesteps',
            maxZoom: 19,
          ),

          // Zones als gekleurde cirkels
          CircleLayer(
            circles: zones.map((zone) {
              final color = _zoneColor(zone.level);
              return CircleMarker(
                point: LatLng(zone.lat, zone.lng),
                radius: zone.radiusMeters,
                useRadiusInMeter: true,
                color: color.withOpacity(0.30),
                borderColor: color.withOpacity(0.70),
                borderStrokeWidth: 1.5,
              );
            }).toList(),
          ),

          // Gebruikerslocatie als blauwe stip
          if (userLocation != null)
            MarkerLayer(
              markers: [
                Marker(
                  point: userLocation!,
                  width: 18,
                  height: 18,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.navy,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2.5),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.navy.withOpacity(0.4),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

          // OpenStreetMap attributie (verplicht bij gebruik)
          const RichAttributionWidget(
            attributions: [
              TextSourceAttribution('OpenStreetMap contributors'),
            ],
          ),
        ],
      ),
    );
  }
}
