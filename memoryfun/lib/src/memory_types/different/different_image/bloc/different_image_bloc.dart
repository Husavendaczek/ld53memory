import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/utils/calculating/randomizer.dart';
import 'package:riverbloc/riverbloc.dart';

import '../../../../game_type/game_type.dart';
import '../../../../game_type/image_mapper.dart';
import '../../../../game_type/theme_set.dart';
import '../../../../levels/level_finisher.dart';
import '../../../../levels/level_info.dart';
import '../../../models/memory_tile.dart';
import '../../../../sound/sounds.dart';
import '../models/split_memory_set.dart';
import '../models/tile_to_hide.dart';

part 'different_image_bloc.freezed.dart';

@freezed
class DifferentImageEvent with _$DifferentImageEvent {
  const factory DifferentImageEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory DifferentImageEvent.handleTap(MemoryTile memoryTile) =
      _HandleTap;
}

@freezed
class DifferentImageState with _$DifferentImageState {
  const factory DifferentImageState.initial() = _Initial;
  const factory DifferentImageState.loading() = _Loading;
  const factory DifferentImageState.initialized(SplitMemorySet memorySet) =
      _Initialized;
  const factory DifferentImageState.loadingResult() = _LoadingResult;
  const factory DifferentImageState.matchResult(SplitMemorySet memorySet) =
      _MatchResult;
}

class DifferentImageBloc
    extends Bloc<DifferentImageEvent, DifferentImageState> {
  static final provider =
      BlocProvider.autoDispose<DifferentImageBloc, DifferentImageState>((ref) {
    ref.onDispose(() => ref.bloc.close());

    return DifferentImageBloc(
      imageMapper: ref.watch(ImageMapper.provider),
      levelFinisher: ref.watch(LevelFinisher.provider),
      soundPlayer: ref.watch(Sounds.provider),
      randomizer: ref.watch(Randomizer.provider),
    );
  });

  final ImageMapper imageMapper;
  final LevelFinisher levelFinisher;
  final Sounds soundPlayer;
  final Randomizer randomizer;

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

  DifferentImageBloc({
    required this.imageMapper,
    required this.levelFinisher,
    required this.soundPlayer,
    required this.randomizer,
  }) : super(const DifferentImageState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(_InitGame event, Emitter<DifferentImageState> emit) async {
    emit(const DifferentImageState.loading());

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
        angle: randomizer.randomTileAngle(),
        isLowerPart: i < matchesLeft,
        isVisible: false,
      );
      tile.image = imageMapper.getImage(tile, currentLevel.themeSet);

      if (tile.isLowerPart) {
        splitMemorySet.lowerTiles.add(tile);
      } else {
        splitMemorySet.upperTiles.add(tile);
      }
    }

    emit(DifferentImageState.initialized(splitMemorySet));
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
    Emitter<DifferentImageState> emit,
  ) async {
    emit(const DifferentImageState.loadingResult());
    if (_prohibitTapInSameArea(event.memoryTile)) {
      return emit(DifferentImageState.initialized(splitMemorySet));
    }

    soundPlayer.playTap();

    var currentIndex = _currentIndex(event.memoryTile);

    _hidePreviousTiles();

    var randomAngle = randomizer.randomTileAngle();

    _setTileImage(
      currentIndex,
      MemoryTile(
        index: currentIndex,
        pairValue: event.memoryTile.pairValue,
        angle: 0,
        isLowerPart: event.memoryTile.isLowerPart,
        isVisible: true,
      ),
    );

    if (firstMemoryTile == null) {
      _handleFirstTap(
        currentIndex,
        event.memoryTile.pairValue,
        randomAngle,
        event.memoryTile.isLowerPart,
      );
      return emit(DifferentImageState.matchResult(splitMemorySet));
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

  void _handleFirstTap(
      int currentIndex, int pairValue, double angle, bool isLowerPart) {
    firstMemoryTile = MemoryTile(
      index: currentIndex,
      pairValue: pairValue,
      angle: angle,
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
    _setError(currentIndex, isLowerPart, false);
    _setError(firstMemoryTile!.index, firstMemoryTile!.isLowerPart, false);

    firstMemoryTile = null;

    matchesLeft = matchesLeft - 1;

    var isFinished =
        levelFinisher.goToNextLevelOrFinish(currentLevel.themeSet, matchesLeft);

    if (isFinished) {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          _resetGame();
        },
      );
    }

    emit(DifferentImageState.matchResult(splitMemorySet));
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
    emit(DifferentImageState.matchResult(splitMemorySet));
  }

  void _setVisibility(int currentIndex, bool isLowerPart, bool visible) {
    if (isLowerPart) {
      splitMemorySet.lowerTiles[currentIndex].isVisible = visible;
      if (firstMemoryTile != null) {
        splitMemorySet.lowerTiles[firstMemoryTile!.index].isVisible = visible;
      }
    } else {
      splitMemorySet.upperTiles[currentIndex].isVisible = visible;
      if (firstMemoryTile != null) {
        splitMemorySet.upperTiles[firstMemoryTile!.index].isVisible = visible;
      }
    }
  }

  void _setError(int index, bool isLowerPart, bool hasError) {
    if (isLowerPart) {
      splitMemorySet.lowerTiles[index].hasError = hasError;
      splitMemorySet.lowerTiles[index].isCorrect = !hasError;
    } else {
      splitMemorySet.upperTiles[index].hasError = hasError;
      splitMemorySet.upperTiles[index].isCorrect = !hasError;
    }
  }

  void _setTileImage(int index, MemoryTile memoryTile) {
    var image = imageMapper.getImage(
      memoryTile,
      currentLevel.themeSet,
    );

    if (memoryTile.isLowerPart) {
      splitMemorySet.lowerTiles[index].image = image;
      splitMemorySet.lowerTiles[index].angle = memoryTile.angle;
    } else {
      splitMemorySet.upperTiles[index].image = image;
      splitMemorySet.upperTiles[index].angle = memoryTile.angle;
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
