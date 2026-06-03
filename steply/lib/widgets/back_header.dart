import 'package:flutter/material.dart';

// Terug-pijl linksboven (wit, op de gradient)
class BackHeader extends StatelessWidget {
  final VoidCallback? onBack;
  const BackHeader({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 6, 8, 0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 26),
          onPressed: onBack ?? () => Navigator.pop(context),
        ),
      ),
    );
  }
}
