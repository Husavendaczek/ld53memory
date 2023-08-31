import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/app_bar/memo_app_bar.dart';
import 'package:memoryfun/src/levels/level_info.dart';
import 'package:memoryfun/src/different_image/memory_bloc.dart';
import 'package:memoryfun/src/components/memory_card/memory_card.dart';
import 'package:memoryfun/src/split_memory/split_memory_grid_view.dart';
import 'package:memoryfun/src/split_memory/split_memory_set.dart';

import '../components/buttons/normal_button.dart';
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
      appBar: MemoryAppBar(
        onRestart: () => ref.read(MemoryBloc.provider.bloc).add(
              MemoryEvent.initGame(widget.levelInfo),
            ),
      ),
      body: ref.watch(MemoryBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet, true),
            matchResult: (memorySet) => _gridView(memorySet, false),
            orElse: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('loading'),
                NormalButton(
                  text: 'Restart game',
                  onTap: () => ref.read(MemoryBloc.provider.bloc).add(
                        MemoryEvent.initGame(widget.levelInfo),
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
      );

  List<Widget> _tiles(List<MemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      tiles.add(
        MemoryCard(
          memoryTile: tile,
          onTap: () => ref.read(MemoryBloc.provider.bloc).add(
                MemoryEvent.handleTap(tile),
              ),
        ),
      );
    }

    return tiles;
  }
}
