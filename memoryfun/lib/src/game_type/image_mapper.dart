import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../memory_types/models/memory_tile.dart';
import '../theme/app_color_mode.dart';
import 'theme_set.dart';

class ImageMapper {
  final AppColorMode appColorMode;

  const ImageMapper({required this.appColorMode});

  static final provider = Provider<ImageMapper>((ref) => ImageMapper(
          appColorMode: ref.watch(
        AppColorMode.provider,
      )));

  AssetImage getImage(MemoryTile memoryTile, ThemeSet themeSet) {
    return _map(memoryTile.isVisible, memoryTile.pairValue, false, themeSet);
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
      return AssetImage('${_colorPath(themeSet)}_l_$pairValue.png');
    }

    return AssetImage('${_colorPath(themeSet)}_$pairValue.png');
  }

  AssetImage _backgroundImage(ThemeSet themeSet, bool isLowerPart) {
    if (isLowerPart) {
      return AssetImage('${_colorPath(themeSet)}_l_background.png');
    }
    return AssetImage('${_colorPath(themeSet)}_background.png');
  }

  String _colorPath(ThemeSet themeSet) {
    return 'assets/${appColorMode.appColorStyle.name}/${themeSet.name}/${themeSet.name}';
  }
}
