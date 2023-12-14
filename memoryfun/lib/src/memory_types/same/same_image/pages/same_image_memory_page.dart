import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/sound/sound_player.dart';

import '../../../../components/app_bar/memo_app_bar.dart';
import '../../../../components/buttons/normal_button.dart';
import '../../../../components/memory_cards/image_cards/memory_card.dart';
import '../../../../levels/level_info.dart';
import '../../../../components/grid/single_memory_grid_view.dart';
import '../../../models/image_memory_tile.dart';
import '../bloc/same_image_bloc.dart';

@RoutePage()
class SameImageMemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const SameImageMemoryPage({
    required this.levelInfo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SimpleMemoryPageState();
}

class _SimpleMemoryPageState extends ConsumerState<SameImageMemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(SameImageBloc.provider.bloc).add(
          SameImageEvent.initGame(widget.levelInfo),
        );
    ref.read(SoundPlayer.provider).playMusic(widget.levelInfo.themeSet);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MemoryAppBar(
          onRestart: () => ref.read(SameImageBloc.provider.bloc).add(
                SameImageEvent.initGame(widget.levelInfo),
              ),
        ),
        body: ref.watch(SameImageBloc.provider).maybeWhen(
              initialized: (memorySet) => _gridView(memorySet, true),
              matchResult: (memorySet) => _gridView(memorySet, false),
              orElse: () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('loading'),
                  NormalButton(
                    text: 'Restart game',
                    onTap: () => ref.read(SameImageBloc.provider.bloc).add(
                          SameImageEvent.initGame(widget.levelInfo),
                        ),
                  ),
                ],
              ),
            ),
      );

  Widget _gridView(List<ImageMemoryTile> memorySet, bool fadeIn) =>
      SingleMemoryGridView(
        tiles: _tiles(memorySet, fadeIn),
      );

  List<Widget> _tiles(List<ImageMemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      tiles.add(
        MemoryCard(
          memoryTile: tile,
          onTap: () => ref.read(SameImageBloc.provider.bloc).add(
                SameImageEvent.handleTap(tile.index, tile.pairValue),
              ),
        ),
      );
    }

    return tiles;
  }
}
