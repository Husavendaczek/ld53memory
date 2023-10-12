import 'package:flutter/material.dart';

import 'memory_tile.dart';

class ImageMemoryTile extends MemoryTile {
  final int pairValue;
  final bool isLowerPart;
  AssetImage? image;

  ImageMemoryTile({
    required super.index,
    required super.angle,
    required this.pairValue,
    super.isVisible = false,
    super.hasError = false,
    super.isCorrect = false,
    this.isLowerPart = false,
    this.image,
  });
}
