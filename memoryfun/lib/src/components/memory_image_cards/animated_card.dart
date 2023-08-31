import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/memory_image_cards/memory_card_error.dart';
import 'package:memoryfun/src/memory_types/same/animated_image/models/animated_memory_tile.dart';

import 'tapable_card.dart';

class AnimatedCard extends ConsumerStatefulWidget {
  final AnimatedMemoryTile animatedMemoryTile;
  final Function() onTap;

  const AnimatedCard({
    required this.animatedMemoryTile,
    required this.onTap,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimatedMemoryTileComponentState();
}

class _AnimatedMemoryTileComponentState extends ConsumerState<AnimatedCard> {
  @override
  Widget build(BuildContext context) {
    Widget animatedCard = Padding(
      padding: const EdgeInsets.all(4.0),
      child: _getImage().animate(),
    ).animate();

    if (widget.animatedMemoryTile.isCorrect) {
      animatedCard = Padding(
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

    if (widget.animatedMemoryTile.hasError) {
      animatedCard = MemoryCardError(
          image: widget.animatedMemoryTile.animationImages.first);
    }

    return TapableCard(
      card: animatedCard,
      onTap: () => widget.animatedMemoryTile.isVisible &&
              widget.animatedMemoryTile.isCorrect
          ? null
          : widget.onTap(),
    );
  }

  Material _getImage() => Material(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        clipBehavior: Clip.antiAlias,
        child: Image(
          image: widget.animatedMemoryTile.image!,
          fit: BoxFit.cover,
        ),
      );

  Padding _getAnimatedImage(int index) => Padding(
        padding: const EdgeInsets.all(4.0),
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: Image(
            image: widget.animatedMemoryTile.animationImages[index],
            fit: BoxFit.cover,
          ),
        ),
      );
}
