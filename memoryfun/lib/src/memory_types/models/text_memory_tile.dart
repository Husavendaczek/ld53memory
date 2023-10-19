import 'package:memoryfun/src/memory_types/models/memory_tile.dart';

class TextMemoryTile extends MemoryTile {
  final String text;

  TextMemoryTile({
    required this.text,
    required super.index,
    required super.angle,
    super.isVisible = false,
    super.hasError = false,
    super.isCorrect = false,
  });
}
