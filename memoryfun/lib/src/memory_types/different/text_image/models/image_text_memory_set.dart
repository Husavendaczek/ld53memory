import 'package:memoryfun/src/memory_types/models/text_memory_tile.dart';

import '../../../models/image_memory_tile.dart';

class ImageTextMemorySet {
  final List<ImageMemoryTile> upperTiles;
  final List<TextMemoryTile> lowerTiles;

  ImageTextMemorySet({
    required this.upperTiles,
    required this.lowerTiles,
  });
}
