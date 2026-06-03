import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/ble_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/steply_logo.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BleService>();
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AppBottomNav(currentIndex: 3),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            children: [
              const Text('Mijn profiel', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),
              Row(children: [
                Container(width: 64, height: 64,
                  decoration: BoxDecoration(color: AppTheme.pink, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: const Icon(Icons.person, color: Colors.white, size: 36)),
                const SizedBox(width: 16),
                const Text('Maria Delgado', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
              ]),
              const SizedBox(height: 24),
              WhiteCard(
                padding: const EdgeInsets.all(16),
                child: Row(children: [
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const Text('Armband', style: TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.check_circle, color: ble.isConnected ? AppTheme.green : Colors.grey, size: 16),
                      const SizedBox(width: 5),
                      Text(ble.isConnected ? 'Verbonden' : 'Niet verbonden',
                        style: TextStyle(color: ble.isConnected ? AppTheme.green : Colors.grey, fontSize: 12, fontWeight: FontWeight.w500)),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.battery_5_bar, color: AppTheme.green, size: 16),
                      const SizedBox(width: 5),
                      Text('${ble.battery}%', style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    ]),
                  ])),
                  const SteplyWatch(height: 72),
                ]),
              ),
              _MenuItem(title: 'Contactpersonen', subtitle: '2 contacten', onTap: () {}),
              _MenuItem(title: 'Voorkeuren aanpassen', onTap: () => Navigator.pushNamed(context, '/preferences')),
              _MenuItem(title: 'Instellingen', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final String title; final String? subtitle; final VoidCallback onTap;
  const _MenuItem({required this.title, this.subtitle, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return WhiteCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      onTap: onTap,
      child: Row(children: [
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600)),
          if (subtitle != null) ...[const SizedBox(height: 2), Text(subtitle!, style: const TextStyle(color: Colors.grey, fontSize: 12))],
        ])),
        const Icon(Icons.chevron_right, color: Colors.grey),
      ]),
    );
  }
}
