class MemoryTile {
  final int index;
  double angle;
  bool isVisible;
  bool hasError;
  bool isCorrect;

  MemoryTile({
    required this.index,
    required this.angle,
    this.isVisible = false,
    this.hasError = false,
    this.isCorrect = false,
  });
}
