import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/gen/assets.gen.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/memory/game_type.dart';
import 'package:memoryfun/src/memory/theme_set.dart';

import '../components/my_button.dart';
import '../memory/level_info.dart';

@RoutePage()
class StartPage extends ConsumerWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Assets.other.thumbnail.image(),
              ),
            ),
            TextButton(
              onPressed: () => ref.read(appRouterProvider).push(
                    SimpleMemoryRoute(
                      levelInfo: const LevelInfo(
                        gameSize: 12,
                        themeSet: ThemeSet.food,
                        gameType: GameType.sameImage,
                      ),
                    ),
                  ),
              child: const MyButton(text: 'Start game', fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
