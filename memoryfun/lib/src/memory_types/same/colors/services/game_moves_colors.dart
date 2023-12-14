import 'package:flutter/material.dart';
import 'package:memoryfun/src/memory_types/match_result.dart';
import 'package:memoryfun/src/memory_types/models/memory_tile.dart';
import 'package:memoryfun/src/sound/sound_player.dart';
import 'package:riverpod/riverpod.dart';

import '../../../../utils/calculating/randomizer.dart';

class GameMovesColors {
  final SoundPlayer soundPlayer;
  final Randomizer randomizer;

  List<MemoryTile> _memoryTiles = [];
  List<int> _hideTiles = [];
  int? _firstIndex;
  Color? _firstColor;

  static final provider = Provider<GameMovesColors>((ref) {
    return GameMovesColors(
      soundPlayer: ref.watch(SoundPlayer.provider),
      randomizer: ref.watch(Randomizer.provider),
    );
  });

  GameMovesColors({
    required this.soundPlayer,
    required this.randomizer,
  });

  void resetGame() {
    _memoryTiles = [];
    _hideTiles = [];

    _firstIndex = null;
    _firstColor = null;
  }

  MatchResult handleTap(List<MemoryTile> memoryTiles, int index, Color color) {
    _memoryTiles = memoryTiles;

    soundPlayer.playTap();

    _hideOtherTiles();

    _setTileVisibilityAndAngle(index, 0, true);

    // first tap
    if (_firstIndex == null) {
      _firstIndex = index;
      _firstColor = color;

      return MatchResult.firstTap;
    } else {
      var oldIndex = _firstIndex!;

      if (index == oldIndex) {
        // same tile was tapped twice
        return MatchResult.sameTile;
      }

      var matchResult = MatchResult.wrongMatch;

      // correct match
      if (color == _firstColor) {
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
      _firstColor = null;

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
    _firstColor = null;
  }

  void _setTileVisibilityAndAngle(int index, double angle, bool isVisible) {
    _memoryTiles[index].angle = angle;
    _memoryTiles[index].isVisible = isVisible;
  }
}
