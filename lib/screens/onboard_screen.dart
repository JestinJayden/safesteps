// ─── screens/onboard_screen.dart ─────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../main.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Hero header
          Container(
            height: 220,
            width: double.infinity,
            color: AppTheme.navy,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.directions_walk, size: 56, color: AppTheme.green),
                const SizedBox(height: 12),
                const Text(
                  'SafeSteps',
                  style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 6),
                Text(
                  'Veilig wandelen door Rotterdam',
                  style: TextStyle(color: AppTheme.green.withOpacity(0.85), fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Waar wil je je op richten?',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          const SizedBox(height: 12),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _ChoiceButton(
                  icon: Icons.map_outlined,
                  title: 'Snel starten',
                  subtitle: 'Direct een veilige route starten',
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                _ChoiceButton(
                  icon: Icons.route_outlined,
                  title: 'Route plannen',
                  subtitle: 'Kies je bestemming vooraf',
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
                _ChoiceButton(
                  icon: Icons.tune_outlined,
                  title: 'Instellingen aanpassen',
                  subtitle: 'Armband koppelen, noodcontact instellen',
                  onTap: () => Navigator.pushReplacementNamed(context, '/settings'),
                ),
                _ChoiceButton(
                  icon: Icons.help_outline,
                  title: 'Anders, namelijk…',
                  subtitle: 'Uitleg en handleiding',
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ChoiceButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300, width: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.grey.shade500),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 18, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
