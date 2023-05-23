import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/level_overview/level_done.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:memoryfun/src/different_image/memory_bloc.dart';
import 'package:memoryfun/src/memory/memory_tile_component.dart';
import 'package:memoryfun/src/split_memory/split_memory_grid_view.dart';
import 'package:memoryfun/src/split_memory/split_memory_set.dart';

import '../components/my_button.dart';
import 'memory_tile.dart';

@RoutePage()
class MemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const MemoryPage({
    required this.levelInfo,
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
          MemoryEvent.initGame(widget.levelInfo),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ref.watch(MemoryBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet, true),
            matchResult: (memorySet) => _gridView(memorySet, false),
            nextLevel: (nextLevel) => LevelDone(nextLevel: nextLevel),
            orElse: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('loading'),
                TextButton(
                  onPressed: () => ref.read(MemoryBloc.provider.bloc).add(
                        MemoryEvent.initGame(widget.levelInfo),
                      ),
                  child: const NormalButtonStyle(
                    text: 'Restart game',
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _gridView(SplitMemorySet splitMemorySet, bool fadeIn) =>
      SplitMemoryGridView(
        upperTiles: _tiles(splitMemorySet.upperTiles, fadeIn),
        lowerTiles: _tiles(splitMemorySet.lowerTiles, fadeIn),
        onRestart: () => ref.read(MemoryBloc.provider.bloc).add(
              MemoryEvent.initGame(widget.levelInfo),
            ),
      );

  List<Widget> _tiles(List<MemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      tiles.add(
        MemoryTileComponent(
          visible: tile.visible,
          hasError: tile.hasError,
          image: tile.image!,
//TODO disable tap for upper or lower tiles when already tapped in this region
          onTap: () {
            ref.read(MemoryBloc.provider.bloc).add(
                  MemoryEvent.handleTap(tile),
                );
          },
        ),
      );
    }

    return tiles;
  }
}
