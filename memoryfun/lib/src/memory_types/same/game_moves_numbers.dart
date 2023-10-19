import 'package:memoryfun/src/memory_types/match_result.dart';
import 'package:memoryfun/src/memory_types/models/memory_tile.dart';
import 'package:riverpod/riverpod.dart';

import '../../game_type/image_mapper.dart';
import '../../sound/sounds.dart';
import '../../utils/calculating/randomizer.dart';

class GameMovesNumbers {
  final ImageMapper imageMapper;
  final Sounds soundPlayer;
  final Randomizer randomizer;

  List<MemoryTile> _memoryTiles = [];
  List<int> _hideTiles = [];
  int? _firstIndex;
  int? _firstNumber;

  static final provider = Provider<GameMovesNumbers>((ref) {
    return GameMovesNumbers(
      imageMapper: ref.watch(ImageMapper.provider),
      soundPlayer: ref.watch(Sounds.provider),
      randomizer: ref.watch(Randomizer.provider),
    );
  });

  GameMovesNumbers({
    required this.imageMapper,
    required this.soundPlayer,
    required this.randomizer,
  });

  void resetGame() {
    _memoryTiles = [];
    _hideTiles = [];

    _firstIndex = null;
    _firstNumber = null;
  }

  MatchResult handleTap(List<MemoryTile> memoryTiles, int index, int number) {
    _memoryTiles = memoryTiles;

    soundPlayer.playTap();

    _hideOtherTiles();

    _setTileVisibilityAndAngle(index, 0, true);

    // first tap
    if (_firstIndex == null) {
      _firstIndex = index;
      _firstNumber = number;

      return MatchResult.firstTap;
    } else {
      var oldIndex = _firstIndex!;

      if (index == oldIndex) {
        // same tile was tapped twice
        return MatchResult.sameTile;
      }

      var matchResult = MatchResult.wrongMatch;

      // correct match
      if (number == _firstNumber) {
        matchResult = MatchResult.correctMatch;

        _setError(index, false);
      }
      // wrong match
      else {
        soundPlayer.playWrongMatch();

        _hideTiles.add(index);
        _hideTiles.add(_firstIndex!);

        _setError(index, true);
      }

      _firstIndex = null;
      _firstNumber = null;

      return matchResult;
    }
  }

  void _hideOtherTiles() {
    if (_hideTiles.isNotEmpty) {
      var randomAngle = randomizer.randomTileAngle();

      for (var hideTileIndex in _hideTiles) {
        _setTileVisibilityAndAngle(
          hideTileIndex,
          randomAngle,
          false,
        );
        _memoryTiles[hideTileIndex].hasError = false;
        _memoryTiles[hideTileIndex].angle = randomAngle;
      }

      _hideTiles = [];
    }
  }

  void _setError(int index, bool hasError) {
    var oldIndex = _firstIndex!;

    _memoryTiles[index].isVisible = !hasError;
    _memoryTiles[oldIndex].isVisible = !hasError;

    _memoryTiles[index].hasError = hasError;
    _memoryTiles[oldIndex].hasError = hasError;

    _memoryTiles[index].isCorrect = !hasError;
    _memoryTiles[oldIndex].isCorrect = !hasError;

    _firstIndex = null;
    _firstNumber = null;
  }

  void _setTileVisibilityAndAngle(int index, double angle, bool isVisible) {
    _memoryTiles[index].angle = angle;
    _memoryTiles[index].isVisible = isVisible;
  }
}
