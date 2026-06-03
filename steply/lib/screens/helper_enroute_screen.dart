import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../services/zone_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/helper_bottom_nav.dart';
import '../widgets/rotterdam_map.dart';

class HelperEnrouteScreen extends StatelessWidget {
  const HelperEnrouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final zones = context.watch<ZoneService>();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const HelperBottomNav(currentIndex: 1),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            children: [
              // Groene check
              Center(child: Container(width: 64, height: 64,
                decoration: const BoxDecoration(color: AppTheme.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 38))),
              const SizedBox(height: 14),
              const Center(child: Text('Hulpvraag geaccepteerd',
                style: TextStyle(color: Colors.white, fontSize: 21, fontWeight: FontWeight.w700))),
              const SizedBox(height: 4),
              Center(child: Text('U bent onderweg om Maria te helpen',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14))),
              const SizedBox(height: 20),

              // Kaart met route naar de gebruiker
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: RotterdamMap(
                  zones: zones.zones, height: 200, initialZoom: 15,
                  center: const LatLng(51.9175, 4.4855),
                  userLocation: const LatLng(51.9190, 4.4880),
                  routes: [const MapRoute(points: [
                    LatLng(51.9190, 4.4880), LatLng(51.9182, 4.4868),
                    LatLng(51.9176, 4.4858), LatLng(51.9168, 4.4860),
                  ], color: AppTheme.navy, highlighted: true)],
                  endMarker: const LatLng(51.9168, 4.4860),
                ),
              ),
              const SizedBox(height: 16),

              // Aankomst-info
              WhiteCard(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                    Text('Aankomst', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 2),
                    Text('250 meter', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w700)),
                  ])),
                  Container(width: 1, height: 36, color: Colors.grey.shade300),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                      Text('Geschat', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      SizedBox(height: 2),
                      Text('ca. 5 min lopen', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w700)),
                    ]),
                  )),
                ]),
              ),
              const SizedBox(height: 8),

              // Ik ben aangekomen / afronden (groen)
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/helper-done'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.green),
                child: const Text('Ik ben aangekomen'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/helper-home', (r) => false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.navy),
                child: const Text('Annuleren'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
