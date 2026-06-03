// ─── widgets/bottom_nav.dart ──────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../main.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  const AppBottomNav({super.key, required this.currentIndex});

  static const _routes = ['/home', '/map-destination', '/help', '/profile'];
  static const _labels = ['Home', 'Route', 'Hulp', 'Profiel'];
  static const _icons = [Icons.home_rounded, Icons.location_on, Icons.favorite, Icons.person];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Color(0x14000000), blurRadius: 10, offset: Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(4, (i) {
              final selected = i == currentIndex;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (i != currentIndex) Navigator.pushReplacementNamed(context, _routes[i]);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_icons[i], color: selected ? AppTheme.navy : Colors.grey.shade400, size: 24),
                    const SizedBox(height: 3),
                    Text(_labels[i], style: TextStyle(fontSize: 11, fontWeight: selected ? FontWeight.w600 : FontWeight.w400, color: selected ? AppTheme.navy : Colors.grey.shade400)),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
