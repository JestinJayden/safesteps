import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/gradient_background.dart';
import '../widgets/helper_bottom_nav.dart';

class HelperProfileScreen extends StatelessWidget {
  const HelperProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const HelperBottomNav(currentIndex: 2),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            children: [
              const Text('Mijn profiel', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
              const SizedBox(height: 20),

              // Avatar + naam
              Row(children: [
                Container(width: 64, height: 64,
                  decoration: BoxDecoration(color: AppTheme.pink, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                  child: const Icon(Icons.person, color: Colors.white, size: 36)),
                const SizedBox(width: 16),
                const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Mira van Dijk', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
                  SizedBox(height: 2),
                  Text('Vrijwilliger', style: TextStyle(color: Colors.white70, fontSize: 13)),
                ]),
              ]),
              const SizedBox(height: 24),

              // Jouw bijdrage aan de buurt (afbeelding in witte kaart)
              Container(
                decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 12, offset: const Offset(0, 4))],
                ),
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.only(bottom: 14),
                child: Image.asset('assets/images/bijdrage.png', fit: BoxFit.cover, width: double.infinity),
              ),

              // Instellingen
              WhiteCard(
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                onTap: () {},
                child: Row(children: const [
                  Icon(Icons.settings_outlined, color: AppTheme.navy, size: 22),
                  SizedBox(width: 14),
                  Expanded(child: Text('Instellingen', style: TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w600))),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
