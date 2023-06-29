import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/helper/app_router.dart';

import '../components/my_button.dart';
import 'env.dart';

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
            const Flexible(
              child: Padding(
                padding: EdgeInsets.only(bottom: 32.0),
                child: Image(
                  image: AssetImage('assets/$COLOR_MODE/other/icon.png'),
                ),
              ),
            ),
            TextButton(
              onPressed: () =>
                  ref.read(appRouterProvider).push(const LevelOverviewRoute()),
              child:
                  const NormalButtonStyle(text: 'Start game', fontSize: 18.0),
            ),
          ],
        ),
      ),
    );
  }
}
