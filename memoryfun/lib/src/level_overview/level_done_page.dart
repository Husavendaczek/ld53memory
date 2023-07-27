import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory/level_info.dart';

import '../components/memo_app_bar.dart';
import '../components/normal_button.dart';
import '../helper/app_router.dart';

@RoutePage()
class LevelDonePage extends ConsumerWidget {
  final LevelInfo nextLevel;

  const LevelDonePage({
    required this.nextLevel,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: const MemoAppBar(onRestart: null),
      body: Column(
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
                    .navigate(LevelOverviewRoute(value: 10)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
