import '../../../models/image_memory_tile.dart';

class SplitMemorySet {
  final List<ImageMemoryTile> upperTiles;
  final List<ImageMemoryTile> lowerTiles;

  SplitMemorySet({
    required this.upperTiles,
    required this.lowerTiles,
  });
}
