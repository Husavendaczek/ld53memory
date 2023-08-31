import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/start/app_colors.dart';

class AppColorMode {
  ThemeMode myThemeMode;
  AppColorStyle appColorStyle;

  AppColorMode({
    this.myThemeMode = ThemeMode.system,
    this.appColorStyle = AppColorStyle.color,
  });

  static final provider = Provider<AppColorMode>((ref) {
    return AppColorMode();
  });

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

  ThemeData lightTheme(BuildContext context) {
    return appColorStyle == AppColorStyle.color
        ? AppColors.lightTheme(context)
        : AppColors.lightMonoTheme(context);
  }

  ThemeData darkTheme(BuildContext context) {
    return appColorStyle == AppColorStyle.color
        ? AppColors.darkTheme(context)
        : AppColors.darkMonoTheme(context);
  }
}
