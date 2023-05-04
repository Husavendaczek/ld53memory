import 'package:memoryfun/src/memory/game_type.dart';
import 'package:memoryfun/src/memory/theme_set.dart';

class LevelInfo {
  final int gameSize;
  final ThemeSet themeSet;
  final GameType gameType;
  final int matches;

  const LevelInfo({
    required this.gameSize,
    required this.themeSet,
    required this.gameType,
    this.matches = 0,
  });

  int getMatches() => gameSize ~/ 2;
}
