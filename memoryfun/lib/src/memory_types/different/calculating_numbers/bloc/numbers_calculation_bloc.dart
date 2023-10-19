import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/memory_types/different/calculating_numbers/models/calculation_memory_tile.dart';
import 'package:memoryfun/src/memory_types/different/calculating_numbers/models/operation.dart';
import 'package:memoryfun/src/memory_types/different/calculating_numbers/models/result_number.dart';
import 'package:memoryfun/src/utils/calculating/randomizer.dart';
import 'package:riverbloc/riverbloc.dart';

import '../../../../game_type/game_type.dart';
import '../../../../game_type/theme_set.dart';
import '../../../../levels/level_finisher.dart';
import '../../../../levels/level_info.dart';
import '../../../match_result.dart';
import '../../../same/game_moves_numbers.dart';

part 'numbers_calculation_bloc.freezed.dart';

@freezed
class NumbersCalculationEvent with _$NumbersCalculationEvent {
  const factory NumbersCalculationEvent.initGame(LevelInfo levelInfo) =
      _InitGame;
  const factory NumbersCalculationEvent.handleTap(
      int tileIndex, int resultNumber) = _HandleTap;
}

@freezed
class NumbersCalculationState with _$NumbersCalculationState {
  const factory NumbersCalculationState.initial() = _Initial;
  const factory NumbersCalculationState.loading() = _Loading;
  const factory NumbersCalculationState.initialized(
      List<CalculationMemoryTile> memorySet) = _Initialized;
  const factory NumbersCalculationState.loadingResult() = _LoadingResult;
  const factory NumbersCalculationState.matchResult(
      List<CalculationMemoryTile> memorySet) = _MatchResult;
}

class NumbersCalculationBloc
    extends Bloc<NumbersCalculationEvent, NumbersCalculationState> {
  static final provider =
      BlocProvider.autoDispose<NumbersCalculationBloc, NumbersCalculationState>(
          (ref) {
    return NumbersCalculationBloc(
      randomizer: ref.watch(Randomizer.provider),
      gameMovesNumbers: ref.watch(GameMovesNumbers.provider),
      levelFinisher: ref.watch(LevelFinisher.provider),
    );
  });

  final Randomizer randomizer;
  final GameMovesNumbers gameMovesNumbers;
  final LevelFinisher levelFinisher;

  List<CalculationMemoryTile> memoryTiles = [];
  int matchesWon = 0;
  int matchesLeft = 100;
  LevelInfo currentLevel = const LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.differentNumbers,
    gameType: GameType.differentNumber,
  );

  NumbersCalculationBloc({
    required this.randomizer,
    required this.gameMovesNumbers,
    required this.levelFinisher,
  }) : super(const NumbersCalculationState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(
      _InitGame event, Emitter<NumbersCalculationState> emit) async {
    emit(const NumbersCalculationState.loading());

    _resetGame();
    matchesLeft = event.levelInfo.getMatches();
    currentLevel = event.levelInfo;

    var resultNumbers = [];

    for (int i = 0; i < event.levelInfo.gameSize; i++) {
      var randomFirstNumber = randomizer.randomOutOfTen();
      var randomSecondNumber = randomizer.randomOutOfTen();
      var operation = randomizer.randomOperation();

      var resultNumber = calculateResult(
        randomFirstNumber,
        randomSecondNumber,
        operation,
      );

      var tile = CalculationMemoryTile(
        index: i,
        firstNumber: randomFirstNumber,
        secondNumber: randomSecondNumber,
        resultNumber: resultNumber,
        angle: randomizer.randomTileAngle(),
        showsText: false,
      );

      if (resultNumbers.contains(resultNumber.number)) {
        i--;
      } else {
        resultNumbers.add(resultNumber.number);
        memoryTiles.add(tile);

        var tilePartner = CalculationMemoryTile(
          index: i + 1,
          firstNumber: randomFirstNumber,
          secondNumber: randomSecondNumber,
          resultNumber: resultNumber,
          angle: randomizer.randomTileAngle(),
          showsText: true,
        );

        memoryTiles.add(tilePartner);
        i++;
      }
    }

    emit(NumbersCalculationState.initialized(memoryTiles));
  }

  ResultNumber calculateResult(int a, int b, Operation operation) {
    switch (operation) {
      case Operation.subtraction:
        if (a > b) {
          return ResultNumber(number: a - b, text: '$a - $b');
        } else {
          return ResultNumber(number: b - a, text: '$b - $a');
        }
      default:
        return ResultNumber(number: a + b, text: '$a + $b');
    }
  }

  void _resetGame() {
    gameMovesNumbers.resetGame();
    memoryTiles = [];
    matchesWon = 0;
  }

  Future _handleTap(
      _HandleTap event, Emitter<NumbersCalculationState> emit) async {
    emit(const NumbersCalculationState.loadingResult());

    var matchResult = gameMovesNumbers.handleTap(
      memoryTiles,
      event.tileIndex,
      event.resultNumber,
    );

    switch (matchResult) {
      case MatchResult.correctMatch:
        _handleCorrectMatch();
        break;
      default:
        emit(NumbersCalculationState.matchResult(memoryTiles));
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

    emit(NumbersCalculationState.matchResult(memoryTiles));
  }
}
