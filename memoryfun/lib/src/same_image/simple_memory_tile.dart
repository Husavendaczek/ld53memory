import 'package:flutter/material.dart';

class SimpleMemoryTile {
  final int index;
  final int pairValue;
  AssetImage? image;
  bool visible;
  bool hasError;

  SimpleMemoryTile({
    required this.index,
    required this.pairValue,
    this.image,
    this.visible = false,
    this.hasError = false,
  });
}
