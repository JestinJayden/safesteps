import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../services/zone_service.dart';
import '../services/route_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/rotterdam_map.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool _selectedSafe = true;

  @override
  void initState() {
    super.initState();
    context.read<ZoneService>().loadZones();
    WidgetsBinding.instance.addPostFrameCallback((_) => _calculateDemo());
  }

  void _calculateDemo() async {
    final zones = context.read<ZoneService>();
    if (!zones.isLoaded) await zones.loadZones();
    final route = context.read<RouteService>();
    await route.calculateBothRoutes(
      RouteService.hogeschoolWijnhaven, RouteService.kunsthalMuseumpark, zones.zones);
  }

  @override
  Widget build(BuildContext context) {
    final zones = context.watch<ZoneService>();
    final route = context.watch<RouteService>();

    final mapRoutes = <MapRoute>[];
    if (route.hasRoutes) {
      if (_selectedSafe) {
        mapRoutes.add(MapRoute(points: route.fastRoute!.points, color: AppTheme.red, highlighted: false));
        mapRoutes.add(MapRoute(points: route.safeRoute!.points, color: AppTheme.green, highlighted: true));
      } else {
        mapRoutes.add(MapRoute(points: route.safeRoute!.points, color: AppTheme.green, highlighted: false));
        mapRoutes.add(MapRoute(points: route.fastRoute!.points, color: AppTheme.red, highlighted: true));
      }
    }

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AppBottomNav(currentIndex: 1),
        body: SafeArea(
          child: Column(
            children: [
              // Adresbalk met terug-pijl
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 16, 8),
                child: Row(children: [
                  IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(context)),
                  Expanded(child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8, offset: const Offset(0, 2))]),
                    child: Column(children: [
                      Row(children: [
                        const Icon(Icons.trip_origin, color: AppTheme.navy, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Wijnhaven 107', style: TextStyle(color: AppTheme.navy, fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.location_on, color: AppTheme.pink, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Kunsthal — Museumpark', style: TextStyle(color: AppTheme.navy, fontSize: 12, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
                      ]),
                    ]),
                  )),
                ]),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Stack(children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: RotterdamMap(
                        zones: zones.zones, height: double.infinity, initialZoom: 14.5,
                        center: const LatLng(51.9120, 4.4785),
                        routes: mapRoutes,
                        startMarker: RouteService.hogeschoolWijnhaven,
                        endMarker: RouteService.kunsthalMuseumpark,
                      ),
                    ),
                    Positioned(top: 10, left: 10, child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.94), borderRadius: BorderRadius.circular(8)),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                        _Legend(color: AppTheme.green, label: 'Rustig'),
                        _Legend(color: AppTheme.amber, label: 'Gemiddeld'),
                        _Legend(color: AppTheme.red, label: 'Druk'),
                      ]),
                    )),
                    if (route.isLoading)
                      Center(child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                        child: const Row(mainAxisSize: MainAxisSize.min, children: [
                          SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
                          SizedBox(width: 12), Text('Routes berekenen…', style: TextStyle(color: AppTheme.navy)),
                        ]),
                      )),
                  ]),
                ),
              ),
              if (route.error.isNotEmpty)
                Padding(padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Container(padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: AppTheme.redLight, borderRadius: BorderRadius.circular(10)),
                    child: Row(children: [
                      const Icon(Icons.error_outline, color: AppTheme.red, size: 18), const SizedBox(width: 8),
                      Expanded(child: Text(route.error, style: const TextStyle(color: AppTheme.red, fontSize: 12))),
                      TextButton(onPressed: _calculateDemo, child: const Text('Opnieuw')),
                    ]))),
              if (route.hasRoutes)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Column(children: [
                    _RouteOption(title: 'Veilige route', subtitle: 'Via rustige zones',
                      duration: route.safeRoute!.durationLabel, distance: route.safeRoute!.distanceLabel,
                      color: AppTheme.green, icon: Icons.verified_outlined, selected: _selectedSafe,
                      onTap: () => setState(() => _selectedSafe = true)),
                    const SizedBox(height: 8),
                    _RouteOption(title: 'Snelle route', subtitle: 'Kortste pad door centrum',
                      duration: route.fastRoute!.durationLabel, distance: route.fastRoute!.distanceLabel,
                      color: AppTheme.red, icon: Icons.bolt_outlined, selected: !_selectedSafe,
                      onTap: () => setState(() => _selectedSafe = false)),
                  ]),
                ),
              if (route.hasRoutes)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, '/route-overview'),
                    child: const Text('Bekijk route'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color; final String label;
  const _Legend({required this.color, required this.label});
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 1),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 9, height: 9, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 5), Text(label, style: const TextStyle(fontSize: 10, color: Colors.black87)),
    ]));
}

class _RouteOption extends StatelessWidget {
  final String title, subtitle, duration, distance;
  final Color color; final IconData icon; final bool selected; final VoidCallback onTap;
  const _RouteOption({required this.title, required this.subtitle, required this.duration,
    required this.distance, required this.color, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected ? color : Colors.transparent, width: 2.5),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))]),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: color, size: 22)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
        ])),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(duration, style: const TextStyle(color: AppTheme.navy, fontSize: 14, fontWeight: FontWeight.w700)),
          Text(distance, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
        ]),
        if (selected) Padding(padding: const EdgeInsets.only(left: 8), child: Icon(Icons.check_circle, color: color, size: 20)),
      ]),
    ));
  }
}
