// ─── screens/loading_screen.dart ──────────────────────────────────────────────
// Laadscherm met logo en spinner. Berekent ondertussen de echte route en
// gaat daarna door naar het route-overzicht.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../services/route_service.dart';
import '../services/location_service.dart';
import '../services/zone_service.dart';
import '../services/storage_service.dart';
import '../widgets/steply_logo.dart';
import '../widgets/gradient_scaffold.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});
  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    _calculateAndContinue();
  }

  void _calculateAndContinue() async {
    final location = context.read<LocationService>();
    final route = context.read<RouteService>();
    final zones = context.read<ZoneService>();
    final storage = context.read<StorageService>();

    final avoidBusy = await storage.getBool('avoid_busy', defaultValue: true);
    final avoidDark = await storage.getBool('avoid_dark');
    final avoidBad = await storage.getBool('avoid_bad_roads');

    final start = LatLng(location.lat, location.lng);
    // Standaard bestemming: Kralingse Bos (rustige route)
    const dest = LatLng(51.9244, 4.5306);

    await route.calculateRoute(start, dest, zones.zones,
        avoidBusy: avoidBusy, avoidBadRoads: avoidBad, avoidDark: avoidDark);

    // Korte pauze zodat het laadscherm zichtbaar is
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) Navigator.pushReplacementNamed(context, '/route-overview');
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            SteplyLogo(size: 110, showText: true),
            SizedBox(height: 40),
            SizedBox(
              width: 32, height: 32,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
