import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/game_type/theme_set.dart';
import 'package:memoryfun/src/same_image/simple_memory_tile.dart';
import 'package:memoryfun/src/theme/app_color_mode.dart';

import '../memory/memory_tile.dart';

class ImageMapper {
  final AppColorMode appColorMode;

  const ImageMapper({required this.appColorMode});

  static final provider = Provider<ImageMapper>((ref) => ImageMapper(
          appColorMode: ref.watch(
        AppColorMode.provider,
      )));

  AssetImage getImage(SimpleMemoryTile simpleMemoryTile, ThemeSet themeSet) {
    return _map(simpleMemoryTile.isVisible, simpleMemoryTile.pairValue, false,
        themeSet);
  }

  AssetImage getComplexImage(MemoryTile memoryTile, ThemeSet themeSet) {
    return _map(memoryTile.isVisible, memoryTile.pairValue,
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
          'assets/${appColorMode.appColorStyle.name}/${themeSet.name}/${themeSet.name}_l_$pairValue.png');
    }

    return AssetImage(
        'assets/${appColorMode.appColorStyle.name}/${themeSet.name}/${themeSet.name}_$pairValue.png');
  }

  AssetImage _backgroundImage(ThemeSet themeSet, bool isLowerPart) {
    if (isLowerPart) {
      return AssetImage(
          'assets/${appColorMode.appColorStyle.name}/${themeSet.name}/${themeSet.name}_l_background.png');
    }
    return AssetImage(
        'assets/${appColorMode.appColorStyle.name}/${themeSet.name}/${themeSet.name}_background.png');
  }

  //TODO function for assetname
}
