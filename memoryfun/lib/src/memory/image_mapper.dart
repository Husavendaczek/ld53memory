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
        switch (pairValue) {
          case 0:
            return Assets.mail.mailBigLetter;
          case 1:
            return Assets.mail.mailBigPackage;
          case 2:
            return Assets.mail.mailLetter;
          case 3:
            return Assets.mail.mailPackage;
          default:
            return Assets.mail.mailLetter;
        }
      case ThemeSet.babies:
        switch (pairValue) {
          case 0:
            return Assets.babies.babiesOne;
          case 1:
            return Assets.babies.babiesTwo;
          case 2:
            return Assets.babies.babiesThree;
          case 3:
            return Assets.babies.babiesFour;
          case 4:
            return Assets.babies.babiesFive;
          case 5:
            return Assets.babies.babiesSix;
          case 6:
            return Assets.babies.babiesSeven;
          case 7:
            return Assets.babies.babiesEight;
          default:
            return Assets.babies.babiesEight;
        }
      default:
        return Assets.food.foodBurger;
    }
  }

  AssetGenImage _backgroundImage(ThemeSet themeSet) {
    switch (themeSet) {
      case ThemeSet.food:
        return Assets.food.background;
      case ThemeSet.mail:
        return Assets.mail.background;
      case ThemeSet.babies:
        return Assets.babies.background;
      default:
        return Assets.food.background;
    }
  }
}
