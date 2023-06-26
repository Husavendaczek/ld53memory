import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/helper/image_mapper.dart';
import 'package:memoryfun/src/helper/sound_player.dart';
import 'package:memoryfun/src/memory/level_info.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:riverbloc/riverbloc.dart';

import '../level_overview/levels.dart';
import '../memory/game_type.dart';
import 'simple_memory_tile.dart';

part 'simple_memory_bloc.freezed.dart';

@freezed
class SimpleMemoryEvent with _$SimpleMemoryEvent {
  const factory SimpleMemoryEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory SimpleMemoryEvent.handleTap(int tileIndex, int pairValue) =
      _HandleTap;
}

@freezed
class SimpleMemoryState with _$SimpleMemoryState {
  const factory SimpleMemoryState.initial() = _Initial;
  const factory SimpleMemoryState.loading() = _Loading;
  const factory SimpleMemoryState.initialized(
      List<SimpleMemoryTile> memorySet) = _Initialized;
  const factory SimpleMemoryState.loadingResult() = _LoadingResult;
  const factory SimpleMemoryState.matchResult(
      List<SimpleMemoryTile> memorySet) = _MatchResult;
  const factory SimpleMemoryState.nextLevel(LevelInfo nextLevel) = _NextLevel;
  const factory SimpleMemoryState.winGame() = _WinGame;
  const factory SimpleMemoryState.looseGame() = _looseGame;
}

class SimpleMemoryBloc extends Bloc<SimpleMemoryEvent, SimpleMemoryState> {
  static final provider =
      BlocProvider.autoDispose<SimpleMemoryBloc, SimpleMemoryState>((ref) {
    ref.onDispose(() => ref.bloc.close());

    return SimpleMemoryBloc(
      imageMapper: ref.watch(ImageMapper.provider),
      appRouter: ref.watch(appRouterProvider),
      soundPlayer: ref.watch(SoundPlayer.provider),
    );
  });

  final ImageMapper imageMapper;
  final AppRouter appRouter;
  final SoundPlayer soundPlayer;

  List<SimpleMemoryTile> memoryTiles = [];
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

  SimpleMemoryBloc({
    required this.imageMapper,
    required this.appRouter,
    required this.soundPlayer,
  }) : super(const SimpleMemoryState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(_InitGame event, Emitter<SimpleMemoryState> emit) async {
    emit(const SimpleMemoryState.loading());
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

      var tile = SimpleMemoryTile(
        index: i,
        pairValue: value,
        visible: false,
      );
      tile.image = imageMapper.getImage(tile, currentLevel.themeSet);

      memoryTiles.add(tile);
    }

    emit(SimpleMemoryState.initialized(memoryTiles));
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
    Emitter<SimpleMemoryState> emit,
  ) async {
    emit(const SimpleMemoryState.loadingResult());
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
        emit(SimpleMemoryState.matchResult(memoryTiles));
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
      emit(SimpleMemoryState.matchResult(memoryTiles));
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

        emit(SimpleMemoryState.nextLevel(levels[level + 1]));
      }
    } else {
      soundPlayer.playCorrectMatch();
      emit(SimpleMemoryState.matchResult(memoryTiles));
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
    emit(SimpleMemoryState.matchResult(memoryTiles));
  }

  void _setTileVisibility(int index, SimpleMemoryTile memoryTile) {
    memoryTiles[index].image = imageMapper.getImage(
      memoryTile,
      currentLevel.themeSet,
    );
  }
}
