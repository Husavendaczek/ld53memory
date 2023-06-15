import 'package:memoryfun/src/memory/game_type.dart';

import '../memory/level_info.dart';
import '../memory/theme_set.dart';

List<LevelInfo> levels = const [
  LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.food,
    gameType: GameType.sameImage,
  ),
  LevelInfo(
    gameSize: 8,
    themeSet: ThemeSet.mail,
    gameType: GameType.sameImage,
  ),
  LevelInfo(
    gameSize: 16,
    themeSet: ThemeSet.babiesComplex,
    gameType: GameType.differentImage,
  ),
  LevelInfo(
    gameSize: 16,
    themeSet: ThemeSet.babies,
    gameType: GameType.sameImage,
  ),
  LevelInfo(
    gameSize: 14,
    themeSet: ThemeSet.jungle,
    gameType: GameType.sameImage,
  ),
];
