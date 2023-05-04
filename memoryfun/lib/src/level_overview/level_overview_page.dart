import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/gen/assets.gen.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/level_overview/levels.dart';

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
              //TODO for apk use Column
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  onTap: () => ref.read(appRouterProvider).push(
                        SimpleMemoryRoute(
                          levelInfo: levels[0],
                        ),
                      ),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Assets.food.foodPizza.image(),
                  ),
                ).animate().fadeIn(
                      duration: 600.ms,
                      curve: Curves.easeIn,
                    ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    onTap: () => ref.read(appRouterProvider).push(
                          SimpleMemoryRoute(
                            levelInfo: levels[1],
                          ),
                        ),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Assets.mail.mailLetter.image(),
                    ),
                  ).animate().fadeIn(
                        duration: 600.ms,
                        curve: Curves.easeIn,
                      ),
                ),
                InkWell(
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                  onTap: () => ref.read(appRouterProvider).push(
                        MemoryRoute(
                          levelInfo: levels[2],
                        ),
                      ),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Assets.babies.babiesHouseTwo.image(),
                  ),
                ).animate().fadeIn(
                      duration: 600.ms,
                      curve: Curves.easeIn,
                    ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    onTap: () => ref.read(appRouterProvider).push(
                          SimpleMemoryRoute(
                            levelInfo: levels[3],
                          ),
                        ),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Assets.babies.babiesOne.image(),
                    ),
                  ).animate().fadeIn(
                        duration: 600.ms,
                        curve: Curves.easeIn,
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
