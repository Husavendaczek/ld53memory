import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/app_bar/memo_app_bar.dart';
import '../../../../components/buttons/normal_button.dart';
import '../../../../components/grid/single_memory_grid_view.dart';
import '../../../../components/memory_cards/number_cards/number_memory_card.dart';
import '../../../../levels/level_info.dart';
import '../../../../sound/sounds.dart';
import '../../../models/number_memory_tile.dart';
import '../bloc/same_number_bloc.dart';

@RoutePage()
class SameNumberMemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const SameNumberMemoryPage({
    required this.levelInfo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SameNumberMemoryPageState();
}

class _SameNumberMemoryPageState extends ConsumerState<SameNumberMemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(SameNumberBloc.provider.bloc).add(
          SameNumberEvent.initGame(widget.levelInfo),
        );
    ref.read(Sounds.provider).playMusic(widget.levelInfo.themeSet);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MemoryAppBar(
          onRestart: () => ref.read(SameNumberBloc.provider.bloc).add(
                SameNumberEvent.initGame(widget.levelInfo),
              ),
        ),
        body: ref.watch(SameNumberBloc.provider).maybeWhen(
              initialized: (memorySet) => _gridView(memorySet, true),
              matchResult: (memorySet) => _gridView(memorySet, false),
              orElse: () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('loading'),
                  NormalButton(
                    text: 'Restart game',
                    onTap: () => ref.read(SameNumberBloc.provider.bloc).add(
                          SameNumberEvent.initGame(widget.levelInfo),
                        ),
                  ),
                ],
              ),
            ),
      );

  Widget _gridView(List<NumberMemoryTile> memorySet, bool fadeIn) =>
      SingleMemoryGridView(
        tiles: _tiles(memorySet, fadeIn),
      );

  List<Widget> _tiles(List<NumberMemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      var memoryTile = NumberMemoryTile(
        index: tile.index,
        number: tile.number,
        angle: tile.angle,
        isVisible: tile.isVisible,
        hasError: tile.hasError,
        isCorrect: tile.isCorrect,
      );
      tiles.add(
        NumberMemoryCard(
          memoryTile: memoryTile,
          onTap: () => ref.read(SameNumberBloc.provider.bloc).add(
                SameNumberEvent.handleTap(tile.index, tile.number),
              ),
        ),
      );
    }

    return tiles;
  }
}
