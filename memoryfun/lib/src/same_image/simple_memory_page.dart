import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/my_button.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:memoryfun/src/memory/theme_set.dart';

import 'simple_memory_bloc.dart';
import 'simple_memory_tile.dart';

@RoutePage()
class SimpleMemoryPage extends ConsumerStatefulWidget {
  final int gameSize;
  final ThemeSet themeSet;

  const SimpleMemoryPage({
    required this.gameSize,
    required this.themeSet,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SimpleMemoryPageState();
}

class _SimpleMemoryPageState extends ConsumerState<SimpleMemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(SimpleMemoryBloc.provider.bloc).add(
          SimpleMemoryEvent.initGame(
            LevelInfo(
              gameSize: widget.gameSize,
              themeSet: widget.themeSet,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(SimpleMemoryBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet, true),
            matchResult: (memorySet) => _gridView(memorySet, false),
            nextLevel: (nextLevel) => Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32.0),
                    child: const Text(
                      'You delivered everything!',
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
                      TextButton(
                        onPressed: () => ref
                            .read(appRouterProvider)
                            .push(const LevelOverviewRoute()),
                        child: const MyButton(
                            text: 'Level overview', fontSize: 16),
                      ),
                      TextButton(
                        onPressed: () => ref.read(appRouterProvider).push(
                              MemoryRoute(
                                gameSize: nextLevel.gameSize,
                                themeSet: nextLevel.themeSet,
                              ),
                            ),
                        child: const MyButton(text: 'Next Level', fontSize: 16),
                      ),
                    ],
                  )
                ],
              ),
            ),
            orElse: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('loading'),
                TextButton(
                  onPressed: () => ref.read(SimpleMemoryBloc.provider.bloc).add(
                        SimpleMemoryEvent.initGame(
                          LevelInfo(
                            gameSize: widget.gameSize,
                            themeSet: widget.themeSet,
                          ),
                        ),
                      ),
                  child: const MyButton(text: 'Restart game', fontSize: 18.0),
                ),
              ],
            ),
          ),
    );
  }

  Widget _gridView(List<SimpleMemoryTile> memorySet, bool fadeIn) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 32.0),
              child: Text(
                'Memory fun',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Flexible(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 1600),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 6, //TODO for apk set to 3
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 1,
                  padding: const EdgeInsets.all(8),
                  children: _tiles(memorySet, fadeIn),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => ref
                        .read(appRouterProvider)
                        .push(const LevelOverviewRoute()),
                    child:
                        const MyButton(text: 'Level overview', fontSize: 18.0),
                  ),
                  TextButton(
                    onPressed: () =>
                        ref.read(SimpleMemoryBloc.provider.bloc).add(
                              SimpleMemoryEvent.initGame(
                                LevelInfo(
                                  gameSize: widget.gameSize,
                                  themeSet: widget.themeSet,
                                ),
                              ),
                            ),
                    child: const MyButton(text: 'Restart game', fontSize: 18.0),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  List<Widget> _tiles(List<SimpleMemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      var initTile = Container(
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: tile.image!.image(fit: BoxFit.cover),
        ),
      ).animate();

      if (tile.hasError) {
        initTile = Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.red,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: tile.image!.image(fit: BoxFit.cover),
          ),
        ).animate().shake();
      }

      tiles.add(
        InkWell(
          onTap: () => tile.visible
              ? {}
              : ref.read(SimpleMemoryBloc.provider.bloc).add(
                    SimpleMemoryEvent.handleTap(tile.index, tile.pairValue),
                  ),
          child: initTile,
        )
            .animate()
            .fadeIn(
              duration: 600.ms,
              curve: Curves.easeIn,
            )
            .blurXY(begin: 1, end: 0, duration: 600.ms, delay: 300.ms),
      );
    }

    return tiles;
  }
}
