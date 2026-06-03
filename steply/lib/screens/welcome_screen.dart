import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/gradient_background.dart';
import '../widgets/bottom_nav.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AppBottomNav(currentIndex: 0),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 16),
            children: [
              const Text('Welkom.', style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Text('Geef aan op welke manier u Steply wilt gebruiken.',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
              const SizedBox(height: 28),

              // Ik ga zelf wandelen
              WhiteCard(
                padding: const EdgeInsets.all(18),
                onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                child: Row(children: [
                  Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: AppTheme.cardGrey, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.directions_walk, color: AppTheme.navy, size: 24)),
                  const SizedBox(width: 14),
                  const Expanded(child: Text('Ik ga zelf wandelen',
                    style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600))),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ]),
              ),

              // Ik bied hulp aan de wandelaars
              WhiteCard(
                padding: const EdgeInsets.all(18),
                onTap: () => Navigator.pushReplacementNamed(context, '/helper-home'),
                child: Row(children: [
                  Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: AppTheme.cardGrey, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.volunteer_activism, color: AppTheme.navy, size: 24)),
                  const SizedBox(width: 14),
                  const Expanded(child: Text('Ik bied hulp aan de wandelaars',
                    style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600))),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
