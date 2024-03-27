import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/levels/texts/level_texts.dart';
import 'package:riverbloc/riverbloc.dart';

import '../../../../game_type/game_type.dart';
import '../../../../game_type/theme_set.dart';
import '../../../../levels/level_finisher.dart';
import '../../../../levels/level_info.dart';
import '../../../../utils/calculating/randomizer.dart';
import '../../../match_result.dart';
import '../../../models/text_memory_tile.dart';
import '../services/game_moves_texts.dart';

part 'same_text_bloc.freezed.dart';

@freezed
class SameTextEvent with _$SameTextEvent {
  const factory SameTextEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory SameTextEvent.handleTap(int tileIndex, String text) =
      _HandleTap;
}

@freezed
class SameTextState with _$SameTextState {
  const factory SameTextState.initial() = _Initial;
  const factory SameTextState.loading() = _Loading;
  const factory SameTextState.initialized(List<TextMemoryTile> memorySet) =
      _Initialized;
  const factory SameTextState.loadingResult() = _LoadingResult;
  const factory SameTextState.matchResult(List<TextMemoryTile> memorySet) =
      _MatchResult;
}

class SameTextBloc extends Bloc<SameTextEvent, SameTextState> {
  static final provider =
      BlocProvider.autoDispose<SameTextBloc, SameTextState>((ref) {
    ref.onDispose(() => ref.bloc.close());

    return SameTextBloc(
      randomizer: ref.watch(Randomizer.provider),
      gameMovesTexts: ref.watch(GameMovesTexts.provider),
      levelFinisher: ref.watch(LevelFinisher.provider),
      levelTexts: ref.watch(LevelTexts.provider),
    );
  });

  final Randomizer randomizer;
  final GameMovesTexts gameMovesTexts;
  final LevelFinisher levelFinisher;
  final LevelTexts levelTexts;

  List<TextMemoryTile> memoryTiles = [];
  int matchesWon = 0;
  int matchesLeft = 100;
  LevelInfo currentLevel = const LevelInfo(
    gameSize: 10,
    themeSet: ThemeSet.texts,
    gameType: GameType.sameText,
  );

  SameTextBloc({
    required this.randomizer,
    required this.gameMovesTexts,
    required this.levelFinisher,
    required this.levelTexts,
  }) : super(const SameTextState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(_InitGame event, Emitter<SameTextState> emit) async {
    emit(const SameTextState.loading());

    _resetGame();
    matchesLeft = event.levelInfo.getMatches();
    currentLevel = event.levelInfo;

    var allTexts = levelTexts.textOfTheme(currentLevel.themeSet);
    allTexts = levelTexts.textOfTheme(currentLevel.themeSet) + allTexts;

    for (int i = 0; i < event.levelInfo.gameSize; i++) {
      var randomIndex = randomizer.randomOutOf(allTexts.length);
      var randomText = allTexts[randomIndex];
      allTexts.removeAt(randomIndex);

      var tile = TextMemoryTile(
        index: i,
        pairValue: i,
        text: randomText,
        angle: randomizer.randomTileAngle(),
      );

      memoryTiles.add(tile);
    }

    emit(SameTextState.initialized(memoryTiles));
  }

  void _resetGame() {
    gameMovesTexts.resetGame();
    memoryTiles = [];
    matchesWon = 0;
  }

  Future _handleTap(_HandleTap event, Emitter<SameTextState> emit) async {
    emit(const SameTextState.loadingResult());

    var matchResult = gameMovesTexts.handleTap(
      memoryTiles,
      event.tileIndex,
      event.text,
    );

    switch (matchResult) {
      case MatchResult.correctMatch:
        _handleCorrectMatch();
        break;
      default:
        emit(SameTextState.matchResult(memoryTiles));
        break;
    }
  }

  void _handleCorrectMatch() {
    matchesWon++;
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

    emit(SameTextState.matchResult(memoryTiles));
  }
}
