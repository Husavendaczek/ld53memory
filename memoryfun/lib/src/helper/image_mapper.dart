import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:memoryfun/src/same_image/simple_memory_tile.dart';

import '../memory/memory_tile.dart';

class ImageMapper {
  static final provider = Provider<ImageMapper>((ref) => ImageMapper());

  AssetImage getImage(SimpleMemoryTile simpleMemoryTile, ThemeSet themeSet) {
    return _map(
        simpleMemoryTile.visible, simpleMemoryTile.pairValue, false, themeSet);
  }

  AssetImage getComplexImage(MemoryTile memoryTile, ThemeSet themeSet) {
    return _map(memoryTile.visible, memoryTile.pairValue,
        memoryTile.isLowerPart, themeSet);
  }

  AssetImage hideComplexImage(ThemeSet themeSet) {
    return _backgroundImage(themeSet);
  }

  AssetImage _map(
      bool visible, int pairValue, bool isLowerPart, ThemeSet themeSet) {
    if (visible != true) {
      return _backgroundImage(themeSet);
    }

    if (isLowerPart) {
      return AssetImage('${themeSet.name}/${themeSet.name}_l_$pairValue.png');
    }

    return AssetImage('${themeSet.name}/${themeSet.name}_$pairValue.png');
  }

  AssetImage _backgroundImage(ThemeSet themeSet) {
    return AssetImage('${themeSet.name}/${themeSet.name}_background.png');
  }
}
