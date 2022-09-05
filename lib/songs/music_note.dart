import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class MusicNote {
  final String name;
  MusicNote(this.name);

  static const soundRoot = 'note_sounds/';
  String get soundPath => '$soundRoot$name.mp3';

  late AudioPlayer player;
  late Soundpool pool;
  late int soundId;

  Future<void> init() async {
    if (usePool) {
      pool = Soundpool.fromOptions(
          options: const SoundpoolOptions(streamType: StreamType.notification));
      final soundData = await rootBundle.load('assets/$soundPath');
      soundId = await pool.load(soundData);

      pool.setVolume(soundId: soundId, volume: 100);
    } else {
      player = AudioPlayer(playerId: name);
    }
  }

  dispose() {
    if (!usePool) {
      player.dispose();
      player = AudioPlayer(playerId: name);
    }
  }

  bool get usePool => kIsWeb || !Platform.isWindows;

  play() {
    if (usePool) {
      pool.play(soundId);
    } else {
      player.stop().then((_) {
        player.play(AssetSource(soundPath));
      });
    }
  }
}
