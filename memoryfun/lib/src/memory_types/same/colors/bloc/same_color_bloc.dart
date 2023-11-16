import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/game_type/theme_set.dart';
import 'package:memoryfun/src/memory_types/same/colors/models/color_memory_tile.dart';
import 'package:memoryfun/src/memory_types/same/colors/services/game_moves_colors.dart';
import 'package:riverbloc/riverbloc.dart';

import '../../../../levels/level_finisher.dart';
import '../../../../levels/level_info.dart';
import '../../../../utils/calculating/randomizer.dart';
import '../../../match_result.dart';

part 'same_color_bloc.freezed.dart';

@freezed
class SameColorEvent with _$SameColorEvent {
  const factory SameColorEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory SameColorEvent.handleTap(int tileIndex, Color color) =
      _HandleTap;
}

@freezed
class SameColorState with _$SameColorState {
  const factory SameColorState.initial() = _Initial;
  const factory SameColorState.loading() = _Loading;
  const factory SameColorState.initialized(List<ColorMemoryTile> memorySet) =
      _Initialized;
  const factory SameColorState.loadingResult() = _LoadingResult;
  const factory SameColorState.matchResult(List<ColorMemoryTile> memorySet) =
      _MatchResult;
}

class SameColorBloc extends Bloc<SameColorEvent, SameColorState> {
  static final provider =
      BlocProvider.autoDispose<SameColorBloc, SameColorState>((ref) {
    ref.onDispose(() => ref.bloc.close());

    return SameColorBloc(
      levelFinisher: ref.watch(LevelFinisher.provider),
      randomizer: ref.watch(Randomizer.provider),
      gameMovesColors: ref.watch(GameMovesColors.provider),
    );
  });

  final LevelFinisher levelFinisher;
  final Randomizer randomizer;
  final GameMovesColors gameMovesColors;

  List<ColorMemoryTile> memoryTiles = [];
  int matchesWon = 0;
  int matchesLeft = 100;
  ThemeSet themeSet = ThemeSet.food;

  SameColorBloc({
    required this.levelFinisher,
    required this.randomizer,
    required this.gameMovesColors,
  }) : super(const SameColorState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(_InitGame event, Emitter<SameColorState> emit) async {
    emit(const SameColorState.loading());

    _resetGame();
    matchesLeft = event.levelInfo.getMatches();
    themeSet = event.levelInfo.themeSet;

    var randomColors = [];
    for (int i = 0; i < matchesLeft; i++) {
      var randomColor = randomizer.randomColor();
      if (randomColors.contains(randomColor)) {
        i--;
      } else {
        randomColors.add(randomColor);
        randomColors.add(randomColor);
      }
    }

    for (int i = 0; i < event.levelInfo.gameSize; i++) {
      var randomIndex = randomizer.randomOutOf(randomColors.length);
      var randomColor = randomColors[randomIndex];
      randomColors.removeAt(randomIndex);

      var tile = ColorMemoryTile(
        index: i,
        angle: randomizer.randomTileAngle(),
        color: randomColor,
      );

      memoryTiles.add(tile);
    }

    emit(SameColorState.initialized(memoryTiles));
  }

  void _resetGame() {
    gameMovesColors.resetGame();

    memoryTiles = [];
    matchesWon = 0;
  }

  Future _handleTap(_HandleTap event, Emitter<SameColorState> emit) async {
    emit(const SameColorState.loading());

    var matchResult = gameMovesColors.handleTap(
      memoryTiles,
      event.tileIndex,
      event.color,
    );

    switch (matchResult) {
      case MatchResult.correctMatch:
        _handleCorrectMatch();
        break;
      default:
        emit(SameColorState.matchResult(memoryTiles));
        break;
    }
  }

  void _handleCorrectMatch() {
    matchesWon++;
    matchesLeft = matchesLeft - 1;

    var isFinished = levelFinisher.goToNextLevelOrFinish(themeSet, matchesLeft);

    if (isFinished) {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          _resetGame();
        },
      );
    }

    emit(SameColorState.matchResult(memoryTiles));
  }
}
