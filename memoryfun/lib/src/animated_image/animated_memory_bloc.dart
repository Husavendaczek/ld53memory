import 'dart:math';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/theme/app_color_mode.dart';
import 'package:riverbloc/riverbloc.dart';

import '../memory/memory_tile.dart';
import '../utils/app_router.dart';
import '../game_type/image_mapper.dart';
import '../sound/sound_player.dart';
import '../levels/levels.dart';
import '../game_type/game_type.dart';
import '../levels/level_info.dart';
import '../game_type/theme_set.dart';
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
      appColorMode: ref.watch(AppColorMode.provider),
    );
  });

  final ImageMapper imageMapper;
  final AppRouter appRouter;
  final SoundPlayer soundPlayer;
  final AppColorMode appColorMode;

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
    required this.appColorMode,
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
            'assets/${appColorMode.appColorStyle.name}/${currentLevel.themeSet.name}/${currentLevel.themeSet.name}_${value}_anim_$j.png'));
      }

      var tile = AnimatedMemoryTile(
        index: i,
        pairValue: value,
        isVisible: false,
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
            MemoryTile(
                index: index, pairValue: event.pairValue, isVisible: false));
        memoryTiles[hideTileIndex].hasError = false;
      }

      hideTiles = [];
    }
    _setTileVisibility(index,
        MemoryTile(index: index, pairValue: event.pairValue, isVisible: true));

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
    memoryTiles[index].isVisible = true;
    memoryTiles[oldIndex].isVisible = true;
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

        currentLevel = levels[level + 1];

        Future.delayed(
          const Duration(seconds: 2),
          () {
            firstIndex = null;
            firstPairValue = null;
            hideTiles = [];
            memoryTiles = [];
            matchesWon = 0;

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

  void _handleWrongMatch(int index, int oldIndex) {
    soundPlayer.playWrongMatch();

    memoryTiles[index].isVisible = false;
    memoryTiles[oldIndex].isVisible = false;
    memoryTiles[index].hasError = true;
    memoryTiles[oldIndex].hasError = true;

    hideTiles.add(index);
    hideTiles.add(oldIndex);

    firstIndex = null;
    firstPairValue = null;
    emit(AnimatedMemoryState.matchResult(memoryTiles));
  }

  void _setTileVisibility(int index, MemoryTile memoryTile) {
    memoryTiles[index].image = imageMapper.getImage(
      memoryTile,
      currentLevel.themeSet,
    );
  }
}
