import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/gen/assets.gen.dart';
import 'package:memoryfun/src/helper/app_router.dart';

import '../memory/theme_set.dart';

@RoutePage()
class LevelOverviewPage extends ConsumerWidget {
  const LevelOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 28.0),
              child: Text(
                'What do you want to deliver?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  hoverColor: Colors.red,
                  onTap: () => ref.read(appRouterProvider).push(
                        MemoryRoute(gameSize: 12, themeSet: ThemeSet.food),
                      ),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Assets.food.foodPizza.image(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    onTap: () => ref.read(appRouterProvider).push(
                          MemoryRoute(gameSize: 8, themeSet: ThemeSet.mail),
                        ),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Assets.mail.mailLetter.image(),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  onTap: () => ref.read(appRouterProvider).push(
                        MemoryRoute(gameSize: 16, themeSet: ThemeSet.babies),
                      ),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Assets.babies.babiesOne.image(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}