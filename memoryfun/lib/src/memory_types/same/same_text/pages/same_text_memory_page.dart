import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../components/app_bar/memo_app_bar.dart';
import '../../../../components/buttons/normal_button.dart';
import '../../../../components/grid/single_memory_grid_view.dart';
import '../../../../components/memory_cards/text_cards/text_memory_card.dart';
import '../../../../levels/level_info.dart';
import '../../../../sound/sound_player.dart';
import '../../../models/text_memory_tile.dart';
import '../bloc/same_text_bloc.dart';

@RoutePage()
class SameTextMemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const SameTextMemoryPage({
    required this.levelInfo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SameTextMemoryPageState();
}

class _SameTextMemoryPageState extends ConsumerState<SameTextMemoryPage> {
  @override
  void initState() {
    super.initState();

    ref
        .read(SameTextBloc.provider.bloc)
        .add(SameTextEvent.initGame(widget.levelInfo));

    ref.read(SoundPlayer.provider).playMusic(widget.levelInfo.themeSet);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MemoryAppBar(
          onRestart: () => ref.read(SameTextBloc.provider.bloc).add(
                SameTextEvent.initGame(widget.levelInfo),
              ),
        ),
        body: ref.watch(SameTextBloc.provider).maybeWhen(
              initialized: (memorySet) => _gridView(memorySet, true),
              matchResult: (memorySet) => _gridView(memorySet, false),
              orElse: () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('loading'),
                  NormalButton(
                    text: 'Restart game',
                    onTap: () => ref.read(SameTextBloc.provider.bloc).add(
                          SameTextEvent.initGame(widget.levelInfo),
                        ),
                  ),
                ],
              ),
            ),
      );

  Widget _gridView(List<TextMemoryTile> memorySet, bool fadeIn) =>
      SingleMemoryGridView(
        tiles: _tiles(memorySet, fadeIn),
      );

  List<Widget> _tiles(List<TextMemoryTile> memorySet, bool fadeIn) {
    List<Widget> cards = [];

    for (var tile in memorySet) {
      Widget memoryCard;

      memoryCard = TextMemoryCard(
        memoryTile: TextMemoryTile(
          text: tile.text,
          index: tile.index,
          pairValue: tile.pairValue,
          angle: tile.angle,
          isVisible: tile.isVisible,
          hasError: tile.hasError,
          isCorrect: tile.isCorrect,
        ),
        onTap: () {
          ref.read(SameTextBloc.provider.bloc).add(
                SameTextEvent.handleTap(
                  tile.index,
                  tile.text,
                ),
              );
        },
      );

      cards.add(memoryCard);
    }

    return cards;
  }
}
