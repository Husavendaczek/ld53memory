import 'package:flutter/material.dart';
import 'package:memoryfun/src/start/env.dart';

class AppColors {
  static Color textColor = Colors.black;
  static Color buttonTextColor =
      COLOR_MODE == 'color' ? Colors.blueAccent : Colors.white;
  static Color buttonBackgroundColor =
      COLOR_MODE == 'color' ? Colors.amber : Colors.black;
  static Color errorColor = COLOR_MODE == 'color' ? Colors.red : Colors.black;
}
