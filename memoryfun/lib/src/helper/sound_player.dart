import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SoundPlayer {
  static final provider = Provider<SoundPlayer>((ref) => SoundPlayer());

  void playTap() {
    var sounds = [
      'sounds/tap1.mp3',
      'sounds/tap2.mp3',
      'sounds/tap3.mp3',
    ];
    _playSilentRandomSound(sounds);
  }

  void playCorrectMatch() {
    var sounds = [
      'sounds/correctmatch1.mp3',
      'sounds/correctmatch2.mp3',
      'sounds/correctmatch3.mp3',
    ];
    _playRandomSound(sounds);
  }

  void playWrongMatch() {
    var sounds = [
      'sounds/wrong1.mp3',
      'sounds/wrong2.mp3',
      'sounds/wrong3.mp3',
      'sounds/wrong4.mp3',
      'sounds/wrong5.mp3',
      'sounds/wrong6.mp3',
    ];
    _playRandomSound(sounds);
  }

  void playWinLevel() {
    var sounds = [
      'sounds/winlevel1.mp3',
      'sounds/winlevel2.mp3',
      'sounds/winlevel3.mp3',
    ];
    _playRandomSound(sounds);
  }

  void playWinGame() {
    var sounds = [
      'sounds/wingame1.mp3',
      'sounds/wingame2.mp3',
      'sounds/wingame3.mp3',
    ];
    _playRandomSound(sounds);
  }

  void _playRandomSound(List<String> sounds) {
    var randomIndex = Random().nextInt(sounds.length);
    AudioPlayer().play(AssetSource(sounds[randomIndex]));
  }

  void _playSilentRandomSound(List<String> sounds) {
    var randomIndex = Random().nextInt(sounds.length);
    AudioPlayer().play(AssetSource(sounds[randomIndex]), volume: 0.6);
  }
}
