import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Het echte Steply-logo (roze hart met witte route-swoosh + STEPLY tekst)
class SteplyLogo extends StatelessWidget {
  final double width;
  const SteplyLogo({super.key, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/logo.svg',
      width: width,
      fit: BoxFit.contain,
    );
  }
}

// De Steply-armband (transparante afbeelding)
class SteplyWatch extends StatelessWidget {
  final double height;
  const SteplyWatch({super.key, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/watch.png',
      height: height,
      fit: BoxFit.contain,
    );
  }
}
