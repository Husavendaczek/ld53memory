import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/app_bar/memo_app_bar.dart';
import 'package:memoryfun/src/components/buttons/normal_button.dart';
import 'package:memoryfun/src/components/memory_cards/text_cards/text_memory_card.dart';
import 'package:memoryfun/src/memory_types/different/text_image/bloc/text_image_bloc.dart';
import 'package:memoryfun/src/memory_types/different/text_image/models/image_text_memory_set.dart';
import 'package:memoryfun/src/sound/sound_player.dart';

import '../../../../components/grid/split_memory_grid_view.dart';
import '../../../../components/memory_cards/image_cards/memory_card.dart';
import '../../../../levels/level_info.dart';
import '../../../models/image_memory_tile.dart';
import '../../../models/text_memory_tile.dart';

@RoutePage()
class TextImageMemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const TextImageMemoryPage({
    required this.levelInfo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TextImageMemoryPageState();
}

class _TextImageMemoryPageState extends ConsumerState<TextImageMemoryPage> {
  @override
  void initState() {
    super.initState();

    ref.read(TextImageBloc.provider.bloc).add(
          TextImageEvent.initGame(widget.levelInfo),
        );
    ref.read(SoundPlayer.provider).playMusic(widget.levelInfo.themeSet);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MemoryAppBar(
          onRestart: () => ref.read(TextImageBloc.provider.bloc).add(
                TextImageEvent.initGame(widget.levelInfo),
              ),
        ),
        body: ref.watch(TextImageBloc.provider).maybeWhen(
            initialized: (memorySet) => _gridView(memorySet, true),
            matchResult: (memorySet) => _gridView(memorySet, false),
            orElse: () => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('loading'),
                    NormalButton(
                      text: 'Restart game',
                      onTap: () => ref.read(TextImageBloc.provider.bloc).add(
                            TextImageEvent.initGame(widget.levelInfo),
                          ),
                    ),
                  ],
                )),
      );

  Widget _gridView(ImageTextMemorySet imageTextMemorySet, bool fadeIn) =>
      SplitMemoryGridView(
        upperTiles: _tiles(imageTextMemorySet.upperTiles, fadeIn),
        lowerTiles: _textTiles(imageTextMemorySet.lowerTiles, fadeIn),
      );

  List<Widget> _tiles(List<ImageMemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      tiles.add(
        MemoryCard(
          memoryTile: tile,
          onTap: () => ref.read(TextImageBloc.provider.bloc).add(
                TextImageEvent.handleImageTap(tile),
              ),
        ),
      );
    }

    return tiles;
  }

  List<Widget> _textTiles(List<TextMemoryTile> memorySet, bool fadeIn) {
    List<Widget> tiles = [];
    for (var tile in memorySet) {
      tiles.add(
        TextMemoryCard(
          memoryTile: TextMemoryTile(
            text: tile.text,
            index: tile.index,
            pairValue: tile.pairValue,
            angle: tile.angle,
            isVisible: tile.isVisible,
            hasError: tile.hasError,
            isCorrect: tile.isCorrect,
          ),
          onTap: () => ref.read(TextImageBloc.provider.bloc).add(
                TextImageEvent.handleTextTap(tile),
              ),
        ),
      );
    }

    return tiles;
  }
}
