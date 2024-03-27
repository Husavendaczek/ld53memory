import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/game_type/game_type.dart';
import '../components/app_bar/overview_app_bar.dart';
import '../utils/routing/app_router.dart';
import 'level_info.dart';
import 'levels.dart';
import '../game_type/theme_set.dart';
import '../utils/theme/app_color_mode.dart';

@RoutePage()
class LevelOverviewPage extends ConsumerStatefulWidget {
  final int value;
  final GameType gameType;
  const LevelOverviewPage({
    this.value = 0,
    this.gameType = GameType.noSelection,
    super.key,
  });

  @override
  ConsumerState<LevelOverviewPage> createState() => _LevelOverviewPageState();
}

class _LevelOverviewPageState extends ConsumerState<LevelOverviewPage> {
  int myValue = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      myValue = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OverviewAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
              padding: const EdgeInsets.all(8),
              children: tiles(ref),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> tiles(WidgetRef ref) {
    var themeTiles = <Widget>[];

    List<LevelInfo> selectedLevels = levels;
    if (widget.gameType == GameType.noSelection) {
      selectedLevels = levels
          .where((element) => element.gameType != GameType.noSelection)
          .toList();
    } else {
      selectedLevels = levels
          .where((element) =>
              element.gameType == widget.gameType &&
              element.gameType != GameType.noSelection)
          .toList();
    }

    for (var levelInfo in selectedLevels) {
      themeTiles.add(_thumbnail(ref, levelInfo));
    }

    if (themeTiles.isEmpty) {
      return [const Text('Für diese Kategorie gibt es noch keine Spiele.')];
    }
    return themeTiles;
  }

  Widget _thumbnail(WidgetRef ref, LevelInfo levelInfo) {
    var themeSet = levelInfo.themeSet;

    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: _selectLevel(levelInfo.gameType, themeSet),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image(
          image: AssetImage(
              'assets/${ref.watch(AppColorMode.provider).appColorStyle.name}/${themeSet.name}/${themeSet.name}_thumbnail.png'),
        ),
      ),
    ).animate().fadeIn(
          duration: 600.ms,
          curve: Curves.easeIn,
        );
  }

  Function()? _selectLevel(GameType gameType, ThemeSet themeSet) {
    Function()? onTap;
    switch (gameType) {
      case GameType.sameImage:
        onTap = () => ref.read(appRouterProvider).push(
              SameImageMemoryRoute(
                levelInfo: levels[themeSet.index],
              ),
            );
        break;
      case GameType.differentImage:
        onTap = () {
          ref.read(appRouterProvider).push(
                DifferentImageMemoryRoute(
                  levelInfo: levels[themeSet.index],
                ),
              );
        };
        break;
      case GameType.animatedImage:
        onTap = () => ref.read(appRouterProvider).push(
              AnimatedImageMemoryRoute(
                levelInfo: levels[themeSet.index],
              ),
            );
        break;
      case GameType.sameNumber:
        onTap = () => ref.read(appRouterProvider).push(
              SameNumberMemoryRoute(
                levelInfo: levels[themeSet.index],
              ),
            );
        break;
      case GameType.differentNumber:
        onTap = () => ref.read(appRouterProvider).push(
              CalculatingNumbersMemoryRoute(
                levelInfo: levels[themeSet.index],
              ),
            );
        break;
      case GameType.onlyColors:
        onTap = () => ref.read(appRouterProvider).push(
              SameColorMemoryRoute(
                levelInfo: levels[themeSet.index],
              ),
            );
        break;
      case GameType.sameText:
        onTap = () => ref.read(appRouterProvider).push(
              SameTextMemoryRoute(
                levelInfo: levels[themeSet.index],
              ),
            );
        break;
      case GameType.textAndImage:
        onTap = () => ref.read(appRouterProvider).push(
              TextImageMemoryRoute(
                levelInfo: levels[themeSet.index],
              ),
            );
        break;
      default:
        onTap = () => ref.read(appRouterProvider).push(
              SameImageMemoryRoute(
                levelInfo: levels[themeSet.index],
              ),
            );
    }
    return onTap;
  }
}
