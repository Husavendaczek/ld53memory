import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppColors {
  static Color textColor = Colors.black;
  static Color buttonTextColor = Colors.white;

  ColorMode colorMode;

  AppColors({required this.colorMode});

  static final provider = Provider<AppColors>(
    (ref) => AppColors(colorMode: ref.watch(ColorMode.provider)),
  );

  Color get buttonBackgroundColor =>
      colorMode.colorStyle == ColorStyle.color ? Colors.amber : Colors.black;
  Color get selectedButtonBackgroundColor =>
      colorMode.colorStyle == ColorStyle.color
          ? const Color.fromARGB(255, 178, 135, 5)
          : const Color.fromARGB(255, 102, 102, 102);
  Color get errorColor =>
      colorMode.colorStyle == ColorStyle.color ? Colors.red : Colors.black;
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
