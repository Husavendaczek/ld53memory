import 'package:flutter/material.dart';
import 'package:memoryfun/src/start/app_colors.dart';

abstract class AppTheme {
  AppTheme._();

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
}
