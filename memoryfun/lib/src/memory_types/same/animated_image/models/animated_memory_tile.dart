import 'package:flutter/material.dart';

import '../../../models/memory_tile.dart';

class AnimatedMemoryTile extends MemoryTile {
  final List<AssetImage> animationImages;

  AnimatedMemoryTile({
    required this.animationImages,
    required super.index,
    required super.pairValue,
    required super.angle,
    super.image,
    super.isVisible = false,
    super.hasError = false,
    super.isCorrect = false,
    super.isLowerPart = false,
  });
}
