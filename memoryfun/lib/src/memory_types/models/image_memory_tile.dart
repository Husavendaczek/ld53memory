import 'package:flutter/material.dart';

import 'memory_tile.dart';

class ImageMemoryTile extends MemoryTile {
  AssetImage? image;

  ImageMemoryTile({
    required super.index,
    required super.pairValue,
    required super.angle,
    super.isVisible = false,
    super.hasError = false,
    super.isCorrect = false,
    super.isLowerPart = false,
    this.image,
  });
}
