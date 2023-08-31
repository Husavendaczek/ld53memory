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

  static ThemeData lightTheme(BuildContext context) => ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        appBarTheme: AppBarTheme(
          color: AppColors.background,
          iconTheme: IconThemeData(color: AppColors.text),
          titleTextStyle: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.background,
              displayColor: AppColors.text,
            ),
        focusColor: AppColors.error,
        cardColor: AppColors.selectedBtnBackground,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: null,
            foregroundColor: AppColors.text,
          ),
        ),
      );

  static ThemeData lightMonoTheme(BuildContext context) => ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundMono,
        appBarTheme: AppBarTheme(
          color: AppColors.backgroundMono,
          iconTheme: IconThemeData(color: AppColors.textMono),
          titleTextStyle: TextStyle(
            color: AppColors.textMono,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.backgroundMono,
              displayColor: AppColors.textMono,
            ),
        focusColor: AppColors.errorMono,
        cardColor: AppColors.selectedBtnBackgroundMono,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: null,
            foregroundColor: AppColors.textMono,
          ),
        ),
      );

  static ThemeData darkTheme(BuildContext context) => ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundDark,
        appBarTheme: AppBarTheme(
          color: AppColors.backgroundDark,
          iconTheme: IconThemeData(color: AppColors.textDark),
          titleTextStyle: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.backgroundDark,
              displayColor: AppColors.textDark,
            ),
        focusColor: AppColors.errorDark,
        cardColor: AppColors.selectedBtnBackgroundDark,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: null,
            foregroundColor: AppColors.textDark,
          ),
        ),
      );

  static ThemeData darkMonoTheme(BuildContext context) => ThemeData(
        scaffoldBackgroundColor: AppColors.backgroundDarkMono,
        appBarTheme: AppBarTheme(
          color: AppColors.backgroundDarkMono,
          iconTheme: IconThemeData(color: AppColors.textDarkMono),
          titleTextStyle: TextStyle(
            color: AppColors.textDarkMono,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: AppColors.backgroundDarkMono,
              displayColor: AppColors.textDarkMono,
            ),
        focusColor: AppColors.errorDarkMono,
        cardColor: AppColors.selectedBtnBackgroundDarkMono,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            backgroundColor: null,
            foregroundColor: AppColors.textDarkMono,
          ),
        ),
      );

  AppColorMode appColorMode;

  AppColors({required this.appColorMode});
}

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

enum AppColorStyle {
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
