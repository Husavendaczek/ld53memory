import 'package:riverpod/riverpod.dart';

import '../game_type/theme_set.dart';
import '../sound/sounds.dart';
import '../utils/routing/app_router.dart';
import 'levels.dart';

class LevelFinisher {
  final AppRouter appRouter;
  final Sounds soundPlayer;

  static final provider = Provider<LevelFinisher>((ref) {
    return LevelFinisher(
      appRouter: ref.watch(appRouterProvider),
      soundPlayer: ref.watch(Sounds.provider),
    );
  });

  LevelFinisher({
    required this.appRouter,
    required this.soundPlayer,
  });

  bool goToNextLevelOrFinish(ThemeSet themeSet, int matchesLeft) {
    // other tiles are left
    if (matchesLeft != 0) {
      soundPlayer.playCorrectMatch();
      return false;
    }

    var level = levels.indexWhere((lvl) => lvl.themeSet == themeSet);

    // finish whole game
    if (level == levels.length - 1) {
      soundPlayer.playWinGame();

      Future.delayed(
        const Duration(seconds: 1),
        () => appRouter.push(const WonRoute()),
      );
      return true;
    }
    // finish level
    else {
      soundPlayer.playWinLevel();

      Future.delayed(
        const Duration(seconds: 1),
        () => appRouter.push(LevelDoneRoute(nextLevel: levels[level + 1])),
      );
      return true;
    }
  }
}
