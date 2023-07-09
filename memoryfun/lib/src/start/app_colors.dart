import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/start/env.dart';

class AppColors {
  static Color textColor = Colors.black;
  static Color buttonTextColor =
      COLOR_MODE == 'color' ? Colors.blueAccent : Colors.white;
  static Color buttonBackgroundColor =
      COLOR_MODE == 'color' ? Colors.amber : Colors.black;
  static Color errorColor = COLOR_MODE == 'color' ? Colors.red : Colors.black;
}

class ColorMode {
  ColorStyle colorStyle;

  ColorMode({this.colorStyle = ColorStyle.color});

  static final provider = Provider<ColorMode>((ref) {
    return ColorMode();
  });

  void switchColorStyle() {
    if (colorStyle == ColorStyle.color) {
      colorStyle = ColorStyle.mono;
    } else {
      colorStyle = ColorStyle.color;
    }
  }
}

enum ColorStyle {
  color,
  mono,
}

class MemoryGridRowSize {
  int rowSize;

  MemoryGridRowSize({this.rowSize = 3});

  static final provider = Provider<MemoryGridRowSize>((ref) {
    return MemoryGridRowSize();
  });

  void setRowSize(int size) {
    rowSize = size;
  }
}
