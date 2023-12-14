import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memoryfun/src/game_type/theme_set.dart';

import 'sounds.dart';

class SoundPlayer {
  final Sounds sounds;
  bool isMusicOn;
  bool isSoundEffectsOn;

  SoundPlayer({
    required this.sounds,
    this.isMusicOn = true,
    this.isSoundEffectsOn = true,
  });

  static final provider = Provider<SoundPlayer>(
    (ref) => SoundPlayer(
      sounds: ref.watch(
        Sounds.provider,
      ),
    ),
  );

  void turnMusicOn(bool setMusicOn) {
    isMusicOn = setMusicOn;

    if (!isMusicOn) {
      sounds.stopMusic();
    }
  }

  void turnSoundEffectsOn(bool setSoundOn) {
    isSoundEffectsOn = setSoundOn;
  }

  void playTap() {
    if (isSoundEffectsOn) {
      sounds.playTap();
    }
  }

  void playCorrectMatch() {
    if (isSoundEffectsOn) {
      sounds.playCorrectMatch();
    }
  }

  void playWrongMatch() {
    if (isSoundEffectsOn) {
      sounds.playWrongMatch();
    }
  }

  void playWinGame() {
    if (isSoundEffectsOn) {
      sounds.playWinGame();
    }
  }

  void playWinLevel() {
    if (isSoundEffectsOn) {
      sounds.playWinLevel();
    }
  }

  void playMusic(ThemeSet themeSet) {
    if (isMusicOn) {
      sounds.playMusic(themeSet);
    }
  }
}
