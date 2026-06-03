// ─── screens/help_coming_screen.dart ──────────────────────────────────────────
// "Hulp onderweg": bevestiging dat hulp eraan komt.

import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_scaffold.dart';

class HelpComingScreen extends StatelessWidget {
  const HelpComingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Column(
        children: [
          const SizedBox(height: 30),
          // Handen-icoon
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
            child: const Icon(Icons.volunteer_activism, color: Colors.white, size: 46),
          ),
          const SizedBox(height: 20),
          const Text('Hulp is onderweg', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 26),

          // Statuskaart
          WhiteCard(
            child: Column(
              children: const [
                _StatusRow(label: 'Uw locatie is gedeeld'),
                SizedBox(height: 12),
                _StatusRow(label: 'Buurthelper op 4 min afstand'),
              ],
            ),
          ),

          const Spacer(),

          // Annuleren (wit)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: OutlinedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 54),
                backgroundColor: Colors.white,
                side: BorderSide.none,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Annuleren', style: TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusRow extends StatelessWidget {
  final String label;
  const _StatusRow({required this.label});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.check_circle, color: AppTheme.green, size: 22),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.navy))),
    ],
  );
}
