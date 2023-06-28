import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverbloc/riverbloc.dart';

import '../helper/app_router.dart';
import '../helper/image_mapper.dart';
import '../helper/sound_player.dart';
import '../level_overview/levels.dart';
import '../memory/game_type.dart';
import '../memory/level_info.dart';
import '../memory/theme_set.dart';
import '../same_image/simple_memory_tile.dart';
import 'animated_memory_tile.dart';

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
  const factory AnimatedMemoryState.nextLevel(LevelInfo nextLevel) = _NextLevel;
}

class AnimatedMemoryBloc
    extends Bloc<AnimatedMemoryEvent, AnimatedMemoryState> {
  static final provider =
      BlocProvider.autoDispose<AnimatedMemoryBloc, AnimatedMemoryState>((ref) {
    ref.onDispose(() => ref.bloc.close());
    return AnimatedMemoryBloc(
      imageMapper: ref.watch(ImageMapper.provider),
      appRouter: ref.watch(appRouterProvider),
      soundPlayer: ref.watch(SoundPlayer.provider),
    );
  });

  final ImageMapper imageMapper;
  final AppRouter appRouter;
  final SoundPlayer soundPlayer;

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
    required this.soundPlayer,
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

      List<AssetImage> animatedImages = [];
      for (int j = 0; j < 7; j++) {
        animatedImages.add(AssetImage(
            '${currentLevel.themeSet.name}/${currentLevel.themeSet.name}_${value}_anim_$j.png'));
      }

      var tile = AnimatedMemoryTile(
        index: i,
        pairValue: value,
        visible: false,
        animationImages: animatedImages,
      );
      tile.image = imageMapper.getImage(tile, currentLevel.themeSet);

      memoryTiles.add(tile);
    }

    emit(AnimatedMemoryState.initialized(memoryTiles));
  }

  void _resetGame() {
    firstIndex = null;
    firstPairValue = null;
    hideTiles = [];
    memoryTiles = [];
    matchesWon = 0;
  }

  Future _handleTap(
    _HandleTap event,
    Emitter<AnimatedMemoryState> emit,
  ) async {
    emit(const AnimatedMemoryState.loadingResult());
    soundPlayer.playTap();

    var index = event.tileIndex;

    if (hideTiles.isNotEmpty) {
      for (var hideTileIndex in hideTiles) {
        _setTileVisibility(
            hideTileIndex,
            SimpleMemoryTile(
                index: index, pairValue: event.pairValue, visible: false));
        memoryTiles[hideTileIndex].hasError = false;
      }

      hideTiles = [];
    }
    _setTileVisibility(
        index,
        SimpleMemoryTile(
            index: index, pairValue: event.pairValue, visible: true));

    if (firstIndex != null) {
      if (firstIndex == event.tileIndex) {
        emit(AnimatedMemoryState.matchResult(memoryTiles));
        return;
      } else {
        if (firstPairValue == event.pairValue) {
          _handleCorrectMatch(index, firstIndex!);
        } else {
          _handleWrongMatch(index, firstIndex!);
        }
      }
    } else {
      firstIndex = event.tileIndex;
      firstPairValue = event.pairValue;
      emit(AnimatedMemoryState.matchResult(memoryTiles));
    }
  }

  void _handleCorrectMatch(int index, int oldIndex) {
    memoryTiles[index].visible = true;
    memoryTiles[oldIndex].visible = true;
    memoryTiles[index].isCorrect = true;
    memoryTiles[oldIndex].isCorrect = true;

    firstIndex = null;
    firstPairValue = null;

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

        firstIndex = null;
        firstPairValue = null;
        hideTiles = [];
        memoryTiles = [];
        matchesWon = 0;
        currentLevel = levels[level + 1];

        emit(AnimatedMemoryState.nextLevel(levels[level + 1]));
      }
    } else {
      soundPlayer.playCorrectMatch();
      emit(AnimatedMemoryState.matchResult(memoryTiles));
    }
  }

  void _handleWrongMatch(int index, int oldIndex) {
    soundPlayer.playWrongMatch();

    memoryTiles[index].visible = false;
    memoryTiles[oldIndex].visible = false;
    memoryTiles[index].hasError = true;
    memoryTiles[oldIndex].hasError = true;

    hideTiles.add(index);
    hideTiles.add(oldIndex);

    firstIndex = null;
    firstPairValue = null;
    emit(AnimatedMemoryState.matchResult(memoryTiles));
  }

  void _setTileVisibility(int index, SimpleMemoryTile memoryTile) {
    memoryTiles[index].image = imageMapper.getImage(
      memoryTile,
      currentLevel.themeSet,
    );
  }
}
