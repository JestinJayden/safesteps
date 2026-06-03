// ─── screens/walk_screen.dart ─────────────────────────────────────────────────
// "Onderweg": voortgangsbalk, live kaart, en een armbandmelding-kaartje.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../services/zone_service.dart';
import '../services/location_service.dart';
import '../services/route_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_scaffold.dart';
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

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() => _km = (_km + 0.05).clamp(0, _totalKm));
    });
  }

  @override
  void dispose() { _timer?.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final zones = context.watch<ZoneService>();
    final location = context.watch<LocationService>();
    final route = context.watch<RouteService>();
    final progress = (_km / _totalKm).clamp(0.0, 1.0);

    return GradientScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 8, 22, 2),
            child: Text('U bent onderweg', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 14),
            child: Text('Voortgang', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ),

          // Voortgangsbalk (groene segmenten)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation(AppTheme.green),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 6, 22, 14),
            child: Text('${_km.toStringAsFixed(1)} km van $_totalKm km', style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ),

          // Kaart
          WhiteCard(
            padding: EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: RotterdamMap(
                zones: zones.zones,
                height: 180,
                initialZoom: 15,
                userLocation: LatLng(location.lat, location.lng),
                routePoints: route.currentRoutePoints,
              ),
            ),
          ),

          // Armbandmelding kaartje
          WhiteCard(
            child: Row(
              children: [
                Container(
                  width: 38, height: 38,
                  decoration: BoxDecoration(color: AppTheme.amberLight, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.warning_amber_rounded, color: AppTheme.amber, size: 22),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Armbandmelding', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.navy)),
                      SizedBox(height: 2),
                      Text('Druk gebied over 200 meter', style: TextStyle(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Alternatieve route knop (wit)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: OutlinedButton(
              onPressed: () => Navigator.pushNamed(context, '/warning'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                backgroundColor: Colors.white,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Alternatieve route', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),

          // Doorgaan knop (donkerblauw)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Doorgaan'),
            ),
          ),
        ],
      ),
    );
  }
}
