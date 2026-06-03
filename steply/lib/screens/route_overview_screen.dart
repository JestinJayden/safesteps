// ─── screens/route_overview_screen.dart ───────────────────────────────────────
// "Route overzicht": Uw wandeling met afstand, tijd, rustpunten etc.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/route_service.dart';
import '../services/ble_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_scaffold.dart';

class RouteOverviewScreen extends StatelessWidget {
  const RouteOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final route = context.watch<RouteService>();
    final ble = context.watch<BleService>();

    final distance = route.formattedDistance.isNotEmpty ? route.formattedDistance : '2.1 km';
    final duration = route.formattedDuration.isNotEmpty ? route.formattedDuration : '28 minuten';

    return GradientScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 12, 22, 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Uw wandeling', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
            ),
          ),

          Expanded(
            child: ListView(
              children: [
                _StatCard(text: distance),
                _StatCard(text: duration.contains('min') ? duration : '$duration minuten'),
                const _StatCard(text: '3 rustpunten'),
                const _StatCard(text: 'Rustige omgeving'),
                const _StatCard(text: 'Weinig verkeer'),
                _StatCard(text: 'Armband actief', trailing: '${ble.batteryLevel}% batterij'),
              ],
            ),
          ),

          // Knoppen onderaan
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/walk'),
              child: const Text('Start wandeling'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.white,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Deel met contactpersoon', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String text;
  final String? trailing;
  const _StatCard({required this.text, this.trailing});

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(text, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.navy)),
          if (trailing != null) Text(trailing!, style: const TextStyle(fontSize: 12, color: Colors.black45)),
        ],
      ),
    );
  }
}
