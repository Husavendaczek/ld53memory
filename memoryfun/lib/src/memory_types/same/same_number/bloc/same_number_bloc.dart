import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/utils/calculating/randomizer.dart';
import 'package:riverbloc/riverbloc.dart';

import '../../../../game_type/game_type.dart';
import '../../../../game_type/theme_set.dart';
import '../../../../levels/level_finisher.dart';
import '../../../../levels/level_info.dart';
import '../../../models/number_memory_tile.dart';

part 'same_number_bloc.freezed.dart';

@freezed
class SameNumberEvent with _$SameNumberEvent {
  const factory SameNumberEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory SameNumberEvent.handleTap(int tileIndex, int number) =
      _HandleTap;
}

@freezed
class SameNumberState with _$SameNumberState {
  const factory SameNumberState.initial() = _Initial;
  const factory SameNumberState.loading() = _Loading;
  const factory SameNumberState.initialized(List<NumberMemoryTile> memorySet) =
      _Initialized;
  const factory SameNumberState.loadingResult() = _LoadingResult;
  const factory SameNumberState.matchResult(List<NumberMemoryTile> memorySet) =
      _MatchResult;
}

class SameNumberBloc extends Bloc<SameNumberEvent, SameNumberState> {
  static final provider =
      BlocProvider.autoDispose<SameNumberBloc, SameNumberState>((ref) {
    return SameNumberBloc(
      randomizer: ref.watch(Randomizer.provider),
      levelFinisher: ref.watch(LevelFinisher.provider),
    );
  });

  final Randomizer randomizer;
  final LevelFinisher levelFinisher;

  List<NumberMemoryTile> memoryTiles = [];
  int matchesWon = 0;
  int matchesLeft = 100;
  LevelInfo currentLevel = const LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.numbers,
    gameType: GameType.sameNumber,
  );

  SameNumberBloc({
    required this.randomizer,
    required this.levelFinisher,
  }) : super(const SameNumberState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(_InitGame event, Emitter<SameNumberState> emit) async {
    emit(const SameNumberState.loading());

    _resetGame();
    matchesLeft = event.levelInfo.getMatches();
    currentLevel = event.levelInfo;

    var randomNumbers = [];
    for (int i = 0; i < matchesLeft; i++) {
      var randomNumber = Random().nextInt(100);
      randomNumbers.add(randomNumber);
      randomNumbers.add(randomNumber);
    }

    for (int i = 0; i < event.levelInfo.gameSize; i++) {
      var randomIndex = Random().nextInt(randomNumbers.length);
      var randomNumber = randomNumbers[randomIndex];
      randomNumbers.removeAt(randomIndex);

      var tile = NumberMemoryTile(
        index: i,
        number: randomNumber,
        angle: randomizer.randomTileAngle(),
        isVisible: false,
      );

      memoryTiles.add(tile);
    }

    emit(SameNumberState.initialized(memoryTiles));
  }

  void _resetGame() {
    memoryTiles = [];
    matchesWon = 0;
  }

  Future _handleTap(_HandleTap event, Emitter<SameNumberState> emit) async {
    emit(const SameNumberState.loading());
  }
}
