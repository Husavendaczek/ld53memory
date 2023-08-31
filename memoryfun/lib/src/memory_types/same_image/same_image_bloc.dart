import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/utils/app_router.dart';
import 'package:memoryfun/src/game_type/image_mapper.dart';
import 'package:memoryfun/src/sound/sound_player.dart';
import 'package:memoryfun/src/levels/level_info.dart';
import 'package:memoryfun/src/game_type/theme_set.dart';
import 'package:riverbloc/riverbloc.dart';

import '../../memory/memory_tile.dart';
import '../../levels/levels.dart';
import '../../game_type/game_type.dart';

part 'same_image_bloc.freezed.dart';

@freezed
class SameImageEvent with _$SameImageEvent {
  const factory SameImageEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory SameImageEvent.handleTap(int tileIndex, int pairValue) =
      _HandleTap;
}

@freezed
class SameImageState with _$SameImageState {
  const factory SameImageState.initial() = _Initial;
  const factory SameImageState.loading() = _Loading;
  const factory SameImageState.initialized(List<MemoryTile> memorySet) =
      _Initialized;
  const factory SameImageState.loadingResult() = _LoadingResult;
  const factory SameImageState.matchResult(List<MemoryTile> memorySet) =
      _MatchResult;
}

class SameImageBloc extends Bloc<SameImageEvent, SameImageState> {
  static final provider =
      BlocProvider.autoDispose<SameImageBloc, SameImageState>((ref) {
    ref.onDispose(() => ref.bloc.close());

    return SameImageBloc(
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

  SameImageBloc({
    required this.imageMapper,
    required this.appRouter,
    required this.soundPlayer,
  }) : super(const SameImageState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(_InitGame event, Emitter<SameImageState> emit) async {
    emit(const SameImageState.loading());
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

      var tile = MemoryTile(
        index: i,
        pairValue: value,
        isVisible: false,
      );
      tile.image = imageMapper.getImage(tile, currentLevel.themeSet);

      memoryTiles.add(tile);
    }

    emit(SameImageState.initialized(memoryTiles));
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
    Emitter<SameImageState> emit,
  ) async {
    emit(const SameImageState.loadingResult());
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
        emit(SameImageState.matchResult(memoryTiles));
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
      emit(SameImageState.matchResult(memoryTiles));
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
          const Duration(seconds: 1),
          () {
            firstIndex = null;
            firstPairValue = null;
            hideTiles = [];
            memoryTiles = [];
            matchesWon = 0;

            return appRouter.push(LevelDoneRoute(nextLevel: levels[level + 1]));
          },
        );

        emit(SameImageState.matchResult(memoryTiles));
      }
    } else {
      soundPlayer.playCorrectMatch();
      emit(SameImageState.matchResult(memoryTiles));
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
    emit(SameImageState.matchResult(memoryTiles));
  }

  void _setTileVisibility(int index, MemoryTile memoryTile) {
    memoryTiles[index].image = imageMapper.getImage(
      memoryTile,
      currentLevel.themeSet,
    );
  }
}
