import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/src/levels/level_info.dart';
import 'package:memoryfun/src/levels/texts/level_texts.dart';
import 'package:memoryfun/src/memory_types/models/image_memory_tile.dart';
import 'package:memoryfun/src/memory_types/models/text_memory_tile.dart';
import 'package:riverbloc/riverbloc.dart';
import '../../../../game_type/game_type.dart';
import '../../../../game_type/image_mapper.dart';
import '../../../../game_type/theme_set.dart';
import '../../../../levels/level_finisher.dart';
import '../../../../sound/sound_player.dart';
import '../../../../utils/calculating/randomizer.dart';
import '../../different_image/models/tile_to_hide.dart';
import '../models/image_text_memory_set.dart';

part 'text_image_bloc.freezed.dart';

@freezed
class TextImageEvent with _$TextImageEvent {
  const factory TextImageEvent.initGame(LevelInfo levelInfo) = _InitGame;
  const factory TextImageEvent.handleImageTap(ImageMemoryTile memoryTile) =
      _HandleImageTap;
  const factory TextImageEvent.handleTextTap(TextMemoryTile memoryTile) =
      _HandleTextTap;
}

@freezed
class TextImageState with _$TextImageState {
  const factory TextImageState.initial() = _Initial;
  const factory TextImageState.loading() = _Loading;
  const factory TextImageState.initialized(ImageTextMemorySet memorySet) =
      _Initialized;
  const factory TextImageState.loadingResult() = _LoadingResult;
  const factory TextImageState.matchResult(ImageTextMemorySet memorySet) =
      _MatchResult;
}

class TextImageBloc extends Bloc<TextImageEvent, TextImageState> {
  static final provider =
      BlocProvider.autoDispose<TextImageBloc, TextImageState>((ref) {
    ref.onDispose(() => ref.bloc.close());

    return TextImageBloc(
      imageMapper: ref.watch(ImageMapper.provider),
      levelFinisher: ref.watch(LevelFinisher.provider),
      soundPlayer: ref.watch(SoundPlayer.provider),
      randomizer: ref.watch(Randomizer.provider),
    );
  });

  final ImageMapper imageMapper;
  final LevelFinisher levelFinisher;
  final SoundPlayer soundPlayer;
  final Randomizer randomizer;

  ImageTextMemorySet imageTextMemorySet = ImageTextMemorySet(
    upperTiles: [],
    lowerTiles: [],
  );
  int matchesLeft = 100;
  LevelInfo currentLevel = const LevelInfo(
    gameSize: 12,
    themeSet: ThemeSet.food,
    gameType: GameType.textAndImage,
  );
  ImageMemoryTile? firstImageMemoryTile;
  TextMemoryTile? firstTextMemoryTile;
  List<TileToHide> hideTiles = [];

  TextImageBloc({
    required this.imageMapper,
    required this.levelFinisher,
    required this.soundPlayer,
    required this.randomizer,
  }) : super(const TextImageState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleImageTap>(_handleImageTap);
    on<_HandleTextTap>(_handleTextTap);
  }

  Future _initGame(_InitGame event, Emitter<TextImageState> emit) async {
    emit(const TextImageState.loading());

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

      var randomIndex = randomizer.randomOutOf(pairValues.length);
      var value = pairValues[randomIndex];
      pairValues.removeAt(randomIndex);

      var isLowerPart = i < matchesLeft;

      var text = levelTexts[currentLevel.themeSet]?[value];
      text ??= '';

      if (isLowerPart) {
        var tile = TextMemoryTile(
          index: i,
          text: text,
          pairValue: value,
          angle: randomizer.randomTileAngle(),
          isVisible: false,
        );

        imageTextMemorySet.lowerTiles.add(tile);
      } else {
        var tile = ImageMemoryTile(
          index: i,
          pairValue: value,
          angle: randomizer.randomTileAngle(),
          isLowerPart: isLowerPart,
          isVisible: false,
        );
        tile.image = imageMapper.getImage(tile, currentLevel.themeSet);
        imageTextMemorySet.upperTiles.add(tile);
      }
    }

    emit(TextImageState.initialized(imageTextMemorySet));
  }

  void _resetGame() {
    firstImageMemoryTile = null;
    firstTextMemoryTile = null;
    hideTiles = [];
    imageTextMemorySet = ImageTextMemorySet(
      upperTiles: [],
      lowerTiles: [],
    );
  }

  bool _prohibitTapInSameImageArea(ImageMemoryTile currentMemoryTile) {
    if (firstImageMemoryTile == null) return false;

    return true;
  }

  int _currentImageIndex(ImageMemoryTile memoryTile) =>
      imageTextMemorySet.upperTiles
          .indexWhere((tile) => tile.index == memoryTile.index);

  Future _handleImageTap(
      _HandleImageTap event, Emitter<TextImageState> emit) async {
    emit(const TextImageState.loadingResult());
    if (_prohibitTapInSameImageArea(event.memoryTile)) {
      return emit(TextImageState.initialized(imageTextMemorySet));
    }

    soundPlayer.playTap();

    var currentIndex = _currentImageIndex(event.memoryTile);

    _hidePreviousTiles();

    var randomAngle = randomizer.randomTileAngle();

    _setTileImage(
      currentIndex,
      ImageMemoryTile(
        index: currentIndex,
        pairValue: event.memoryTile.pairValue,
        angle: 0,
        isLowerPart: event.memoryTile.isLowerPart,
        isVisible: true,
      ),
    );

    if (firstTextMemoryTile == null) {
      _handleFirstImageTap(
        currentIndex,
        event.memoryTile.pairValue,
        randomAngle,
        event.memoryTile.isLowerPart,
      );
      return emit(TextImageState.matchResult(imageTextMemorySet));
    } else {
      _handleSecondTap(
        currentIndex,
        event.memoryTile,
      );
    }
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

  void _handleFirstImageTap(
      int currentIndex, int pairValue, double angle, bool isLowerPart) {
    firstImageMemoryTile = ImageMemoryTile(
      index: currentIndex,
      pairValue: pairValue,
      angle: angle,
      isLowerPart: isLowerPart,
    );

    _setVisibility(currentIndex, isLowerPart, true);
  }

  void _handleSecondTap(int currentIndex, ImageMemoryTile memoryTile) {
    if (firstTextMemoryTile!.pairValue == memoryTile.pairValue) {
      _handleCorrectMatch(
        currentIndex,
        false,
      );
    } else {
      _handleWrongMatch(
        currentIndex,
        false,
      );
    }
  }

  void _handleCorrectMatch(int currentIndex, bool isLowerPart) {
    _setError(currentIndex, isLowerPart, false);
    if (firstTextMemoryTile != null) {
      _setError(firstTextMemoryTile!.index, true, false);
    }
    if (firstImageMemoryTile != null) {
      _setError(firstImageMemoryTile!.index, false, false);
    }

    firstTextMemoryTile = null;
    firstImageMemoryTile = null;

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

    emit(TextImageState.matchResult(imageTextMemorySet));
  }

  void _handleWrongMatch(int currentIndex, bool isLowerPart) {
    soundPlayer.playWrongMatch();

    _setVisibility(
      currentIndex,
      isLowerPart,
      false,
    );
    _setError(currentIndex, isLowerPart, true);

    if (firstTextMemoryTile != null) {
      _setTextVisibility(
        firstTextMemoryTile!.index,
        false,
      );

      _setError(firstTextMemoryTile!.index, true, true);
      hideTiles.add(
        TileToHide(
          index: firstTextMemoryTile!.index,
          isLowerPart: true,
        ),
      );
    }
    if (firstImageMemoryTile != null) {
      _setVisibility(
        firstImageMemoryTile!.index,
        false,
        false,
      );
      _setError(firstImageMemoryTile!.index, false, true);
      hideTiles.add(
        TileToHide(
          index: firstImageMemoryTile!.index,
          isLowerPart: false,
        ),
      );
    }

    hideTiles.add(TileToHide(index: currentIndex, isLowerPart: isLowerPart));

    firstImageMemoryTile = null;
    firstTextMemoryTile = null;

    emit(TextImageState.matchResult(imageTextMemorySet));
  }

  void _setVisibility(int currentIndex, bool isLowerPart, bool visible) {
    imageTextMemorySet.upperTiles[currentIndex].isVisible = visible;
    if (firstImageMemoryTile != null) {
      imageTextMemorySet.upperTiles[firstImageMemoryTile!.index].isVisible =
          visible;
    }
    if (firstTextMemoryTile != null) {
      imageTextMemorySet.lowerTiles[firstTextMemoryTile!.index].isVisible =
          visible;
    }
  }

  void _setError(int index, bool isLowerPart, bool hasError) {
    if (isLowerPart) {
      imageTextMemorySet.lowerTiles[index].hasError = hasError;
      imageTextMemorySet.lowerTiles[index].isCorrect = false;
    } else {
      imageTextMemorySet.upperTiles[index].hasError = hasError;
      imageTextMemorySet.upperTiles[index].isCorrect = !hasError;
    }
  }

  void _setTileImage(int index, ImageMemoryTile memoryTile) {
    var image = imageMapper.getImage(
      memoryTile,
      currentLevel.themeSet,
    );

    imageTextMemorySet.upperTiles[index].image = image;
    imageTextMemorySet.upperTiles[index].angle = memoryTile.angle;
  }

  void _setHideImage(int index, bool isLowerPart) {
    var image =
        imageMapper.hideComplexImage(currentLevel.themeSet, isLowerPart);

    if (isLowerPart) {
      imageTextMemorySet.lowerTiles[index].isVisible = false;
      imageTextMemorySet.lowerTiles[index].hasError = false;
      imageTextMemorySet.lowerTiles[index].isCorrect = false;
      var randomAngle = randomizer.randomTileAngle();
      imageTextMemorySet.lowerTiles[index].angle = randomAngle;
    } else {
      imageTextMemorySet.upperTiles[index].image = image;
      var randomAngle = randomizer.randomTileAngle();
      imageTextMemorySet.upperTiles[index].angle = randomAngle;
    }
  }

  Future _handleTextTap(
      _HandleTextTap event, Emitter<TextImageState> emit) async {
    emit(const TextImageState.loadingResult());
    if (_prohibitTapInSameTextArea(event.memoryTile)) {
      return emit(TextImageState.initialized(imageTextMemorySet));
    }

    soundPlayer.playTap();

    var currentIndex = _currentTextIndex(event.memoryTile);

    _hidePreviousTiles();

    var randomAngle = randomizer.randomTileAngle();

    _resetTextAngle(currentIndex);

    if (firstImageMemoryTile == null) {
      _handleFirstTextTap(
        currentIndex,
        randomAngle,
        event.memoryTile.text,
        event.memoryTile.pairValue,
      );
      return emit(TextImageState.matchResult(imageTextMemorySet));
    } else {
      _handleSecondTextTap(
        currentIndex,
        event.memoryTile,
      );
    }
  }

  bool _prohibitTapInSameTextArea(TextMemoryTile currentMemoryTile) {
    if (firstTextMemoryTile == null) return false;

    return true;
  }

  int _currentTextIndex(TextMemoryTile memoryTile) =>
      imageTextMemorySet.lowerTiles
          .indexWhere((tile) => tile.index == memoryTile.index);

  void _resetTextAngle(int index) {
    // var image = imageMapper.getImage(
    //   memoryTile,
    //   currentLevel.themeSet,
    // );

    // imageTextMemorySet.lowerTiles[index].image = image;
    imageTextMemorySet.lowerTiles[index].isVisible = true;
    imageTextMemorySet.lowerTiles[index].angle = 0;
  }

  void _handleFirstTextTap(
      int currentIndex, double angle, String text, int pairValue) {
    firstTextMemoryTile = TextMemoryTile(
      index: currentIndex,
      text: text,
      pairValue: pairValue,
      angle: angle,
    );

    _setTextVisibility(currentIndex, true);
  }

  void _setTextVisibility(int currentIndex, bool visible) {
    imageTextMemorySet.lowerTiles[currentIndex].isVisible = visible;
    if (firstTextMemoryTile != null) {
      imageTextMemorySet.lowerTiles[firstTextMemoryTile!.index].isVisible =
          visible;
    }

    if (firstImageMemoryTile != null) {
      imageTextMemorySet.upperTiles[firstImageMemoryTile!.index].isVisible =
          visible;
    }
  }

  void _handleSecondTextTap(int currentIndex, TextMemoryTile memoryTile) {
    if (firstImageMemoryTile!.pairValue == memoryTile.pairValue) {
      _handleCorrectMatch(
        currentIndex,
        true,
      );
    } else {
      _handleWrongMatch(
        currentIndex,
        true,
      );
    }
  }
}
