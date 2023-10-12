import 'package:flutter/material.dart';

import '../../../models/image_memory_tile.dart';

class AnimatedMemoryTile extends ImageMemoryTile {
  final List<AssetImage> animationImages;

  AnimatedMemoryTile({
    required this.animationImages,
    required super.index,
    required super.pairValue,
    required super.angle,
    super.isVisible = false,
    super.hasError = false,
    super.isCorrect = false,
    super.isLowerPart = false,
    super.image,
  });
}
