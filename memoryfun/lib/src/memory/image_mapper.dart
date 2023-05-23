import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/gen/assets.gen.dart';
import 'package:memoryfun/src/memory/memory_tile.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:memoryfun/src/same_image/simple_memory_tile.dart';

class ImageMapper {
  static final provider = Provider<ImageMapper>((ref) => ImageMapper());

  AssetGenImage mapSimple(SimpleMemoryTile memoryTile, ThemeSet themeSet) {
    return _map(memoryTile.visible, memoryTile.pairValue, false, themeSet);
  }

  AssetGenImage mapDifferentImage(MemoryTile memoryTile, ThemeSet themeSet) {
    return _map(memoryTile.visible, memoryTile.pairValue,
        memoryTile.isLowerPart, themeSet);
  }

  AssetGenImage _map(
      bool visible, int pairValue, bool isDeliveryPerson, ThemeSet themeSet) {
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
      case ThemeSet.babiesComplex:
        if (isDeliveryPerson) {
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
        } else {
          switch (pairValue) {
            case 0:
              return Assets.babies.babiesHouseOne;
            case 1:
              return Assets.babies.babiesHouseTwo;
            case 2:
              return Assets.babies.babiesHouseThree;
            case 3:
              return Assets.babies.babiesHouseFour;
            case 4:
              return Assets.babies.babiesHouseFive;
            case 5:
              return Assets.babies.babiesHouseSix;
            case 6:
              return Assets.babies.babiesHouseSeven;
            case 7:
              return Assets.babies.babiesHouseEight;
            default:
              return Assets.babies.babiesHouseEight;
          }
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
      case ThemeSet.babiesComplex:
        return Assets.babies.background;
      default:
        return Assets.food.background;
    }
  }
}
