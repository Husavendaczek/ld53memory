import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/level_overview/levels.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:memoryfun/src/start/app_colors.dart';

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
            Padding(
              padding: const EdgeInsets.only(bottom: 28.0),
              child: Text(
                'Memory FUN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
              padding: const EdgeInsets.all(8),
              children: tiles(ref),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> tiles(WidgetRef ref) {
    var themeTiles = <Widget>[];

    for (var themeSet in ThemeSet.values) {
      themeTiles.add(_thumbnail(ref, themeSet));
    }
    return themeTiles;
  }

  Widget _thumbnail(WidgetRef ref, ThemeSet themeSet) {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      onTap: (themeSet == ThemeSet.babies || themeSet == ThemeSet.farmComplex)
          ? () {
              ref.read(appRouterProvider).push(
                    MemoryRoute(
                      levelInfo: levels[themeSet.index],
                    ),
                  );
            }
          : (themeSet == ThemeSet.club)
              ? () => ref.read(appRouterProvider).push(
                    AnimatedImageMemoryRoute(
                      levelInfo: levels[themeSet.index],
                    ),
                  )
              : () => ref.read(appRouterProvider).push(
                    SimpleMemoryRoute(
                      levelInfo: levels[themeSet.index],
                    ),
                  ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        clipBehavior: Clip.antiAlias,
        child: Image(
            image:
                AssetImage('${themeSet.name}/${themeSet.name}_thumbnail.png')),
      ),
    ).animate().fadeIn(
          duration: 600.ms,
          curve: Curves.easeIn,
        );
  }
}
