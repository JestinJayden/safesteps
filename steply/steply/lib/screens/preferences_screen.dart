import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import '../services/storage_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/back_header.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});
  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final List<_Pref> _prefs = [
    _Pref('Rustige omgeving', 'avoid_busy', true),
    _Pref('Weinig verkeer', 'avoid_traffic', true),
    _Pref('Rustpunten onderweg', 'want_rest', false),
    _Pref('Speelplaatsen vermijden', 'avoid_playgrounds', false),
    _Pref('Iets anders, namelijk...', 'other', false),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final storage = context.read<StorageService>();
    for (final p in _prefs) {
      p.value = await storage.getBool(p.key, defaultValue: p.value);
    }
    if (mounted) setState(() {});
  }

  void _toggle(_Pref p) async {
    setState(() => p.value = !p.value);
    await context.read<StorageService>().setBool(p.key, p.value);
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Column(
            children: [
              const BackHeader(),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
                  children: [
                    const Text('Wat vindt u prettig\ntijdens het wandelen?',
                      style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700, height: 1.3)),
                    const SizedBox(height: 8),
                    Text('Wij maken de route op basis van uw voorkeuren',
                      style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white, borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.10), blurRadius: 12, offset: const Offset(0, 4))],
                      ),
                      child: Column(children: _prefs.map((p) => _PrefRow(pref: p, onTap: () => _toggle(p))).toList()),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamed(context, '/loading'),
                  child: const Text('Bevestigen'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Pref {
  final String label; final String key; bool value;
  _Pref(this.label, this.key, this.value);
}

class _PrefRow extends StatelessWidget {
  final _Pref pref;
  final VoidCallback onTap;
  const _PrefRow({required this.pref, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Container(
            width: 26, height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pref.value ? AppTheme.navy : Colors.transparent,
              border: Border.all(color: pref.value ? AppTheme.navy : Colors.grey.shade400, width: 2),
            ),
            child: pref.value ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
          ),
          const SizedBox(width: 14),
          Text(pref.label, style: const TextStyle(color: AppTheme.navy, fontSize: 15, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}
