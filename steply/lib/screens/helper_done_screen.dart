import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/gradient_background.dart';
import '../widgets/helper_bottom_nav.dart';

class HelperDoneScreen extends StatelessWidget {
  const HelperDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const HelperBottomNav(currentIndex: 0),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            children: [
              Center(child: Container(width: 64, height: 64,
                decoration: const BoxDecoration(color: AppTheme.green, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.white, size: 38))),
              const SizedBox(height: 14),
              const Center(child: Text('Ondersteuning afgerond',
                style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700))),
              const SizedBox(height: 4),
              Center(child: Text('Bedankt voor uw hulp',
                style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14))),
              const SizedBox(height: 24),

              // Wandel-illustratie
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset('assets/images/walking.png', fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),

              // Bedank-tekst kaart
              WhiteCard(
                padding: const EdgeInsets.all(18),
                child: Text(
                  'Uw inzet maakt het verschil. Samen zorgen we voor een veiligere en fijnere buurt.',
                  style: TextStyle(color: AppTheme.navy, fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),

              ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/helper-home', (r) => false),
                child: const Text('Terug naar home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
