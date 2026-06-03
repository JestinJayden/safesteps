import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../services/zone_service.dart';
import '../services/location_service.dart';
import '../services/route_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/rotterdam_map.dart';

class WalkScreen extends StatefulWidget {
  const WalkScreen({super.key});
  @override
  State<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  double _km = 1.2;
  final double _totalKm = 2.1;
  Timer? _timer;

  // Simpele turn-by-turn instructies die wisselen
  final List<(IconData, String, String)> _directions = [
    (Icons.arrow_upward, 'Ga rechtdoor', '200 meter'),
    (Icons.turn_left, 'Sla linksaf', '150 meter'),
    (Icons.turn_right, 'Sla rechtsaf', '80 meter'),
    (Icons.arrow_upward, 'Ga rechtdoor', '120 meter'),
  ];
  int _dirIndex = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        _km = (_km + 0.1).clamp(0, _totalKm);
        _dirIndex = (_dirIndex + 1) % _directions.length;
      });
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final zones = context.watch<ZoneService>();
    final loc = context.watch<LocationService>();
    final route = context.watch<RouteService>();
    final progress = (_km / _totalKm).clamp(0.0, 1.0);
    final dir = _directions[_dirIndex];

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AppBottomNav(currentIndex: 1),
        body: SafeArea(
          child: Column(
            children: [
              // Terug-pijl + navigatie-instructie kaart
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 16, 0),
                child: Row(children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(context)),
                  Expanded(child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 2))]),
                    child: Row(children: [
                      Container(width: 44, height: 44,
                        decoration: BoxDecoration(color: AppTheme.navy, borderRadius: BorderRadius.circular(12)),
                        child: Icon(dir.$1, color: Colors.white, size: 26)),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(dir.$2, style: const TextStyle(color: AppTheme.navy, fontSize: 17, fontWeight: FontWeight.w700)),
                        Text(dir.$3, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ])),
                    ]),
                  )),
                ]),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  children: [
                    // Kaart
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: RotterdamMap(
                        zones: zones.zones, height: 200, initialZoom: 14,
                        center: const LatLng(51.9120, 4.4785),
                        userLocation: LatLng(loc.lat, loc.lng),
                        routes: route.safeRoute != null
                          ? [MapRoute(points: route.safeRoute!.points, color: AppTheme.green, highlighted: true)]
                          : const [],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Voortgang
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 12, offset: const Offset(0, 4))]),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text('Voortgang', style: TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        ClipRRect(borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(value: progress, minHeight: 12,
                            backgroundColor: AppTheme.cardGrey, valueColor: const AlwaysStoppedAnimation(AppTheme.green))),
                        const SizedBox(height: 8),
                        Text('${_km.toStringAsFixed(1)} km van $_totalKm km',
                          style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ]),
                    ),
                    const SizedBox(height: 12),

                    // Armbandmelding
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/warning'),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))]),
                        child: Row(children: [
                          Container(width: 38, height: 38,
                            decoration: BoxDecoration(color: AppTheme.amberLight, borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.warning_amber_rounded, color: AppTheme.amber, size: 22)),
                          const SizedBox(width: 12),
                          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text('Armbandmelding', style: TextStyle(color: AppTheme.navy, fontSize: 14, fontWeight: FontWeight.w600)),
                            SizedBox(height: 2),
                            Text('Druk gebied over 200 meter', style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ])),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              // Stop route
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop route'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.red),
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
