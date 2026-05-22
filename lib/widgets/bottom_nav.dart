// ─── widgets/bottom_nav.dart ──────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../main.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  static const _routes = ['/home', '/notifs', '/chat', '/settings'];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) {
        if (i != currentIndex) {
          Navigator.pushReplacementNamed(context, _routes[i]);
        }
      },
      selectedItemColor: AppTheme.navy,
      unselectedItemColor: Colors.grey,
      selectedFontSize: 11,
      unselectedFontSize: 11,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.map_outlined), label: 'Kaart'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), label: 'Meldingen'),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Chat'),
        BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), label: 'Instellingen'),
      ],
    );
  }
}
