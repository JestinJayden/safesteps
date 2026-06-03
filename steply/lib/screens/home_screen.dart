// ─── screens/home_screen.dart ─────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/ble_service.dart';
import '../services/zone_service.dart';
import '../services/location_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_scaffold.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ZoneService>().loadZones();
    // Start GPS tracking op de achtergrond
    context.read<LocationService>().startTracking((lat, lng) {});
    // Simuleer verbonden armband voor demo
    context.read<BleService>().simulateConnected();
  }

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BleService>();

    return GradientScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        children: [
          // Begroeting
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 8, 22, 4),
            child: Text('Welkom terug,\nMaria', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700, height: 1.2)),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 20),
            child: Text('Hoe wilt u vandaag wandelen?', style: TextStyle(color: Colors.white70, fontSize: 14)),
          ),

          // Optie 1: Rustige wandeling (donkerblauwe kaart)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/preferences'),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.navy,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44, height: 44,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.directions_walk, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rustige wandeling', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(height: 2),
                          Text('Wij kiezen veilige route', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Optie 2: Eigen bestemming kiezen (witte kaart)
          WhiteCard(
            onTap: () => Navigator.pushNamed(context, '/map-destination'),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.location_on, color: AppTheme.navy, size: 24),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Eigen bestemming kiezen', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('Kies zelf waar u naartoe wilt', style: TextStyle(color: Colors.black45, fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Armband-kaart
          WhiteCard(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Armband', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      Row(children: [
                        Icon(Icons.check_circle, color: ble.isConnected ? AppTheme.green : Colors.grey, size: 16),
                        const SizedBox(width: 5),
                        Text(ble.isConnected ? 'Verbonden' : 'Niet verbonden', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ]),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.battery_charging_full, color: AppTheme.green, size: 16),
                        const SizedBox(width: 5),
                        Text('${ble.batteryLevel}%', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                      ]),
                    ],
                  ),
                ),
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.06), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.watch, color: AppTheme.navy, size: 32),
                ),
              ],
            ),
          ),

          // Laatste wandeling
          WhiteCard(
            onTap: () {},
            child: Row(
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Laatste wandeling', style: TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600)),
                      SizedBox(height: 2),
                      Text('30 minuten geleden', style: TextStyle(color: Colors.black45, fontSize: 12)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
