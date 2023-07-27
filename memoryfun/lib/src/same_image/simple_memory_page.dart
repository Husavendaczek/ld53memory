import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:memoryfun/src/memory/memory_tile_component.dart';

import '../components/memo_app_bar.dart';
import '../components/normal_button.dart';
import '../memory/memory_grid_view.dart';
import 'simple_memory_bloc.dart';
import 'simple_memory_tile.dart';

@RoutePage()
class SimpleMemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const SimpleMemoryPage({
    required this.levelInfo,
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
          SimpleMemoryEvent.initGame(widget.levelInfo),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MemoAppBar(
        onRestart: () => ref.read(SimpleMemoryBloc.provider.bloc).add(
              SimpleMemoryEvent.initGame(widget.levelInfo),
            ),
      ),
      body: ref.watch(SimpleMemoryBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet, true),
            matchResult: (memorySet) => _gridView(memorySet, false),
            orElse: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('loading'),
                NormalButton(
                  text: 'Restart game',
                  onTap: () => ref.read(SimpleMemoryBloc.provider.bloc).add(
                        SimpleMemoryEvent.initGame(widget.levelInfo),
                      ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _gridView(List<SimpleMemoryTile> memorySet, bool fadeIn) =>
      MemoryGridView(
        tiles: _tiles(memorySet, fadeIn),
      );

  List<Widget> _tiles(List<SimpleMemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      tiles.add(
        MemoryTileComponent(
          visible: tile.visible,
          hasError: tile.hasError,
          isCorrect: tile.isCorrect,
          image: tile.image!,
          onTap: () => ref.read(SimpleMemoryBloc.provider.bloc).add(
                SimpleMemoryEvent.handleTap(tile.index, tile.pairValue),
              ),
        ),
      );
    }

    return tiles;
  }
}
