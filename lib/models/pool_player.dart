import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:soundpool/soundpool.dart';

class PoolPlayer {
  Soundpool pool = Soundpool.fromOptions(
      options: const SoundpoolOptions(
    streamType: StreamType.music,
  ));

  Map<String, int> setSoundId = {};
  Future<void> _loadFile(String filePath) async {
    final currentId = setSoundId[filePath];
    if (currentId == null && setSoundId.isNotEmpty) {
      await release();
    }
    if (currentId == -1) {
      return;
    }
    setSoundId[filePath] = -1;
    await rootBundle.load(filePath).then((soundData) async {
      final id = await pool.load(soundData);
      setSoundId[filePath] = id;
    }).catchError((error) {
      // no need handle
      log('error when load bundle: $error');
    });
  }

  release() async {
    setSoundId.clear();
    await pool.release();
  }

  _play(String filePath) {
    final id = setSoundId[filePath];
    if (id != null && id > -1) {
      pool.play(id);
    } else {
      _loadFile(filePath);
    }
  }

  static final Map<int, PoolPlayer> _players = {};
  static PoolPlayer getPlayer(int soundIdx) {
    return _players[soundIdx] ??= PoolPlayer();
  }

  static playMusicSound(int soundIdx, String filePath) {
    getPlayer(soundIdx)._play(filePath);
  }

  static playAppSound(String filePath) {
    getPlayer(-1)._play(filePath);
  }

  static loadSounds(List<int> soundIdxList, List<String> filePaths) async {
    for (int i = 0; i < soundIdxList.length; i++) {
      final soundIdx = soundIdxList[i];
      final filePath = filePaths[i];
      await getPlayer(soundIdx)._loadFile(filePath);
    }
  }

  static realeaseAllSounds() async {
    for (var player in _players.values) {
      await player.release();
    }
  }
}
