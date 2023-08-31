import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/theme/app_colors.dart';

import 'app_color_style.dart';

class AppColorMode {
  ThemeMode myThemeMode;
  AppColorStyle appColorStyle;

  AppColorMode({
    this.myThemeMode = ThemeMode.system,
    this.appColorStyle = AppColorStyle.color,
  });

  static final provider = Provider<AppColorMode>((ref) => AppColorMode());

  void setThemeMode(ThemeMode themeMode) {
    myThemeMode = themeMode;
  }

  void switchColorStyle() {
    if (appColorStyle == AppColorStyle.color) {
      appColorStyle = AppColorStyle.mono;
    } else {
      appColorStyle = AppColorStyle.color;
    }
  }

  void setColorStyle(bool highContrast) {
    appColorStyle = highContrast ? AppColorStyle.mono : AppColorStyle.color;
  }

  ThemeData lightTheme(BuildContext context) =>
      appColorStyle == AppColorStyle.color
          ? AppColors.lightTheme(context)
          : AppColors.lightMonoTheme(context);

  ThemeData darkTheme(BuildContext context) =>
      appColorStyle == AppColorStyle.color
          ? AppColors.darkTheme(context)
          : AppColors.darkMonoTheme(context);
}
