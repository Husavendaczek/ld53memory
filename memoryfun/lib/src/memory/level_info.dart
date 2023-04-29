import 'package:memoryfun/src/memory/theme_set.dart';

class LevelInfo {
  final int gameSize;
  final ThemeSet themeSet;
  final int matches;

  const LevelInfo({
    required this.gameSize,
    required this.themeSet,
    this.matches = 0,
  });

  int getMatches() => gameSize ~/ 2;
}
