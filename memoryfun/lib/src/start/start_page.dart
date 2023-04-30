import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/memory/theme_set.dart';

import '../components/my_button.dart';

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
            const Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text(
                'My awesome memory',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton(
              onPressed: () => ref.read(appRouterProvider).push(
                    MemoryRoute(gameSize: 12, themeSet: ThemeSet.food),
                  ),
              child: const MyButton(text: 'Start game', fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
