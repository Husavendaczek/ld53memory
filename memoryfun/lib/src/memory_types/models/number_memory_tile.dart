import 'package:memoryfun/src/memory_types/models/memory_tile.dart';

class NumberMemoryTile extends MemoryTile {
  final int number;

  NumberMemoryTile({
    required this.number,
    required super.index,
    required super.angle,
    super.isVisible = false,
    super.hasError = false,
    super.isCorrect = false,
  });
}
