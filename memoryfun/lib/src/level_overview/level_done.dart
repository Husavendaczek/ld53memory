import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory/game_type.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:memoryfun/src/start/app_colors.dart';

import '../components/normal_button.dart';
import '../helper/app_router.dart';

class LevelDone extends ConsumerWidget {
  final LevelInfo nextLevel;

  const LevelDone({
    required this.nextLevel,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
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
            NormalButton(
              text: 'Level overview',
              onTap: () => ref
                  .read(appRouterProvider)
                  .push(LevelOverviewRoute(value: 0)),
            ),
          ],
        )
      ],
    );
  }
}
