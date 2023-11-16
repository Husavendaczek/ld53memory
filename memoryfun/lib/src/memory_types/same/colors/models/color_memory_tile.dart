import 'package:flutter/material.dart';
import 'package:memoryfun/src/memory_types/models/memory_tile.dart';

class ColorMemoryTile extends MemoryTile {
  final Color color;

  ColorMemoryTile({
    required super.index,
    required super.angle,
    required this.color,
  });
}
