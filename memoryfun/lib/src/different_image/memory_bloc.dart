import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/helper/sound_player.dart';
import 'package:memoryfun/src/memory/game_type.dart';
import 'package:memoryfun/src/memory/image_mapper.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:memoryfun/src/memory/memory_tile.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:riverbloc/riverbloc.dart';

import '../level_overview/levels.dart';

part 'memory_bloc.freezed.dart';

@freezed
class MemoryEvent with _$MemoryEvent {
  const factory MemoryEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory MemoryEvent.handleTap(
      int tileIndex, int pairValue, bool isDeliverer) = _HandleTap;
}

@freezed
class MemoryState with _$MemoryState {
  const factory MemoryState.initial() = _Initial;
  const factory MemoryState.loading() = _Loading;
  const factory MemoryState.initialized(List<MemoryTile> memorySet) =
      _Initialized;
  const factory MemoryState.loadingResult() = _LoadingResult;
  const factory MemoryState.matchResult(List<MemoryTile> memorySet) =
      _MatchResult;
  const factory MemoryState.nextLevel(LevelInfo nextLevel) = _NextLevel;
  const factory MemoryState.winGame() = _WinGame;
  const factory MemoryState.looseGame() = _looseGame;
}

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  static final provider =
      BlocProvider.autoDispose<MemoryBloc, MemoryState>((ref) {
    ref.onDispose(() => ref.bloc.close());

    return MemoryBloc(
      imageMapper: ref.watch(ImageMapper.provider),
      appRouter: ref.watch(appRouterProvider),
      soundPlayer: ref.watch(SoundPlayer.provider),
    );
  });

  final ImageMapper imageMapper;
  final AppRouter appRouter;
  final SoundPlayer soundPlayer;

  List<MemoryTile> memoryTiles = [];
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

  MemoryBloc({
    required this.imageMapper,
    required this.appRouter,
    required this.soundPlayer,
  }) : super(const MemoryState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(_InitGame event, Emitter<MemoryState> emit) async {
    emit(const MemoryState.loading());
    soundPlayer.playMusic(event.levelInfo.themeSet);

    _resetGame();
    matchesLeft = event.levelInfo.getMatches();
    currentLevel = event.levelInfo;

    var pairValues = [];
    for (int i = 0; i < matchesLeft; i++) {
      pairValues.add(i);
    }

    for (int i = 0; i < event.levelInfo.gameSize; i++) {
      if (i == matchesLeft) {
        for (int i = 0; i < matchesLeft; i++) {
          pairValues.add(i);
        }
      }

      var randomIndex = Random().nextInt(pairValues.length);
      var value = pairValues[randomIndex];
      pairValues.removeAt(randomIndex);

      var tile = MemoryTile(
        index: i,
        pairValue: value,
        isDeliveryPerson: i < matchesLeft,
        visible: false,
      );
      tile.image = imageMapper.mapDifferentImage(tile, currentLevel.themeSet);

      memoryTiles.add(tile);
    }

    emit(MemoryState.initialized(memoryTiles));
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
    Emitter<MemoryState> emit,
  ) async {
    emit(const MemoryState.loadingResult());
    soundPlayer.playTap();

    var index = memoryTiles.indexWhere((tile) => tile.index == event.tileIndex);
    var oldIndex = memoryTiles.indexWhere((tile) => tile.index == firstIndex);

    if (hideTiles.isNotEmpty) {
      for (var hideTileIndex in hideTiles) {
        _setTileVisibility(
            hideTileIndex,
            MemoryTile(
                index: index,
                pairValue: event.pairValue,
                isDeliveryPerson: event.isDeliverer,
                visible: false));
        memoryTiles[hideTileIndex].hasError = false;
      }

      hideTiles = [];
    }
    _setTileVisibility(
        index,
        MemoryTile(
            index: index,
            pairValue: event.pairValue,
            isDeliveryPerson: event.isDeliverer,
            visible: true));

    if (firstIndex != null) {
      if (firstIndex == event.tileIndex) {
        emit(MemoryState.matchResult(memoryTiles));
        return;
      } else {
        if (firstPairValue == event.pairValue) {
          _handleCorrectMatch(index, oldIndex);
        } else {
          _handleWrongMatch(index, oldIndex);
        }
      }
    } else {
      firstIndex = event.tileIndex;
      firstPairValue = event.pairValue;
      emit(MemoryState.matchResult(memoryTiles));
    }
  }

  void _handleCorrectMatch(int index, int oldIndex) {
    memoryTiles[index].visible = true;
    memoryTiles[oldIndex].visible = true;

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

        emit(MemoryState.nextLevel(levels[level + 1]));
      }
    } else {
      soundPlayer.playCorrectMatch();
      emit(MemoryState.matchResult(memoryTiles));
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
    emit(MemoryState.matchResult(memoryTiles));
  }

  void _setTileVisibility(int index, MemoryTile memoryTile) {
    memoryTiles[index].image = imageMapper.mapDifferentImage(
      memoryTile,
      currentLevel.themeSet,
    );
  }
}
