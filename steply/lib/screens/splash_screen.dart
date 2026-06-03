// ─── screens/splash_screen.dart ───────────────────────────────────────────────

import 'dart:async';
import 'package:flutter/material.dart';
import '../widgets/steply_logo.dart';
import '../widgets/gradient_scaffold.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Na 2,5 seconde automatisch naar home
    Timer(const Duration(milliseconds: 2500), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      showStatusBar: true,
      body: GestureDetector(
        onTap: () => Navigator.pushReplacementNamed(context, '/home'),
        child: const Center(
          child: SteplyLogo(size: 120, showText: true),
        ),
      ),
    );
  }
}
