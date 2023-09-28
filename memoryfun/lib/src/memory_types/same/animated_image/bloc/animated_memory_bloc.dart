import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/utils/calculating/randomizer.dart';
import 'package:riverbloc/riverbloc.dart';

import '../../../game_moves.dart';
import '../../../match_result.dart';
import '../../../../utils/routing/app_router.dart';
import '../../../../game_type/image_mapper.dart';
import '../../../../sound/sounds.dart';
import '../../../../levels/levels.dart';
import '../../../../game_type/game_type.dart';
import '../../../../levels/level_info.dart';
import '../../../../game_type/theme_set.dart';
import '../models/animated_memory_tile.dart';

part 'animated_memory_bloc.freezed.dart';

@freezed
class AnimatedMemoryEvent with _$AnimatedMemoryEvent {
  const factory AnimatedMemoryEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory AnimatedMemoryEvent.handleTap(int tileIndex, int pairValue) =
      _HandleTap;
}

@freezed
class AnimatedMemoryState with _$AnimatedMemoryState {
  const factory AnimatedMemoryState.initial() = _Initial;
  const factory AnimatedMemoryState.loading() = _Loading;
  const factory AnimatedMemoryState.initialized(
      List<AnimatedMemoryTile> memorySet) = _Initialized;
  const factory AnimatedMemoryState.loadingResult() = _LoadingResult;
  const factory AnimatedMemoryState.matchResult(
      List<AnimatedMemoryTile> memorySet) = _MatchResult;
}

class AnimatedMemoryBloc
    extends Bloc<AnimatedMemoryEvent, AnimatedMemoryState> {
  static final provider =
      BlocProvider.autoDispose<AnimatedMemoryBloc, AnimatedMemoryState>((ref) {
    ref.onDispose(() => ref.bloc.close());
    return AnimatedMemoryBloc(
      imageMapper: ref.watch(ImageMapper.provider),
      appRouter: ref.watch(appRouterProvider),
      gameMoves: ref.watch(GameMoves.provider),
      soundPlayer: ref.watch(Sounds.provider),
      randomizer: ref.watch(Randomizer.provider),
    );
  });

  final ImageMapper imageMapper;
  final AppRouter appRouter;
  final GameMoves gameMoves;
  final Sounds soundPlayer;
  final Randomizer randomizer;

  List<AnimatedMemoryTile> memoryTiles = [];
  int matchesWon = 0;
  int matchesLeft = 100;
  LevelInfo currentLevel = const LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.food,
    gameType: GameType.sameImage,
  );
  int? firstIndex;
  int? firstPairValue;
  List<int> hideTiles = [];

  AnimatedMemoryBloc({
    required this.imageMapper,
    required this.appRouter,
    required this.gameMoves,
    required this.soundPlayer,
    required this.randomizer,
  }) : super(const AnimatedMemoryState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(_InitGame event, Emitter<AnimatedMemoryState> emit) async {
    emit(const AnimatedMemoryState.loading());
    soundPlayer.playMusic(event.levelInfo.themeSet);

    _resetGame();
    matchesLeft = event.levelInfo.getMatches();
    currentLevel = event.levelInfo;

    var pairValues = [];
    for (int i = 0; i < matchesLeft; i++) {
      pairValues.add(i);
      pairValues.add(i);
    }

    for (int i = 0; i < event.levelInfo.gameSize; i++) {
      var randomIndex = Random().nextInt(pairValues.length);
      var value = pairValues[randomIndex];
      pairValues.removeAt(randomIndex);

      List<AssetImage> animatedImages =
          imageMapper.animatedImages(currentLevel.themeSet, value);

      var tile = AnimatedMemoryTile(
        index: i,
        pairValue: value,
        angle: randomizer.randomTileAngle(),
        isVisible: false,
        animationImages: animatedImages,
      );
      tile.image = imageMapper.getImage(tile, currentLevel.themeSet);

      memoryTiles.add(tile);
    }

    emit(AnimatedMemoryState.initialized(memoryTiles));
  }

  void _resetGame() {
    gameMoves.resetGame();

    memoryTiles = [];
    matchesWon = 0;
  }

  Future _handleTap(
    _HandleTap event,
    Emitter<AnimatedMemoryState> emit,
  ) async {
    emit(const AnimatedMemoryState.loadingResult());

    var matchResult = gameMoves.handleTap(
      currentLevel.themeSet,
      memoryTiles,
      event.tileIndex,
      event.pairValue,
    );

    switch (matchResult) {
      case MatchResult.correctMatch:
        _handleCorrectMatch();
        break;
      default:
        emit(AnimatedMemoryState.matchResult(memoryTiles));
        break;
    }
  }

  void _handleCorrectMatch() {
    matchesWon++;
    matchesLeft = matchesLeft - 1;

    if (matchesLeft == 0) {
      var level =
          levels.indexWhere((lvl) => lvl.themeSet == currentLevel.themeSet);
      if (level == levels.length - 1) {
        soundPlayer.playWinGame();

        appRouter.push(const WonRoute());
      } else {
        soundPlayer.playWinLevel();

        currentLevel = levels[level + 1];

        Future.delayed(
          const Duration(seconds: 2),
          () {
            _resetGame();

            return appRouter.push(LevelDoneRoute(nextLevel: levels[level + 1]));
          },
        );

        emit(AnimatedMemoryState.matchResult(memoryTiles));
      }
    } else {
      soundPlayer.playCorrectMatch();
      emit(AnimatedMemoryState.matchResult(memoryTiles));
    }
  }
}
