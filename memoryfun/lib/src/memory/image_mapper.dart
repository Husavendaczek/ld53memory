import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/gen/assets.gen.dart';
import 'package:memoryfun/src/memory/theme_set.dart';

class ImageMapper {
  static final provider = Provider<ImageMapper>((ref) => ImageMapper());

  AssetGenImage map(ThemeSet themeSet, int pairValue) {
    switch (themeSet) {
      case ThemeSet.food:
        return Assets.food.foodBurger;
      case ThemeSet.mail:
        return Assets.food.foodBurger;
      default:
        return Assets.food.foodBurger;
    }
  }
}
