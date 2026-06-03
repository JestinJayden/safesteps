import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/gradient_background.dart';
import '../widgets/bottom_nav.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});
  static const _situations = ['Ik ben gevallen', 'Ik voel mij onveilig', 'Ik ben verdwaald', 'Medische hulp nodig'];

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AppBottomNav(currentIndex: 2),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              children: [
                // Bel 112
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 18),
                    decoration: BoxDecoration(color: AppTheme.red, borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: AppTheme.red.withOpacity(0.4), blurRadius: 14, offset: const Offset(0, 4))]),
                    child: const Column(children: [
                      Icon(Icons.phone, color: Colors.white, size: 30), SizedBox(height: 6),
                      Text('BEL 112', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                      Text('Bij nood', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ]),
                  ),
                ),
                const SizedBox(height: 20),
                ..._situations.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/situation', arguments: s),
                    child: Container(
                      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2))]),
                      child: Center(child: Text(s, style: const TextStyle(color: AppTheme.navy, fontSize: 16, fontWeight: FontWeight.w600))),
                    ),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
