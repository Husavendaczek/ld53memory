import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/my_button.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/memory/image_mapper.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:memoryfun/src/memory/memory_bloc.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:riverbloc/riverbloc.dart';

import 'memory_tile.dart';

@RoutePage()
class MemoryPage extends ConsumerStatefulWidget {
  final int gameSize;
  final ThemeSet themeSet;

  const MemoryPage({
    required this.gameSize,
    required this.themeSet,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MemoryPageState();
}

class _MemoryPageState extends ConsumerState<MemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(MemoryBloc.provider.bloc).add(
          MemoryEvent.initGame(
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
      body: ref.watch(MemoryBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet),
            matchResult: (memorySet) => _gridView(memorySet),
            nextLevel: (nextLevel) => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('You delivered everything!'),
                ButtonBar(
                  alignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () => ref
                          .read(appRouterProvider)
                          .push(const LevelOverviewRoute()),
                      child: const Text('Level overview'),
                    ),
                    TextButton(
                      onPressed: () => ref.read(appRouterProvider).push(
                            MemoryRoute(
                              gameSize: nextLevel.gameSize,
                              themeSet: nextLevel.themeSet,
                            ),
                          ),
                      child: const Text('Next Level'),
                    ),
                  ],
                )
              ],
            ),
            orElse: () => const Text('loading'),
          ),
    );
  }

  Widget _gridView(List<MemoryTile> memorySet) => Center(
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
              child: GridView.count(
                shrinkWrap: true,
                crossAxisCount: 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1,
                padding: const EdgeInsets.all(8),
                children: _tiles(memorySet),
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
                    onPressed: () => ref.read(MemoryBloc.provider.bloc).add(
                          MemoryEvent.initGame(
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

  List<Widget> _tiles(List<MemoryTile> memorySet) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      var initTile = Container(
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAlias,
          child: tile.image!.image(fit: BoxFit.cover),
        ),
      );

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
        );
      }

      tiles.add(InkWell(
        onTap: () => tile.visible
            ? {}
            : ref
                .read(MemoryBloc.provider.bloc)
                .add(MemoryEvent.handleTap(tile.index, tile.pairValue)),
        child: initTile,
      ));
    }

    return tiles;
  }
}
