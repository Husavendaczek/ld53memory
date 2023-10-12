import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../memory_types/models/image_memory_tile.dart';
import '../utils/theme/app_color_mode.dart';
import 'theme_set.dart';

class ImageMapper {
  final AppColorMode appColorMode;

  const ImageMapper({required this.appColorMode});

  static final provider = Provider<ImageMapper>(
    (ref) => ImageMapper(
      appColorMode: ref.watch(
        AppColorMode.provider,
      ),
    ),
  );

  AssetImage getImage(ImageMemoryTile memoryTile, ThemeSet themeSet) => _map(
        memoryTile.isVisible,
        memoryTile.pairValue,
        memoryTile.isLowerPart,
        themeSet,
      );

  List<AssetImage> animatedImages(ThemeSet themeSet, int value) {
    var themeSetName = themeSet.name;

    List<AssetImage> animatedImages = [];
    for (int j = 0; j < 7; j++) {
      animatedImages.add(
        AssetImage(
            'assets/${appColorMode.appColorStyle.name}/$themeSetName/${themeSetName}_${value}_anim_$j.png'),
      );
    }
    return animatedImages;
  }

  AssetImage hideComplexImage(ThemeSet themeSet, bool isLowerPart) =>
      _backgroundImage(themeSet, isLowerPart);

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
    var themeSetName = themeSet.name;
    return 'assets/${appColorMode.appColorStyle.name}/$themeSetName/$themeSetName';
  }
}
