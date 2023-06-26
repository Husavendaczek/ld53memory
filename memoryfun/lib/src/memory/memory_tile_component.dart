import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MemoryTileComponent extends ConsumerWidget {
  final bool visible;
  final bool hasError;
  final bool isCorrect;
  final AssetImage image;
  final Function() onTap;

  const MemoryTileComponent({
    required this.visible,
    required this.hasError,
    required this.isCorrect,
    required this.image,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: avoid_unnecessary_containers
    var initTile = Container(
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Image(image: image, fit: BoxFit.cover),
      ),
    ).animate();

    if (isCorrect) {
      // ignore: avoid_unnecessary_containers
      initTile = Container(
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Image(image: image, fit: BoxFit.cover),
        ),
      ).animate().shimmer();
    }

    if (hasError) {
      initTile = Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.red,
            width: 2,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image(image: image, fit: BoxFit.cover),
        ),
      ).animate().shake();
    }

    return InkWell(
      onTap: () => visible && isCorrect ? {} : onTap(),
      child: initTile,
    )
        .animate()
        .fadeIn(
          duration: 600.ms,
          curve: Curves.easeIn,
        )
        .blurXY(begin: 1, end: 0, duration: 600.ms, delay: 300.ms);
  }
}
