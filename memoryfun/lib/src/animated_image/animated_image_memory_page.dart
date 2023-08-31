import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/animated_image/animated_memory_tile.dart';
import '../components/app_bar/memo_app_bar.dart';
import '../components/buttons/normal_button.dart';
import '../levels/level_info.dart';
import '../memory/memory_grid_view.dart';
import 'animated_memory_bloc.dart';
import 'animated_memory_tile_component.dart';

@RoutePage()
class AnimatedImageMemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const AnimatedImageMemoryPage({
    required this.levelInfo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AnimatedImageMemoryPageState();
}

class _AnimatedImageMemoryPageState
    extends ConsumerState<AnimatedImageMemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(AnimatedMemoryBloc.provider.bloc).add(
          AnimatedMemoryEvent.initGame(widget.levelInfo),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MemoryAppBar(
        onRestart: () => ref.read(AnimatedMemoryBloc.provider.bloc).add(
              AnimatedMemoryEvent.initGame(widget.levelInfo),
            ),
      ),
      body: ref.watch(AnimatedMemoryBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet, true),
            matchResult: (memorySet) => _gridView(memorySet, false),
            orElse: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('loading'),
                NormalButton(
                  text: 'Restart game',
                  onTap: () => ref.read(AnimatedMemoryBloc.provider.bloc).add(
                        AnimatedMemoryEvent.initGame(widget.levelInfo),
                      ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _gridView(List<AnimatedMemoryTile> memorySet, bool fadeIn) =>
      MemoryGridView(
        tiles: _tiles(memorySet, fadeIn),
      );

  List<Widget> _tiles(List<AnimatedMemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      tiles.add(
        AnimatedMemoryTileComponent(
          visible: tile.visible,
          hasError: tile.hasError,
          isCorrect: tile.isCorrect,
          image: tile.image!,
          animatedImages: tile.animationImages,
          onTap: () => ref.read(AnimatedMemoryBloc.provider.bloc).add(
                AnimatedMemoryEvent.handleTap(tile.index, tile.pairValue),
              ),
        ),
      );
    }

    return tiles;
  }
}
