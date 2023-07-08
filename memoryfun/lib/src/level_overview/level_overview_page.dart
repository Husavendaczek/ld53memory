import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/level_overview/levels.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:memoryfun/src/start/app_colors.dart';

import '../components/my_button.dart';

@RoutePage()
class LevelOverviewPage extends ConsumerStatefulWidget {
  const LevelOverviewPage({super.key});

  @override
  ConsumerState<LevelOverviewPage> createState() => _LevelOverviewPageState();
}

class _LevelOverviewPageState extends ConsumerState<LevelOverviewPage> {
  int value = 0;

  @override
  Widget build(BuildContext context) {
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
            TextButton(
              onPressed: () {
                ref.read(ColorMode.provider).switchColorStyle();
                setState(() {
                  value = 1;
                });
              },
              child:
                  const NormalButtonStyle(text: 'Switch style', fontSize: 16.0),
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
            image: AssetImage(
                'assets/${ref.watch(ColorMode.provider).colorStyle.name}/${themeSet.name}/${themeSet.name}_thumbnail.png')),
      ),
    ).animate().fadeIn(
          duration: 600.ms,
          curve: Curves.easeIn,
        );
  }
}
