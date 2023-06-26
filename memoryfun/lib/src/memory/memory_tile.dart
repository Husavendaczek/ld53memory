import 'package:flutter/material.dart';

class MemoryTile {
  final int index;
  final int pairValue;
  final bool isLowerPart;
  AssetImage? image;
  bool visible;
  bool hasError;

  MemoryTile({
    required this.index,
    required this.pairValue,
    required this.isLowerPart,
    this.image,
    this.visible = false,
    this.hasError = false,
  });
}
