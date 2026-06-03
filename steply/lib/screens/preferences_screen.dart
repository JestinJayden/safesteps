// ─── screens/preferences_screen.dart ──────────────────────────────────────────
// "Wat vindt u prettig tijdens het wandelen?" — voorkeuren met vinkjes.
// Deze sturen de routeberekening (avoidBusy/avoidDark) aan.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/storage_service.dart';
import '../widgets/bottom_nav.dart';
import '../widgets/gradient_scaffold.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});
  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  bool _rustigeOmgeving = true;
  bool _weinigVerkeer = true;
  bool _rustpunten = false;
  bool _speelplaatsen = false;
  bool _anders = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final s = context.read<StorageService>();
    final busy = await s.getBool('avoid_busy', defaultValue: true);
    final dark = await s.getBool('avoid_dark', defaultValue: false);
    if (mounted) setState(() {
      _weinigVerkeer = busy;
      _speelplaatsen = false;
      _rustigeOmgeving = busy;
      _rustpunten = dark;
    });
  }

  void _showRoute() async {
    final s = context.read<StorageService>();
    // Map voorkeuren naar route-instellingen
    await s.setBool('avoid_busy', _rustigeOmgeving || _weinigVerkeer);
    await s.setBool('avoid_dark', _rustpunten);
    await s.setBool('avoid_bad_roads', _speelplaatsen);
    if (mounted) Navigator.pushNamed(context, '/loading');
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 12, 22, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Wat vindt u prettig\ntijdens het wandelen?', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, height: 1.2)),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(22, 0, 22, 18),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Wij maken de route op basis van\nuw voorkeuren', style: TextStyle(color: Colors.white70, fontSize: 14)),
            ),
          ),

          Expanded(
            child: WhiteCard(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: ListView(
                shrinkWrap: true,
                children: [
                  _PrefRow(label: 'Rustige omgeving', value: _rustigeOmgeving, onTap: () => setState(() => _rustigeOmgeving = !_rustigeOmgeving)),
                  _PrefRow(label: 'Weinig verkeer', value: _weinigVerkeer, onTap: () => setState(() => _weinigVerkeer = !_weinigVerkeer)),
                  _PrefRow(label: 'Rustpunten onderweg', value: _rustpunten, onTap: () => setState(() => _rustpunten = !_rustpunten)),
                  _PrefRow(label: 'Speelplaatsen vermijden', value: _speelplaatsen, onTap: () => setState(() => _speelplaatsen = !_speelplaatsen)),
                  _PrefRow(label: 'Iets anders, namelijk..', value: _anders, onTap: () => setState(() => _anders = !_anders)),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: ElevatedButton(
              onPressed: _showRoute,
              child: const Text('Route tonen'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrefRow extends StatelessWidget {
  final String label;
  final bool value;
  final VoidCallback onTap;
  const _PrefRow({required this.label, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            // Ronde checkbox
            Container(
              width: 24, height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: value ? AppTheme.navy : Colors.transparent,
                border: Border.all(color: value ? AppTheme.navy : Colors.grey.shade400, width: 2),
              ),
              child: value ? const Icon(Icons.check, color: Colors.white, size: 15) : null,
            ),
            const SizedBox(width: 14),
            Text(label, style: const TextStyle(fontSize: 15, color: AppTheme.navy, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
