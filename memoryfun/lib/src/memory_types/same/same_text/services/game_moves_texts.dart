import 'package:memoryfun/src/memory_types/match_result.dart';
import 'package:memoryfun/src/memory_types/models/memory_tile.dart';
import 'package:memoryfun/src/sound/sound_player.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../utils/calculating/randomizer.dart';

class GameMovesTexts {
  final SoundPlayer soundPlayer;
  final Randomizer randomizer;

  List<MemoryTile> _memoryTiles = [];
  List<int> _hideTiles = [];
  int? _firstIndex;
  String? _firstText;

  static final provider = Provider<GameMovesTexts>((ref) {
    return GameMovesTexts(
      soundPlayer: ref.watch(SoundPlayer.provider),
      randomizer: ref.watch(Randomizer.provider),
    );
  });

  GameMovesTexts({
    required this.soundPlayer,
    required this.randomizer,
  });

  void resetGame() {
    _memoryTiles = [];
    _hideTiles = [];

    _firstIndex = null;
    _firstText = null;
  }

  MatchResult handleTap(List<MemoryTile> memoryTiles, int index, String text) {
    _memoryTiles = memoryTiles;

    soundPlayer.playTap();

    _hideOtherTiles();

    _setTileVisibilityAndAngle(index, 0, true);

    // first tap
    if (_firstIndex == null) {
      _firstIndex = index;
      _firstText = text;

      return MatchResult.firstTap;
    } else {
      var oldIndex = _firstIndex!;

      if (index == oldIndex) {
        // same tile was tapped twice
        return MatchResult.sameTile;
      }

      var matchResult = MatchResult.wrongMatch;

      // correct match
      if (text == _firstText) {
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
      _firstText = null;

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
    _firstText = null;
  }

  void _setTileVisibilityAndAngle(int index, double angle, bool isVisible) {
    _memoryTiles[index].angle = angle;
    _memoryTiles[index].isVisible = isVisible;
  }
}
