import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:memoryfun/gen/assets.gen.dart';
import 'package:memoryfun/src/memory/image_mapper.dart';
import 'package:memoryfun/src/memory/memory_tile.dart';
import 'package:memoryfun/src/memory/theme_set.dart';
import 'package:riverbloc/riverbloc.dart';

part 'memory_bloc.freezed.dart';

@freezed
class MemoryEvent with _$MemoryEvent {
  const factory MemoryEvent.initGame(int gameSize, ThemeSet themeSet) =
      _InitGame;
  const factory MemoryEvent.handleTap(int tileIndex, int pairValue) =
      _HandleTap;
}

@freezed
class MemoryState with _$MemoryState {
  const factory MemoryState.initial() = _Initial;
  const factory MemoryState.loading() = _Loading;
  const factory MemoryState.initialized(List<MemoryTile> memorySet) =
      _Initialized;
  const factory MemoryState.loadingResult() = _LoadingResult;
  const factory MemoryState.matchResult(List<MemoryTile> memorySet) =
      _MatchResult;
  const factory MemoryState.winGame() = _WinGame;
  const factory MemoryState.looseGame() = _looseGame;
}

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  static final provider =
      BlocProvider.autoDispose<MemoryBloc, MemoryState>((ref) {
    ref.onDispose(() => ref.bloc.close());

    return MemoryBloc(
      imageMapper: ref.watch(ImageMapper.provider),
    );
  });

  final ImageMapper imageMapper;
  List<MemoryTile> memoryTiles = [];
  ThemeSet? themeSet;
  int? firstIndex;
  int? firstPairValue;
  List<int> hideTiles = [];

  MemoryBloc({
    required this.imageMapper,
  }) : super(const MemoryState.initial()) {
    on<_InitGame>(_initGame);
    on<_HandleTap>(_handleTap);
  }

  Future _initGame(_InitGame event, Emitter<MemoryState> emit) async {
    emit(const MemoryState.loading());

    firstIndex = null;
    firstPairValue = null;
    hideTiles = [];
    memoryTiles = [];

    themeSet = event.themeSet;
    var pairValues = [];
    for (int i = 0; i < event.gameSize / 2; i++) {
      pairValues.add(i);
      pairValues.add(i);
    }

    for (int i = 0; i < event.gameSize; i++) {
      var randomIndex = Random().nextInt(pairValues.length);
      var value = pairValues[randomIndex];
      pairValues.removeAt(randomIndex);

      var tile = MemoryTile(
        index: i,
        pairValue: value,
        image: Assets.food.background,
        visible: false,
      );

      memoryTiles.add(tile);
    }

    emit(MemoryState.initialized(memoryTiles));
  }

  Future _handleTap(
    _HandleTap event,
    Emitter<MemoryState> emit,
  ) async {
    emit(const MemoryState.loadingResult());
    var index = memoryTiles.indexWhere((tile) => tile.index == event.tileIndex);
    var oldIndex = memoryTiles.indexWhere((tile) => tile.index == firstIndex);

    if (hideTiles.isNotEmpty) {
      for (var hideTileIndex in hideTiles) {
        _setTileVisibility(hideTileIndex, event.pairValue, false);
      }

      hideTiles = [];
    }

    _setTileVisibility(index, event.pairValue, true);

    if (firstIndex != null) {
      if (firstIndex == event.tileIndex) {
        return;
      } else {
        if (firstPairValue == event.pairValue) {
          memoryTiles[index].visible = true;
          memoryTiles[oldIndex].visible = true;

          firstIndex = null;
          firstPairValue = null;
          emit(MemoryState.matchResult(memoryTiles));
          return;
        } else {
          memoryTiles[index].visible = false;
          memoryTiles[oldIndex].visible = false;

          hideTiles.add(index);
          hideTiles.add(oldIndex);

          firstIndex = null;
          firstPairValue = null;
          emit(MemoryState.matchResult(memoryTiles));
        }
      }
    } else {
      firstIndex = event.tileIndex;
      firstPairValue = event.pairValue;
    }
    emit(MemoryState.matchResult(memoryTiles));
  }

  void _setTileVisibility(int index, int pairValue, bool visible) {
    memoryTiles[index].image = imageMapper.map(themeSet!, pairValue, visible);
  }
}
