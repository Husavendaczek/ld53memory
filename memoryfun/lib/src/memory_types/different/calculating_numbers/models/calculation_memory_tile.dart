import 'package:memoryfun/src/memory_types/different/calculating_numbers/models/result_number.dart';
import 'package:memoryfun/src/memory_types/models/memory_tile.dart';

class CalculationMemoryTile extends MemoryTile {
  final int firstNumber;
  final int secondNumber;
  final ResultNumber resultNumber;
  final bool showsText;

  CalculationMemoryTile({
    required this.firstNumber,
    required this.secondNumber,
    required this.resultNumber,
    required super.index,
    required super.angle,
    super.isVisible = false,
    super.hasError = false,
    super.isCorrect = false,
    this.showsText = false,
  });
}
