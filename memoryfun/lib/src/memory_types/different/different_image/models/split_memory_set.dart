import '../../../../memory/memory_tile.dart';

class SplitMemorySet {
  final List<MemoryTile> upperTiles;
  final List<MemoryTile> lowerTiles;

  SplitMemorySet({
    required this.upperTiles,
    required this.lowerTiles,
  });
}
