// ─── screens/notifications_screen.dart ───────────────────────────────────────

import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/bottom_nav.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  static const _notifs = [
    (icon: Icons.warning_amber_outlined, color: Color(0xFF791F1F), bg: Color(0xFFFCEBEB), title: 'Druk punt naderen', sub: 'Er is een drukkere zone in de buurt', time: 'Nu'),
    (icon: Icons.check_circle_outline, color: Color(0xFF085041), bg: Color(0xFFE1F5EE), title: 'Rustig gebied bereikt', sub: 'Fijn om door te wandelen in dit gedeelte', time: '5 min'),
    (icon: Icons.check_circle_outline, color: Color(0xFF085041), bg: Color(0xFFE1F5EE), title: 'Fijn wandelgebied!', sub: 'Goed verlicht en rustig pad', time: '12 min'),
    (icon: Icons.nightlight_outlined, color: Color(0xFF633806), bg: Color(0xFFFAEEDA), title: 'Nachtmodus actief', sub: 'Avondmodus ingeschakeld na 19:00', time: 'Gisteren'),
    (icon: Icons.bluetooth, color: Color(0xFF0C447C), bg: Color(0xFFE6F1FB), title: 'Armband verbonden', sub: 'SafeSteps-ESP32 succesvol gekoppeld', time: 'Gisteren'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.navy,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Meldingen'),
      ),
      body: ListView.separated(
        itemCount: _notifs.length,
        separatorBuilder: (_, __) => const Divider(height: 0.5, thickness: 0.5),
        itemBuilder: (context, i) {
          final n = _notifs[i];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: CircleAvatar(
              backgroundColor: n.bg,
              child: Icon(n.icon, color: n.color, size: 20),
            ),
            title: Text(n.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            subtitle: Text(n.sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
            trailing: Text(n.time, style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
            onTap: () {},
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}
