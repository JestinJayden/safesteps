// ─── widgets/zone_badge.dart ──────────────────────────────────────────────────

import 'package:flutter/material.dart';
import '../models/zone.dart';
import '../main.dart';

class ZoneBadge extends StatelessWidget {
  final ZoneLevel level;
  const ZoneBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final config = switch (level) {
      ZoneLevel.comfortable => (
          label: 'Comfortabel',
          bg: AppTheme.greenLight,
          fg: const Color(0xFF085041),
        ),
      ZoneLevel.caution => (
          label: 'Let op',
          bg: AppTheme.amberLight,
          fg: const Color(0xFF633806),
        ),
      ZoneLevel.busy => (
          label: 'Drukker gebied',
          bg: AppTheme.redLight,
          fg: const Color(0xFF791F1F),
        ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: config.bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config.label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: config.fg,
        ),
      ),
    );
  }
}
