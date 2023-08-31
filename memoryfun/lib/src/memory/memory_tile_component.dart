import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/theme/app_colors.dart';

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
    var initTile = Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Image(image: image, fit: BoxFit.cover),
      ).animate(),
    );

    if (isCorrect) {
      initTile = Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Image(image: image, fit: BoxFit.cover),
        ).animate().shimmer(),
      );
    }

    if (hasError) {
      initTile = Padding(
        padding: const EdgeInsets.all(0.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).focusColor,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAlias,
              child: Image(image: image, fit: BoxFit.cover),
            ),
          ),
        ).animate().shake(),
      );
    }

    return InkWell(
      onTap: () => visible && isCorrect ? {} : onTap(),
      customBorder: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
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
