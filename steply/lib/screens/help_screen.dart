// ─── screens/help_screen.dart ─────────────────────────────────────────────────
// "Hulp nodig": SOS-scherm met 112-knop en situatie-opties.

import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_scaffold.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: ListView(
        padding: const EdgeInsets.only(top: 16, bottom: 16),
        children: [
          // BEL 112 knop (rood, bovenaan)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.red,
                minimumSize: const Size(double.infinity, 64),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.phone, color: Colors.white, size: 26),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('BEL 112', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
                      Text('Bij nood', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Situatie-opties (witte knoppen)
          _OptionButton(label: 'Ik ben gevallen', onTap: () => Navigator.pushNamed(context, '/situation-chosen')),
          _OptionButton(label: 'Ik voel mij onveilig', onTap: () => Navigator.pushNamed(context, '/situation-chosen')),
          _OptionButton(label: 'Ik ben verdwaald', onTap: () => Navigator.pushNamed(context, '/situation-chosen')),
          _OptionButton(label: 'Medische hulp nodig', onTap: () => Navigator.pushNamed(context, '/situation-chosen')),

          const SizedBox(height: 8),

          // Bel een vertrouwd persoon (groene kaart)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(color: AppTheme.greenLight, borderRadius: BorderRadius.circular(14)),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person, color: AppTheme.green, size: 20),
                  SizedBox(width: 8),
                  Text('Bel een vertrouwd persoon', style: TextStyle(color: Color(0xFF1B6B45), fontSize: 14, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _OptionButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2))],
          ),
          alignment: Alignment.center,
          child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppTheme.navy)),
        ),
      ),
    );
  }
}
