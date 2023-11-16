import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/app_bar/memo_app_bar.dart';
import '../../../../components/buttons/normal_button.dart';
import '../../../../components/grid/single_memory_grid_view.dart';
import '../../../../components/memory_cards/color_cards/color_memory_card.dart';
import '../../../../levels/level_info.dart';
import '../../../../sound/sounds.dart';
import '../bloc/same_color_bloc.dart';
import '../models/color_memory_tile.dart';

@RoutePage()
class SameColorMemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const SameColorMemoryPage({
    required this.levelInfo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SameColorMemoryPageState();
}

class _SameColorMemoryPageState extends ConsumerState<SameColorMemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(SameColorBloc.provider.bloc).add(
          SameColorEvent.initGame(widget.levelInfo),
        );
    ref.read(Sounds.provider).playMusic(widget.levelInfo.themeSet);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MemoryAppBar(
          onRestart: () => ref.read(SameColorBloc.provider.bloc).add(
                SameColorEvent.initGame(widget.levelInfo),
              ),
        ),
        body: ref.watch(SameColorBloc.provider).maybeWhen(
              initialized: (memorySet) => _gridView(memorySet, true),
              matchResult: (memorySet) => _gridView(memorySet, false),
              orElse: () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('loading'),
                  NormalButton(
                    text: 'Restart game',
                    onTap: () => ref.read(SameColorBloc.provider.bloc).add(
                          SameColorEvent.initGame(widget.levelInfo),
                        ),
                  ),
                ],
              ),
            ),
      );

  Widget _gridView(List<ColorMemoryTile> memorySet, bool fadeIn) =>
      SingleMemoryGridView(
        tiles: _tiles(memorySet, fadeIn),
      );

  List<Widget> _tiles(List<ColorMemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      tiles.add(
        ColorMemoryCard(
          memoryTile: tile,
          onTap: () => ref.read(SameColorBloc.provider.bloc).add(
                SameColorEvent.handleTap(tile.index, tile.color),
              ),
        ),
      );
    }

    return tiles;
  }
}
