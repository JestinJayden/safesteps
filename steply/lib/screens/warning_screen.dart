// ─── screens/warning_screen.dart ──────────────────────────────────────────────
// "Armband melding": grote waarschuwing dat het drukker wordt + keuze.

import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_scaffold.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Grote waarschuwingsdriehoek
          const Icon(Icons.warning_rounded, color: AppTheme.red, size: 72),
          const SizedBox(height: 14),
          const Text('Waarschuwing', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text('Het wordt drukker in dit gebied.\nWilt u een rustige route?', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4)),
          ),
          const SizedBox(height: 24),

          // Armband afbeelding (watch icon in cirkel)
          Container(
            width: 130, height: 130,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.25), width: 2),
            ),
            child: const Icon(Icons.watch, color: Colors.white, size: 64),
          ),

          const Spacer(),

          // Ja, wijzig route (rood)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/loading'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.red,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Ja, wijzig route'),
            ),
          ),

          // Nee, ga verder (wit)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.white,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Nee, ga verder', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
