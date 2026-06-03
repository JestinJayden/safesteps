import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/route_service.dart';
import '../services/ble_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/back_header.dart';
import '../widgets/bottom_nav.dart';

class RouteOverviewScreen extends StatelessWidget {
  const RouteOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final route = context.watch<RouteService>();
    final ble = context.watch<BleService>();
    final r = route.safeRoute;
    final items = [
      _Item(Icons.straighten, r != null ? r.distanceLabel : '2.1 km'),
      _Item(Icons.access_time, r != null ? r.durationLabel : '28 minuten'),
      _Item(Icons.park_outlined, '3 rustpunten'),
      _Item(Icons.nature_people_outlined, 'Rustige omgeving'),
      _Item(Icons.directions_car_outlined, 'Weinig verkeer'),
      _Item(Icons.watch, 'Armband actief  ${ble.battery}%'),
    ];

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AppBottomNav(currentIndex: 1),
        body: SafeArea(
          child: Column(
            children: [
              const BackHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  children: [
                    const Text('Uw wandeling', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                    const SizedBox(height: 20),
                    ...items.map((it) => WhiteCard(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Row(children: [
                        Icon(it.icon, color: AppTheme.navy, size: 22),
                        const SizedBox(width: 14),
                        Text(it.label, style: const TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w500)),
                      ]),
                    )),
                  ],
                ),
              ),
              Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                child: ElevatedButton(onPressed: () => Navigator.pushNamed(context, '/walk'), child: const Text('Start wandeling'))),
              Padding(padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: ElevatedButton(onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.navy),
                  child: const Text('Deel met contactpersoon'))),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item { final IconData icon; final String label; _Item(this.icon, this.label); }
