import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnimatedMemoryTileComponent extends ConsumerStatefulWidget {
  final bool visible;
  final bool hasError;
  final bool isCorrect;
  final List<AssetImage> images;
  final Function() onTap;

  const AnimatedMemoryTileComponent({
    required this.visible,
    required this.hasError,
    required this.isCorrect,
    required this.images,
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
    var initTile = Container(
      child: _getImage(0),
    ).animate();

    if (widget.isCorrect) {
      initTile = Container(
        child: _getImage(0),
      )
          .animate()
          // TODO check if shimmer can work .shimmer(
          //   duration: 180.ms,
          // )
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getImage(1),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getImage(2),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getImage(3),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getImage(4),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getImage(5),
          )
          .then()
          .swap(
            duration: 180.ms,
            builder: (context, otherWidget) => _getImage(6),
          );
    }

    if (widget.hasError) {
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
          child: Image(image: widget.images.first, fit: BoxFit.cover),
        ),
      ).animate().shake();
    }

    return InkWell(
      onTap: () => widget.visible && widget.isCorrect ? {} : widget.onTap(),
      child: initTile,
    )
        .animate()
        .fadeIn(
          duration: 600.ms,
          curve: Curves.easeIn,
        )
        .blurXY(begin: 1, end: 0, duration: 600.ms, delay: 300.ms);
  }

  Material _getImage(int index) => Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Image(
          image: widget.images[index],
          fit: BoxFit.cover,
        ),
      );
}
