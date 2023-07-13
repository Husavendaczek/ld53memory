import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppColors {
  static Color text = Colors.black;
  static Color textMono = text;
  static Color textDark = Colors.white;
  static Color textDarkMono = textDark;

  static Color background = Colors.white;
  static Color backgroundMono = background;
  static Color backgroundDark = const Color.fromARGB(255, 41, 41, 41);
  static Color backgroundDarkMono = Colors.black;

  static Color btnText = Colors.white;
  static Color btnTextMono = Colors.white;
  static Color btnTextDark = Colors.black;
  static Color btnTextDarkMono = Colors.black;

  static Color btnBackground = Colors.amber;
  static Color btnBackgroundMono = Colors.black;
  static Color btnBackgroundDark = const Color.fromARGB(255, 187, 145, 20);
  static Color btnBackgroundDarkMono = Colors.white;

  static Color selectedBtnBackground = const Color.fromARGB(255, 178, 135, 5);
  static Color selectedBtnBackgroundMono =
      const Color.fromARGB(255, 102, 102, 102);
  static Color selectedBtnBackgroundDark =
      const Color.fromARGB(255, 124, 97, 14);
  static Color selectedBtnBackgroundDarkMono =
      const Color.fromARGB(255, 189, 189, 189);

  static Color error = Colors.red;
  static Color errorMono = Colors.black;
  static Color errorDark = const Color.fromARGB(255, 255, 168, 161);
  static Color errorDarkMono = Colors.white;

  ColorMode colorMode;

  AppColors({required this.colorMode});
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

  MemoryGridRowSize({this.rowSize = 4});

  static final provider = Provider<MemoryGridRowSize>((ref) {
    return MemoryGridRowSize();
  });

  void setRowSize(int size) {
    rowSize = size;
  }
}
