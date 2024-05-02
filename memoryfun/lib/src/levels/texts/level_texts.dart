import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../game_type/theme_set.dart';

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
    ThemeSet.mealsText: [
      'Sushi',
      'Müsli',
      'Brot',
      'Hähnchen',
      'Pizza',
      'Suppe',
      'Spaghetti',
      'Teigtaschen',
      'Burger',
      'Poké Bowl',
      'Salat',
      'Kuchen',
    ],
    ThemeSet.wildAnimalsText: [
      'Löwe',
      'Giraffe',
      'Elefant',
      'Zebra',
      'Affe',
      'Tiger',
      'Panda',
      'Papagei',
      'Nilpferd',
      'Eisbär',
      'Gepard',
      'Krokodil',
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
    ThemeSet.mealsText: [
      'sushi',
      'cereals',
      'bread',
      'chicken',
      'pizza',
      'soup',
      'spaghetti',
      'dumplings',
      'burger',
      'poké bowl',
      'salad',
      'pie',
    ],
    ThemeSet.wildAnimalsText: [
      'lion',
      'giraffe',
      'elephant',
      'zebra',
      'monkey',
      'tiger',
      'panda',
      'parrot',
      'hippo',
      'polar bear',
      'cheetah',
      'crocodile',
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
