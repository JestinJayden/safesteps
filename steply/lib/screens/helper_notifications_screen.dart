import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/gradient_background.dart';
import '../widgets/helper_bottom_nav.dart';

class HelperNotificationsScreen extends StatelessWidget {
  const HelperNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const HelperBottomNav(currentIndex: 1),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
            children: [
              // Bel-icoon met badge
              Center(child: Stack(clipBehavior: Clip.none, children: [
                Container(width: 84, height: 84,
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), shape: BoxShape.circle),
                  child: const Icon(Icons.notifications, color: AppTheme.pink, size: 42)),
                Positioned(right: -2, top: -2, child: Container(
                  width: 26, height: 26,
                  decoration: BoxDecoration(color: AppTheme.red, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: const Center(child: Text('1', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700))),
                )),
              ])),
              const SizedBox(height: 18),
              const Center(child: Text('Nieuwe hulpvraag',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))),
              const SizedBox(height: 4),
              Center(child: Text('Maria vraagt om ondersteuning',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14))),
              const SizedBox(height: 24),

              // Detailkaart
              WhiteCard(
                padding: const EdgeInsets.all(18),
                child: Column(children: const [
                  _DetailRow(icon: Icons.location_on_outlined, label: 'Locatie', value: 'Blaak — 100 meter'),
                  Divider(height: 24),
                  _DetailRow(icon: Icons.info_outline, label: 'Reden', value: 'Onveilig gevoel'),
                  Divider(height: 24),
                  _DetailRow(icon: Icons.access_time, label: 'Tijdstip', value: 'Zojuist'),
                ]),
              ),
              const SizedBox(height: 8),

              // Ik ga helpen (groen)
              ElevatedButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Ik ga helpen'),
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.green),
                onPressed: () => Navigator.pushNamed(context, '/helper-enroute'),
              ),
              const SizedBox(height: 12),
              // Niet beschikbaar (wit)
              ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/helper-none'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.red),
                child: const Text('Niet beschikbaar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon; final String label, value;
  const _DetailRow({required this.icon, required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Row(children: [
    Icon(icon, color: AppTheme.navy, size: 22),
    const SizedBox(width: 14),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      const SizedBox(height: 2),
      Text(value, style: const TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600)),
    ]),
  ]);
}
