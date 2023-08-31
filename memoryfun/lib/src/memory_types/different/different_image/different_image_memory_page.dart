import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../components/app_bar/memo_app_bar.dart';
import '../../../components/buttons/normal_button.dart';
import '../../../components/memory_card/memory_card.dart';
import '../../../levels/level_info.dart';
import '../../../memory/memory_tile.dart';
import '../../../split_memory/split_memory_grid_view.dart';
import '../../../split_memory/split_memory_set.dart';
import 'different_image_bloc.dart';

@RoutePage()
class DifferentImageMemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const DifferentImageMemoryPage({
    required this.levelInfo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MemoryPageState();
}

class _MemoryPageState extends ConsumerState<DifferentImageMemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(DifferentImageBloc.provider.bloc).add(
          DifferentImageEvent.initGame(widget.levelInfo),
        );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MemoryAppBar(
          onRestart: () => ref.read(DifferentImageBloc.provider.bloc).add(
                DifferentImageEvent.initGame(widget.levelInfo),
              ),
        ),
        body: ref.watch(DifferentImageBloc.provider).maybeWhen(
              initialized: (memorySet) => _gridView(memorySet, true),
              matchResult: (memorySet) => _gridView(memorySet, false),
              orElse: () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('loading'),
                  NormalButton(
                    text: 'Restart game',
                    onTap: () => ref.read(DifferentImageBloc.provider.bloc).add(
                          DifferentImageEvent.initGame(widget.levelInfo),
                        ),
                  ),
                ],
              ),
            ),
      );

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
          onTap: () => ref.read(DifferentImageBloc.provider.bloc).add(
                DifferentImageEvent.handleTap(tile),
              ),
        ),
      );
    }

    return tiles;
  }
}
