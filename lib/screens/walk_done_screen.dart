// ─── screens/walk_done_screen.dart ───────────────────────────────────────────

import 'package:flutter/material.dart';
import '../main.dart';

class WalkDoneScreen extends StatelessWidget {
  const WalkDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final seconds = args?['seconds'] as int? ?? 0;
    final km = args?['km'] as double? ?? 0.0;
    final minutes = seconds ~/ 60;

    return Scaffold(
      appBar: AppBar(backgroundColor: AppTheme.navy, title: const Text('Wandeling voltooid')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            Container(
              width: 72, height: 72,
              decoration: BoxDecoration(color: AppTheme.greenLight, shape: BoxShape.circle),
              child: Icon(Icons.check, size: 36, color: const Color(0xFF085041)),
            ),
            const SizedBox(height: 16),
            const Text('Goed gedaan!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(height: 4),
            Text('U heeft gewandeld vandaag', style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
            const SizedBox(height: 20),
            Row(
              children: [
                _DoneStat(value: '$minutes', label: 'minuten'),
                const SizedBox(width: 8),
                _DoneStat(value: km.toStringAsFixed(1), label: 'km'),
                const SizedBox(width: 8),
                _DoneStat(value: '0', label: 'waarschuw.'),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Route samenvatting', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Text('Volledig via comfortabele zones gewandeld. Geen drukke gebieden gepasseerd.', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.5)),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton.icon(
              icon: const Icon(Icons.home_outlined),
              label: const Text('Terug naar home'),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.share_outlined),
              label: const Text('Deel resultaat'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.navy, side: BorderSide(color: Colors.grey.shade300)),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _DoneStat extends StatelessWidget {
  final String value, label;
  const _DoneStat({required this.value, required this.label});
  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
        ],
      ),
    ),
  );
}
