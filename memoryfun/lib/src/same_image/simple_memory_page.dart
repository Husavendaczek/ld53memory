import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/memory/level_info.dart';

import '../components/my_button.dart';
import '../level_overview/level_done.dart';
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
      body: ref.watch(SimpleMemoryBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet, true),
            matchResult: (memorySet) => _gridView(memorySet, false),
            nextLevel: (nextLevel) => LevelDone(nextLevel: nextLevel),
            orElse: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('loading'),
                TextButton(
                  onPressed: () => ref.read(SimpleMemoryBloc.provider.bloc).add(
                        SimpleMemoryEvent.initGame(widget.levelInfo),
                      ),
                  child: const NormalButtonStyle(
                      text: 'Restart game', fontSize: 18.0),
                ),
              ],
            ),
          ),
    );
  }

  Widget _gridView(List<SimpleMemoryTile> memorySet, bool fadeIn) =>
      MemoryGridView(
        tiles: _tiles(memorySet, fadeIn),
        onRestart: () => ref.read(SimpleMemoryBloc.provider.bloc).add(
              SimpleMemoryEvent.initGame(widget.levelInfo),
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
