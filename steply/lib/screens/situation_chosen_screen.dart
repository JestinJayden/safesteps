// ─── screens/situation_chosen_screen.dart ─────────────────────────────────────
// "Situatie gekozen": bevestiging dat hulpverzoek wordt voorbereid.

import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_scaffold.dart';

class SituationChosenScreen extends StatelessWidget {
  const SituationChosenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
      body: Column(
        children: [
          const SizedBox(height: 30),
          // Icoon mensen
          Container(
            width: 90, height: 90,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle),
            child: const Icon(Icons.groups, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 20),
          const Text('Ik ben gevallen', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text('We sturen een hulpverzoek\nnaar uw contactpersonen en\nbuurthelpers in de buurt.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5)),
          ),
          const SizedBox(height: 30),

          // Bevestigingskaart met vinkjes
          WhiteCard(
            child: Column(
              children: const [
                _CheckRow(label: 'Vertrouwd contact'),
                SizedBox(height: 12),
                _CheckRow(label: 'Buurthelpers in de buurt'),
              ],
            ),
          ),

          const Spacer(),

          // Verstuur hulpverzoek (donkerblauw)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/help-coming'),
              child: const Text('Verstuur hulpverzoek'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  const _CheckRow({required this.label});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.check_circle, color: AppTheme.green, size: 22),
      const SizedBox(width: 12),
      Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: AppTheme.navy)),
    ],
  );
}
