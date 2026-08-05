import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class EventMatchedConfettiOverlay extends StatelessWidget {
  const EventMatchedConfettiOverlay({
    super.key,
    required this.animationPath,
    required this.visible,
  });

  final String animationPath;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible) {
      return const SizedBox.shrink();
    }

    return Positioned.fill(
      child: IgnorePointer(
        child: Lottie.asset(
          animationPath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
