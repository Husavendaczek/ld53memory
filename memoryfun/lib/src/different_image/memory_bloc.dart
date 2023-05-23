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
import '../split_memory/split_memory_set.dart';

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
  const factory MemoryState.initialized(SplitMemorySet memorySet) =
      _Initialized;
  const factory MemoryState.loadingResult() = _LoadingResult;
  const factory MemoryState.matchResult(SplitMemorySet memorySet) =
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
  int? firstIndex;
  int? firstPairValue;
  Map<int, bool> hideTiles = {};

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
      tile.image = imageMapper.mapDifferentImage(tile, currentLevel.themeSet);

      if (tile.isLowerPart) {
        splitMemorySet.lowerTiles.add(tile);
      } else {
        splitMemorySet.upperTiles.add(tile);
      }
    }

    emit(MemoryState.initialized(splitMemorySet));
  }

  void _resetGame() {
    firstIndex = null;
    firstPairValue = null;
    hideTiles = {};
    splitMemorySet = SplitMemorySet(
      upperTiles: [],
      lowerTiles: [],
    );
  }

  int _currentIndex(int tileIndex, bool isDeliverer) {
    var index = 0;
    if (isDeliverer) {
      index = splitMemorySet.lowerTiles
          .indexWhere((tile) => tile.index == tileIndex);
    } else {
      index = splitMemorySet.upperTiles
          .indexWhere((tile) => tile.index == tileIndex);
    }

    return index;
  }

  void _hidePreviousTiles(int pairValue) {
    if (hideTiles.isNotEmpty) {
      for (var hideTileIndex in hideTiles.keys) {
        print('hide tile index $hideTileIndex');
        var isLowerPart = hideTiles[hideTileIndex];
        print('bool is $isLowerPart');
        _setTileImage(
          isLowerPart!,
          hideTileIndex,
          MemoryTile(
            index: hideTileIndex,
            pairValue: pairValue,
            isLowerPart: isLowerPart,
            visible: false,
          ),
        );

        _setError(isLowerPart, false, hideTileIndex);
      }

      hideTiles = {};
    }
  }

  Future _handleTap(
    _HandleTap event,
    Emitter<MemoryState> emit,
  ) async {
    emit(const MemoryState.loadingResult());
    soundPlayer.playTap();

    var currentIndex = _currentIndex(
      event.tileIndex,
      event.isDeliverer,
    );
    print('--------------------------------------');
    print('current index: $currentIndex');
    print('is deliverer: ${event.isDeliverer}');
    print('first index: $firstIndex');

    _hidePreviousTiles(event.pairValue);
    _setTileImage(
      event.isDeliverer,
      currentIndex,
      MemoryTile(
        index: currentIndex,
        pairValue: event.pairValue,
        isLowerPart: event.isDeliverer,
        visible: true,
      ),
    );

    if (firstIndex != null) {
      _handleSecondTap(currentIndex, event.pairValue, event.isDeliverer);
    } else {
      _handleFirstTap(currentIndex, event.pairValue);
    }
  }

  void _handleFirstTap(int currentIndex, int pairValue) {
    print('first index was null and is now set to');
    firstIndex = currentIndex;
    firstPairValue = pairValue;
    print(firstIndex);
    emit(MemoryState.matchResult(splitMemorySet));
  }

  void _handleSecondTap(int currentIndex, int pairValue, bool isLowerPart) {
    if (firstPairValue == pairValue) {
      print('is correct match');
      _handleCorrectMatch(
        currentIndex,
        isLowerPart,
      );
    } else {
      print('wrong match');
      _handleWrongMatch(
        currentIndex,
        isLowerPart,
      );
    }
  }

  void _handleCorrectMatch(int index, bool isDeliverer) {
    _setVisibility(
      index,
      isDeliverer,
      true,
    );

    firstIndex = null;
    firstPairValue = null;

    matchesLeft = matchesLeft - 1;

    if (matchesLeft == 0) {
      var level =
          levels.indexWhere((lvl) => lvl.themeSet == currentLevel.themeSet);
      if (level == levels.length - 1) {
        soundPlayer.playWinGame();

        appRouter.push(const WonRoute());
      } else {
        soundPlayer.playWinLevel();

        hideTiles = {};
        splitMemorySet = SplitMemorySet(upperTiles: [], lowerTiles: []);
        currentLevel = levels[level + 1];

        emit(MemoryState.nextLevel(levels[level + 1]));
      }
    } else {
      soundPlayer.playCorrectMatch();
      emit(MemoryState.matchResult(splitMemorySet));
    }
  }

  void _handleWrongMatch(int index, bool isDeliverer) {
    soundPlayer.playWrongMatch();

    _setVisibility(
      index,
      isDeliverer,
      false,
    );

    _setError(isDeliverer, true, index);
    _setError(!isDeliverer, true, firstIndex!);

    var tilesToHide = <int, bool>{
      index: isDeliverer,
      firstIndex!: !isDeliverer
    };
    hideTiles.addEntries(tilesToHide.entries);

    firstIndex = null;
    firstPairValue = null;
    emit(MemoryState.matchResult(splitMemorySet));
  }

  void _setVisibility(int currentIndex, bool isDeliverer, bool visible) {
    if (isDeliverer) {
      splitMemorySet.lowerTiles[currentIndex].visible = visible;
      if (firstIndex != null) {
        splitMemorySet.lowerTiles[firstIndex!].visible = visible;
      }
    } else {
      splitMemorySet.upperTiles[currentIndex].visible = visible;
      if (firstIndex != null) {
        splitMemorySet.upperTiles[firstIndex!].visible = visible;
      }
    }
  }

  void _setError(bool isDeliverer, bool hasError, int index) {
    if (isDeliverer) {
      splitMemorySet.lowerTiles[index].hasError = hasError;
    } else {
      splitMemorySet.upperTiles[index].hasError = hasError;
    }
  }

  void _setTileImage(bool isDeliverer, int index, MemoryTile memoryTile) {
    var image = imageMapper.mapDifferentImage(
      memoryTile,
      currentLevel.themeSet,
    );

    if (isDeliverer) {
      splitMemorySet.lowerTiles[index].image = image;
    } else {
      splitMemorySet.upperTiles[index].image = image;
    }
  }
}
