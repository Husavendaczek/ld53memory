import 'package:flutter/material.dart';

class MemoryTile {
  final int index;
  final int pairValue;
  final bool isLowerPart;
  AssetImage? image;
  bool isVisible;
  bool hasError;
  bool isCorrect;

  MemoryTile({
    required this.index,
    required this.pairValue,
    this.image,
    this.isLowerPart = false,
    this.isVisible = false,
    this.hasError = false,
    this.isCorrect = false,
  });
}
