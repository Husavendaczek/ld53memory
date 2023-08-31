import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/game_type/game_type.dart';
import 'package:memoryfun/src/theme/app_colors.dart';

import '../components/normal_button.dart';
import '../utils/app_router.dart';
import '../levels/level_info.dart';
import '../game_type/theme_set.dart';

@RoutePage()
class WonPage extends ConsumerWidget {
  const WonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'CONGRATULATIONS!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            )
                .animate(
                  onPlay: (controller) => controller.repeat(),
                )
                .custom(
                  duration: 300.ms,
                  builder: (context, value, child) => Container(
                    color: Color.lerp(Colors.yellow, Colors.orange, value),
                    padding: const EdgeInsets.all(8),
                    child: child,
                  ),
                )
                .custom(
                  duration: 300.ms,
                  builder: (context, value, child) => Container(
                    color: Color.lerp(Colors.orange, Colors.red, value),
                    padding: const EdgeInsets.all(8),
                    child: child,
                  ),
                )
                .custom(
                  duration: 300.ms,
                  builder: (context, value, child) => Container(
                    color: Color.lerp(Colors.red, Colors.purple, value),
                    padding: const EdgeInsets.all(8),
                    child: child,
                  ),
                )
                .custom(
                  duration: 300.ms,
                  builder: (context, value, child) => Container(
                    color: Color.lerp(Colors.purple, Colors.blue, value),
                    padding: const EdgeInsets.all(8),
                    child: child,
                  ),
                )
                .custom(
                  duration: 300.ms,
                  builder: (context, value, child) => Container(
                    color: Color.lerp(Colors.blue, Colors.green, value),
                    padding: const EdgeInsets.all(8),
                    child: child,
                  ),
                )
                .custom(
                  duration: 300.ms,
                  builder: (context, value, child) => Container(
                    color: Color.lerp(Colors.green, Colors.yellow, value),
                    padding: const EdgeInsets.all(8),
                    child: child,
                  ),
                ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: const Text(
                'You have won!',
                style: TextStyle(fontSize: 20),
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(),
                  )
                  .custom(
                    duration: 300.ms,
                    builder: (context, value, child) => _myText(
                      const Color.fromARGB(255, 255, 223, 234),
                      Colors.purple,
                      value,
                    ),
                  ),
            ),
            Text(
              'Thanks for playing my game.',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: NormalButton(
                text: 'Play again',
                onTap: () => ref.read(appRouterProvider).push(
                      SimpleMemoryRoute(
                        levelInfo: const LevelInfo(
                            gameSize: 12,
                            themeSet: ThemeSet.food,
                            gameType: GameType.sameImage),
                      ),
                    ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Text _myText(Color a, Color b, double value) => Text(
        'You have won!',
        style: TextStyle(fontSize: 20, color: Color.lerp(a, b, value)),
      );
}
