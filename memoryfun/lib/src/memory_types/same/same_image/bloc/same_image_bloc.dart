import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/memory_types/game_moves.dart';
import 'package:memoryfun/src/memory_types/match_result.dart';
import 'package:memoryfun/src/utils/calculating/randomizer.dart';
import 'package:riverbloc/riverbloc.dart';

import '../../../../game_type/image_mapper.dart';
import '../../../../game_type/theme_set.dart';
import '../../../../levels/level_info.dart';
import '../../../models/memory_tile.dart';
import '../../../../levels/levels.dart';
import '../../../../game_type/game_type.dart';
import '../../../../sound/sounds.dart';
import '../../../../utils/routing/app_router.dart';

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
        gameMoves: ref.watch(GameMoves.provider),
        soundPlayer: ref.watch(Sounds.provider),
        randomizer: ref.watch(Randomizer.provider));
  });

  final ImageMapper imageMapper;
  final AppRouter appRouter;
  final GameMoves gameMoves;
  final Sounds soundPlayer;
  final Randomizer randomizer;

  List<MemoryTile> memoryTiles = [];
  int matchesWon = 0;
  int matchesLeft = 100;
  LevelInfo currentLevel = const LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.food,
    gameType: GameType.sameImage,
  );

  SameImageBloc({
    required this.imageMapper,
    required this.appRouter,
    required this.gameMoves,
    required this.soundPlayer,
    required this.randomizer,
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
        angle: randomizer.randomTileAngle(),
        isVisible: false,
      );
      tile.image = imageMapper.getImage(tile, currentLevel.themeSet);

      memoryTiles.add(tile);
    }

    emit(SameImageState.initialized(memoryTiles));
  }

  void _resetGame() {
    gameMoves.resetGame();

    memoryTiles = [];
    matchesWon = 0;
  }

  Future _handleTap(
    _HandleTap event,
    Emitter<SameImageState> emit,
  ) async {
    emit(const SameImageState.loadingResult());

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
        emit(SameImageState.matchResult(memoryTiles));
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
          const Duration(seconds: 1),
          () {
            _resetGame();

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
}
