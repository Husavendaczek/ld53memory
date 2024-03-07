import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/game_type/game_type.dart';

import '../../utils/theme/app_color_mode.dart';

class MemoryTypeState {
  GameType myGameType;

  MemoryTypeState({this.myGameType = GameType.noSelection});

  static final provider = Provider<MemoryTypeState>((ref) {
    return MemoryTypeState();
  });

  void setGameType(GameType gameType) {
    myGameType = gameType;
  }

  Image gameTypeIcon(WidgetRef ref) {
    return Image(
      image: AssetImage(
          'assets/${ref.watch(AppColorMode.provider).appColorStyle.name}/gameTypeThumbnails/${myGameType.name}_quer.png'),
      width: 76,
      height: 44,
    );
  }
}
