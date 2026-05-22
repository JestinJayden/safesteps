// ─── screens/walk_screen.dart ─────────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../main.dart';
import '../services/ble_service.dart';
import '../services/zone_service.dart';
import '../widgets/zone_badge.dart';
import '../widgets/rotterdam_map.dart';

class WalkScreen extends StatefulWidget {
  const WalkScreen({super.key});
  @override
  State<WalkScreen> createState() => _WalkScreenState();
}

class _WalkScreenState extends State<WalkScreen> {
  int _seconds = 0;
  double _km = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _seconds++;
        _km = (_km + 0.003).clamp(0, 99);
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _formattedTime {
    final m = (_seconds ~/ 60).toString().padLeft(2, '0');
    final s = (_seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _stopWalk() {
    _timer?.cancel();
    Navigator.pushReplacementNamed(context, '/walk-done', arguments: {
      'seconds': _seconds,
      'km': _km,
    });
  }

  @override
  Widget build(BuildContext context) {
    final ble = context.watch<BleService>();
    final zoneService = context.watch<ZoneService>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.navy,
        leading: IconButton(icon: const Icon(Icons.arrow_back, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Aan het wandelen'),
        actions: [
          IconButton(icon: const Icon(Icons.close, color: Colors.white), onPressed: _stopWalk),
        ],
      ),
      body: Column(
        children: [
          // BLE status bar
          Container(
            color: AppTheme.navy,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Container(width: 8, height: 8, decoration: const BoxDecoration(color: Color(0xFF5DCAA5), shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Expanded(child: Text('Live — ${ble.statusMessage}', style: const TextStyle(color: Colors.white, fontSize: 12))),
                Icon(Icons.bluetooth, color: ble.isConnected ? const Color(0xFF5DCAA5) : Colors.grey, size: 20),
              ],
            ),
          ),

          // Echte kaart, ingezoomd op de gebruiker
          RotterdamMap(
            zones: zoneService.zones,
            height: 200,
            initialZoom: 15,
            userLocation: const LatLng(51.9225, 4.4792),
          ),

          // Richting card
          Container(
            margin: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE6F1FB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 36, height: 36,
                  decoration: const BoxDecoration(color: AppTheme.navy, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_back, color: Colors.white, size: 18),
                ),
                const SizedBox(width: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Over 80m linksaf', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF0C447C))),
                    Text('Mauritsweg richting centrum', style: TextStyle(fontSize: 11, color: Color(0xFF185FA5))),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                _StatBox(value: _formattedTime, label: 'Tijd'),
                const SizedBox(width: 8),
                _StatBox(value: _km.toStringAsFixed(1), label: 'km'),
                const SizedBox(width: 8),
                _StatBox(
                  value: '',
                  label: 'Zone',
                  child: ZoneBadge(level: zoneService.currentLevel),
                ),
              ],
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.stop),
              label: const Text('Wandeling stoppen'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFA32D2D)),
              onPressed: _stopWalk,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final Widget? child;
  const _StatBox({required this.value, required this.label, this.child});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            child ?? Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}
