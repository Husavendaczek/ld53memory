import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory_types/different/calculating_numbers/models/operation.dart';

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

  Operation randomOperation() =>
      randomOutOf(1) == 0 ? Operation.addition : Operation.subtraction;

  bool randomBool() => randomOutOf(1) == 0;

  int randomOutOf(int value) => Random().nextInt(value);

  int randomOutOfTen() => randomOutOf(10);

  int randomOutOfHundred() => randomOutOf(100);
}
