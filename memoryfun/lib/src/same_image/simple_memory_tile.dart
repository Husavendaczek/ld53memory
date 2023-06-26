import 'package:flutter/material.dart';

class SimpleMemoryTile {
  final int index;
  final int pairValue;
  AssetImage? image;
  bool visible;
  bool hasError;
  bool isCorrect;

  SimpleMemoryTile({
    required this.index,
    required this.pairValue,
    this.image,
    this.visible = false,
    this.hasError = false,
    this.isCorrect = false,
  });
}
