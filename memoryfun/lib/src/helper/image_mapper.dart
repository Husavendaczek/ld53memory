import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:memoryfun/src/same_image/simple_memory_tile.dart';

import '../memory/memory_tile.dart';
import '../start/env.dart';

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

  AssetImage hideComplexImage(ThemeSet themeSet, bool isLowerPart) {
    return _backgroundImage(themeSet, isLowerPart);
  }

  AssetImage _map(
      bool visible, int pairValue, bool isLowerPart, ThemeSet themeSet) {
    if (visible != true) {
      return _backgroundImage(themeSet, isLowerPart);
    }

    if (isLowerPart) {
      return AssetImage(
          'assets/$COLOR_MODE/${themeSet.name}/${themeSet.name}_l_$pairValue.png');
    }

    return AssetImage(
        'assets/$COLOR_MODE/${themeSet.name}/${themeSet.name}_$pairValue.png');
  }

  AssetImage _backgroundImage(ThemeSet themeSet, bool isLowerPart) {
    if (isLowerPart) {
      return AssetImage(
          'assets/$COLOR_MODE/${themeSet.name}/${themeSet.name}_l_background.png');
    }
    return AssetImage(
        'assets/$COLOR_MODE/${themeSet.name}/${themeSet.name}_background.png');
  }
}
