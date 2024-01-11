import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/app_bar/overview_app_bar.dart';
import 'package:memoryfun/src/game_type/game_type.dart';
import 'package:memoryfun/src/utils/routing/app_router.dart';

import '../levels/level_info.dart';
import '../levels/levels.dart';
import '../utils/theme/app_color_mode.dart';

@RoutePage()
class GameTypeOverviewPage extends ConsumerWidget {
  const GameTypeOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        appBar: const OverviewAppBar(),
        body: Center(
          child: GridView.count(
            shrinkWrap: true,
            crossAxisCount: 3,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1,
            padding: const EdgeInsets.all(8),
            children: tiles(ref),
          ),
        ),
      );

  List<Widget> tiles(WidgetRef ref) {
    var themeTiles = <Widget>[];

    var gameTypes =
        GameType.values.where((element) => element != GameType.noSelection);

    for (var gameType in gameTypes) {
      themeTiles.add(_thumbnail(ref, gameType));
    }
    return themeTiles;
  }

  Widget _thumbnail(WidgetRef ref, GameType gameType) => InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: () => ref.read(appRouterProvider).push(
              LevelOverviewRoute(value: 0, gameType: gameType),
            ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Image(
            image: AssetImage(
                'assets/${ref.watch(AppColorMode.provider).appColorStyle.name}/gameTypeThumbnails/${gameType.name}.png'),
          ),
        ),
      ).animate().fadeIn(
            duration: 600.ms,
            curve: Curves.easeIn,
          );
}
