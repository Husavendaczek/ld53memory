import '../game_type/game_type.dart';
import 'level_info.dart';
import '../game_type/theme_set.dart';

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
    gameSize: 24,
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
    gameSize: 24,
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
    gameType: GameType.animatedImage,
  ),
  LevelInfo(
    gameSize: 28,
    themeSet: ThemeSet.numbers,
    gameType: GameType.sameNumber,
  ),
  LevelInfo(
    gameSize: 28,
    themeSet: ThemeSet.differentNumbers,
    gameType: GameType.differentNumber,
  ),
  LevelInfo(
    gameSize: 20,
    themeSet: ThemeSet.onlyColors,
    gameType: GameType.onlyColors,
  ),
  LevelInfo(
    gameSize: 18,
    themeSet: ThemeSet.christmas,
    gameType: GameType.sameImage,
  ),
  LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.emotions,
    gameType: GameType.sameImage,
  ),
  LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.emotions,
    gameType: GameType.textAndImage,
  ),
];
