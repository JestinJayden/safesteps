// ─── widgets/gradient_scaffold.dart ───────────────────────────────────────────
// Achtergrond met blauwe gradient + nep-statusbalk (9:41 etc.) zoals in de designs.

import 'package:flutter/material.dart';
import '../main.dart';

class GradientScaffold extends StatelessWidget {
  final Widget body;
  final Widget? bottomNavigationBar;
  final bool showStatusBar;

  const GradientScaffold({
    super.key,
    required this.body,
    this.bottomNavigationBar,
    this.showStatusBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.bgGradient),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: bottomNavigationBar,
        body: SafeArea(
          child: Column(
            children: [
              if (showStatusBar) const _FakeStatusBar(),
              Expanded(child: body),
            ],
          ),
        ),
      ),
    );
  }
}

class _FakeStatusBar extends StatelessWidget {
  const _FakeStatusBar();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 6, 20, 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('9:41', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          Row(children: [
            Icon(Icons.signal_cellular_alt, color: Colors.white, size: 14),
            SizedBox(width: 5),
            Icon(Icons.wifi, color: Colors.white, size: 14),
            SizedBox(width: 5),
            Icon(Icons.battery_full, color: Colors.white, size: 16),
          ]),
        ],
      ),
    );
  }
}

// Witte kaart met afgeronde hoeken + schaduw (herbruikbaar)
class WhiteCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Color? borderColor;
  final double radius;

  const WhiteCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.fromLTRB(20, 0, 20, 14),
    this.onTap,
    this.borderColor,
    this.radius = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(radius),
            border: borderColor != null ? Border.all(color: borderColor!, width: 2) : null,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: child,
        ),
      ),
    );
  }
}
