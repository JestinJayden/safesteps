// ─── widgets/steply_logo.dart ─────────────────────────────────────────────────
// Het Steply-logo: een roze hart met een witte "S" erin, en de tekst eronder.

import 'package:flutter/material.dart';
import '../main.dart';

class SteplyLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color textColor;

  const SteplyLogo({
    super.key,
    this.size = 90,
    this.showText = true,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hart met S
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(
            painter: _HeartPainter(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: size * 0.08),
                child: Text(
                  'S',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.42,
                    fontWeight: FontWeight.w800,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (showText) ...[
          SizedBox(height: size * 0.12),
          Text(
            'STEPLY',
            style: TextStyle(
              color: textColor,
              fontSize: size * 0.36,
              fontWeight: FontWeight.w800,
              letterSpacing: 2,
            ),
          ),
          Text(
            'THINKTANK',
            style: TextStyle(
              color: textColor.withOpacity(0.7),
              fontSize: size * 0.10,
              fontWeight: FontWeight.w600,
              letterSpacing: 3,
            ),
          ),
        ],
      ],
    );
  }
}

class _HeartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.pink
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;
    final path = Path();
    path.moveTo(w * 0.5, h * 0.88);
    path.cubicTo(w * 0.05, h * 0.55, w * 0.12, h * 0.12, w * 0.5, h * 0.30);
    path.cubicTo(w * 0.88, h * 0.12, w * 0.95, h * 0.55, w * 0.5, h * 0.88);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
