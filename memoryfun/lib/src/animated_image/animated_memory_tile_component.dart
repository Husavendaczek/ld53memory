import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/theme/app_colors.dart';

class AnimatedMemoryTileComponent extends ConsumerStatefulWidget {
  final bool visible;
  final bool hasError;
  final bool isCorrect;
  final AssetImage image;
  final List<AssetImage> animatedImages;
  final Function() onTap;

  const AnimatedMemoryTileComponent({
    required this.visible,
    required this.hasError,
    required this.isCorrect,
    required this.image,
    required this.animatedImages,
    required this.onTap,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimatedMemoryTileComponentState();
}

class _AnimatedMemoryTileComponentState
    extends ConsumerState<AnimatedMemoryTileComponent> {
  @override
  Widget build(BuildContext context) {
    var initTile = Padding(
      padding: const EdgeInsets.all(4.0),
      child: _getImage().animate(),
    ).animate();

    if (widget.isCorrect) {
      initTile = Padding(
        padding: const EdgeInsets.all(4.0),
        child: _getImage(),
      )
          .animate()
          // TODO check if shimmer can work .shimmer(
          //   duration: 180.ms,
          // )
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getAnimatedImage(1),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getAnimatedImage(2),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getAnimatedImage(3),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getAnimatedImage(4),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getAnimatedImage(5),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getAnimatedImage(6),
          );
    }

    if (widget.hasError) {
      initTile = Padding(
        padding: const EdgeInsets.all(0),
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
              child:
                  Image(image: widget.animatedImages.first, fit: BoxFit.cover),
            ),
          ),
        ).animate().shake(),
      ).animate();
    }

    return InkWell(
      onTap: () => widget.visible && widget.isCorrect ? {} : widget.onTap(),
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

  Material _getImage() => Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Image(
          image: widget.image,
          fit: BoxFit.cover,
        ),
      );

  Padding _getAnimatedImage(int index) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Image(
            image: widget.animatedImages[index],
            fit: BoxFit.cover,
          ),
        ),
      );
}
