import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/gradient_background.dart';

class HelpComingScreen extends StatelessWidget {
  const HelpComingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
            child: Column(children: [
              const SizedBox(height: 50),
              Container(width: 90, height: 90,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                child: const Icon(Icons.volunteer_activism, color: Colors.white, size: 48)),
              const SizedBox(height: 24),
              const Text('Hulp is onderweg', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700)),
              const SizedBox(height: 30),
              Container(width: double.infinity, padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: const Column(children: [
                  _CheckRow(text: 'Uw locatie is gedeeld'), SizedBox(height: 14),
                  _CheckRow(text: 'Buurthelper op 4 min afstand'),
                ])),
              const Spacer(),
              ElevatedButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (r) => false),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.navy),
                child: const Text('Annuleren')),
            ]),
          ),
        ),
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  final String text;
  const _CheckRow({required this.text});
  @override
  Widget build(BuildContext context) => Row(children: [
    const Icon(Icons.check_circle, color: AppTheme.green, size: 22), const SizedBox(width: 12),
    Text(text, style: const TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w500)),
  ]);
}
