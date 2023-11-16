import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/components/memory_cards/text_cards/text_memory_card.dart';
import 'package:memoryfun/src/levels/level_info.dart';
import 'package:memoryfun/src/memory_types/different/calculating_numbers/bloc/numbers_calculation_bloc.dart';

import '../../../../components/app_bar/memo_app_bar.dart';
import '../../../../components/buttons/normal_button.dart';
import '../../../../components/grid/single_memory_grid_view.dart';
import '../../../../components/memory_cards/number_cards/number_memory_card.dart';
import '../../../../sound/sounds.dart';
import '../../../models/number_memory_tile.dart';
import '../../../models/text_memory_tile.dart';
import '../models/calculation_memory_tile.dart';

@RoutePage()
class CalculatingNumbersMemoryPage extends ConsumerStatefulWidget {
  final LevelInfo levelInfo;

  const CalculatingNumbersMemoryPage({
    required this.levelInfo,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _CalculatingNumbersMemoryPageState();
}

class _CalculatingNumbersMemoryPageState
    extends ConsumerState<CalculatingNumbersMemoryPage> {
  @override
  void initState() {
    super.initState();

    ref
        .read(NumbersCalculationBloc.provider.bloc)
        .add(NumbersCalculationEvent.initGame(widget.levelInfo));

    ref.read(Sounds.provider).playMusic(widget.levelInfo.themeSet);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: MemoryAppBar(
          onRestart: () => ref.read(NumbersCalculationBloc.provider.bloc).add(
                NumbersCalculationEvent.initGame(widget.levelInfo),
              ),
        ),
        body: ref.watch(NumbersCalculationBloc.provider).maybeWhen(
              initialized: (memorySet) => _gridView(memorySet, true),
              matchResult: (memorySet) => _gridView(memorySet, false),
              orElse: () => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('loading'),
                  NormalButton(
                    text: 'Restart game',
                    onTap: () => ref
                        .read(NumbersCalculationBloc.provider.bloc)
                        .add(
                          NumbersCalculationEvent.initGame(widget.levelInfo),
                        ),
                  ),
                ],
              ),
            ),
      );

  Widget _gridView(List<CalculationMemoryTile> memorySet, bool fadeIn) =>
      SingleMemoryGridView(
        tiles: _tiles(memorySet, fadeIn),
      );

  List<Widget> _tiles(List<CalculationMemoryTile> memorySet, bool fadeIn) {
    List<Widget> cards = [];

    for (var tile in memorySet) {
      Widget memoryCard;

      if (!tile.showsText) {
        memoryCard = NumberMemoryCard(
          memoryTile: NumberMemoryTile(
            index: tile.index,
            number: tile.resultNumber.number,
            angle: tile.angle,
            isVisible: tile.isVisible,
            hasError: tile.hasError,
            isCorrect: tile.isCorrect,
          ),
          onTap: () {
            ref.read(NumbersCalculationBloc.provider.bloc).add(
                  NumbersCalculationEvent.handleTap(
                    tile.index,
                    tile.resultNumber.number,
                  ),
                );
          },
        );
      } else {
        memoryCard = TextMemoryCard(
          memoryTile: TextMemoryTile(
            text: tile.resultNumber.text,
            index: tile.index,
            angle: tile.angle,
            isVisible: tile.isVisible,
            hasError: tile.hasError,
            isCorrect: tile.isCorrect,
          ),
          onTap: () {
            ref.read(NumbersCalculationBloc.provider.bloc).add(
                  NumbersCalculationEvent.handleTap(
                    tile.index,
                    tile.resultNumber.number,
                  ),
                );
          },
        );
      }

      cards.add(memoryCard);
    }

    return cards;
  }
}
