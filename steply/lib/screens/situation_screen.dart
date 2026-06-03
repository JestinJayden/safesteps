import 'package:flutter/material.dart';
import '../main.dart';
import '../widgets/gradient_background.dart';
import '../widgets/back_header.dart';

class SituationScreen extends StatelessWidget {
  const SituationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final situation = ModalRoute.of(context)?.settings.arguments as String? ?? 'Ik heb hulp nodig';
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const BackHeader(),
              Expanded(child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                child: Column(children: [
                  const SizedBox(height: 20),
                  Container(width: 90, height: 90,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), shape: BoxShape.circle),
                    child: const Icon(Icons.groups, color: Colors.white, size: 48)),
                  const SizedBox(height: 24),
                  Text(situation, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text('We sturen een hulpverzoek naar uw contactpersonen en buurthelpers in de buurt',
                    style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 14, height: 1.5), textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  Container(width: double.infinity, padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: const Column(children: [
                      _CheckRow(text: 'Vertrouwd contact'), SizedBox(height: 14),
                      _CheckRow(text: 'Buurthelpers in de buurt'),
                    ])),
                  const Spacer(),
                  ElevatedButton(onPressed: () => Navigator.pushReplacementNamed(context, '/help-coming'),
                    child: const Text('Verstuur hulpverzoek')),
                ]),
              )),
            ],
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
