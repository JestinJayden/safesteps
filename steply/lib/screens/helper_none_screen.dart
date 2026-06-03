import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/gradient_background.dart';
import '../widgets/helper_bottom_nav.dart';

class HelperNoneScreen extends StatelessWidget {
  const HelperNoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const HelperBottomNav(currentIndex: 1),
        body: SafeArea(
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 84, height: 84,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.85), shape: BoxShape.circle),
                child: const Icon(Icons.notifications_none, color: AppTheme.pink, size: 42)),
              const SizedBox(height: 18),
              const Text('Geen meldingen', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Momenteel is er geen hulp nodig',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
            ]),
          ),
        ),
      ),
    );
  }
}
