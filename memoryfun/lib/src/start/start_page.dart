import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/memory/theme_set.dart';

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
            const Text('My awesome memory'),
            TextButton(
                onPressed: () => ref.read(appRouterProvider).push(
                      MemoryRoute(gameSize: 12, themeSet: ThemeSet.food),
                    ),
                child: const Text('Start game'))
          ],
        ),
      ),
    );
  }
}
