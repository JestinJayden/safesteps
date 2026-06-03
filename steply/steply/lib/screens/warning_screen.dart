import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/gradient_background.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/steply_logo.dart';

class WarningScreen extends StatelessWidget {
  const WarningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: const AppBottomNav(currentIndex: 0),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            child: Column(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppTheme.amber, size: 84),
                const SizedBox(height: 14),
                const Text('Waarschuwing', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text('Het wordt drukker in dit gebied',
                  style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 15), textAlign: TextAlign.center),
                Text('Wilt u een rustige route?',
                  style: TextStyle(color: Colors.white.withOpacity(0.95), fontSize: 15), textAlign: TextAlign.center),
                const SizedBox(height: 20),
                const Expanded(child: Center(child: SteplyWatch(height: 220))),
                ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/map', (r) => r.settings.name == '/home'),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.red),
                  child: const Text('Ja, wijzig route'),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.navy),
                  child: const Text('Nee, ga terug'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
