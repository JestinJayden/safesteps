// ─── screens/home_screen.dart ─────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/zone_service.dart';
import '../models/zone.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/zone_badge.dart';
import '../widgets/rotterdam_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedRoute = 0;

  @override
  void initState() {
    super.initState();
    context.read<ZoneService>().loadZones();
  }

  @override
  Widget build(BuildContext context) {
    final zoneService = context.watch<ZoneService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('SafeSteps', style: TextStyle(color: AppTheme.green, fontWeight: FontWeight.w600)),
        backgroundColor: AppTheme.navy,
        actions: [
          IconButton(icon: const Icon(Icons.notifications_outlined, color: Colors.white), onPressed: () => Navigator.pushNamed(context, '/notifs')),
          IconButton(icon: const Icon(Icons.person_outline, color: Colors.white), onPressed: () => Navigator.pushNamed(context, '/settings')),
        ],
      ),
      body: Column(
        children: [
          // Echte OpenStreetMap kaart met zones
          Stack(
            children: [
              RotterdamMap(
                zones: zoneService.zones,
                height: 220,
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _LegendRow(color: AppTheme.green, label: 'Comfortabel'),
                      _LegendRow(color: AppTheme.amber, label: 'Let op'),
                      _LegendRow(color: AppTheme.red, label: 'Drukker'),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('AANBEVOLEN ROUTES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 0.5)),
                  const SizedBox(height: 8),
                  _RouteCard(
                    title: 'Veiligste route',
                    badge: ZoneLevel.comfortable,
                    duration: '25 min',
                    distance: '1.8 km',
                    extra: 'Goed verlicht',
                    extraIcon: Icons.lightbulb_outline,
                    selected: _selectedRoute == 0,
                    onTap: () => setState(() => _selectedRoute = 0),
                  ),
                  const SizedBox(height: 8),
                  _RouteCard(
                    title: 'Kortste route',
                    badge: ZoneLevel.caution,
                    duration: '17 min',
                    distance: '1.2 km',
                    extra: '1 drukke zone',
                    extraIcon: Icons.warning_amber_outlined,
                    selected: _selectedRoute == 1,
                    onTap: () => setState(() => _selectedRoute = 1),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.play_arrow),
              label: const Text('Selectie opstarten'),
              onPressed: () => Navigator.pushNamed(context, '/walk'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendRow({required this.color, required this.label});
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

class _RouteCard extends StatelessWidget {
  final String title;
  final ZoneLevel badge;
  final String duration;
  final String distance;
  final String extra;
  final IconData extraIcon;
  final bool selected;
  final VoidCallback onTap;

  const _RouteCard({
    required this.title, required this.badge, required this.duration,
    required this.distance, required this.extra, required this.extraIcon,
    required this.selected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: selected ? AppTheme.navy : Colors.grey.shade300, width: selected ? 2 : 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                ZoneBadge(level: badge),
              ],
            ),
            const SizedBox(height: 6),
            Row(children: [
              Icon(Icons.access_time, size: 13, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(duration, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(width: 12),
              Icon(Icons.place_outlined, size: 13, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(distance, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              const SizedBox(width: 12),
              Icon(extraIcon, size: 13, color: Colors.grey.shade500),
              const SizedBox(width: 4),
              Text(extra, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            ]),
          ],
        ),
      ),
    );
  }
}
