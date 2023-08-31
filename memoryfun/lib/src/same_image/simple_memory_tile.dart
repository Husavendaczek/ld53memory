import 'package:flutter/material.dart';

class SimpleMemoryTile {
  final int index;
  final int pairValue;
  AssetImage? image;
  bool isVisible;
  bool hasError;
  bool isCorrect;

  SimpleMemoryTile({
    required this.index,
    required this.pairValue,
    this.image,
    this.isVisible = false,
    this.hasError = false,
    this.isCorrect = false,
  });
}
