import 'package:flutter/material.dart';
import 'package:memoryfun/src/same_image/simple_memory_tile.dart';

class AnimatedMemoryTile extends SimpleMemoryTile {
  final List<AssetImage> animationImages;

  AnimatedMemoryTile({
    required this.animationImages,
    required super.index,
    required super.pairValue,
    super.image,
    super.isVisible = false,
    super.hasError = false,
    super.isCorrect = false,
  });
}
