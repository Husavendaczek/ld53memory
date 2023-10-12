import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../memory_types/models/image_memory_tile.dart';
import 'memory_card_background.dart';
import 'memory_card_error.dart';
import 'memory_card_visible.dart';
import 'tapable_card.dart';

class MemoryCard extends ConsumerWidget {
  final ImageMemoryTile memoryTile;
  final Function() onTap;

  const MemoryCard({
    required this.memoryTile,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var image = memoryTile.image!;
    Widget memoryCard = MemoryCardBackground(image: image, onTap: onTap);

    if (memoryTile.isCorrect) {
      memoryCard = MemoryCardVisible(
        widget: Image(image: image, fit: BoxFit.cover),
      );
    }

    if (memoryTile.hasError) {
      memoryCard = MemoryCardError(
        widget: Image(image: image, fit: BoxFit.cover),
      );
    }

    return TapableCard(
      card: memoryCard,
      rotationAngle: memoryTile.angle,
      shouldFlip: memoryTile.isVisible,
      onTap: () =>
          memoryTile.isVisible && memoryTile.isCorrect ? null : onTap(),
    );
  }
}
