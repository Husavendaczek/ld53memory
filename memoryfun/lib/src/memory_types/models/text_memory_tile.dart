import 'package:memoryfun/src/memory_types/models/memory_tile.dart';

class TextMemoryTile extends MemoryTile {
  final String text;
  final int pairValue;

  TextMemoryTile({
    required this.text,
    required this.pairValue,
    required super.index,
    required super.angle,
    super.isVisible = false,
    super.hasError = false,
    super.isCorrect = false,
  });
}
