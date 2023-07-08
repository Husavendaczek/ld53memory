import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory/game_type.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:memoryfun/src/start/app_colors.dart';

import '../components/my_button.dart';
import '../helper/app_router.dart';

class LevelDone extends ConsumerWidget {
  final LevelInfo nextLevel;

  const LevelDone({
    required this.nextLevel,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      color: AppColors.textColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 32.0),
            child: const Text(
              'You did it!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate(
              onPlay: (controller) => controller.repeat(),
            )
                .shimmer(
              duration: 700.ms,
              colors: [
                Colors.yellow,
                Colors.orange,
                Colors.red,
                Colors.purple,
                Colors.blue,
                Colors.green,
                Colors.blue,
                Colors.purple,
                Colors.red,
              ],
            ),
          ),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () => ref
                    .read(appRouterProvider)
                    .push(const LevelOverviewRoute()),
                child: const NormalButtonStyle(
                    text: 'Level overview', fontSize: 16),
              ),
              TextButton(
                onPressed: () {
                  PageRouteInfo route;
                  switch (nextLevel.gameType) {
                    case GameType.sameImage:
                      route = SimpleMemoryRoute(levelInfo: nextLevel);
                      break;
                    case GameType.differentImage:
                      route = MemoryRoute(levelInfo: nextLevel);
                      break;
                    default:
                      route = SimpleMemoryRoute(levelInfo: nextLevel);
                  }
                  ref.read(appRouterProvider).push(
                        route,
                      );
                },
                child:
                    const NormalButtonStyle(text: 'Next Level', fontSize: 16),
              ),
            ],
          )
        ],
      ),
    );
  }
}
