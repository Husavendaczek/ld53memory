import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/gen/assets.gen.dart';
import 'package:memoryfun/src/memory/theme_set.dart';

class ImageMapper {
  static final provider = Provider<ImageMapper>((ref) => ImageMapper());

  AssetGenImage map(ThemeSet themeSet, int pairValue, bool visible) {
    if (visible != true) {
      return _backgroundImage(themeSet);
    }
    switch (themeSet) {
      case ThemeSet.food:
        switch (pairValue) {
          case 0:
            return Assets.food.foodBowl;
          case 1:
            return Assets.food.foodBurger;
          case 2:
            return Assets.food.foodNoodles;
          case 3:
            return Assets.food.foodPizza;
          case 4:
            return Assets.food.foodPommes;
          case 5:
            return Assets.food.foodSandwich;
          default:
            return Assets.food.foodBurger;
        }
      case ThemeSet.mail:
        return Assets.food.foodBurger;
      default:
        return Assets.food.foodBurger;
    }
  }

  AssetGenImage _backgroundImage(ThemeSet themeSet) {
    switch (themeSet) {
      case ThemeSet.food:
        return Assets.food.background;
      case ThemeSet.mail:
        return Assets.food.background;
      default:
        return Assets.food.background;
    }
  }
}
