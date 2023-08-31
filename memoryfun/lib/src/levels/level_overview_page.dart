import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../components/app_bar/overview_app_bar.dart';
import '../utils/app_router.dart';
import 'levels.dart';
import '../game_type/theme_set.dart';
import '../theme/app_color_mode.dart';

@RoutePage()
class LevelOverviewPage extends ConsumerStatefulWidget {
  final int value;
  const LevelOverviewPage({
    this.value = 0,
    super.key,
  });

  @override
  ConsumerState<LevelOverviewPage> createState() => _LevelOverviewPageState();
}

class _LevelOverviewPageState extends ConsumerState<LevelOverviewPage> {
  int myValue = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      myValue = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: const OverviewAppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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

  List<Widget> tiles(WidgetRef ref) {
    var themeTiles = <Widget>[];

    for (var themeSet in ThemeSet.values) {
      themeTiles.add(_thumbnail(ref, themeSet));
    }
    return themeTiles;
  }

  Widget _thumbnail(WidgetRef ref, ThemeSet themeSet) => InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: (themeSet == ThemeSet.babiesComplex ||
                themeSet == ThemeSet.farmComplex)
            ? () {
                ref.read(appRouterProvider).push(
                      DifferentImageMemoryRoute(
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
                      SameImageMemoryRoute(
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
                  'assets/${ref.watch(AppColorMode.provider).appColorStyle.name}/${themeSet.name}/${themeSet.name}_thumbnail.png')),
        ),
      ).animate().fadeIn(
            duration: 600.ms,
            curve: Curves.easeIn,
          );
}
