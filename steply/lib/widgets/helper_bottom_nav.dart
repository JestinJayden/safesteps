import 'package:flutter/material.dart';
import '../main.dart';

// Bottom nav voor de vrijwilliger/buurtbewoner: Home, Meldingen, Profiel
class HelperBottomNav extends StatelessWidget {
  final int currentIndex;
  const HelperBottomNav({super.key, required this.currentIndex});

  static const _routes = ['/helper-home', '/helper-notifications', '/helper-profile'];
  static const _labels = ['Home', 'Meldingen', 'Profiel'];
  static const _icons = [Icons.home_rounded, Icons.notifications_rounded, Icons.person_rounded];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(3, (i) {
              final selected = i == currentIndex;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  if (i != currentIndex) Navigator.pushReplacementNamed(context, _routes[i]);
                },
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Icon(_icons[i], color: selected ? AppTheme.navy : Colors.grey.shade400, size: 24),
                  const SizedBox(height: 3),
                  Text(_labels[i], style: TextStyle(fontSize: 11,
                    color: selected ? AppTheme.navy : Colors.grey.shade400,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
                ]),
              );
            }),
          ),
        ),
      ),
    );
  }
}
