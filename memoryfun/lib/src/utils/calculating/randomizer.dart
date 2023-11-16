import 'dart:math';

import 'package:flutter/material.dart';
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

  Color randomColor() {
    var thecolors = [
      Colors.red,
      Colors.amber,
      Colors.black,
      Colors.blue,
      Colors.green,
      Colors.grey,
      Colors.orange,
      Colors.pink,
      Colors.yellow,
      Colors.purple,
      Colors.lightBlue,
      Colors.deepOrangeAccent,
      Colors.lime,
      Colors.teal,
      Colors.cyanAccent,
      Colors.brown,
      Colors.indigo,
      Colors.redAccent,
    ];

    var index = randomOutOf(thecolors.length - 1);
    return thecolors[index];
  } //TODO

  Operation randomOperation() =>
      randomOutOf(2) == 0 ? Operation.addition : Operation.subtraction;

  int randomOutOf(int value) => Random().nextInt(value);

  int randomOutOfTen() => randomOutOf(10);

  int randomOutOfHundred() => randomOutOf(100);
}
