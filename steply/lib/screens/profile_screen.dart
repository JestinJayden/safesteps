// ─── screens/profile_screen.dart ──────────────────────────────────────────────
// "Profiel": Mijn profiel met avatar, armband-status en instelopties.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/ble_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_scaffold.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BleService>();

    return GradientScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: ListView(
        padding: const EdgeInsets.only(top: 12, bottom: 16),
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 8, 22, 18),
            child: Text('Mijn profiel', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
          ),

          // Avatar + naam
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 0, 22, 22),
            child: Row(
              children: [
                Container(
                  width: 64, height: 64,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(Icons.person, color: AppTheme.navy, size: 36),
                ),
                const SizedBox(width: 16),
                const Text('Anita Delgado', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
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
                  width: 56, height: 56,
                  decoration: BoxDecoration(color: AppTheme.navy.withOpacity(0.06), borderRadius: BorderRadius.circular(14)),
                  child: const Icon(Icons.watch, color: AppTheme.navy, size: 30),
                ),
              ],
            ),
          ),

          // Menu-opties
          _MenuCard(label: 'Contactpersonen', subtitle: '2 contacten', onTap: () {}),
          _MenuCard(label: 'Voorkeuren aanpassen', onTap: () => Navigator.pushNamed(context, '/preferences')),
          _MenuCard(label: 'Instellingen', onTap: () {}),
        ],
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  const _MenuCard({required this.label, this.subtitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.navy)),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(subtitle!, style: const TextStyle(fontSize: 12, color: Colors.black45)),
                ],
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
        ],
      ),
    );
  }
}
