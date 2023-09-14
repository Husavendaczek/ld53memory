import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TapableCard extends ConsumerWidget {
  final Widget card;
  final double rotationAngle;
  final bool shouldFlip;
  final Function() onTap;

  const TapableCard({
    required this.card,
    required this.rotationAngle,
    required this.shouldFlip,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var transform = Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationZ(rotationAngle),
      child: InkWell(
        onTap: onTap,
        customBorder: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(8),
          ),
        ),
        child: shouldFlip ? card.animate().flipH() : card,
      )
          .animate()
          .fadeIn(
            duration: 600.ms,
            curve: Curves.easeIn,
          )
          .blurXY(begin: 1, end: 0, duration: 600.ms, delay: 300.ms),
    );

    return Transform.translate(
      offset: Offset(rotationAngle * 10, rotationAngle * 20),
      child: transform,
    );
  }
}
