import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/game_type/theme_set.dart';

class LevelTexts {
  static final provider = Provider<LevelTexts>((ref) {
    return LevelTexts();
  });

  static Locale currentLocale = const Locale('de');

  Map<ThemeSet, List<String>> deLevelTexts = {
    ThemeSet.texts: [
      'Urlaub',
      'Berge',
      'Sonne',
      'Spaß',
      'Wetter',
      'Strand',
      'Erde',
      'Sommer',
    ],
    ThemeSet.emotionsText: [
      'Wut',
      'Freude',
      'Trauer',
      'Angst',
      'Überraschung',
      'Ekel',
    ],
    ThemeSet.farmAnimalsText: [
      'Hahn',
      'Kuh',
      'Huhn',
      'Schaf',
      'Schwein',
      'Truthahn',
      'Katze',
      'Hund',
      'Esel',
      'Ziege',
      'Ente',
      'Hase',
    ],
  };

  Map<ThemeSet, List<String>> enLevelTexts = {
    ThemeSet.texts: [
      'holidays',
      'mountains',
      'sun',
      'fun',
      'weather',
      'beach',
      'earth',
      'summer',
    ],
    ThemeSet.emotionsText: [
      'Anger',
      'Happiness',
      'Sadness',
      'Fear',
      'Surprise',
      'Disgust',
    ],
    ThemeSet.farmAnimalsText: [
      'rooster',
      'cow',
      'chicken',
      'sheep',
      'pig',
      'turkey',
      'cat',
      'dog',
      'donkey',
      'goat',
      'duck',
      'rabbit',
    ],
  };

  void initLocale(Locale locale) {
    currentLocale = locale;
  }

  List<String> textOfTheme(ThemeSet themeSet) {
    if (currentLocale.toString().startsWith('de')) {
      return deLevelTexts[themeSet] ?? [];
    }
    return enLevelTexts[themeSet] ?? [];
  }
}
