// ─── screens/map_destination_screen.dart ──────────────────────────────────────
// "Kaart - kies bestemming": echte kaart, zoekbalk, en een aanbevolen-route-kaart.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../services/zone_service.dart';
import '../services/route_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/rotterdam_map.dart';
import '../widgets/gradient_scaffold.dart';

class MapDestinationScreen extends StatefulWidget {
  const MapDestinationScreen({super.key});
  @override
  State<MapDestinationScreen> createState() => _MapDestinationScreenState();
}

class _MapDestinationScreenState extends State<MapDestinationScreen> {
  final _searchController = TextEditingController();
  bool _routeReady = false;
  bool _calculating = false;

  static const _destinations = {
    'Kralingse Bos': LatLng(51.9244, 4.5306),
    'Museumpark': LatLng(51.9167, 4.4728),
    'Zuiderpark': LatLng(51.8989, 4.4672),
    'Euromast': LatLng(51.9056, 4.4853),
    'Erasmusbrug': LatLng(51.9028, 4.4853),
  };

  @override
  void initState() {
    super.initState();
    context.read<ZoneService>().loadZones();
  }

  void _search(String query) async {
    LatLng? dest;
    for (final entry in _destinations.entries) {
      if (entry.key.toLowerCase().contains(query.toLowerCase()) && query.isNotEmpty) {
        dest = entry.value;
        break;
      }
    }
    dest ??= _destinations['Kralingse Bos'];

    setState(() => _calculating = true);
    final location = context.read<LocationService>();
    final route = context.read<RouteService>();
    final zones = context.read<ZoneService>();
    final storage = context.read<StorageService>();
    final avoidBusy = await storage.getBool('avoid_busy', defaultValue: true);
    final avoidDark = await storage.getBool('avoid_dark');

    await route.calculateRoute(LatLng(location.lat, location.lng), dest!, zones.zones,
        avoidBusy: avoidBusy, avoidBadRoads: false, avoidDark: avoidDark);

    setState(() { _calculating = false; _routeReady = true; });
  }

  @override
  Widget build(BuildContext context) {
    final zones = context.watch<ZoneService>();
    final route = context.watch<RouteService>();
    final location = context.watch<LocationService>();

    return GradientScaffold(
      showStatusBar: false,
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: Stack(
        children: [
          // Kaart vult bijna het hele scherm
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: RotterdamMap(
                zones: zones.zones,
                height: MediaQuery.of(context).size.height,
                userLocation: LatLng(location.lat, location.lng),
                routePoints: route.currentRoutePoints,
                initialZoom: 13,
              ),
            ),
          ),

          // Zoekbalk bovenaan
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 18, 28, 0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: TextField(
                controller: _searchController,
                onSubmitted: _search,
                decoration: InputDecoration(
                  hintText: 'Zoek een locatie',
                  hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 22),
                  suffixIcon: _calculating
                      ? const Padding(padding: EdgeInsets.all(12), child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)))
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),

          // Legenda links onder de zoekbalk
          Positioned(
            top: 80, left: 32,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.94), borderRadius: BorderRadius.circular(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _Legend(color: AppTheme.green, label: 'Rustig'),
                  _Legend(color: AppTheme.amber, label: 'Gemiddeld'),
                  _Legend(color: AppTheme.red, label: 'Druk'),
                ],
              ),
            ),
          ),

          // Aanbevolen route-kaart onderaan
          if (_routeReady)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 14, offset: const Offset(0, 4))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Aanbevolen route', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.navy)),
                    const SizedBox(height: 10),
                    Row(children: [
                      _Info(icon: Icons.access_time, text: route.formattedDuration.isNotEmpty ? route.formattedDuration : '28 minuten'),
                      const SizedBox(width: 20),
                      const _Info(icon: Icons.park_outlined, text: '3 rustpunten'),
                    ]),
                    const SizedBox(height: 6),
                    const _Info(icon: Icons.directions_walk, text: 'Weinig verkeer'),
                    const SizedBox(height: 14),
                    ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/route-overview'),
                      child: const Text('Bekijk route'),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 2),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87)),
    ]),
  );
}

class _Info extends StatelessWidget {
  final IconData icon;
  final String text;
  const _Info({required this.icon, required this.text});
  @override
  Widget build(BuildContext context) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 16, color: Colors.black54),
    const SizedBox(width: 6),
    Text(text, style: const TextStyle(fontSize: 13, color: Colors.black87)),
  ]);
}
