import 'package:memoryfun/src/game_type/theme_set.dart';
import 'package:memoryfun/src/memory_types/match_result.dart';
import 'package:riverpod/riverpod.dart';

import '../game_type/image_mapper.dart';
import '../sound/sounds.dart';
import '../utils/calculating/randomizer.dart';
import 'models/image_memory_tile.dart';

class GameMoves {
  final ImageMapper imageMapper;
  final Sounds soundPlayer;
  final Randomizer randomizer;

  late ThemeSet _themeSet;
  List<ImageMemoryTile> _memoryTiles = [];
  List<int> _hideTiles = [];
  int? _firstIndex;
  int? _firstPairValue;

  static final provider = Provider<GameMoves>((ref) {
    return GameMoves(
      imageMapper: ref.watch(ImageMapper.provider),
      soundPlayer: ref.watch(Sounds.provider),
      randomizer: ref.watch(Randomizer.provider),
    );
  });

  GameMoves({
    required this.imageMapper,
    required this.soundPlayer,
    required this.randomizer,
  });

  void resetGame() {
    _memoryTiles = [];
    _hideTiles = [];

    _firstIndex = null;
    _firstPairValue = null;
  }

  MatchResult handleTap(
    ThemeSet themeSet,
    List<ImageMemoryTile> memoryTiles,
    int index,
    int pairValue,
  ) {
    _themeSet = themeSet;
    _memoryTiles = memoryTiles;

    soundPlayer.playTap();

    _hideOtherTiles(pairValue);

    _setTileVisibilityAndAngle(
      index,
      ImageMemoryTile(
        index: index,
        pairValue: pairValue,
        angle: 0,
        isVisible: true,
      ),
    );

    // first tap
    if (_firstIndex == null) {
      _firstIndex = index;
      _firstPairValue = pairValue;

      return MatchResult.firstTap;
    } else {
      var oldIndex = _firstIndex!;

      if (index == oldIndex) {
        // same tile was tapped twice
        return MatchResult.sameTile;
      }

      var matchResult = MatchResult.wrongMatch;

      // correct match
      if (pairValue == _firstPairValue) {
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
      _firstPairValue = null;

      return matchResult;
    }
  }

  void _hideOtherTiles(
    int pairValue,
  ) {
    if (_hideTiles.isNotEmpty) {
      var randomAngle = randomizer.randomTileAngle();

      for (var hideTileIndex in _hideTiles) {
        _setTileVisibilityAndAngle(
          hideTileIndex,
          ImageMemoryTile(
            index: 0,
            pairValue: pairValue,
            angle: randomAngle,
            isVisible: false,
          ),
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
    _firstPairValue = null;
  }

  void _setTileVisibilityAndAngle(
    int index,
    ImageMemoryTile memoryTile,
  ) {
    _memoryTiles[index].image = imageMapper.getImage(
      memoryTile,
      _themeSet,
    );
    _memoryTiles[index].angle = memoryTile.angle;
    _memoryTiles[index].isVisible = memoryTile.isVisible;
  }
}
