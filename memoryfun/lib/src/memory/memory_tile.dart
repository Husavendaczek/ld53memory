import 'package:flutter/material.dart';
import 'package:memoryfun/gen/assets.gen.dart';

class MemoryTile {
  final int index;
  final int pairValue;
  AssetGenImage? image;
  bool visible;

  MemoryTile({
    required this.index,
    required this.pairValue,
    this.image,
    this.visible = false,
  });
}
