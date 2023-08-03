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
    gameSize: 18,
    themeSet: ThemeSet.babiesComplex,
    gameType: GameType.differentImage,
  ),
  LevelInfo(
    gameSize: 28,
    themeSet: ThemeSet.babies,
    gameType: GameType.sameImage,
  ),
  LevelInfo(
    gameSize: 16,
    themeSet: ThemeSet.jungle,
    gameType: GameType.sameImage,
  ),
  LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.farm,
    gameType: GameType.sameImage,
  ),
  LevelInfo(
    gameSize: 10,
    themeSet: ThemeSet.farmMud,
    gameType: GameType.sameImage,
  ),
  LevelInfo(
    gameSize: 8,
    themeSet: ThemeSet.farmComplex,
    gameType: GameType.differentImage,
  ),
  LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.club,
    gameType: GameType.sameImage,
  ),
];
