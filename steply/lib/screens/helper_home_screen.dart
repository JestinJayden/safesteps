import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../services/zone_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/helper_bottom_nav.dart';
import '../widgets/rotterdam_map.dart';

class HelperHomeScreen extends StatefulWidget {
  const HelperHomeScreen({super.key});
  @override
  State<HelperHomeScreen> createState() => _HelperHomeScreenState();
}

class _HelperHomeScreenState extends State<HelperHomeScreen> {
  bool _available = true;

  @override
  void initState() {
    super.initState();
    context.read<ZoneService>().loadZones();
  }

  @override
  Widget build(BuildContext context) {
    final zones = context.watch<ZoneService>();

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const HelperBottomNav(currentIndex: 0),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
            children: [
              const Text('Welkom terug.', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
              const Text('Mira', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Samen maken we de buurt veiliger voor iedereen.',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
              const SizedBox(height: 24),

              // Beschikbaarheid kaart
              WhiteCard(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Beschikbaar om te helpen', style: TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('U ontvangt alleen meldingen als u beschikbaar bent',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 14),
                  // Toggle-knoppen
                  Row(children: [
                    Expanded(child: GestureDetector(
                      onTap: () => setState(() => _available = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: _available ? AppTheme.green : AppTheme.cardGrey,
                          borderRadius: BorderRadius.circular(10)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.check_circle, color: _available ? Colors.white : Colors.grey, size: 18),
                          const SizedBox(width: 6),
                          Text('Beschikbaar', style: TextStyle(color: _available ? Colors.white : Colors.grey,
                            fontSize: 13, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: GestureDetector(
                      onTap: () => setState(() => _available = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: !_available ? AppTheme.red : AppTheme.cardGrey,
                          borderRadius: BorderRadius.circular(10)),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.cancel, color: !_available ? Colors.white : Colors.grey, size: 18),
                          const SizedBox(width: 6),
                          Text('Niet nu', style: TextStyle(color: !_available ? Colors.white : Colors.grey,
                            fontSize: 13, fontWeight: FontWeight.w600)),
                        ]),
                      ),
                    )),
                  ]),
                ]),
              ),

              // Bekijk meldingen met badge
              WhiteCard(
                padding: const EdgeInsets.all(16),
                onTap: () => Navigator.pushNamed(context, '/helper-notifications'),
                child: Row(children: [
                  Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: AppTheme.cardGrey, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.notifications_outlined, color: AppTheme.navy, size: 24)),
                  const SizedBox(width: 14),
                  const Expanded(child: Text('Bekijk meldingen',
                    style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600))),
                  if (_available)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: const BoxDecoration(color: AppTheme.red, shape: BoxShape.circle),
                      child: const Text('1', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
                    ),
                  const SizedBox(width: 4),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ]),
              ),

              // Actief in uw buurt - kaart
              WhiteCard(
                padding: const EdgeInsets.all(14),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Actief in uw buurt', style: TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('1 wandelaar in de buurt · 2 vrijwilligers actief',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: RotterdamMap(
                      zones: zones.zones, height: 150, initialZoom: 13.5,
                      center: const LatLng(51.9170, 4.4800),
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
