import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/helper/app_router.dart';
import 'package:memoryfun/src/helper/image_mapper.dart';
import 'package:memoryfun/src/helper/sound_player.dart';
import 'package:memoryfun/src/memory/game_type.dart';
import 'package:memoryfun/src/levels/level_info.dart';
import 'package:memoryfun/src/memory/memory_tile.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:memoryfun/src/split_memory/tile_to_hide.dart';
import 'package:riverbloc/riverbloc.dart';

import '../levels/levels.dart';
import '../split_memory/split_memory_set.dart';

part 'memory_bloc.freezed.dart';

@freezed
class MemoryEvent with _$MemoryEvent {
  const factory MemoryEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory MemoryEvent.handleTap(MemoryTile memoryTile) = _HandleTap;
}

@freezed
class MemoryState with _$MemoryState {
  const factory MemoryState.initial() = _Initial;
  const factory MemoryState.loading() = _Loading;
  const factory MemoryState.initialized(SplitMemorySet memorySet) =
      _Initialized;
  const factory MemoryState.loadingResult() = _LoadingResult;
  const factory MemoryState.matchResult(SplitMemorySet memorySet) =
      _MatchResult;
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

  SplitMemorySet splitMemorySet = SplitMemorySet(
    upperTiles: [],
    lowerTiles: [],
  );
  int matchesLeft = 100;
  LevelInfo currentLevel = const LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.food,
    gameType: GameType.sameImage,
  );
  MemoryTile? firstMemoryTile;
  List<TileToHide> hideTiles = [];

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
    //add first part of tiles
    for (int i = 0; i < matchesLeft; i++) {
      pairValues.add(i);
    }

    for (int i = 0; i < event.levelInfo.gameSize; i++) {
      //add second part of tiles
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
        isLowerPart: i < matchesLeft,
        visible: false,
      );
      tile.image = imageMapper.getComplexImage(tile, currentLevel.themeSet);

      if (tile.isLowerPart) {
        splitMemorySet.lowerTiles.add(tile);
      } else {
        splitMemorySet.upperTiles.add(tile);
      }
    }

    emit(MemoryState.initialized(splitMemorySet));
  }

  void _resetGame() {
    firstMemoryTile = null;
    hideTiles = [];
    splitMemorySet = SplitMemorySet(
      upperTiles: [],
      lowerTiles: [],
    );
  }

  bool _prohibitTapInSameArea(MemoryTile currentMemoryTile) {
    if (firstMemoryTile == null) return false;

    return firstMemoryTile!.isLowerPart == currentMemoryTile.isLowerPart;
  }

  Future _handleTap(
    _HandleTap event,
    Emitter<MemoryState> emit,
  ) async {
    emit(const MemoryState.loadingResult());
    if (_prohibitTapInSameArea(event.memoryTile)) {
      return emit(MemoryState.initialized(splitMemorySet));
    }

    soundPlayer.playTap();

    var currentIndex = _currentIndex(event.memoryTile);

    _hidePreviousTiles();
    _setTileImage(
      currentIndex,
      MemoryTile(
        index: currentIndex,
        pairValue: event.memoryTile.pairValue,
        isLowerPart: event.memoryTile.isLowerPart,
        visible: true,
      ),
    );

    if (firstMemoryTile == null) {
      _handleFirstTap(
        currentIndex,
        event.memoryTile.pairValue,
        event.memoryTile.isLowerPart,
      );
      return emit(MemoryState.matchResult(splitMemorySet));
    } else {
      _handleSecondTap(
        currentIndex,
        event.memoryTile,
      );
    }
  }

  int _currentIndex(MemoryTile memoryTile) {
    var index = 0;
    if (memoryTile.isLowerPart) {
      index = splitMemorySet.lowerTiles
          .indexWhere((tile) => tile.index == memoryTile.index);
    } else {
      index = splitMemorySet.upperTiles
          .indexWhere((tile) => tile.index == memoryTile.index);
    }

    return index;
  }

  void _hidePreviousTiles() {
    if (hideTiles.isNotEmpty) {
      for (var hideTile in hideTiles) {
        var isLowerPart = hideTile.isLowerPart;

        _setHideImage(hideTile.index, isLowerPart);
        _setError(hideTile.index, isLowerPart, false);
      }

      hideTiles = [];
    }
  }

  void _handleFirstTap(int currentIndex, int pairValue, bool isLowerPart) {
    firstMemoryTile = MemoryTile(
      index: currentIndex,
      pairValue: pairValue,
      isLowerPart: isLowerPart,
    );

    _setVisibility(currentIndex, isLowerPart, true);
  }

  void _handleSecondTap(int currentIndex, MemoryTile memoryTile) {
    if (firstMemoryTile!.pairValue == memoryTile.pairValue) {
      _handleCorrectMatch(
        currentIndex,
        memoryTile.isLowerPart,
      );
    } else {
      _handleWrongMatch(
        currentIndex,
        memoryTile.isLowerPart,
      );
    }
  }

  void _handleCorrectMatch(int currentIndex, bool isLowerPart) {
    _setVisibility(
      currentIndex,
      isLowerPart,
      true,
    );

    _setCorrect(currentIndex, isLowerPart);
    _setCorrect(firstMemoryTile!.index, firstMemoryTile!.isLowerPart);

    firstMemoryTile = null;

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
          const Duration(seconds: 1),
          () {
            hideTiles = [];
            splitMemorySet = SplitMemorySet(upperTiles: [], lowerTiles: []);

            return appRouter.push(LevelDoneRoute(nextLevel: levels[level + 1]));
          },
        );

        emit(MemoryState.matchResult(splitMemorySet));
      }
    } else {
      soundPlayer.playCorrectMatch();
      emit(MemoryState.matchResult(splitMemorySet));
    }
  }

  void _handleWrongMatch(int currentIndex, bool isLowerPart) {
    soundPlayer.playWrongMatch();

    _setVisibility(
      currentIndex,
      isLowerPart,
      false,
    );
    _setVisibility(
      firstMemoryTile!.index,
      firstMemoryTile!.isLowerPart,
      false,
    );

    _setError(currentIndex, isLowerPart, true);
    _setError(firstMemoryTile!.index, firstMemoryTile!.isLowerPart, true);

    hideTiles.add(TileToHide(index: currentIndex, isLowerPart: isLowerPart));
    hideTiles.add(TileToHide(
        index: firstMemoryTile!.index,
        isLowerPart: firstMemoryTile!.isLowerPart));

    firstMemoryTile = null;
    emit(MemoryState.matchResult(splitMemorySet));
  }

  void _setVisibility(int currentIndex, bool isLowerPart, bool visible) {
    if (isLowerPart) {
      splitMemorySet.lowerTiles[currentIndex].visible = visible;
      if (firstMemoryTile != null) {
        splitMemorySet.lowerTiles[firstMemoryTile!.index].visible = visible;
      }
    } else {
      splitMemorySet.upperTiles[currentIndex].visible = visible;
      if (firstMemoryTile != null) {
        splitMemorySet.upperTiles[firstMemoryTile!.index].visible = visible;
      }
    }
  }

  void _setError(int index, bool isLowerPart, bool hasError) {
    if (isLowerPart) {
      splitMemorySet.lowerTiles[index].hasError = hasError;
    } else {
      splitMemorySet.upperTiles[index].hasError = hasError;
    }
  }

  void _setCorrect(int index, bool isLowerPart) {
    if (isLowerPart) {
      splitMemorySet.lowerTiles[index].isCorrect = true;
      splitMemorySet.lowerTiles[index].hasError = false;
    } else {
      splitMemorySet.upperTiles[index].isCorrect = true;
      splitMemorySet.upperTiles[index].hasError = false;
    }
  }

  void _setTileImage(int index, MemoryTile memoryTile) {
    var image = imageMapper.getComplexImage(
      memoryTile,
      currentLevel.themeSet,
    );

    if (memoryTile.isLowerPart) {
      splitMemorySet.lowerTiles[index].image = image;
    } else {
      splitMemorySet.upperTiles[index].image = image;
    }
  }

  void _setHideImage(int index, bool isLowerPart) {
    var image =
        imageMapper.hideComplexImage(currentLevel.themeSet, isLowerPart);

    if (isLowerPart) {
      splitMemorySet.lowerTiles[index].image = image;
    } else {
      splitMemorySet.upperTiles[index].image = image;
    }
  }
}
