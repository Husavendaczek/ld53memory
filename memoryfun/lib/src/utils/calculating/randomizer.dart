import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory_types/different/calculating_numbers/models/operation.dart';
import 'package:memoryfun/src/memory_types/same/colors/models/card_color.dart';

class Randomizer {
  static final provider = Provider<Randomizer>((ref) {
    return Randomizer();
  });

  double randomTileAngle() {
    var randomAngle = Random().nextDouble() * 1.1;
    var randomSign = Random().nextBool();

    if (randomSign) {
      randomAngle = randomAngle * -1;
    }

    return randomAngle;
  }

  List<CardColor> randomColor(int colorAmount) {
    final List<CardColor> cardColors = [];

    for (int i = 0; i < colorAmount; i++) {
      var hue = randomOutOf(360).toDouble();
      var saturation = 0.5;
      var lightness = 0.5;

      var isUniqueHue = true;

      for (var cardColor in cardColors) {
        var distance = (cardColor.hue - hue).abs();
        if (distance <= 25 || distance >= 335) {
          i--;
          isUniqueHue = false;
          break;
        }
        if (distance <= 35 || distance >= 325) {
          lightness = Random().nextDouble();
          break;
        }
      }

      if (isUniqueHue) {
        var colorToAdd = CardColor(
          color: HSLColor.fromAHSL(
            1,
            hue,
            saturation,
            lightness,
          ).toColor(),
          hue: hue,
        );

        cardColors.add(colorToAdd);
        cardColors.add(colorToAdd);
      }
    }
    return cardColors;
  }

  Operation randomOperation() =>
      randomOutOf(2) == 0 ? Operation.addition : Operation.subtraction;

  int randomOutOf(int value) => Random().nextInt(value);

  int randomOutOfTen() => randomOutOf(10);

  int randomOutOfHundred() => randomOutOf(100);
}
